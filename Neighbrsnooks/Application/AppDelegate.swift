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
import FirebaseAnalytics
import FirebaseAuth
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import AppTrackingTransparency


@available(iOS 16.0, *)
@main
@available(iOS 16.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var shouldSupportAllOrientations = false
    var lastNotificationIdentifier: String?
    var fireBaseToken : UpdateTokenModel?
    var HomeNewData : HomeAllModel?
    
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        //            print("📱 APNs device token: \(token)")
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("📱 APNs device token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
        
        // Manually fetch FCM token
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ Error fetching FCM token: \(error)")
            } else if let token = token {
                print("✅ FCM Registration Token: \(token)")
                self.sendTokenToServer(token)
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
    }
    func application(
          _ app: UIApplication,
          open url: URL,
          options: [UIApplication.OpenURLOptionsKey : Any] = [:]
      ) -> Bool {
          return ApplicationDelegate.shared.application(app, open: url, options: options)
      }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMonitor.shared.startMonitoring()
        
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.isEnabled = true
        keyboardManager.resignOnTouchOutside = true
        keyboardManager.enableAutoToolbar = false
        // Listen for verification popup notification
        if #available(iOS 16.0, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    // User ne permission allow ya disallow kiya
                    print("Tracking authorization status: \(status.rawValue)")
                }
            }
        NotificationCenter.default.addObserver(self, selector: #selector(showVerificationPopup), name: Notification.Name("ShowVerificationPopup"), object: nil)
        UserDefaults.standard.set(true, forKey: "FIRDebugEnabled")
        FirebaseApp.configure()
        // Create event FirebaseAnalytics install app
        UserDefaults.standard.set(true, forKey: "FIRAnalyticsDebugEnabled")
        
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if isFirstLaunch {
            // Firebase Analytics Event
            Analytics.logEvent("app_install_iOS", parameters: [
                "time": Date().timeIntervalSince1970,
                "platform": "iOS"
            ])

            // Facebook Analytics Event (instance method)
            AppEvents.shared.logEvent(
                .init("app_install_iOS"),
                parameters: [
                    AppEvents.ParameterName("time"): Date().timeIntervalSince1970,
                    AppEvents.ParameterName("platform"): "iOS"
                ]
            )

            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()
        }
        
        
        Messaging.messaging().delegate = self
        UIWindow.appearance().overrideUserInterfaceStyle = .light
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        func updateFCMToken() {
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("❌ Error fetching FCM token: \(error.localizedDescription)")
                } else if let token = token {
                    print("✅ Refreshed FCM token: \(token)")
                    if let userId = UserDefaults.standard.string(forKey: "userid") {
                        self.callUpdateFirebaseTokenPostWebService(userId: userId, firebaseToken: token) {
                            print("📡 Token updated on server manually")
                        }
                    }
                }
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            Messaging.messaging().token { token, error in
                if let token = token {
                    print("🔥 Got token manually: \(token)")
                    if let userId = UserDefaults.standard.string(forKey: "userid") {
                        self.callUpdateFirebaseTokenPostWebService(userId: userId, firebaseToken: token) {
                            print("📡 Token updated on server manually")
                        }
                    }
                }
            }
        }
        
        
        GMSServices.provideAPIKey("AIzaSyD7gl7LrxtbTjlplCXphN2EJi7HRi9s_8Y")
        GMSPlacesClient.provideAPIKey("AIzaSyBWpyfvSIauIk1wgzWU4PhnZuYe-doOv1I")

        window?.rootViewController = NeigbrnookViewController()
        window?.makeKeyAndVisible()
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ Error fetching FCM token: \(error)")
            } else if let token = token {
                print("✅ FCM token: \(token)")
                
                if let userId = UserDefaults.standard.string(forKey: "userid") {
                    self.callUpdateFirebaseTokenPostWebService(userId: userId, firebaseToken: token) {
                        print("🎯 Firebase token API call completed")
                    }
                } else {
                    print("⚠️ User ID not found in UserDefaults")
                }
            }
        }
        
        //  customizeAppearance()
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification), name: Notification.Name("FCMToken"), object: nil)
        
        
        // Request Notification Permission
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        
        // Facebook SDK Initialization
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
 
        print("✅ Facebook SDK Initialized with App ID: 929962769257001")

        return true
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let token = userInfo["token"] as? String {
            sendTokenToServer(token)
        }
    }
    
    
    // MARK: - Custom Verification Popup (Using ViewController instead of UIAlertController)
    @objc func showVerificationPopup() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootVC = window.rootViewController else {
                return
            }
            
            let topVC = self.getTopViewController(rootVC)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let popupVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                popupVC.modalPresentationStyle = .overFullScreen
                popupVC.modalTransitionStyle = .crossDissolve
                topVC?.present(popupVC, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helper to get top visible ViewController
    private func getTopViewController(_ rootVC: UIViewController?) -> UIViewController? {
        if let presented = rootVC?.presentedViewController {
            return getTopViewController(presented)
        }
        if let nav = rootVC as? UINavigationController {
            return getTopViewController(nav.visibleViewController)
        }
        if let tab = rootVC as? UITabBarController {
            return getTopViewController(tab.selectedViewController)
        }
        return rootVC
    }
    
    
    
    
    
    func customizeAppearance() {
        let customFont = UIFont(name: "Montserrat-Regular", size: 16.0)! // Replace "YourFontName" with your desired font
        UILabel.appearance().font = customFont
        UIButton.appearance().titleLabel?.font = customFont
        // Customize other UI elements if needed
    }
    
    // MARK: - UISceneSession Lifecycle
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
        AppEvents.shared.activateApp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let userID = UserDefaults.standard.string(forKey: "userid"), !userID.isEmpty {
            let registrationStep = UserDefaults.standard.string(forKey: "registrationStep") ?? "done"
            
            switch registrationStep {
            case "step1":
                let vc = storyboard.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC")
                self.window?.rootViewController = UINavigationController(rootViewController: vc)
            case "step2":
                let vc = storyboard.instantiateViewController(withIdentifier: "RegistationAdressProofVC")
                self.window?.rootViewController = UINavigationController(rootViewController: vc)
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
    
    // MARK: - Call api firebaseToken change api old admin and admin 
    func callUpdateFirebaseTokenPostWebService(userId: String, firebaseToken: String, _ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = [
            "userid": userId,
            "firebase_token": firebaseToken
        ]
        print("Request Params: \(dictParams)")

        WebService.sharedInstance.callUpdatetokenPostWebService(withParams: dictParams) { (data: UpdateTokenModel?) in
            if let fireBaseToken = data {
                print("✅ Full Webservice Response:")
                dump(fireBaseToken) // Pretty print the full model
                self.fireBaseToken = fireBaseToken
            } else {
                print("❌ No response received from server (nil)")
            }
            completionClosure()
        }
    }
    
}

@available(iOS 16.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // App foreground me ho toh ye chalega
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let title = notification.request.content.title
        let body = notification.request.content.body
        print("🔔 Notification received: Title: \(title), Body: \(body)")
        // Send signal to refresh Home page
        NotificationCenter.default.post(name: NSNotification.Name("RefreshHomePageNotification"), object: nil)
        completionHandler([.alert, .sound])
    }
    
    // Jab user notification pe tap kare tab ye chalega
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("📩 Notification tapped: \(userInfo)")
        // Send signal to refresh Home page
        NotificationCenter.default.post(name: NSNotification.Name("RefreshHomePageNotification"), object: nil)
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
        callUpdateFirebaseTokenPostWebService(userId: userId, firebaseToken: fcmToken) {
            print("📡 Token updated to server successfully")
        }
        
        let dictParams: [String: Any] = [
            "userid": userId,
            "firebase_token": fcmToken
        ]
        
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

