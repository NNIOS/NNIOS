import UIKit
import SVProgressHUD


@available(iOS 16.0, *)
class GroupDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ConfirmNewDelegate  {
    
    @IBOutlet weak var tableviewDetails: UITableView!
    @IBOutlet weak var MembersLbl: UILabel!
    @IBOutlet weak var GroupNameLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var DescriptionLbl: UILabel!
    @IBOutlet weak var GroupTypeLbl: UILabel!
    @IBOutlet weak var btnedit: UIButton!
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var GroupBgView: UIView!
    @IBOutlet weak var MembersDescView: UIView!
    @IBOutlet weak var PublicView: UIView!
    
    
    var selection = 1
    var GrouDetailsData : GroupDetailsModel?
    var GrouListsData : GroupListModel?
    var GrouDeleteData : GroupDeleteModel?
    var DeleteUserData : DeleteUserModel?
    var GroupListData : GropsListModel?
    var groupid : String?
    var userid : String?
    var account = ""
    var JoinListData : JoinGroupModel?
    var userName : String?
    var groupName : String?
    
    var ApproveGroupData : ApproveGroupModel?
    var refreshTimer: Timer?
    
    func tapConfirm() {
     //   callGroupListWebService{}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
        self.GroupNameLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.DescriptionLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        tableviewDetails.dataSource = self
        tableviewDetails.delegate = self
        NetworkMonitor.shared.startMonitoring()
        startRepeatingAPICall()
        tableviewDetails.allowsSelection = false

        callDetailsGroupWebService{ [self] in
            SVProgressHUD.dismiss()
            self.GroupNameLbl.text = self.GrouDetailsData?.groupname
            self.DescriptionLbl.text = self.GrouDetailsData?.description
            

            if GrouDetailsData?.membJoinStatus == 0 {
                btnJoin.isHidden = false
            } else {
                btnJoin.isHidden = true
            }


           // print("Button hidden state after: \(btnJoin.isHidden)")


            
            if let groupType = self.GrouDetailsData?.groupType {
                self.GroupTypeLbl.text = "\(groupType) Group"
            } else {
                self.GroupTypeLbl.text = "N/A Group" // Fallback if groupType is nil
            }

            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                print("id: \(id), idCr: \(idCr)") // Debugging output
                
                if id == idCr {
                    self.btnedit.isHidden = false
                    self.btnDel.isHidden = false
                   
                } else {
                    self.btnedit.isHidden = true
                    self.btnDel.isHidden = true
                   
                }
            } else {
                print("UserDefaults values are nil") // Handle nil case
            }
          
            
            let url = URL(string: (self.GrouDetailsData?.image ?? ""))
            self.profileImgView.kf.indicatorType = .activity
           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupImg"))
            

        }
     
    }
    
    func startRepeatingAPICall() {
        // Invalidate existing timer if already running
        refreshTimer?.invalidate()
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.callGroupListGroupWebService {
                print("API call completed")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        
        SVProgressHUD.show()
       
        callGroupListGroupWebService{
            self.tableviewDetails.reloadData()
        }
        callDetailsGroupWebService{ [self] in
            SVProgressHUD.dismiss()
            self.GroupNameLbl.text = self.GrouDetailsData?.groupname
            self.DescriptionLbl.text = self.GrouDetailsData?.description
          //  self.GroupNameLbl.text = self.GrouDetailsData?.membercount
            if let memberCount = GrouDetailsData?.membercount {
                self.MembersLbl.text = "\(memberCount) members"
            } else {
                self.MembersLbl.text = "N/A" // Or some default value
            }
            


            if GrouDetailsData?.membJoinStatus == 0 {
                btnJoin.isHidden = false
            } else {
                btnJoin.isHidden = true
            }


            if let groupType = self.GrouDetailsData?.groupType {
                self.GroupTypeLbl.text = "\(groupType) Group"
            } else {
                self.GroupTypeLbl.text = "N/A Group" // Fallback if groupType is nil
            }

            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                print("id: \(id), idCr: \(idCr)") // Debugging output
                
                if id == idCr {
                    self.btnedit.isHidden = false
                    self.btnDel.isHidden = false
                   
                } else {
                    self.btnedit.isHidden = true
                    self.btnDel.isHidden = true
                   
                }
            } else {
                print("UserDefaults values are nil") // Handle nil case
            }
          
            
            let url = URL(string: (self.GrouDetailsData?.image ?? ""))
            self.profileImgView.kf.indicatorType = .activity
           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupImg"))
            

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateColors()
       
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            GroupBgView.backgroundColor = .black
            MembersDescView.backgroundColor = .black
            PublicView.backgroundColor = .black
            MembersDescView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            PublicView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            DescriptionLbl.textColor = .white
            
           
            MembersDescView.layer.borderWidth = 1.0
            PublicView.layer.borderWidth = 1.0
           
        } else {
            // Light mode mein storyboard ke original colors preserve karna
           
            // Light mode mein PollsView ka background red karna
            GroupBgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            MembersDescView.backgroundColor = .white
            PublicView.backgroundColor = .white
            
            MembersDescView.layer.borderWidth = 0
            PublicView.layer.borderWidth = 0
           // lblName.textColor = defaultTextColor
           
            DescriptionLbl.textColor = UIColor.secondaryLabel
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors() // Re-apply colors on theme change
        }
    }
    
    @IBAction func btnDiscussion(_ : UIButton){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupMessageViewController")as! GroupMessageViewController
        vc.groupid = GrouDetailsData?.groupid
        vc.GroupName = GrouListsData?.groupname
        vc.userImage = GrouDetailsData?.image

    
        self.navigationController?.pushViewController(vc, animated: true)
       }
    
    @IBAction func btnEdit(_ : UIButton){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateGroupViewController")as! UpdateGroupViewController
        
        vc.groupid = GrouDetailsData?.groupid
        self.navigationController?.pushViewController(vc, animated: true)
        
       }
    
    @IBAction func btnJoinGroup(_ : UIButton){

        self.callJoinGroupWebService {
            self.callDetailsGroupWebService{ [self] in
                SVProgressHUD.dismiss()
                self.GroupNameLbl.text = self.GrouDetailsData?.groupname
                self.DescriptionLbl.text = self.GrouDetailsData?.description
//
//                if GrouDetailsData?.membJoinStatus == 0 {
//                    btnJoin.isHidden = false
//
//
//                } else if GrouDetailsData?.membJoinStatus == 1 {
//
//                    btnJoin.isHidden = true
//
//
//                }
                
                if let groupType = self.GrouDetailsData?.groupType {
                    self.GroupTypeLbl.text = "\(groupType) Group"
                } else {
                    self.GroupTypeLbl.text = "N/A Group" // Fallback if groupType is nil
                }

                if let id = UserDefaults.standard.string(forKey: "userid"),
                   let idCr = UserDefaults.standard.string(forKey: "usercr") {
                    print("id: \(id), idCr: \(idCr)") // Debugging output
                    
                    if id == idCr {
                        self.btnedit.isHidden = false
                        self.btnDel.isHidden = false
                       
                    } else {
                        self.btnedit.isHidden = true
                        self.btnDel.isHidden = true
                       
                    }
                } else {
                    print("UserDefaults values are nil") // Handle nil case
                }
              
                
                let url = URL(string: (self.GrouDetailsData?.image ?? ""))
                self.profileImgView.kf.indicatorType = .activity
               self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupImg"))
                

            }
        }
       }

    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func DeleteGroupBtnAction(_ sender: UIButton) {
      
        callGroupDeleteWebService{}

   }
    
    @IBAction func DeletePopUpBtnAction(_ sender: UIButton) {
      
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)

            // Customizing the message font and size
            let messageText = "Are you sure you want to remove this group?"
            let attributedMessage = NSAttributedString(string: messageText, attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
                .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            ])
            alertController.setValue(attributedMessage, forKey: "attributedMessage")

            // Define RGB Colors
            let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)  // Green
            let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)   // Red

            // Yes Action
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.callGroupDeleteWebService {
                    // Pop one screen back after the API call is successful
                    self.navigationController?.popViewController(animated: true)
                }
            }
            yesAction.setValue(yesColor, forKey: "titleTextColor") // Set Yes button color

            // No Action
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            noAction.setValue(noColor, forKey: "titleTextColor") // Set No button color

            alertController.addAction(yesAction)
            alertController.addAction(noAction)

            // Present the alert
            self.present(alertController, animated: true, completion: nil)
   }
    
    func callGroupDeleteWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                     "userid":id ?? "",
                                                    "groupid": groupid ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callGroupDeleteWebService(withParams: dictParams) { data in
            self.GrouDeleteData = data
         

            completionClosure()
          }
        }
    
    
   
   @IBAction func DeclineBtnAction(_ sender: UIButton) {
       
       account = "2"
      
   }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController")as! MyProfileViewController
