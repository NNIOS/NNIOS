//
//  MenuViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 11/03/24.
//

import UIKit
import Kingfisher
import SVProgressHUD

@available(iOS 16.0, *)
class MenuViewController: UIViewController {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var LastNameLbl: UILabel!
    @IBOutlet weak var SectorLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var viewToHide: UIView!
    
    var profileData : ProfileModel?
    let transitionManager = SideMenuTransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewToHide = viewToHide {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
            viewToHide.addGestureRecognizer(tapGesture)
        } else {
            print("viewToHide is nil")
        }

        
        NetworkMonitor.shared.startMonitoring()
        
        setdata()
        profileImgView.layer.cornerRadius = profileImgView.frame.size.width / 2
        profileImgView.clipsToBounds = true
         
       // presentSideMenu()
//        let dismissButton = UIButton(type: .system)
//               dismissButton.setTitle("Dismiss", for: .normal)
//               dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
//               dismissButton.translatesAutoresizingMaskIntoConstraints = false
//               view.addSubview(dismissButton)
//               NSLayoutConstraint.activate([
//                   dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                   dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//               ])

        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                swipeGesture.direction = .left
                view.addGestureRecognizer(swipeGesture)

        // Do any additional setup after loading the view.
    }
    
    
    @objc func handleTapOutside() {
        dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
            // Stop monitoring when the view controller is deallocated
            NetworkMonitor.shared.stopMonitoring()
        }
    
    func setdata(){
        
        NameLbl.text = UserDefaults.standard.object(forKey: "username") as? String
        LastNameLbl.text = UserDefaults.standard.object(forKey: "lastName") as? String
        SectorLbl.text = UserDefaults.standard.object(forKey: "neighbrshood") as? String
        let urlString = UserDefaults.standard.object(forKey: "userphoto") as? String
        let url = URL(string: (urlString ?? ""))
        self.profileImgView.kf.indicatorType = .activity
        self.profileImgView.kf.setImage(with:url,placeholder:UIImage(named: "My-profile"))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                swipeGesture.direction = .left
                view.addGestureRecognizer(swipeGesture)
       
     //   self.lblHeading.font = UIFont(name: "Montserrat-SemiBold", size: 20)
       // self.NameLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
     //   self.SecLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
      
        
        SVProgressHUD.show()
//        callUserProfileWebService{ [self] in
//            
//            SVProgressHUD.dismiss()
//            
//            
//            
//            self.NameLbl.text = self.profileData?.firstname
//          //  self.SecLbl.text = self.profileData?.lastname
//           
//            
//            self.SectorLbl.text = self.profileData?.neighborhood
//           // self.MobileLbl.text = self.profileData?.phoneno
//            
//           
//        }
        // Do any additional setup after loading the view.
    }
    


       @objc func handleSwipe() {
           dismiss(animated: true, completion: nil)
       }
    
    @IBAction func btnDismiss(_ : UIButton){

        dismiss(animated: true, completion: nil)


       }
    
   
    
    @IBAction func navigateButtonTapped(_ sender: UIButton) {
        presentNewViewController()
    }
    
    @objc func presentNewViewController() {
           guard let newViewController = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {
               return
           }
        newViewController.modalPresentationStyle = .overFullScreen
               present(newViewController, animated: true, completion: nil)
         //  present(newViewController, animated: true, completion: nil)
       }
    
    
//    @objc func presentNewViewController() {
//        guard let newViewController = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {
//            return
//        }
//        newViewController.modalPresentationStyle = .fullScreen // or .overFullScreen for a transparent background
//        present(newViewController, animated: true, completion: nil)
//    }
    
    
    @objc func navigateToAnotherScreen() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}
            present(vc, animated: true, completion: nil)
        
        }
    
    @IBAction func btnProfile(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnNeighbrood(_ : UIButton){
        

        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeighbourhoodViewController") as? NeighbourhoodViewController else {return}

        self.navigationController?.pushViewController(vc, animated: true)


       }
    
    @IBAction func btnBussiness(_ : UIButton){
        
//        guard let newViewController = storyboard?.instantiateViewController(withIdentifier: "BussinesViewController") as? BussinesViewController else {
//            return
//        }
//     newViewController.modalPresentationStyle = .overFullScreen
//            present(newViewController, animated: true, completion: nil)
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BussinesViewController") as? BussinesViewController else {return}

        self.navigationController?.pushViewController(vc, animated: true)

    

       }
    
    @IBAction func btnContactUs(_ : UIButton){

   
        
        
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController else {return}

        self.navigationController?.pushViewController(vc, animated: true)



       }
    
    @IBAction func btnPost(_ : UIButton){

        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MennuPostViewController") as? MennuPostViewController else {return}

        self.navigationController?.pushViewController(vc, animated: true)


       }
    
    @IBAction func btnGroup(_ : UIButton){

    
        
//        guard let newViewController = storyboard?.instantiateViewController(withIdentifier: "MenuGroupViewController") as? MenuGroupViewController else {
//            return
//        }
//     newViewController.modalPresentationStyle = .overFullScreen
//            present(newViewController, animated: true, completion: nil)
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuGroupViewController") as? MenuGroupViewController else {return}

        self.navigationController?.pushViewController(vc, animated: true)



       }
   
    
    @IBAction func btnTerms$Condition(_ sender: UIButton) { //dev.
     
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
    
    @IBAction func btnDm(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectMessageViewController") as? DirectMessageViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnEvent(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsViewController") as? EventsViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnGroups(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnPolls(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollsViewController") as? PollsViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnSettings(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }

//    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//          let dictParams: Dictionary<String, Any> = [
//                                                    
//                                                    "userid":id ?? "",
//                                                   
//                                                   
//                                                                        ]
//          WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
//            self.profileData = data
//              UserDefaults.standard.set(self.profileData?.emerPhone, forKey: "emer_phone")
//              UserDefaults.standard.set(self.profileData?.userpic, forKey: "profileImage")
//              UserDefaults.standard.set(self.profileData?.lastname, forKey: "lastName")
//
//            completionClosure()
//          }
//        }
}
