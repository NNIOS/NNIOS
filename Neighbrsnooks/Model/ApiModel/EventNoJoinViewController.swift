//
//  EventNoJoinViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 22/08/24.
//

import UIKit
protocol ConfirmNoEventDelegate {
  func tapConfirm() -> Void
}
@available(iOS 16.0, *)
class EventNoJoinViewController: UIViewController {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var viewAtt: UIView!
    
    var EventJoinListData : EventJionListModel?
    var callback : ((_ range : String?) ->())?
    var eventid = ""
    var delegate: ConfirmNoEventDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cornerRadius: CGFloat = 10.0
               
               // Mask the bottom corners only
        tableviewMembers.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableviewMembers.layer.cornerRadius = cornerRadius
        
        viewAtt.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewAtt.layer.cornerRadius = cornerRadius

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        
        
        
        
        callEventJoinListWebService{
            
            self.tableviewMembers.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func tapDismiss(_ sender: UIButton) {
          self.dismiss(animated: true)
    }
    
    func callEventJoinListWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "eventid": eventid ?? "",
                                                    "type": "0",
                                                   
                                                                        ]
          WebService.sharedInstance.callEventJoinListWebService(withParams: dictParams) { data in
            self.EventJoinListData = data
           //   UserDefaults.standard.set(self.EventJoinListData?.listdata.id, forKey: "id")
         

            completionClosure()
          }
        }
    

}

@available(iOS 16.0, *)
extension EventNoJoinViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return EventJoinListData?.listdata?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessReviwDetailTableViewCell", for: indexPath) as! BusinessReviwDetailTableViewCell
        
        cell.lblName.text = EventJoinListData?.listdata?[indexPath.row].name
        
        cell.lblSec.text = EventJoinListData?.listdata?[indexPath.row].neigh
        let url = URL(string: (EventJoinListData?.listdata?[indexPath.row].img ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
       
     //   cell.lblDSec.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblNonAttendes.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        cell.CommentCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
            vc.otherid = EventJoinListData?.listdata?[indexPath.row].eID ?? ""

            
            self.navigationController?.pushViewController(vc, animated: true)
            

            
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
        vc.otherid = EventJoinListData?.listdata?[indexPath.row].eID ?? ""

        
        self.navigationController?.pushViewController(vc, animated: true)
        

    }

    
    
}