//       // vc.id = GrouListsData?.memberlist[indexPath.row].userid ?? ""
//
//      //  vc.sourceViewController = "MessageViewController"
//        vc.Oid = GrouListsData?.memberlist[indexPath.row].userid ?? ""
//
//
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        
        }else{
            return GrouListsData?.memberlist.count ?? 0
           // GrouListsData?.memberlist.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if indexPath.section == 0 {
        let cell: GroupOwnerableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroupOwnerableViewCell") as! GroupOwnerableViewCell
           
           cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
           cell.lblOwner.font = UIFont(name: "Montserrat-Regular", size: 13)
           cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 13)
           cell.lblName.text = GrouListsData?.groupusername
           cell.lblSector.text = GrouListsData?.groupuserneigh
           
           let url = URL(string: (GrouListsData?.groupuserpic ?? ""))
           cell.profileImgView.kf.indicatorType = .activity
           cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
           
           cell.ProfileDetailCallback = { [self] value in
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController")as! MyProfileViewController
              
               vc.Oid = GrouListsData?.ownerid
               self.navigationController?.pushViewController(vc, animated: true)
           
                    }

            return cell
            
        
        }else {
        let cell: GroupMemberTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberTableViewCell") as! GroupMemberTableViewCell
            cell.lblName.text = GrouListsData?.memberlist[indexPath.row].username
            cell.lblSector.text = GrouListsData?.memberlist[indexPath.row].neighbrhood
            cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 13)
            
            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                print("id: \(id), idCr: \(idCr)") // Debugging output

                if id == idCr {
                    // If id == idCr, btnDelete should be hidden regardless of status == "2"
                    cell.btnDelete.isHidden = true

                    // Apply status-based conditions
                    if GrouListsData?.memberlist[indexPath.row].status == "2" {
                        cell.btnAccept.isHidden = false
                        cell.btnDecline.isHidden = false
                        cell.btnDelete.isHidden = true
                    } else if GrouListsData?.memberlist[indexPath.row].status == "1" {
                        cell.btnAccept.isHidden = true
                        cell.btnDecline.isHidden = true
                        cell.btnDelete.isHidden = false
                    }
                } else {
                    // If id != idCr, apply normal conditions
                    if GrouListsData?.memberlist[indexPath.row].status == "2" {
                        cell.btnAccept.isHidden = true
                        cell.btnDecline.isHidden = true
                        cell.btnDelete.isHidden = true
                    } else if GrouListsData?.memberlist[indexPath.row].status == "1" {
                        cell.btnAccept.isHidden = true
                        cell.btnDecline.isHidden = true
                        cell.btnDelete.isHidden = true
                    }
                }
            } else {
                print("UserDefaults values are nil") // Handle nil case
            }

            
            cell.AcceptCallback = { [weak self] value in
                guard let self = self else { return }
                
                print("Accept callback triggered")
                self.account = "1"
                
                self.callAcceptGroupWebService { [weak self] in
                    print("Accept service completed")
                    self?.callGroupListGroupWebService {
                        DispatchQueue.main.async {
                            print("Final UI update")
                            self?.tableviewDetails.reloadData()
                            self?.tableviewDetails.layoutIfNeeded()
                        }
                    }
                }
            }


            
            cell.DeclineCallback = { [self] value in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController")as! GroupsViewController
                account = "2"
                callAcceptGroupWebService{
                    self.tableviewDetails.reloadData()
                }
              //  self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.ProfileDetailCallback = { [self] value in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController")as! MyProfileViewController
               
                vc.Oid = self.GrouListsData?.memberlist[indexPath.row].userid
                self.navigationController?.pushViewController(vc, animated: true)
            
                     }
            
            cell.DelUserCallback = { [self] value in
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)

                // Customizing the message font and size
                let messageText = "Are you sure you want to remove this user?"
                let attributedMessage = NSAttributedString(string: messageText, attributes: [
                    .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
                    .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
                ])
                alertController.setValue(attributedMessage, forKey: "attributedMessage")

                // Define RGB Colors
                let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)  // Green
                let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)   // Red

                // Yes Action
                let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                    self.callDelUserGroupWebService {
                        self.callGroupListGroupWebService {
                            DispatchQueue.main.async {
                                self.tableviewDetails.reloadData()
                            }
                        }
                    }
                }
                yesAction.setValue(yesColor, forKey: "titleTextColor") // Set Yes button color

                // No Action
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                noAction.setValue(noColor, forKey: "titleTextColor") // Set No button color

                alertController.addAction(yesAction)
                alertController.addAction(noAction)

                // Present the alert
                self.present(alertController, animated: true, completion: nil)
            }


            
            let url = URL(string: (GrouListsData?.memberlist[indexPath.row].userphoto ?? ""))
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
            
           
            
        return cell
        
        }
        
    }
   
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       if indexPath.section == 0 {
//        return 100
//
//        }else{
//        return 100
//        }
//
//
//}
    
    
    func callJoinGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let UserName = UserDefaults.standard.string(forKey: "UserName")
        let grName = UserDefaults.standard.string(forKey: "groupName")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "groupid": groupid ?? "",
                                                    "groupname": grName ?? "",
                                                    "username": userName ?? ""
                                                   
                                                                        ]
          WebService.sharedInstance.callJoinGroupWebService(withParams: dictParams) { data in
            self.JoinListData = data
              if self.JoinListData?.status == "success"{
                  completionClosure()
              }else{
                  self.showAlert(Message: self.JoinListData?.message ?? "")
              }
          }
        }
  //  memberUserId
    
    func callAcceptGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idUser = UserDefaults.standard.string(forKey: "memberUserId")
          let dictParams: Dictionary<String, Any> = [
                                                    "owner":id ?? "",
                                                    "groupname":self.GroupNameLbl.text ?? "",
                                                    "groupid": groupid ?? "",
                                                    "userid":idUser ?? "",
                                                    
                                                    "type": account
                                                  //  "groupimage":  "\(NSDate().timeIntervalSince1970.rounded())"
                                                    
                                                   
                                                                        ]
        WebService.sharedInstance.callAcceptGroupWebService(withParams: dictParams) { [self] data in
              
              self.ApproveGroupData = data
            //  UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
              
             
              
              
          }
        }
    
    func callDetailsGroupWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "usercr")
        let grName = UserDefaults.standard.string(forKey: "groupName")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "groupid": groupid ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callDetailsGroupWebService(withParams: dictParams) { data in
            self.GrouDetailsData = data
              UserDefaults.standard.set(self.GrouDetailsData?.createdby, forKey: "usercr")
              UserDefaults.standard.set(self.GrouDetailsData?.groupname, forKey: "groupName")
//              if let members = self.GrouDetailsData?.memberlist {
//                         for (index, member) in members.enumerated() {
//                             if let userid = member.userid {
//                                 UserDefaults.standard.set(userid, forKey: "memberUserId_\(index)")
//                             }
//                         }
//                     }
          

            completionClosure()
          }
        }
    
