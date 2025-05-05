//
//  NotificationViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 02/03/24.
//

import UIKit
import SVProgressHUD
@available(iOS 16.0, *)
class NotificationViewController: BaseViewController {
    
    var NotificationData : NotificationModel?
    var HideNotificationData : HideNotificationModel?
    
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var NotificationView: UIView!
    
//    @IBOutlet weak var viewSideMenu: UIView!
//    @IBOutlet weak var NameLbl: UILabel!
//    @IBOutlet weak var LastNameLbl: UILabel!
//    @IBOutlet weak var SectorMenuLbl: UILabel!
//    @IBOutlet weak var profileImgView : UIImageView!
//
//    @IBOutlet weak var viewToHide: UIView!
    var sideMenuVisible = false
    var profileData : ProfileModel?
    let transitionManager = SideMenuTransitionManager()
    var NotificationCountData : NotificationCountModel?
    var notiid = ""
    private let bottomPanelView = BottomPanelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        NetworkMonitor.shared.startMonitoring()
        updateColors()
       
//        setdata()
//        view.backgroundColor = .white
//        self.tabBarController?.delegate = self
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//                viewToHide.addGestureRecognizer(tapGesture)
//        setupBottomPanel()
       // viewNotification.roundCorners([.topRight, .bottomRight], radius: 25)
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//           super.viewDidAppear(animated)
//           tabBarController?.delegate = self
//       }
//
//       override func viewDidDisappear(_ animated: Bool) {
//           super.viewDidDisappear(animated)
//           if tabBarController?.delegate === self {
//               tabBarController?.delegate = nil
//           }
//       }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  callHideNotificationWebService{}
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//                viewToHide.addGestureRecognizer(tapGesture)
//    //    self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
//        viewSideMenu.isHidden = true
//        SVProgressHUD.show()
//        if let selectedIndex = selectedTabIndex {
//               bottomPanelView.updateTabAppearance(selectedIndex: selectedIndex)
//           }
//
//        callUserProfileWebService{ [self] in
//
//            SVProgressHUD.dismiss()
//
//            self.NameLbl.text = self.profileData?.firstname
//          //  self.SecLbl.text = self.profileData?.lastname
//
//            let url = URL(string: (self.profileData?.userpic ?? ""))
//            self.profileImgView.kf.indicatorType = .activity
//           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "profile 1"))
//            self.SectorMenuLbl.text = self.profileData?.neighborhood
//           // self.MobileLbl.text = self.profileData?.phoneno
//
//
//        }
        callNoticationWebService{
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            
            
        // Do any additional setup after loading the view.
        }
        callNotificationCountWebService ()
    }
    
    private func setupBottomPanel() {
        bottomPanelView.delegate = self
        bottomPanelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomPanelView)

        NSLayoutConstraint.activate([
            bottomPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5), // Moves it downward
            bottomPanelView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            NotificationView.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
           

            // Light mode mein PollsView ka background red karna
            NotificationView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            tableviewMembers.separatorStyle = .none
        }
    }

    
