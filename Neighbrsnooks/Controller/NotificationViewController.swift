//
//  NotificationViewController.swift
//  NeighbrsNook Latest
//
//  Created by  on 02/03/24.
//

import UIKit
import SVProgressHUD
@available(iOS 16.0, *)
class NotificationViewController: BaseViewController {
    
    var NotificationData : NotificationModel?
    var HideNotificationData : HideNotificationModel?
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tableviewMembers: UITableView!
    
    
    var sideMenuVisible = false
    var profileData : ProfileModel?
    let transitionManager = SideMenuTransitionManager()
    var NotificationCountData : NotificationCountModel?
    var notiid = ""
     let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        NetworkMonitor.shared.startMonitoring()
        tableviewMembers.separatorStyle = .none
//        tableviewMembers.rowHeight = UITableView.automaticDimension
        
        // 🌀 Add refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableviewMembers.refreshControl = refreshControl
        
        // 🔁 Initial API call
        callNoticationWebService {
            self.tableviewMembers.reloadData()
            DispatchQueue.main.async {
                self.tableviewMembers.reloadData()
                self.tableviewMembers.layoutIfNeeded()
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callNoticationWebService {
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
        }
        
        callNotificationCountWebService()
    }
    
    
    
    
    @objc func refreshData() {
        callNoticationWebService {
            DispatchQueue.main.async {
                self.tableviewMembers.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        // ✅ Optionally update count too
        callNotificationCountWebService()
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
//            
//            completionClosure()
//        }
    }
    
    func callHideNotificationWebService(notificationID: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
        let dictParams: [String: Any] = [
            "userid": id ?? "",
            "appkey": "abc1239",
            "not_Id": notificationID // Sending as a string instead of an array
        ]
        
//        WebService.sharedInstance.callHideNotificationWebService(withParams: dictParams) { data in
//            self.HideNotificationData = data
//            
//            // Clear stored notiId after successful API call (if needed)
//            UserDefaults.standard.removeObject(forKey: "notiId")
//            
//            completionClosure()
//        }
    }
    
    
    
    // dev.
    func callNotificationCountWebService() {
        let url = "https://neighbrsnook.com/admin/api/notificationcount?flag=counter&appkey=abc1239"
        
        // let dictParams: Dictionary<String, Any> = ["":""]
        
        
        let id = UserDefaults.standard.string(forKey: "userid")
        
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            
            
        ]
//        
//        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true)
//        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            switch statusCode {
//            case .SUCCESS ,.CREATED:
//                do {
//                    let data = try JSONDecoder().decode(NotificationCountModel.self, from: result!)
//                    self.NotificationCountData = data
//                    //  self.collectionViewMyEvent.reloadData()
//                    
//                    //    completionClosure(data)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
//                do {
//                    let data = try JSONDecoder().decode(NotificationCountModel.self, from: result!)
//                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .UNAUTHORIZED:
//                print(error?.localizedDescription)
//                //   self.showLogoutAlert()
//            default:
//                break
//            }
//        }
    }
    
    
    
    
    func callNoticationWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
        let dictParams: [String: Any] = [
            "userid": id ?? "",
            "appkey": "abc1239"
        ]
        
//        WebService.sharedInstance.callNoticationWebService(withParams: dictParams) { data in
//            self.NotificationData = data
//            
//            // Extract notificationIDs
//            let notificationIDs = self.NotificationData?.nbdata.compactMap { $0.notificationID } ?? []
//            
//            // Convert Array to JSON String
//            if let jsonData = try? JSONSerialization.data(withJSONObject: notificationIDs, options: []),
//               let jsonString = String(data: jsonData, encoding: .utf8) {
//                UserDefaults.standard.set(jsonString, forKey: "notiId")
//            }
//            
//            completionClosure()
//        }
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
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController") as! EventsDetailViewController
//                    
//                    vc.eventid = NotificationData?.nbdata[indexPath.row].id ?? ""
//                    vc.id = notificationID
//                    
//                    self.navigationController?.pushViewController(vc, animated: true)
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
                    
                    // Open GroupsViewController for Private groups
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController") as! GroupsViewController
                    
                    guard let notificationID = self.NotificationData?.nbdata[indexPath.row].notificationID else {
                        print("Notification ID not found")
                        return
                    }
                    
                    if let id = UserDefaults.standard.string(forKey: "userid"),
                       let userList = NotificationData?.nbdata,
                       indexPath.row < userList.count {
                        
                        let userId = userList[indexPath.row].userid ?? ""
                        
                        if id == userId {
                            //                                vc.sourceViewController = "MyProfile"
                        } else {
                            //                                vc.sourceViewController = "OtherProfile"
                        }
                        
                        vc.userid = userId
                        
                        if let index = userList.firstIndex(where: { $0.userid == userId }) {
                            print("Index of userId is: \(index)")
                        }
                    }
                    
                    callHideNotificationWebService(notificationID: notificationID) {
                        vc.groupid = self.NotificationData?.nbdata[indexPath.row].id ?? ""
                        vc.userid = self.NotificationData?.nbdata[indexPath.row].notificationID ?? "" // double check this line, might be wrong logically
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
                    cell.viewNotification.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.337254902, blue: 0.2745098039, alpha: 1)
                    cell.lblName.textColor = #colorLiteral(red: 0.5960784314, green: 0.337254902, blue: 0.2745098039, alpha: 1)
                    guard let notificationID = NotificationData?.nbdata[indexPath.row].notificationID else {
                        print("Notification ID not found")
                        return
                    }
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailsNewViewController") as? PostDetailsNewViewController else { return }
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
                        cell.viewNotification.backgroundColor = #colorLiteral(red: 0, green: 0.3921568627, blue: 0.5803921569, alpha: 1)
                        cell.lblName.textColor = #colorLiteral(red: 0, green: 0.3921568627, blue: 0.5803921569, alpha: 1)

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
                    vc.senderUserpic = NotificationData?.nbdata[indexPath.row].ownerpic ?? ""
                    vc.id = notificationID // Sending the clicked notification ID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
        
        else if NotificationData?.nbdata[indexPath.row].notificationType == "Groupchat" {
            cell.viewNotification.backgroundColor =  #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1)
            cell.lblName.textColor =  #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1)
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
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblDate.font = UIFont(name: "Montserrat-Regular", size: 10)
//        cell.viewNotification.roundCorners([.topLeft, .bottomLeft], radius: 25)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        //        spacer.backgroundColor = .clear
        return spacer
    }
    
    
    
}
