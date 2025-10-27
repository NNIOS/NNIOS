//
//  NeigbrnookViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 07/03/24.
//

import UIKit
@available(iOS 16.0, *)
class NeigbrnookViewController:UITabBarController,UITabBarControllerDelegate, UINavigationControllerDelegate{
    
    let transitionManager = SideMenuTransitionManager()
    @IBOutlet weak var sliderControl: UISlider!
    // @IBOutlet weak var NotiLbl: UILabel!
    var name = ""
    var secname = ""
    var Neighbourname : String! = nil
    var NotificationCountData : NotificationCountModel?
    var profileData : ProfileModel?
    
    let NotiLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        label.text = "0" // Default text
        label.textColor = .white // Customize as needed
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.backgroundColor = .red // Set red background color for the label
        label.layer.cornerRadius = 10 // Optional: round the corners
        label.layer.masksToBounds = true // Clips to the rounded corners
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.selectedIndex = 0
        self.extendedLayoutIncludesOpaqueBars = true
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        
        tabBar.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        
        // Optional: Set tint colors for selected/unselected items
        tabBar.tintColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        tabBar.unselectedItemTintColor = .gray
        // MARK: - Irshad code tab bar show and hide
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        callNotificationCountWebService { [self] in
            if let count = self.NotificationCountData?.notificationCount {
                self.NotiLbl.text = String(count) // Convert Int to String
            } else {
                self.NotiLbl.text = "0" // or any default value you want
            }
        }
        
        view.addSubview(NotiLbl)
        // view.addSubview(backgroundView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Center the label horizontally in the view
            NotiLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 275),
            // Set the label 20 points from the bottom edge of the view
            NotiLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            // Set width and height
            NotiLbl.widthAnchor.constraint(equalToConstant: 20),
            NotiLbl.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//            if granted {
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            } else {
//                print("❌ Notification permission denied")
//            }
//        }

        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshFromPushNotification), name: NSNotification.Name("RefreshHomePageNotification"), object: nil)
 
    }
    
    
    
    @objc func handleRefreshFromPushNotification() {
        // Call your desired API here
        fetchLatestNeighbourData()
    }

    func fetchLatestNeighbourData() {
        // Replace with your actual API logic
        print("🌐 Calling Neighbour API after push notification")
          callUserProfileWebService{}
    }
     deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tabBar.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Check if verification is completed
//        
//        if profileData?.verfiedMsg == "User Verification is completed!" {
//            return true // Allow navigation
//        } else {
//            
//            showVerificationAlert()
//            return false // Prevent navigation
//        }
        return true
    }
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        refreshNotificationCountManually()
    }

    
    private func showVerificationAlert() {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        
        // Define font and color attributes
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        let messageAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        ]
        
        // Create attributed strings
        let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
        let attributedMessage = NSAttributedString(
            string: "You have limited access till verification is complete. We thank you for your patience.",
            attributes: messageAttributes
        )
        
        // Set the title and message of the alert
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        // Add an action to the alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callUserProfileWebService{}
        refreshNotificationCountManually()
//        callNotificationCountWebService { [self] in
//            if let count = self.NotificationCountData?.notificationCount {
//                if count == 0 {
//                    self.NotiLbl.isHidden = true
//                } else {
//                    
//                }
//                self.NotiLbl.text = String(count) // Convert Int to String
//            } else {
//                self.NotiLbl.text = "0" // or any default value you want
//            }
//        }
    }
    
    
    func refreshNotificationCountManually() {
        callNotificationCountWebService { [self] in
            if let count = self.NotificationCountData?.notificationCount {
                self.NotiLbl.text = String(count)
                self.NotiLbl.isHidden = count == 0
            } else {
                self.NotiLbl.text = "0"
                self.NotiLbl.isHidden = true
            }
        }
    }

    @objc func appDidBecomeActive() {
        refreshNotificationCountManually()
    }

    
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            
            "userid":id ?? "",
            
            
        ]
//        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
//            self.profileData = data
//            UserDefaults.standard.set(self.profileData?.emerPhone, forKey: "emer_phone")
//            UserDefaults.standard.set(self.profileData?.userpic, forKey: "profileImage")
//            UserDefaults.standard.set(self.profileData?.lastname, forKey: "lastName")
//            UserDefaults.standard.set(self.profileData?.neighborhood, forKey: "myNeighbhrhhod")
//            
//            completionClosure()
//        }
    }
    
    
    
    
    func callNotificationCountWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
 
        ]
//        WebService.sharedInstance.callNotificationCountWebService(withParams: dictParams) { data in
//            self.NotificationCountData = data
//            
//            
//            completionClosure()
//        }
    }
    
    
    //    func callNotificationCountWebService() {
    //                  let url = "https://dev.neighbrsnook.com/admin/api/notificationcount?flag=counter&appkey=abc1239"
    //
    //       // let dictParams: Dictionary<String, Any> = ["":""]
    //
    //
    //        let id = UserDefaults.standard.string(forKey: "userid")
    //
    //          let dictParams: Dictionary<String, Any> = [
    //                                                    "userid":id ?? "",
    //
    //
    //                                                                        ]
    //
    //        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true)
    //          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
    //          switch statusCode {
    //          case .SUCCESS ,.CREATED:
    //          do {
    //              let data = try JSONDecoder().decode(NotificationCountModel.self, from: result!)
    //            self.NotificationCountData = data
    //          //  self.collectionViewMyEvent.reloadData()
    //
    //          //    completionClosure(data)
    //              } catch {
    //              print(error.localizedDescription)
    //              }
    //          case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
    //              do {
    //                  let data = try JSONDecoder().decode(NotificationCountModel.self, from: result!)
    //               //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
    //                  } catch {
    //                  print(error.localizedDescription)
    //                  }
    //          case .UNAUTHORIZED:
    //              print(error?.localizedDescription)
    //       //   self.showLogoutAlert()
    //          default:
    //          break
    //          }
    //      }
    //  }
    
}
//let video: String?
