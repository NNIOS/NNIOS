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
    @IBOutlet weak var DMView: UIView!
    
    var MemberListData : MembersModel?
    var selectedNeighborhoodId: String? // Property to receive the selected ID

    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        
       // SVProgressHUD.show()
        if let id = selectedNeighborhoodId {
                   print("Received Neighborhood ID: \(id)")
                   // Use the id as needed in this view controller
               }
        
        callMemberListWebService{
          //  SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            DMView.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
           

            // Light mode mein PollsView ka background red karna
            DMView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            tableviewMembers.separatorStyle = .none
        }
    }


}
@available(iOS 16.0, *)
extension MembersViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MemberListData?.listdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembersTableViewCell", for: indexPath) as! MembersTableViewCell
        
        cell.lblName.text = MemberListData?.listdata[indexPath.row].fullname
        cell.lblSec.text = MemberListData?.listdata[indexPath.row].neighbrhood
        
        cell.lblName.font = UIFont(name: "Montserrat-SemiBold", size: 17)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
        
      //  cell.profileImgView.image = UIImage(named: [indexPath.row]
        
        let url = URL(string: (MemberListData?.listdata[indexPath.row].userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        
       // cell.btnOtherProfile.tag = indexPath.row
      //  cell.btnOtherProfile.addTarget(self, action: #selector(onProfileClick(_:)), for: .touchUpInside)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
        vc.otherid = MemberListData?.listdata[indexPath.row].id ?? ""

        
        self.navigationController?.pushViewController(vc, animated: true)
        
//        guard let newViewController = storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController") as? OtherProfileViewController else {
//            return
//        }
//     newViewController.modalPresentationStyle = .overFullScreen
//        newViewController.otherid = MemberListData?.listdata[indexPath.row].id ?? ""
//            present(newViewController, animated: true, completion: nil)
    }
    
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
    
    func callMemberListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let neighborhoodId = selectedNeighborhoodId ?? idNeighbour // Use default if selectedNeighborhoodId is nil
        
        let dictParams: [String: Any] = [
            "userid": id ?? "",
            "nbd_id": neighborhoodId ?? "", // Use the resolved neighborhoodId
            "type": "members",
        ]
        
        WebService.sharedInstance.callMemberListWebService(withParams: dictParams) { data in
            self.MemberListData = data
            UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
            
            completionClosure()
        }
    }

}
