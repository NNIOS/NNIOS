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
           label.font = UIFont.systemFont(ofSize: 18)
           label.textAlignment = .center
           label.backgroundColor = .red // Set red background color for the label
        label.layer.cornerRadius = 12.5 // Optional: round the corners
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
        
        // MARK: - Irshad code tab bar show and hide 
        
//        if let tabBar = self.tabBarController {
//                tabBar.tabBar.isHidden = false // Ensure tab bar is visible
//            }
 
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
                   NotiLbl.widthAnchor.constraint(equalToConstant: 25),
                   NotiLbl.heightAnchor.constraint(equalToConstant: 25)
               
               ])
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            // Check if verification is completed
            if profileData?.verfiedMsg == "User Verification is completed!" {
                return true // Allow navigation
            } else {
                showVerificationAlert()
                return false // Prevent navigation
            }
        }
    
    private func showVerificationAlert() {
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            // Define font and color attributes
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
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
       
        callNotificationCountWebService { [self] in
            if let count = self.NotificationCountData?.notificationCount {
                self.NotiLbl.text = String(count) // Convert Int to String
            } else {
                self.NotiLbl.text = "0" // or any default value you want
            }
        }
        
        
    }
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                    
                                                    "userid":id ?? "",
                                                   
                                                   
                                                                        ]
          WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
            self.profileData = data
              UserDefaults.standard.set(self.profileData?.emerPhone, forKey: "emer_phone")
              UserDefaults.standard.set(self.profileData?.userpic, forKey: "profileImage")
              UserDefaults.standard.set(self.profileData?.lastname, forKey: "lastName")
              UserDefaults.standard.set(self.profileData?.neighborhood, forKey: "myNeighbhrhhod")

            completionClosure()
          }
        }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//            if self.selectedIndex == 4 { // Check if the selected index is 4 (fifth tab)
//
//                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
//
////                if let homeVC = viewController as? HomeViewController {
////                    homeVC.tabBarButtonTapped()
////                }
//            }
//        }
    
    
    func callNotificationCountWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "appkey":"abc1239"
                                                   
                                                                        ]
          WebService.sharedInstance.callNotificationCountWebService(withParams: dictParams) { data in
            self.NotificationCountData = data
           

            completionClosure()
          }
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
