//
//  MenuGroupViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 11/07/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class MenuGroupViewController: BaseViewController, ConfirmDelegate  {
    func tapConfirm() {
     //   callGroupListWebService{}
    }
    
//    func tapConfirm() {
//        <#code#>
//    }
    
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var GroupLbl: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
   
    
    var GroupListData : GropsListModel?
    var JoinListData : JoinGroupModel?
    var groupid : String?
    var groupName : String?
    var userName : String?
   // let blurEffectTransitioningDelegate = BlurEffectTransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        SVProgressHUD.show()
        
        
        callGroupListWebService{
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            
           // self.GroupLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
            // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
   
    
    @IBAction func btnCreateGroup(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as? CreateGroupViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func JoinBtn(_ sender: UIButton){
        
       
        callJoinGroupWebService{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController")as! GroupsViewController

                 self.navigationController?.pushViewController(vc, animated: false)
            }
        
        
      
    }
   
    func callGroupListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callGroupListWebService(withParams: dictParams) { data in
            self.GroupListData = data
            //  UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
            //  UserDefaults.standard.set("\(self.MemberListData?.listdata.first?.id ?? 0)", forKey: "userid")
//              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")

            completionClosure()
          }
        }
    
    func callJoinGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let UserName = UserDefaults.standard.string(forKey: "UserName")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "groupid": groupid ?? "",
                                                    "groupname": groupName ?? "",
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
}

@available(iOS 16.0, *)
extension MenuGroupViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GroupListData?.listdata?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
      
        cell.lblName.text = GroupListData?.listdata?[indexPath.row].username
        cell.lblGroupName.text = GroupListData?.listdata?[indexPath.row].groupname
        cell.lblPrivate.text = GroupListData?.listdata?[indexPath.row].group_type
        cell.lblSec.text = GroupListData?.listdata?[indexPath.row].neighbrhood
      //  cell.lblMember.text = GroupListData?.listdata![indexPath.row].userid
        cell.lblOwner.text = GroupListData?.listdata?[indexPath.row].getjoin
        
        cell.lblName.font  = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblGroupName.font  = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblPrivate.font  = UIFont(name: "Montserrat-Regular", size: 10)
        cell.lblSec.font  = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblMemberText.font = UIFont(name: "Montserrat-Regular", size: 10)
        cell.lblOwner.font = UIFont(name: "Montserrat-Regular", size: 14)
       
        
        if GroupListData?.listdata![indexPath.row].getjoin == "owner" {
            cell.viewOwner.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.8941176471, blue: 0.7882352941, alpha: 1)
            cell.btnExit.isHidden = true
            cell.btnJoin.isHidden = true
            cell.btnReqPending.isHidden = true
           // cell.lblName.textColor = #colorLiteral(red: 0.3843137255, green: 0.2, blue: 0.8392156863, alpha: 1)
           
        } else if GroupListData?.listdata![indexPath.row].getjoin == "joined" {
           
            cell.viewOwner.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.5490196078, blue: 0, alpha: 1)
            cell.viewOwner.isHidden = true
            cell.btnExit.isHidden = false
            cell.btnJoin.isHidden = true
            cell.btnReqPending.isHidden = true
            cell.viewPendingCount.isHidden = true
         
        }
        else if GroupListData?.listdata![indexPath.row].getjoin == "pending" {
           
            cell.viewOwner.backgroundColor = #colorLiteral(red: 0.6392156863, green: 0.7098039216, blue: 0.1490196078, alpha: 1)
            cell.btnJoin.isHidden = true
            cell.btnExit.isHidden = true
            cell.btnReqPending.isHidden = true
            cell.viewPendingCount.isHidden = true
            cell.btnDetails.isHidden = true
        }
        
        else if GroupListData?.listdata![indexPath.row].getjoin == "join" {
           
           
            cell.btnExit.isHidden = true
            cell.btnJoin.isHidden = false
            cell.btnReqPending.isHidden = true
            cell.viewPendingCount.isHidden = true
        }
        
        if GroupListData?.listdata![indexPath.row].pendingRequestCount == "1" {
            cell.btnReqPending.isHidden = false
            cell.lblPendingCount.text = GroupListData?.listdata?[indexPath.row].pendingRequestCount
            cell.viewPendingCount.isHidden = false

        } else if GroupListData?.listdata![indexPath.row].pendingRequestCount == "0" {
            cell.btnReqPending.isHidden = true
            cell.viewPendingCount.isHidden = true
        }
        
        let url = URL(string: (GroupListData?.listdata?[indexPath.row].image ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
        
        cell.ExitCallback = { [self] value in
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExitPopupViewController")as! ExitPopupViewController
//           // vc.groupid = GroupListData?.listdata![IndexPath.row].groupid
//
//            vc.groupid = GroupListData?.listdata![indexPath.row].groupid ?? ""
//            vc.userid = GroupListData?.listdata![indexPath.row].userid ?? ""
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let vc = storyboard?.instantiateViewController(withIdentifier:"ExitPopupViewController")as! ExitPopupViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            vc.groupid = GroupListData?.listdata![indexPath.row].groupid ?? ""
            vc.userid = GroupListData?.listdata![indexPath.row].userid ?? ""
            self.present(vc , animated: true)
            
        }
        
        cell.JoinCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsViewController")as! GroupDetailsViewController
           // vc.groupid = GroupListData?.listdata![IndexPath.row].groupid
            
            self.groupid = GroupListData?.listdata![indexPath.row].groupid ?? ""
            self.groupName = GroupListData?.listdata![indexPath.row].groupname ?? ""
            self.userName = GroupListData?.listdata![indexPath.row].username ?? ""
            callJoinGroupWebService{}
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        cell.DetailsCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsViewController")as! GroupDetailsViewController
           // vc.groupid = GroupListData?.listdata![IndexPath.row].groupid
            
            vc.groupid = GroupListData?.listdata![indexPath.row].groupid ?? ""
            vc.userid = GroupListData?.listdata![indexPath.row].userid ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    
}

