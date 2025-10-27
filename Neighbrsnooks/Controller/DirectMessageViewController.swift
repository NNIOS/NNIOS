//
//  DirectMessageViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 07/03/24.
//

import UIKit
import SVProgressHUD


@available(iOS 16.0, *)
class DirectMessageViewController: BaseViewController {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var MembersLbl: UILabel!
    @IBOutlet weak var DMView: UIView!
    
    var DirectMessageData : DirectMessageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        SVProgressHUD.show()
        view.backgroundColor = .white
        NetworkMonitor.shared.startMonitoring()
        tableviewMembers.delegate = self
        tableviewMembers.dataSource = self
        callChatListWebService{
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.MembersLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        
        callChatListWebService{
            
        }
    }
    
   
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            DMView.backgroundColor = .black
        } else {
            DMView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            tableviewMembers.separatorStyle = .none
        }
    }
    
    @IBAction func btnChatList(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatMemberViewController") as? ChatMemberViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 16.0, *)
extension DirectMessageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DirectMessageData?.nbdata?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectMessageTableViewCell", for: indexPath) as! DirectMessageTableViewCell
        
        // Safely unwrap
        if let data = DirectMessageData?.nbdata?[indexPath.row] {
            cell.lblName.text = data.username
            cell.lblSec.text = data.dttime
            cell.lblName.font = UIFont(name: "Montserrat-SemiBold", size: 15)
            cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
            
            let url = URL(string: data.userpic ?? "")
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
            
            cell.MessageCallback = { [weak self] value in
                guard let self = self else { return }
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
                vc.userImage = data.userpic
                vc.userName = data.username
                vc.otherid = data.id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

        return cell
    }

    
    func callChatListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        var dictParams: [String: Any] = [:]
        dictParams = ["userid":id ?? ""]
        print("Params is: \(dictParams)")
//        WebService.sharedInstance.callChatListWebService(withParams: dictParams) { data in
//            self.DirectMessageData = data
//            self.tableviewMembers.reloadData()
//            print("Data  is: \(data)")
//            completionClosure()
//        }
    }
}
