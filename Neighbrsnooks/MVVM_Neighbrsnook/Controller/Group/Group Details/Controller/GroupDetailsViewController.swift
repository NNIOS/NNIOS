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
    
    
    var jGroupId:Int?
    var objGroupList: GroupDetailItem?
    var objDeleteGroup: DeleteGroupResponse?
    
    var objGroupMember: GroupMemberResponse?
    var objDecryptedGroupMembers: [GroupMemberData]?
    var objGroupAccpt:GroupJoinResponse?

    
    func tapConfirm() {
        callGroupListGroupWebService{}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reach().isInternet() {
            groupDetailsAPI()
            groupMemberListAPI()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reach().isInternet() {
            groupDetailsAPI()
            groupMemberListAPI()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    func groupDetailsAPI() {
        let request = GroupDetails_Request(id: jGroupId ?? 0)
        let param: [String: Any] = ["id": jGroupId ?? 0]
        print("Group Detail apai param is :\(param)")
        let viewModel = GroupDetail_VM()
        let http = HttpUtility()
        
        viewModel.fetchGroupDetailData(parameter: param, request: request) { response in
            DispatchQueue.main.async {
                if let encryptedData = response?.data {
                    print("Encrypted Group Detail Data is :\(encryptedData)")
                    http.decryptGroupDetailtData(encryptedData: encryptedData) { decryptedResponse in
                        if let groupList = decryptedResponse,
                           let groupItem = groupList.data {
                            self.objGroupList = groupItem
                            DispatchQueue.main.async {
                                let creadedBy = self.objGroupList?.createdby
                                let userID = UserDefaults.standard.string(forKey: "userId")
                                print("User id is:\(userID ?? "")")
                                print("created by is: \(creadedBy ?? 0)")
                                if Int(userID ?? "") == creadedBy {
                                    self.btnedit.isHidden = false
                                    self.btnDel.isHidden = false
                                } else {
                                    self.btnedit.isHidden = true
                                    self.btnDel.isHidden = true
                                }
                                self.GroupNameLbl.text = self.objGroupList?.group_name
                                self.DescriptionLbl.text = self.objGroupList?.group_description
                                self.MembersLbl.text = "\(self.objGroupList?.membercount ?? 0) member"
                                if let groupType = self.objGroupList?.group_type {
                                    self.GroupTypeLbl.text = "\(groupType) Group"
                                } else {
                                    self.GroupTypeLbl.text = "N/A Group"
                                }

                              


                                ImageLoader.shared.setImage(
                                    on: self.profileImgView,
                                    urlString: self.objGroupList?.group_image,
                                    placeholder: "groupImg"
                                )
                                self.tableviewDetails.reloadData()
                                self.tableviewDetails.layoutIfNeeded()
                            }
                        } else {
                            print("❌ Failed to extract GroupDetailItem from decrypted response")
                        }
                    }
                } else {
                    print("❌ No encrypted data received")
                }
            }
        }
    }
    
    func groupMemberListAPI() {
        let request = GroupMember_Request(group_id: jGroupId ?? 0)
        let param: [String: Any] = ["group_id": request.group_id ?? 0]
        print("Group Member api param is :\(param)")
        
        let viewModel = GroupMember_VM()
        viewModel.groupmember(parameter: param, request: request) { response in
            DispatchQueue.main.async {
                guard let encryptedData = response?.data else {
                    print("❌ Group Member API failed or no data found")
                    return
                }
                
                // Store encrypted API response
                self.objGroupMember = response
                self.objGroupMember?.data = encryptedData
                
                // Decrypt the data
                HttpUtility().decryptGroupMembertData(encryptedData: encryptedData) { decryptedResponse in
                    DispatchQueue.main.async {
                        guard let groupMembers = decryptedResponse else {
                            print("❌ Decrypt failed")
                            return
                        }
                        self.objDecryptedGroupMembers = groupMembers
                        print("✅ Decrypted group members: \(groupMembers)")
                        self.tableviewDetails.reloadData()
                    }
                }
            }
        }
    }
    
    func groupApproveApi() {
        let request = GroupApprove_Request(group_id: 1, member_id: 2)
        let param: [String: Any] = ["group_id": request.group_id ?? 0,"member_id":request.member_id ?? 0]
        print("Group Member api param is :\(param)")
        
        let viewModel = GroupMember_VM()
        viewModel.groupApprove(parameter: param, request: request) { response in
            
            self.tableviewDetails.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        }
    }
    
    
    @IBAction func btnDiscussion(_ : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupMessageViewController")as! GroupMessageViewController
        vc.groupid = GrouDetailsData?.groupid
        vc.GroupName = GrouListsData?.groupname
        vc.userImage = GrouDetailsData?.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEdit(_ : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateGroupViewController")as! UpdateGroupViewController
        vc.groupid = jGroupId
        vc.objData = objGroupList
        print("Sending group id is: \(self.jGroupId ?? 0)")
        vc.onUpdateComplete = { [weak self] updatedGroup in
            guard let self = self else { return }
            self.objGroupList = updatedGroup
            DispatchQueue.main.async {
                self.GroupNameLbl.text = self.objGroupList?.group_name
                self.DescriptionLbl.text = self.objGroupList?.group_description
                self.MembersLbl.text = "\(self.objGroupList?.membercount ?? 0) member"
                if let groupType = self.objGroupList?.group_type {
                    self.GroupTypeLbl.text = "\(groupType) Group"
                } else {
                    self.GroupTypeLbl.text = "N/A Group"
                }
            }
        }
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
            self.callDeleteGroupApi()
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
//        WebService.sharedInstance.callGroupDeleteWebService(withParams: dictParams) { data in
//            self.GrouDeleteData = data
//            completionClosure()
//        }
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
//        WebService.sharedInstance.callJoinGroupWebService(withParams: dictParams) { data in
//            self.JoinListData = data
//            if self.JoinListData?.status == "success"{
//                completionClosure()
//            }else{
//                self.showAlert(Message: self.JoinListData?.message ?? "")
//            }
//        }
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
//        WebService.sharedInstance.callAcceptGroupWebService(withParams: dictParams) { [self] data in
//            self.ApproveGroupData = data
////            self.callGroupListGroupWebService{}
////            self.navigationController?.popViewController(animated: true)
//            completionClosure()
//        }
    }
    
    func callDetailsGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "groupid": groupid ?? "",
            
        ]
//        WebService.sharedInstance.callDetailsGroupWebService(withParams: dictParams) { data in
//            self.GrouDetailsData = data
//            UserDefaults.standard.set(self.GrouDetailsData?.createdby, forKey: "usercr")
//            UserDefaults.standard.set(self.GrouDetailsData?.groupname, forKey: "groupName")
//            completionClosure()
//        }
    }
    
    func callGroupListGroupWebService(_ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = ["groupid": groupid ?? ""]
        print("Params are: \(dictParams)")
        
//        WebService.sharedInstance.callGroupListGroupWebService(withParams: dictParams) { [weak self] data in
//            guard let self = self else { return }
//            print("New data received: \(data)")
//            self.GrouListsData = data
//            if let members = self.GrouListsData?.memberlist,
//               let index = self.GrouDetailsData?.membercount,
//               index >= 0, index < members.count {
//                memberUserId = members[index].userid
//                print("User ID at index \(index): \(memberUserId ?? "")")
//            } else {
//                print("Invalid index or missing data")
//            }
//            DispatchQueue.main.async {
//                self.tableviewDetails.reloadData()
//                self.tableviewDetails.layoutIfNeeded()
//                print("UI updated")
//            }
//            completionClosure()
//        }
    }
    
    func callDeleteGroupApi() {
        let request = DeleteGroup_Request(group_id: objGroupList?.groupid ?? 0)
        let param: [String: Any] = [ "group_id": request.group_id ]
        let viewModel = DeleteGroup_VM()
        viewModel.deleteGroup(parameter: param, request: request) { deleteResponse in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.objDeleteGroup = deleteResponse
                print("Delete group data is: \(String(describing: self.objDeleteGroup))")
                self.navigationController?.popViewController(animated: true)
            }
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
            print("return count is: \(objDecryptedGroupMembers?.count ?? 0)")
            return objDecryptedGroupMembers?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: GroupOwnerableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroupOwnerableViewCell") as! GroupOwnerableViewCell
            let imageURL = objGroupList?.userpic ?? ""
            cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.lblOwner.font = UIFont(name: "Montserrat-Regular", size: 13)
            cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 13)
            cell.lblName.text = objGroupList?.username
            cell.lblSector.text = objGroupList?.neighborhood
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: imageURL.isEmpty ? nil : imageURL, placeholder: "groupImg")
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
        } else {
            let cell: GroupMemberTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberTableViewCell") as! GroupMemberTableViewCell
            cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 13)
            let item = objDecryptedGroupMembers?[indexPath.row]
            if let imageURLString = item?.profile_pic, !imageURLString.isEmpty, let url = URL(string: imageURLString) {
                ImageLoader.shared.setImage(on: cell.profileImgView, urlString: url.absoluteString, placeholder: "check")
            } else {
                cell.profileImgView.image = UIImage(named: "check")
            }
            cell.lblName.text = item?.full_name
            cell.lblSector.text = item?.neighbourhood
            let creadedBy = self.objGroupList?.createdby
            let userID = UserDefaults.standard.string(forKey: "userId")
            print("User id is: \(userID ?? "")")
            print("created by is: \(creadedBy ?? 0)")

            if Int(userID ?? "") == creadedBy {
                if item?.join_status_label == true {
                    if objGroupList?.group_type == "Public" {
                        cell.btnAccept.isHidden = true
                        cell.btnDecline.isHidden = true
                        cell.btnDelete.isHidden = false
                    } else if objGroupList?.group_type == "Private" {
                        if objGroupList?.group_status == true {
                            cell.btnAccept.isHidden = true
                            cell.btnDecline.isHidden = true
                            cell.btnDelete.isHidden = false
                        } else {
                            cell.btnAccept.isHidden = false
                            cell.btnDecline.isHidden = false
                            cell.btnDelete.isHidden = true
                        }
                    }
                } else {
                    if item?.join_status_label == false {
                        if objGroupList?.group_type == "Public" {
                            cell.btnAccept.isHidden = true
                            cell.btnDecline.isHidden = true
                            cell.btnDelete.isHidden = false
                        } else if objGroupList?.group_type == "Private" {
                            cell.btnAccept.isHidden = false
                            cell.btnDecline.isHidden = false
                            cell.btnDelete.isHidden = true
                        }
                    }
                }
            } else {
                if item?.join_status_label == true {
                    if objGroupList?.group_type == "Public" {
                        cell.btnAccept.isHidden = true
                        cell.btnDecline.isHidden = true
                        cell.btnDelete.isHidden = true
                    } else if objGroupList?.group_type == "Private" {
                        cell.btnAccept.isHidden = true
                        cell.btnDecline.isHidden = true
                        cell.btnDelete.isHidden = true
                    }
                } else {
                    if item?.join_status_label == false {
                        if objGroupList?.group_type == "Public" {
                            cell.btnAccept.isHidden = true
                            cell.btnDecline.isHidden = true
                            cell.btnDelete.isHidden = true
                        } else if objGroupList?.group_type == "Private" {
                            cell.btnAccept.isHidden = true
                            cell.btnDecline.isHidden = true
                            cell.btnDelete.isHidden = true
                        }
                    }
                }
            }

            cell.AcceptCallback = { [weak self] value in
                guard let self = self else { return }
                if let member = self.objDecryptedGroupMembers?[indexPath.row],
                   let groupId = member.group_id,
                   let memberId = member.user_id {
                    
                    let request = GroupApprove_Request(group_id: groupId, member_id: memberId)
                    let param: [String: Any] = [
                        "group_id": request.group_id ?? 0,
                        "member_id": request.member_id ?? 0
                    ]
                    print("Group Approve Api param is : \(param)")
                    
                    let viewModel = GroupMember_VM()
                    viewModel.groupApprove(parameter: param, request: request) { response in
                        DispatchQueue.main.async {
                            self.groupMemberListAPI()
                        }
                    }
                } else {
                    print("❌ Could not fetch group_id or member_id for row: \(indexPath.row)")
                }
            }
            cell.DeclineCallback = { [self] value in
                if let member = self.objDecryptedGroupMembers?[indexPath.row],
                   let groupId = member.group_id,
                   let memberId = member.user_id {
                    
                    let request = GroupApprove_Request(group_id: groupId, member_id: memberId)
                    let param: [String: Any] = [
                        "group_id": request.group_id ?? 0,
                        "member_id": request.member_id ?? 0
                    ]
                    print("Group Decline Api param is : \(param)")
                    
                    let viewModel = GroupMember_VM()
                    viewModel.groupDeclineRemove(parameter: param, request: request) { response in
                        DispatchQueue.main.async {
                            self.groupMemberListAPI()
                        }
                    }
                } else {
                    print("❌ Could not fetch group_id or member_id for row: \(indexPath.row)")
                }
                print("Chcek Decline button")
            }
            
            cell.DelUserCallback = { [self] value in
                
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                let messageText = "Are you sure you want to remove this group?"
                let attributedMessage = NSAttributedString(string: messageText, attributes: [
                    .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
                    .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
                ])
                alertController.setValue(attributedMessage, forKey: "attributedMessage")
                
                let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                    if let member = self.objDecryptedGroupMembers?[indexPath.row],
                       let groupId = member.group_id,
                       let memberId = member.user_id {
                        
                        let request = GroupApprove_Request(group_id: groupId, member_id: memberId)
                        let param: [String: Any] = [
                            "group_id": request.group_id ?? 0,
                            "member_id": request.member_id ?? 0
                        ]
                        print("Group Decline/Remove Api param is : \(param)")
                        
                        let viewModel = GroupMember_VM()
                        viewModel.groupDeclineRemove(parameter: param, request: request) { response in
                            DispatchQueue.main.async {
                                self.groupMemberListAPI()
                            }
                        }
                    } else {
                        print("❌ Could not fetch group_id or member_id for row: \(indexPath.row)")
                    }
                    print("Check Remove button")
                }
                
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
                
                // Set button colors
                yesAction.setValue(UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1), forKey: "titleTextColor") // #008000
                noAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
                
                self.present(alertController, animated: true, completion: nil)
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
            
            
           
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let cell = tableView.cellForRow(at: indexPath) as? GroupMemberTableViewCell {
                print("Tapped cell name: \(cell.lblName.text ?? "")")
            }
            
            // Or safer: use your data source
            if let item = objDecryptedGroupMembers?[indexPath.row] {
                print("Tapped member: \(item.full_name ?? "")")
            }
        }
    }


}
