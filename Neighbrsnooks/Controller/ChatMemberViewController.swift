//
//  ChatMemberViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 01/05/24.
//

import UIKit
import SVProgressHUD
@available(iOS 16.0, *)
class ChatMemberViewController: BaseViewC {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var MembersLbl: UILabel!
    
    var ChatMemberData : ChatMemberModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        
        SVProgressHUD.show()
        
        
        callChatMemberListWebService{
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
}
@available(iOS 16.0, *)
extension ChatMemberViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ChatMemberData?.listdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMemberTableViewCell", for: indexPath) as! ChatMemberTableViewCell
        
        cell.lblName.text = ChatMemberData?.listdata[indexPath.row].fullname
        cell.lblSec.text = ChatMemberData?.listdata[indexPath.row].neighbrhood
        
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
        
      //  cell.profileImgView.image = UIImage(named: [indexPath.row]
        
        let url = URL(string: (ChatMemberData?.listdata[indexPath.row].userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        
       // cell.btnOtherProfile.tag = indexPath.row
      //  cell.btnOtherProfile.addTarget(self, action: #selector(onProfileClick(_:)), for: .touchUpInside)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController")as! MessageViewController
            vc.otherid = ChatMemberData?.listdata[indexPath.row].id ?? ""

            vc.userImage = ChatMemberData?.listdata[indexPath.row].userpic

            vc.userName = self.ChatMemberData?.listdata[indexPath.row].fullname
           /// vc.otherid = self.ChatMemberData?.listdata[indexPath.row].id
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
//        vc.otherid = MemberListData?.listdata[indexPath.row].id ?? ""
//
//        
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    

    
    func callChatMemberListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "nbd_id":idNeighbour ?? "",
                                                    
                                                                        ]
          WebService.sharedInstance.callChatMemberListWebService(withParams: dictParams) { data in
            self.ChatMemberData = data
              UserDefaults.standard.set(self.ChatMemberData?.listdata.first?.id, forKey: "id")
            //  UserDefaults.standard.set("\(self.MemberListData?.listdata.first?.id ?? 0)", forKey: "userid")
//              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")

            completionClosure()
          }
        }
}