//    func setdata(){
//
//        NameLbl.text = UserDefaults.standard.object(forKey: "username") as? String
//        LastNameLbl.text = UserDefaults.standard.object(forKey: "lastName") as? String
//        SectorMenuLbl.text = UserDefaults.standard.object(forKey: "neighbrshood") as? String
//        let urlString = UserDefaults.standard.object(forKey: "userphoto") as? String
//        let url = URL(string: (urlString ?? ""))
//        self.profileImgView.kf.indicatorType = .activity
//        self.profileImgView.kf.setImage(with:url,placeholder:UIImage(named: "My-profile"))
//
//    }
    
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
    
    func callHideNotificationWebService(notificationID: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")

        let dictParams: [String: Any] = [
            "userid": id ?? "",
            "appkey": "abc1239",
            "not_Id": notificationID // Sending as a string instead of an array
        ]

        WebService.sharedInstance.callHideNotificationWebService(withParams: dictParams) { data in
            self.HideNotificationData = data
            
            // Clear stored notiId after successful API call (if needed)
            UserDefaults.standard.removeObject(forKey: "notiId")
            
            completionClosure()
        }
    }



    
    func callNotificationCountWebService() {
                  let url = "https://dev.neighbrsnook.com/admin/api/notificationcount?flag=counter&appkey=abc1239"

       // let dictParams: Dictionary<String, Any> = ["":""]
        
       
        let id = UserDefaults.standard.string(forKey: "userid")
        
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    
                                                   
                                                                        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
          switch statusCode {
          case .SUCCESS ,.CREATED:
          do {
              let data = try JSONDecoder().decode(NotificationCountModel.self, from: result!)
            self.NotificationCountData = data
          //  self.collectionViewMyEvent.reloadData()
              
          //    completionClosure(data)
              } catch {
              print(error.localizedDescription)
              }
          case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
              do {
                  let data = try JSONDecoder().decode(NotificationCountModel.self, from: result!)
               //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                  } catch {
                  print(error.localizedDescription)
                  }
          case .UNAUTHORIZED:
              print(error?.localizedDescription)
       //   self.showLogoutAlert()
          default:
          break
          }
      }
  }
    
//    func callNoticationWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
//          let dictParams: Dictionary<String, Any> = [
//                                                    "userid":id ?? "",
//                                                    "appkey":"abc1239"
//
//                                                                        ]
//          WebService.sharedInstance.callNoticationWebService(withParams: dictParams) { data in
//            self.NotificationData = data
//              UserDefaults.standard.set(self.NotificationData?.nbdata?.first?.notificationID, forKey: "notiId")
//
//            completionClosure()
//          }
//        }
    
    
    func callNoticationWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")

        let dictParams: [String: Any] = [
            "userid": id ?? "",
            "appkey": "abc1239"
        ]

        WebService.sharedInstance.callNoticationWebService(withParams: dictParams) { data in
            self.NotificationData = data
            
            // Extract notificationIDs
            let notificationIDs = self.NotificationData?.nbdata.compactMap { $0.notificationID } ?? []

            // Convert Array to JSON String
            if let jsonData = try? JSONSerialization.data(withJSONObject: notificationIDs, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                UserDefaults.standard.set(jsonString, forKey: "notiId")
            }

            completionClosure()
        }
    }

    
    
//    @objc func handleTap() {
//        viewSideMenu.isHidden = true
//       }
    
//    func closeSideMenu()
//    {
//        sideMenuVisible = false
//        viewSideMenu.isHidden = true
//    }
    
