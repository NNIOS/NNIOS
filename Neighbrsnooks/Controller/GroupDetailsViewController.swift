import UIKit
import SVProgressHUD


@available(iOS 16.0, *)
class GroupDetailsViewController: BaseViewController, ConfirmNewDelegate  {
    
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
    
    var account = ""
    var selection = 1
    var userid: String?
    var groupid: String?
    var userName: String?
    var groupName: String?
    var refreshTimer: Timer?
    var memberUserId: String?
    var JoinListData: JoinGroupModel?
    var GrouListsData: GroupListModel?
    var GroupListData: GropsListModel?
    var DeleteUserData: DeleteUserModel?
    var GrouDeleteData: GroupDeleteModel?
    var GrouDetailsData: GroupDetailsModel?
    var ApproveGroupData: ApproveGroupModel?
    
    func tapConfirm() {
        callGroupListGroupWebService{}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        updateColors()
        self.GroupNameLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.DescriptionLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        tableviewDetails.dataSource = self
        tableviewDetails.delegate = self
        NetworkMonitor.shared.startMonitoring()
        tableviewDetails.allowsSelection = false
        self.GroupTypeLbl.textColor = .secondaryLabel
        callDetailsGroupWebService{ [self] in
            SVProgressHUD.dismiss()
            self.GroupNameLbl.text = self.GrouDetailsData?.groupname
            self.DescriptionLbl.text = self.GrouDetailsData?.description
            if GrouDetailsData?.membJoinStatus == 0 {
                btnJoin.isHidden = false
            } else {
                btnJoin.isHidden = true
            }
            if let groupType = self.GrouDetailsData?.groupType {
                self.GroupTypeLbl.text = "\(groupType) Group"
            } else {
                self.GroupTypeLbl.text = "N/A Group"
            }
            
            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                print("id: \(id), idCr: \(idCr)")
                
                if id == idCr {
                    self.btnedit.isHidden = false
                    self.btnDel.isHidden = false
                    
                } else {
                    self.btnedit.isHidden = true
                    self.btnDel.isHidden = true
                }
            } else {
                print("UserDefaults values are nil")
            }
            let url = URL(string: (self.GrouDetailsData?.image ?? ""))
            self.profileImgView.kf.indicatorType = .activity
            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupImg"))
        }
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
            if let memberCount = GrouDetailsData?.membercount {
                self.MembersLbl.text = "\(memberCount) members"
            } else {
                self.MembersLbl.text = "N/A"
            }
            if GrouDetailsData?.membJoinStatus == 0 {
                btnJoin.isHidden = false
            } else {
                btnJoin.isHidden = true
            }
            if let groupType = self.GrouDetailsData?.groupType {
                self.GroupTypeLbl.text = "\(groupType) Group"
            } else {
                self.GroupTypeLbl.text = "N/A Group"
            }
            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                print("id: \(id), idCr: \(idCr)")
                if id == idCr {
                    self.btnedit.isHidden = false
                    self.btnDel.isHidden = false
                } else {
                    self.btnedit.isHidden = true
                    self.btnDel.isHidden = true
                }
            } else {
                print("UserDefaults values are nil")
            }
            let url = URL(string: (self.GrouDetailsData?.image ?? ""))
            self.profileImgView.kf.indicatorType = .activity
            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupImg"))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        updateColors()
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
                if let groupType = self.GrouDetailsData?.groupType {
                    self.GroupTypeLbl.text = "\(groupType) Group"
                } else {
                    self.GroupTypeLbl.text = "N/A Group"
                }
                
                if let id = UserDefaults.standard.string(forKey: "userid"),
                   let idCr = UserDefaults.standard.string(forKey: "usercr") {
                    print("id: \(id), idCr: \(idCr)")
                    if id == idCr {
                        self.btnedit.isHidden = false
                        self.btnDel.isHidden = false
                    } else {
                        self.btnedit.isHidden = true
                        self.btnDel.isHidden = true
                    }
                } else {
                    print("UserDefaults values are nil")
                }
                let url = URL(string: (self.GrouDetailsData?.image ?? ""))
                self.profileImgView.kf.indicatorType = .activity
                self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupImg"))
            }
        }
    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DeleteGroupBtnAction(_ sender: UIButton) {
        callGroupDeleteWebService{}
    }
    
    @IBAction func DeletePopUpBtnAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let messageText = "Are you sure you want to remove this group?"
        let attributedMessage = NSAttributedString(string: messageText, attributes: [
            .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        ])
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)
        let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.callGroupDeleteWebService {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.tableviewDetails.reloadData()
                    self.tableviewDetails.layoutIfNeeded()
                    print("UI updated")
                }
            }
        }
        yesAction.setValue(yesColor, forKey: "titleTextColor")
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(noColor, forKey: "titleTextColor")
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func callGroupDeleteWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "groupid": groupid ?? "",
        ]
        print("param is :\(dictParams)")
        WebService.sharedInstance.callGroupDeleteWebService(withParams: dictParams) { data in
            self.GrouDeleteData = data
            completionClosure()
        }
    }
    
    @IBAction func DeclineBtnAction(_ sender: UIButton) {
        account = "2"
    }
}


extension GroupDetailsViewController {
    
    func callJoinGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
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
    
