//
//  AppDelegate.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 10/04/25.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
 
      

@available(iOS 16.0, *)
@main
@available(iOS 16.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var shouldSupportAllOrientations = false

    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
           return OrientationManager.shared.shouldSupportAllOrientations ? .all : .portrait
       }

       func applicationDidFinishLaunching(_ application: UIApplication) {
           NotificationCenter.default.addObserver(self, selector: #selector(updateOrientation), name: NSNotification.Name("UpdateOrientation"), object: nil)
       }

       @objc func updateOrientation() {
           let orientation = OrientationManager.shared.shouldSupportAllOrientations ? UIInterfaceOrientationMask.all : .portrait
           DispatchQueue.main.async {
               UIApplication.shared.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
           }
       }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMonitor.shared.startMonitoring()

        
      //  UITextField.appearance().autocapitalizationType = .sentences
        
        GMSServices.provideAPIKey("AIzaSyD7gl7LrxtbTjlplCXphN2EJi7HRi9s_8Y")
        GMSPlacesClient.provideAPIKey("AIzaSyBWpyfvSIauIk1wgzWU4PhnZuYe-doOv1I")
        
      //  AIzaSyDzLGIh8vJ1SCOkp_rgSLch3z7uSPFOl3I
        
       // AIzaSyD7gl7LrxtbTjlplCXphN2EJi7HRi9s_8Y
        // Override point for customization after application launch.
//        let homeVC = HomeViewController()
//                // Set title and image for the fifth tab
//                let homeTabBarItem = UITabBarItem(title: "MenuRaj", image: UIImage(named: "menu_icon"), tag: 4)
//                homeVC.tabBarItem = homeTabBarItem

        window?.rootViewController = NeigbrnookViewController()
        window?.makeKeyAndVisible()
        
//        if #available(iOS 16.0, *){
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                with: authOptions { _, _ in})
//        }
//        
//        
        
        FirebaseApp.configure()
      //  customizeAppearance()
        return true
        
        
        
    }
    deinit {
            // Stop monitoring when the view controller is deallocated
            NetworkMonitor.shared.stopMonitoring()
        }
    
    
    func customizeAppearance() {
        let customFont = UIFont(name: "Montserrat-Regular", size: 16.0)! // Replace "YourFontName" with your desired font
        UILabel.appearance().font = customFont
        UIButton.appearance().titleLabel?.font = customFont
        // Customize other UI elements if needed
    }
    
    


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let userID = UserDefaults.standard.string(forKey: "userid"), !userID.isEmpty {
            // User logged in hai, toh home open ho
            let homeVC = storyboard.instantiateViewController(withIdentifier: "NeigbrnookViewController")
            self.window?.rootViewController = UINavigationController(rootViewController: homeVC)
        } else {
            // User logged out hai, toh login screen open ho
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = UINavigationController(rootViewController: loginVC)
        }
        self.window?.makeKeyAndVisible()
    }


}

