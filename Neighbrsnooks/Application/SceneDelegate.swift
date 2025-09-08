//
//  SceneDelegate.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 10/04/25.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            NetworkMonitor.shared.startMonitoring()
            
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(windowScene: windowScene)
            window?.overrideUserInterfaceStyle = .light
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
        // Always show SplashVC first
                let splashVC = storyboard.instantiateViewController(withIdentifier: "SplashVC")
                window?.rootViewController = splashVC
                window?.makeKeyAndVisible()
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2 seconds splash delay
                if let userID = UserDefaults.standard.string(forKey: "userid"), !userID.isEmpty {
                    let registrationStep = UserDefaults.standard.string(forKey: "registrationStep") ?? "done"
                    
                    switch registrationStep {
                    case "step1":
                        if let vc = storyboard.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
                            vc.sourceScreen = "Malik"
                            self.window?.rootViewController = UINavigationController(rootViewController: vc)
                        }
                    case "step2":
                        if let vc = storyboard.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC{
                            vc.sourceScreen = "Malik"
                            self.window?.rootViewController = UINavigationController(rootViewController: vc)
                        }
                    default:
                        let homeVC = storyboard.instantiateViewController(withIdentifier: "NeigbrnookViewController")
                        self.window?.rootViewController = UINavigationController(rootViewController: homeVC)
                    }
                } else {
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.window?.rootViewController = UINavigationController(rootViewController: loginVC)
                }
                
                    self.window?.makeKeyAndVisible()
            }
        
        
        
        
        }



    func checkAppVersion() {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let appStoreVersion = results.first?["version"] as? String {
                
                DispatchQueue.main.async {
                    if self.isUpdateAvailable(currentVersion: currentVersion, appStoreVersion: appStoreVersion) {
                        self.showForceUpdateAlert()
                    }
                }
            }
        }
        task.resume()
    }

    func isUpdateAvailable(currentVersion: String, appStoreVersion: String) -> Bool {
        return currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending
    }

    func showForceUpdateAlert() {
        guard let window = self.window else { return }
        
        let alert = UIAlertController(title: "Update Required",
                                      message: "Please update to the latest version to continue using the app",
                                      preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id6746369263") {
                UIApplication.shared.open(url)
            }

        }
        
        alert.addAction(updateAction)
        
        // ✅ Cancel option नहीं देंगे ताकि force update हो
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.checkAppVersion()
    }

    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        checkAppVersion()
        if let userID = UserDefaults.standard.string(forKey: "userid"), !userID.isEmpty {
                print("App became active - Resuming from last screen")
            }
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if let lastScreen = UserDefaults.standard.string(forKey: "lastScreen") {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let viewController = storyboard.instantiateViewController(withIdentifier: lastScreen)
               self.window?.rootViewController = UINavigationController(rootViewController: viewController)
           }
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    deinit {
            // Stop monitoring when the view controller is deallocated
            NetworkMonitor.shared.stopMonitoring()
        }

}