    func callAcceptGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "owner":id ?? "",
            "groupname":self.GroupNameLbl.text ?? "",
            "groupid": groupid ?? "",
            "userid":memberUserId ?? "",
            "type": account
        ]
        print("Param is :\(dictParams)")
        WebService.sharedInstance.callAcceptGroupWebService(withParams: dictParams) { [self] data in
            self.ApproveGroupData = data
//            self.callGroupListGroupWebService{}
//            self.navigationController?.popViewController(animated: true)
            completionClosure()
        }
    }
    
    func callDetailsGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "groupid": groupid ?? "",
            
        ]
        WebService.sharedInstance.callDetailsGroupWebService(withParams: dictParams) { data in
            self.GrouDetailsData = data
            UserDefaults.standard.set(self.GrouDetailsData?.createdby, forKey: "usercr")
            UserDefaults.standard.set(self.GrouDetailsData?.groupname, forKey: "groupName")
            completionClosure()
        }
    }
    
    func callGroupListGroupWebService(_ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = ["groupid": groupid ?? ""]
        print("Params are: \(dictParams)")
        
        WebService.sharedInstance.callGroupListGroupWebService(withParams: dictParams) { [weak self] data in
            guard let self = self else { return }
            print("New data received: \(data)")
            self.GrouListsData = data
            if let members = self.GrouListsData?.memberlist,
               let index = self.GrouDetailsData?.membercount,
               index >= 0, index < members.count {
                memberUserId = members[index].userid
                print("User ID at index \(index): \(memberUserId ?? "")")
            } else {
                print("Invalid index or missing data")
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
        let dictParams: Dictionary<String, Any> = [
            "userid": memberUserId ?? "",
            "groupname": self.GroupNameLbl.text ?? "",
        ]
        print("Param is :\(dictParams)")
        WebService.sharedInstance.callDelUserGroupWebService(withParams: dictParams) { data in
            self.DeleteUserData = data
            self.tableviewDetails.reloadData()
            self.tableviewDetails.layoutIfNeeded()
            completionClosure()
        }
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            GroupBgView.backgroundColor = .black
            MembersDescView.backgroundColor = .black
            PublicView.backgroundColor = .black
            MembersDescView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            PublicView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            DescriptionLbl.textColor = .white
            MembersDescView.layer.borderWidth = 1.0
            PublicView.layer.borderWidth = 1.0
            
        } else {
            GroupBgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            MembersDescView.backgroundColor = .white
            PublicView.backgroundColor = .white
            
            MembersDescView.layer.borderWidth = 0
            PublicView.layer.borderWidth = 0
            DescriptionLbl.textColor = UIColor.secondaryLabel
        }
    }
}


extension GroupDetailsViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return GrouListsData?.memberlist.count ?? 0
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
                if let id = UserDefaults.standard.string(forKey: "userid") {
                    if id == memberUserId {
                        vc.Oid = memberUserId
                    } else if let ownerId = GrouListsData?.ownerid {
                        vc.Oid = ownerId
                    }
                }
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
                    cell.btnDelete.isHidden = true
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
                print("UserDefaults values are nil")
            }
            
            cell.AcceptCallback = { [weak self] value in
                guard let self = self else { return }
                print("Accept callback triggered")
                self.account = "1"
                self.memberUserId = self.GrouListsData?.memberlist[indexPath.row].userid
                print("Selected UserID for Accept: \(self.memberUserId ?? "")")
                
                self.callAcceptGroupWebService { [weak self] in
                    guard let self = self else { return }
                    print("Accept service completed")
                    self.callGroupListGroupWebService {
                        DispatchQueue.main.async {
                            print("Final UI update")
                            self.tableviewDetails.reloadData()
                            self.tableviewDetails.layoutIfNeeded()
                            
                            // 🚫 prevent navigation back
                            if let nav = self.navigationController,
                               nav.topViewController != self {
                                nav.pushViewController(self, animated: false)
                            }
                        }
                    }
                }
            }
            
            
            cell.DeclineCallback = { [self] value in
                account = "2"
                self.memberUserId = self.GrouListsData?.memberlist[indexPath.row].userid
                print("Selected UserID for Accept: \(self.memberUserId ?? "")")
                self.callAcceptGroupWebService { [weak self] in
                    print("Accept service completed")
                    self?.callGroupListGroupWebService {
                        DispatchQueue.main.async {
                            print("Final UI update")
                            self?.tableviewDetails.reloadData()
                            self?.tableviewDetails.layoutIfNeeded()
                            
                            if let nav = self?.navigationController,
                               nav.topViewController != self {
                                nav.pushViewController(self!, animated: false)
                            }
                        }
                    }
                }
            }
            
            cell.ProfileDetailCallback = { [self] value in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController")as! MyProfileViewController
                if let id = UserDefaults.standard.string(forKey: "userid") {
                    if id == self.GrouListsData?.memberlist[indexPath.row].userid {
                        vc.Oid = id
                        vc.sourceViewController = "MyProfile"
                    } else {
                        vc.Oid = self.GrouListsData?.memberlist[indexPath.row].userid
                        vc.sourceViewController = "OtherProfile"
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            cell.DelUserCallback = { [self] value in
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                let messageText = "Are you sure you want to remove this user?"
                let attributedMessage = NSAttributedString(string: messageText, attributes: [
                    .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
                    .foregroundColor: UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
                ])
                alertController.setValue(attributedMessage, forKey: "attributedMessage")
                
                let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)
                let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                    self.memberUserId = self.GrouListsData?.memberlist[indexPath.row].userid
                    print("Selected UserID for Accept: \(self.memberUserId ?? "")")
                    self.callDelUserGroupWebService {
                        self.callGroupListGroupWebService {
                            DispatchQueue.main.async {
                                self.tableviewDetails.reloadData()
                                self.tableviewDetails.layoutIfNeeded()
                                print("UI updated")
                            }
                        }
                    }
                }
                yesAction.setValue(yesColor, forKey: "titleTextColor")
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                noAction.setValue(noColor, forKey: "titleTextColor")
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }
            let url = URL(string: (GrouListsData?.memberlist[indexPath.row].userphoto ?? ""))
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
            return cell
        }
    }
}
