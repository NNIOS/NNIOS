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
    var lastNotificationIdentifier: String?
    var fireBaseToken : UpdateTokenModel?
    
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
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
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
//        Messaging.messaging().token { token, error in
//               if let error = error {
//                   print("❌ Error fetching FCM token: \(error)")
//               } else if let token = token {
//                   print("✅ FCM token: \(token)")
//                   
//                   if let userId = UserDefaults.standard.string(forKey: "userid") {
//                       self.callUpdateFirebaseTokenPostWebService(userId: userId, firebaseToken: token) {
//                           print("🎯 Firebase token API call completed")
//                       }
//                   } else {
//                       print("⚠️ User ID not found in UserDefaults")
//                   }
//               }
//           }
        
        //  customizeAppearance()
        
        // Request Notification Permission
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Notification permission granted: \(granted)")
        }
        application.registerForRemoteNotifications()
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
    
    
    
    
    // MARK: - Call api delete for post
    func callUpdateFirebaseTokenPostWebService(userId: String, firebaseToken: String, _ completionClosure: @escaping () -> ()) {
        let dictParams: Dictionary<String, Any> = [
            "userid": userId,
            "firebase_token": firebaseToken
            
        ]
        print(dictParams)
        
        WebService.sharedInstance.callUpdatetokenPostWebService(withParams: dictParams) { data in
            self.fireBaseToken = data
            completionClosure()
        }
    }

    
    
}

@available(iOS 16.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {

    // Show alert while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let title = notification.request.content.title
        let body = notification.request.content.body
        let combined = "\(title)-\(body)"

        // 🎉 emoji wala title hi show karna hai
        if !title.contains("🎉") {
            print("🚫 Notification without 🎉 ignored")
            completionHandler([])
            return
        }

        // Duplicate check
        if combined == lastNotificationIdentifier {
            print("🔁 Duplicate notification ignored")
            completionHandler([])
        } else {
            lastNotificationIdentifier = combined
            print("🔔 Showing notification: \(combined)")
            completionHandler([.alert, .sound])
        }
    }


    // Handle tap on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle when user taps the notification
        let userInfo = response.notification.request.content.userInfo
        print("📩 Notification tapped: \(userInfo)")
        completionHandler()
    }
}



@available(iOS 16.0, *)
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🌐 Firebase registration token: \(fcmToken ?? "")")
        if let token = fcmToken {
            sendTokenToServer(token)
        }
    }

    func sendTokenToServer(_ fcmToken: String) {
        guard let userId = UserDefaults.standard.string(forKey: "userid") else { return }

        let url = URL(string: "https://yourdomain.com/api/store-fcm-token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "user_id": userId,
            "firebase_token": fcmToken
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error sending token: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("✅ Token sent with status code: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}

