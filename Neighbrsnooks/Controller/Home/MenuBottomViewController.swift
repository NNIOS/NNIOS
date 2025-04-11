//
//  MenuBottomViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 09/12/24.
//

import UIKit


protocol MenuBottomViewControllerDelegate: AnyObject {
    func navigateToBussinesViewController()
}

@available(iOS 16.0, *)
class MenuBottomViewController: UIViewController {
    
    @IBOutlet weak var SectorLbl: UILabel!
    @IBOutlet weak var MemberLbl: UILabel!
    @IBOutlet weak var NMemberLbl: UILabel!
    @IBOutlet weak var lblMarket: UILabel!
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var LastNameLbl: UILabel!
    @IBOutlet weak var SectorMenuLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var viewSideMenu: UIView!
    
    @IBOutlet weak var viewToHide: UIView!
    
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var Lblneighbourhood: UILabel!
    @IBOutlet weak var LblBussiness: UILabel!
    @IBOutlet weak var lblDm: UILabel!
    @IBOutlet weak var LblEvent: UILabel!
    @IBOutlet weak var LblFavourite: UILabel!
    @IBOutlet weak var lblGroup: UILabel!
    @IBOutlet weak var LblPolls: UILabel!
    @IBOutlet weak var LblPost: UILabel!
    @IBOutlet weak var lblPublic: UILabel!
    @IBOutlet weak var LblShare: UILabel!
    @IBOutlet weak var LblSetting: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var LblContact: UILabel!
   
    var profileData : ProfileModel?
//    private let bottomPanelView = BottomPanelView()
    var selectedNewTabIndex: Int?
    weak var delegate: MenuBottomViewControllerDelegate?
  //  weak var delegate: MenuBottomViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.tintColor = UIColor.red
       
