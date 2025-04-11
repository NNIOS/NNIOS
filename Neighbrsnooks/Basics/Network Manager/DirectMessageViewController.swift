//
//  DirectMessageViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 07/03/24.
//

import UIKit
import SVProgressHUD
//BaseViewC

@available(iOS 16.0, *)
class DirectMessageViewController: BaseViewController {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var MembersLbl: UILabel!
    
    
    var DirectMessageData : DirectMessageModel?
    private let bottomPanelView = BottomPanelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      //  setupBottomPanel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        
       // SVProgressHUD.show()
        if let selectedIndex = selectedTabIndex {
               bottomPanelView.updateTabAppearance(selectedIndex: selectedIndex)
           }
        
        callChatListWebService{
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
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
    
    
    @IBAction func btnChatList(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatMemberViewController") as? ChatMemberViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }

}

@available(iOS 16.0, *)
extension DirectMessageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DirectMessageData?.nbdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectMessageTableViewCell", for: indexPath) as! DirectMessageTableViewCell
        
        cell.lblName.text = DirectMessageData?.nbdata[indexPath.row].username
        cell.lblSec.text = DirectMessageData?.nbdata[indexPath.row].dttime
        
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
        
      //  cell.profileImgView.image = UIImage(named: [indexPath.row]
        
        let url = URL(string: (DirectMessageData?.nbdata[indexPath.row].userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        
        cell.MessageCallback = { [self] value in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController")as! MessageViewController
            vc.userImage = DirectMessageData?.nbdata[indexPath.row].userpic

            vc.userName = self.DirectMessageData?.nbdata[indexPath.row].username
            vc.otherid = self.DirectMessageData?.nbdata[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        
                 }
        
       // cell.btnOtherProfile.tag = indexPath.row
      //  cell.btnOtherProfile.addTarget(self, action: #selector(onProfileClick(_:)), for: .touchUpInside)
       
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController")as! MessageViewController
//        vc.userImage = DirectMessageData?.nbdata[indexPath.row].userpic
//
//        vc.userName = self.DirectMessageData?.nbdata[indexPath.row].username
//        vc.otherid = self.DirectMessageData?.nbdata[indexPath.row].id
//
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
//    @objc func onProfileClick(_ sender:UIButton){
//
//        print(sender.tag)
//      //  let data = neighbrhoodData[sender.tag]
//
//
//
//
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController") as? OtherProfileViewController{
//            vc.MemberListData = self.MemberListData
//            self.navigationController?.pushViewController(vc, animated: false)
//        }
//
//
//    }
    
    func callChatListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? ""
                                                    
                                                                        ]
          WebService.sharedInstance.callChatListWebService(withParams: dictParams) { data in
            self.DirectMessageData = data
        //      UserDefaults.standard.set(self.DirectMessageData?.nbdata[IndexPath.row].userpic, forKey: "id")
            //  UserDefaults.standard.set("\(self.MemberListData?.listdata.first?.id ?? 0)", forKey: "userid")
//              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")

            completionClosure()
          }
        }
}
