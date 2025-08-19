//
//  MembersViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 04/04/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class MembersViewController: UIViewController {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var MembersLbl: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnFavourite: UIButton!
    
    var MemberListData : MembersModel?
    var isselected:Int?
    var selectedNeighborhoodId: String?
    var filteredListdata: [MemberListData] = []
    var is_blocked: Int?
    var savedUserID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        isselected = 0
        updateButtonColors()
        btnAll.layer.cornerRadius = 22.5
        btnBlock.layer.cornerRadius = 22.5
        btnFavourite.layer.cornerRadius = 10
        savedUserID = UserDefaults.standard.string(forKey: "userid")
        callMemberListWebService{ self.tableviewMembers.reloadData() }
        print("Saved userId : \(savedUserID ?? "")")
        tableviewMembers.showsVerticalScrollIndicator = false
    }
    
    func updateButtonColors() {
        btnAll.backgroundColor = isselected == 0 ? #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) : #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        btnFavourite.backgroundColor = isselected == 1 ? #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) : #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        btnBlock.backgroundColor = isselected == 2 ? #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) : #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        btnAll.setTitleColor(isselected == 0 ? .white : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        btnFavourite.setTitleColor(isselected == 1 ? .white : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        btnBlock.setTitleColor(isselected == 2 ? .white : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tableviewMembers.separatorStyle = .none
        self.MembersLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        if let id = selectedNeighborhoodId { print("Received Neighborhood ID: \(id)") }
        callMemberListWebService{ self.tableviewMembers.reloadData() }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAll(_ sender: Any) {
        isselected = 0
        updateButtonColors()
        callMemberListWebService{
            self.tableviewMembers.reloadData()
        }
    }
    
    @IBAction func actionFavourite(_ sender: Any) {
        isselected = 1
        updateButtonColors()
        callMemberListWebService{
            self.tableviewMembers.reloadData()
        }
    }
    
    @IBAction func actionBlock(_ sender: Any) {
        isselected = 2
        updateButtonColors()
        callMemberListWebService{
            self.tableviewMembers.reloadData()
        }
    }
    
    
    
    @objc func connected(sender: UIButton){
        if isselected == 0 {
            let buttonTag = sender.tag
            DispatchQueue.main.async {  self.tableviewMembers.reloadData() }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BottomVC") as! BottomVC
            vc.modalPresentationStyle = .overFullScreen
            let tappedUser = filteredListdata[buttonTag]
            vc.is_blocked = tappedUser.is_blocked ?? 0
            vc.blocked_userid = tappedUser.id
            //            vc.view.backgroundColor = .white
            vc.onUpdateForBlock = { [weak self] in
                self?.callMemberListWebService{
                    DispatchQueue.main.async {
                        self?.tableviewMembers.reloadData()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.present(vc, animated: false, completion: nil)
            }
            
            print("Abdul Aleem Usmani :\(buttonTag)")
        } else  if isselected == 1 {
            let buttonTag = sender.tag
            DispatchQueue.main.async {  self.tableviewMembers.reloadData() }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BottomVC") as! BottomVC
            vc.modalPresentationStyle = .overFullScreen
            let tappedUser = filteredListdata[buttonTag]
            vc.is_blocked = tappedUser.is_blocked ?? 0
            vc.blocked_userid = tappedUser.id
            vc.view.backgroundColor = .white
            vc.onUpdateForBlock = { [weak self] in
                self?.callMemberListWebService{
                    DispatchQueue.main.async {
                        self?.tableviewMembers.reloadData()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.present(vc, animated: false, completion: nil)
            }
            print("Irshad Malik :\(buttonTag)")
        } else  if isselected == 2 {
            let buttonTag = sender.tag
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BottomVC") as! BottomVC
            vc.modalPresentationStyle = .overFullScreen
            vc.blocked_userid = self.MemberListData?.listdata.first?.id
            let tappedUser = filteredListdata[buttonTag]
            vc.is_blocked = tappedUser.is_blocked ?? 0
            vc.blocked_userid = tappedUser.id
            
            vc.onUpdateForBlock = { [weak self] in
                self?.callMemberListWebService{
                    DispatchQueue.main.async {
                        self?.tableviewMembers.reloadData()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.present(vc, animated: false, completion: nil)
            }
            print("Arshad :\(buttonTag)")
        }
    }
    
    
    
}
@available(iOS 16.0, *)
extension MembersViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredListdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembersTableViewCell", for: indexPath) as! MembersTableViewCell
        let member = filteredListdata[indexPath.row]
        cell.lblName.text = member.fullname
        cell.lblSec.text = member.neighbrhood
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 17)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 16)
        cell.selectionStyle = .none
        cell.profileImgView.layer.cornerRadius = cell.profileImgView.bounds.size.width / 2.0
        if let url = URL(string: member.userpic) {
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
        }
        cell.btnThreeDots.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        cell.btnThreeDots.tag = indexPath.row
        cell.btnThreeDots.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        if savedUserID == member.id {
            cell.btnThreeDots.isHidden = true
        } else {
            cell.btnThreeDots.isHidden = false
        }
        
        cell.onAnyTap = { [weak self] tappedView in
            guard let self = self else { return }
            
            if tappedView == cell.lblName {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                vc.Oid = filteredListdata[indexPath.row].id
                vc.headingTitle = vc.Oid!.isEmpty ? "My Profile" : "Profile"
                vc.isFromMessage = true
                self.navigationController?.pushViewController(vc, animated: true)
                print("Tapped on name at \(indexPath.row)")
                // Handle name tap
            } else if tappedView == cell.lblSec {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                vc.Oid = filteredListdata[indexPath.row].id
                vc.headingTitle = vc.Oid!.isEmpty ? "My Profile" : "Profile"
                vc.isFromMessage = true
                self.navigationController?.pushViewController(vc, animated: true)
                print("Tapped on sec label at \(indexPath.row)")
                // Handle sec tap
            } else if tappedView == cell.profileImgView {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                vc.Oid = filteredListdata[indexPath.row].id
                vc.headingTitle = vc.Oid!.isEmpty ? "My Profile" : "Profile"
                vc.isFromMessage = true
                self.navigationController?.pushViewController(vc, animated: true)
                print("Tapped on profile image at \(indexPath.row)")
                // Handle profile image tap
            }
        }
        
        return cell
    }
    
    
    
    
    func callMemberListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let neighborhoodId = selectedNeighborhoodId ?? idNeighbour
        let dictParams: [String: Any] = [
            "userid": id ?? "",
            "nbd_id": neighborhoodId ?? "",
            "type": "members",
        ]
        WebService.sharedInstance.callMemberListWebService(withParams: dictParams) { data in
            self.MemberListData = data
            let blockedStatusArray = self.MemberListData?.listdata.map { $0.is_blocked ?? 0 } ?? []
            self.is_blocked = blockedStatusArray.allSatisfy { $0 == 1 } ? 1 : 0
            
            switch self.isselected {
            case 2:
                self.filteredListdata = self.MemberListData?.listdata.filter { $0.is_blocked == 1 } ?? []
            default:
                self.filteredListdata = self.MemberListData?.listdata ?? []
            }
            if let savedUserID = id {
                self.filteredListdata.sort {
                    if $0.id == savedUserID {
                        return true
                    } else if $1.id == savedUserID {
                        return false
                    } else {
                        return false
                    }
                }
            }
            UserDefaults.standard.set(self.filteredListdata.first?.id, forKey: "id")
            completionClosure()
        }
    }
}