        view.backgroundColor = .white
      //  self.tabBarController?.tabBar.tintColor = UIColor.green
        self.SectorLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
      //  self.MemberLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
       // self.NMemberLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
      //  self.SectorMenuLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        
        self.lblProfile.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.Lblneighbourhood.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.LblBussiness.font = UIFont(name: "Montserrat-Regular", size: 15)
     //   self.lblDm.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.LblEvent.font = UIFont(name: "Montserrat-Regular", size: 15)
    //    self.LblFavourite.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblGroup.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.LblPolls.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.LblPost.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblPublic.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.LblShare.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.LblSetting.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        
     //   self.LblContact.font = UIFont(name: "Montserrat-Regular", size: 15)
        
//        NSLayoutConstraint.activate([
//            viewSideMenu.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0), // Top constraint
//            viewSideMenu.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0), // Bottom constraint
//            viewSideMenu.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0), // Leading (left) constraint
//            viewSideMenu.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0) // Trailing (right) constraint
//        ])
        
        
        setdata()
        profileImgView.layer.cornerRadius = profileImgView.frame.size.width / 2
        profileImgView.clipsToBounds = true
        
       
//        callHomeAllWebService{
//            self.tableviewMember.reloadData()
//
//        }
        
    }
    
    func setdata(){
        
        NameLbl.text = UserDefaults.standard.object(forKey: "username") as? String
      //  LastNameLbl.text = UserDefaults.standard.object(forKey: "lastName") as? String
     //   SectorMenuLbl.text = UserDefaults.standard.object(forKey: "neighbrshood") as? String
        let urlString = UserDefaults.standard.object(forKey: "userphoto") as? String
        let url = URL(string: (urlString ?? ""))
        self.profileImgView.kf.indicatorType = .activity
        self.profileImgView.kf.setImage(with:url,placeholder:UIImage(named: "My-profile"))

    }
    


    
    func openMenuBottomViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuBottomViewController") as? MenuBottomViewController else { return }
        
        // Optionally set the selected index if needed
        menuVC.selectedNewTabIndex = 4
        
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = .right
           self.view.addGestureRecognizer(swipeGesture)
        self.view.frame.origin.x = self.view.frame.width
        
        let menuWidth = UIScreen.main.bounds.width * 0.75
           self.view.frame = CGRect(
               x: UIScreen.main.bounds.width,
               y: 0,
               width: menuWidth,
               height: UIScreen.main.bounds.height
           )
           
           // Dimming background
           self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        if let selectedIndex = selectedTabIndex {
//               bottomPanelView.updateTabAppearance(selectedIndex: selectedIndex)
//           }
           // Animate it into view
           UIView.animate(withDuration: 0.3) {
               self.view.frame.origin.x = self.view.frame.width * 0.5 // Adjust the width for your menu size
           }
       
    
        callUserProfileWebService{ [self] in
            
          
            self.NameLbl.text = self.profileData?.firstname
            self.LastNameLbl.text = self.profileData?.lastname
          //  self.SecLbl.text = self.profileData?.lastname
           
            
            self.SectorLbl.text = self.profileData?.neighborhood
            let url = URL(string: (self.profileData?.userpic ?? ""))
            self.profileImgView.kf.indicatorType = .activity
           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "profile 1"))
           // self.MobileLbl.text = self.profileData?.phoneno
            
           
        }
        // Do any additional setup after loading the view.
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.x = UIScreen.main.bounds.width
        }) { _ in
            self.dismiss(animated: false, completion: nil)
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

            completionClosure()
          }
        }
   
    
    @IBAction func btnProfile(_ : UIButton) {
        

        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }
    }
    
    @IBAction func btndissmiss(_ : UIButton) {
        

        dismissMenu()
      //  NeighbourhoodViewController
    }
    
    func dismissMenu() {
        let menuWidth = UIScreen.main.bounds.width * 0.75

        // Animate the slide-out effect
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.x = UIScreen.main.bounds.width
        }) { _ in
            // Dismiss the view controller after the animation completes
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnNeighbrood(_ : UIButton) {
        
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "NeighbourhoodViewController") as? NeighbourhoodViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }
        
       }
   
    
    
    @IBAction func btnBussiness(_ : UIButton){
       
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "BussinesViewController") as? BussinesViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }
       
       }
    
    @IBAction func btnContactUs(_ : UIButton){

   
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }
       }
   
    
    @IBAction func btnPost(_ : UIButton){

        
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "MennuPostViewController") as? MennuPostViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }


       }
    
    @IBAction func btnEvent(_ : UIButton){

   
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsViewController") as? EventsViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }


       }
    
    @IBAction func btnGroups(_ : UIButton){

   
        
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }

       }
    
    @IBAction func btnPolls(_ : UIButton){

   
        
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "PollsViewController") as? PollsViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }

       }
    
    @IBAction func btnSettings(_ : UIButton){

    
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingNewViewController") as? SettingNewViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }

       }
    
    @IBAction func btnPublic(_ : UIButton){

   
        
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "PublicAgencyViewController") as? PublicAgencyViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }

       }
    
    @IBAction func btnTerms$Condition(_ sender: UIButton) {
     
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewControllerViewController") as? WebViewControllerViewController else {return}
        vc.heading = "Privacy Policy"
        vc.urlString = "http://neighbrsnook.com/privacy-policy/"
        self.navigationController?.pushViewController(vc, animated: true)
        
       
    }
    
    @IBAction func shareTapped(sender: UIButton)
    {
        let shareText = "Neighbrsnook is a hyperlocal social networking service connecting neighbours... https://itunes.apple.com/in/app/helperinfo/id1212105977?mt=8"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnDm(_ : UIButton) {

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectMessageViewController") as? DirectMessageViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnMarket(_ : UIButton){

   
        
        guard let businessVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeMarketViewController") as? HomeMarketViewController else {
                return
            }
            
            // Dismiss the current view controller (MenuBottomViewController)
            self.dismiss(animated: true) {
                // Push the NeighbourhoodViewController after the menu is dismissed
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(businessVC, animated: true)
                }
            }

       }
}


//if let vc = storyboard.instantiateViewController(withIdentifier: "MenuBottomViewController") as? MenuBottomViewController {
//    vc.modalPresentationStyle = .overFullScreen
//    vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Optional dimmed background
//
//                // Set initial frame for side menu
//    vc.view.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height)
//
//                // Present side menu with animation
//                self.present(vc, animated: false) {
//                    UIView.animate(withDuration: 0.3) {
//                        vc.view.frame.origin.x = UIScreen.main.bounds.width * 0.25
//                    }
//                }
//
//}