//    @IBAction func btnSliderMenu(_ sender: UIButton) {
//        viewSideMenu.isHidden = false
//
////        if sideMenuVisible
////        {
////           closeSideMenu()
////        }
////        else
////        {
////            sideMenuVisible = true
////            viewSideMenu.isHidden = false
////        }
//
//    }
//
//    @objc func tabBarButtonTapped() {
//        viewSideMenu.isHidden = false
//    }
//    @objc func handleSwipe() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    @IBAction func btnHideenMenu(_ : UIButton){
//
//        viewSideMenu.isHidden = true
//       }
//
//
//
//    @objc func methodOfReceivedNotification(notification: Notification) {
//        viewSideMenu.isHidden = false
//    }
    
    @IBAction func btnProfile(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnNeighbrood(_ : UIButton){
        

        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeighbourhoodViewController") as? NeighbourhoodViewController else {return}

        self.navigationController?.pushViewController(vc, animated: true)


       }
    
    @IBAction func btnBussiness(_ : UIButton){
        

        
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
    
    @IBAction func btnDm(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectMessageViewController") as? DirectMessageViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
//    @objc func presentHalfScreenVC() {
//        guard let halfScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {return}
//           if let sheet = halfScreenVC.sheetPresentationController {
//               sheet.detents = [.medium(), .large()]
//               sheet.prefersGrabberVisible = true
//               sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//           }
//           present(halfScreenVC, animated: true, completion: nil)
//       }
//
    @objc func presentSideMenu() {
        guard let sideMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {return}
           sideMenuVC.modalPresentationStyle = .custom
           sideMenuVC.transitioningDelegate = transitionManager
           present(sideMenuVC, animated: true, completion: nil)
       }
    

}
@available(iOS 16.0, *)
extension NotificationViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return NotificationData?.nbdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        
        cell.lblName.text = NotificationData?.nbdata[indexPath.row].title
        cell.lblSec.text = NotificationData?.nbdata[indexPath.row].message
        cell.lblDate.text = NotificationData?.nbdata[indexPath.row].createon
        
        if NotificationData?.nbdata[indexPath.row].notificationType == "Event" {
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.4862745098, alpha: 1)
            cell.lblName.textColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.4862745098, alpha: 1)
            

            
            cell.DetailsCallback = { [self] value in
                // Fetch the clicked notification ID
                guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                    print("Notification ID not found")
                    return
                }

                // Call API first to hide the notification
                callHideNotificationWebService(notificationID: notificationID) {
                    // After API call, navigate to PollsDetailViewController
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController") as! EventsDetailViewController

                    vc.eventid = NotificationData?.nbdata[indexPath.row].id ?? ""
                    vc.id = notificationID
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }

           
        } else if NotificationData?.nbdata[indexPath.row].notificationType == "Group" {
            
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1)
            cell.lblName.textColor = #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1)
            
            cell.DetailsCallback = { [self] value in
                
                guard let groupType = NotificationData?.nbdata[indexPath.row].groupType else { return }
                
                if groupType == "Public" {
                    // Open GroupsViewController for Public groups
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsViewController") as! GroupDetailsViewController
                    guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                        print("Notification ID not found")
                        return
                    }
                    callHideNotificationWebService(notificationID: notificationID) {
                        vc.groupid = NotificationData?.nbdata[indexPath.row].id ?? ""
                        vc.userid = NotificationData?.nbdata[indexPath.row].notificationID ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                } else if groupType == "Private" {
                    // Open GroupDetailsViewController for Private groups
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController") as! GroupsViewController
                    guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                        print("Notification ID not found")
                        return
                    }
                    callHideNotificationWebService(notificationID: notificationID) {
                        vc.groupid = NotificationData?.nbdata[indexPath.row].id ?? ""
                        vc.userid = NotificationData?.nbdata[indexPath.row].notificationID ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }

        
        else if NotificationData?.nbdata[indexPath.row].notificationType == "Post" {

            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.337254902, blue: 0.2745098039, alpha: 1)
            cell.lblName.textColor = #colorLiteral(red: 0.5960784314, green: 0.337254902, blue: 0.2745098039, alpha: 1)
            
            cell.DetailsCallback = { [self] value in
                // Check if the title is "Direct Message"
                if NotificationData?.nbdata[indexPath.row].title == "Comment on Post" {
                    guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                        print("Notification ID not found")
                        return
                    }
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as? PostDetailsViewController else { return }
                    
                    callHideNotificationWebService(notificationID: notificationID) {
                        vc.postid =  NotificationData?.nbdata[indexPath.row].id ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                } else {
                    guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                        print("Notification ID not found")
                        return
                    }
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController else { return }
                    
                    callHideNotificationWebService(notificationID: notificationID) {
                      //  vc.id = notificationID
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }

        
        else if NotificationData?.nbdata[indexPath.row].notificationType == "Poll" {
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.6862745098, green: 0.6156862745, blue: 0.4, alpha: 1)
            cell.lblName.textColor = #colorLiteral(red: 0.6862745098, green: 0.6156862745, blue: 0.4, alpha: 1)

            cell.DetailsCallback = { [self] value in
                // Fetch the clicked notification ID
                guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                    print("Notification ID not found")
                    return
                }

                // Call API first to hide the notification
                callHideNotificationWebService(notificationID: notificationID) {
                    // After API call, navigate to PollsDetailViewController
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollsDetailViewController") as! PollsDetailViewController

                    vc.pollid = NotificationData?.nbdata[indexPath.row].id ?? ""
                    vc.id = notificationID // Sending the clicked notification ID
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }


        
        else if NotificationData?.nbdata[indexPath.row].notificationType == "Business" {
           
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.5098039216, green: 0.5843137255, blue: 0.568627451, alpha: 1)
            cell.lblName.textColor = #colorLiteral(red: 0.5098039216, green: 0.5843137255, blue: 0.568627451, alpha: 1)
            

            
            cell.DetailsCallback = { [self] value in
                // Fetch the clicked notification ID
                guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                    print("Notification ID not found")
                    return
                }

                // Call API first to hide the notification
                callHideNotificationWebService(notificationID: notificationID) {
                    // After API call, navigate to PollsDetailViewController
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as! BusinessDetailsViewController

                    vc.business_id = NotificationData?.nbdata[indexPath.row].id ?? ""
                    vc.id = notificationID // Sending the clicked notification ID
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
         
        }
        
        else if NotificationData?.nbdata[indexPath.row].notificationType == "Marketplacechat" {
           
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1)
            cell.lblName.textColor = #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1)
            
            

            
            cell.DetailsCallback = { [self] value in
                // Fetch the clicked notification ID
                guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                    print("Notification ID not found")
                    return
                }

                // Call API first to hide the notification
                callHideNotificationWebService(notificationID: notificationID) {
                    // After API call, navigate to PollsDetailViewController
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController") as! MarketDetailViewController

                    vc.idD = NotificationData?.nbdata[indexPath.row].id ?? ""
                    vc.id = notificationID // Sending the clicked notification ID
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
         
        }
        
        else if NotificationData?.nbdata[indexPath.row].notificationType == "Directmessage" {
           
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            cell.lblName.textColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            
            

            
            cell.DetailsCallback = { [self] value in
                // Fetch the clicked notification ID
                guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                    print("Notification ID not found")
                    return
                }

                // Call API first to hide the notification
                callHideNotificationWebService(notificationID: notificationID) {
                    // After API call, navigate to PollsDetailViewController
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController

                    vc.otherid = NotificationData?.nbdata[indexPath.row].createdOwner ?? ""
                    vc.userName = NotificationData?.nbdata[indexPath.row].ownername ?? ""
                    vc.id = notificationID // Sending the clicked notification ID
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
         
        }
        
        else if NotificationData?.nbdata[indexPath.row].notificationType == "Groupchat" {
           
            cell.viewNotification.backgroundColor =  #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1)
            cell.lblName.textColor =  #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1)
            
            
//            cell.DetailsCallback = { [self] value in
//
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupMessageViewController")as! GroupMessageViewController
//
//                vc.groupid = NotificationData?.nbdata[indexPath.row].id ?? ""
//                vc.GroupName = NotificationData?.nbdata[indexPath.row].groupchatName ?? ""
//                vc.userImage = NotificationData?.nbdata[indexPath.row].groupchatImage ?? ""
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            }
            
            cell.DetailsCallback = { [self] value in
                // Fetch the clicked notification ID
                guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                    print("Notification ID not found")
                    return
                }

                // Call API first to hide the notification
                callHideNotificationWebService(notificationID: notificationID) {
                    // After API call, navigate to PollsDetailViewController
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupMessageViewController") as! GroupMessageViewController

                    vc.groupid = NotificationData?.nbdata[indexPath.row].id ?? ""
                    vc.GroupName = NotificationData?.nbdata[indexPath.row].groupchatName ?? ""
                    vc.userImage = NotificationData?.nbdata[indexPath.row].groupchatImage ?? ""
                    vc.id = notificationID // Sending the clicked notification ID
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
         
        }
        
        else if NotificationData?.nbdata[indexPath.row].notificationType == "Member" {
           
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.6862745098, green: 0.4196078431, blue: 0.462745098, alpha: 1)
            cell.lblName.textColor = #colorLiteral(red: 0.6862745098, green: 0.4196078431, blue: 0.462745098, alpha: 1)
         
        }
        
        
       
        
        cell.lblName.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 14)
        cell.lblDate.font = UIFont(name: "Montserrat-Regular", size: 10)
        
        cell.viewNotification.roundCorners([.topLeft, .bottomLeft], radius: 25)
       
        return cell
    }
    
    


    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    
}