//    func callGroupDeleteWebService(_ completionClosure: @escaping () -> ()) {
//       // let id = UserDefaults.standard.string(forKey: "userid")
//        let idName = UserDefaults.standard.string(forKey: "name")
//          let dictParams: Dictionary<String, Any> = [
//                                                    "userid":userid ?? "",
//                                                    "groupid": groupid ?? "",
//
//                                                                        ]
//          WebService.sharedInstance.callGroupDeleteWebService(withParams: dictParams) { data in
//            self.GrouDeleteData = data
//
//
//            completionClosure()
//          }
//        }
    
    func callGroupListGroupWebService(_ completionClosure: @escaping () -> ()) {
        let dictParams: Dictionary<String, Any> = ["groupid": groupid ?? ""]
        
        WebService.sharedInstance.callGroupListGroupWebService(withParams: dictParams) { [weak self] data in
            guard let self = self else { return }
            
            print("New data received: \(data)")
            self.GrouListsData = data
            
            if let members = self.GrouListsData?.memberlist {
                       for (index, member) in members.enumerated() {
                           if let userid = member.userid {
                               UserDefaults.standard.set(userid, forKey: "memberUserId")
                           }
                       }
                   }
            
            DispatchQueue.main.async {
                self.tableviewDetails.reloadData()
                self.tableviewDetails.layoutIfNeeded()
                print("UI updated")
            }
            
            completionClosure()
        }
    }

    
    func callDelUserGroupWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let idUser = UserDefaults.standard.string(forKey: "idUser")
          let dictParams: Dictionary<String, Any> = [
                                                    
                                                    "userid": idUser ?? "",
                                                    "groupname": self.GroupNameLbl.text ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callDelUserGroupWebService(withParams: dictParams) { data in
            self.DeleteUserData = data
          //    UserDefaults.standard.set(self.neighbrhoodData?.nearestNeighbrhood.name, forKey: "neighbrshood")
//              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
              UserDefaults.standard.set(self.GrouListsData?.memberlist.first?.userid, forKey: "idUser")
            //  UserDefaults.standard.set(self.groupl?.data., forKey: "profileImage")

            completionClosure()
          }
        }
        
    }
