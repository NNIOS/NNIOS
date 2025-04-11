//
//  EventJoinListViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 21/08/24.
//

import UIKit

protocol ConfirmEventDelegate {
  func tapConfirm() -> Void
}


@available(iOS 16.0, *)
class EventJoinListViewController: UIViewController {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var LblAttendes: UILabel!
    
    var EventJoinListData : EventJionListModel?
    @IBOutlet weak var viewAtt: UIView!
    
    var callback : ((_ range : String?) ->())?
    var eventid = ""
    var delegate: ConfirmEventDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
       // viewAtt.roundCorners([.topRight, .topLeft], radius: 10)
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
    

//    var height: CGFloat?
//    var topCornerRadius: CGFloat?
//    var presentDuration: Double?
//    var dismissDuration: Double?
//    var shouldDismissInteractivelty: Bool?
//
//    override var popupHeight: CGFloat { return height ?? CGFloat(SCREEN_HEIGHT - 10) }
//
//    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(0) }
//
//    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
//
//    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
//
//    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
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
                                                    "type": "1",
                                                   
                                                                        ]
          WebService.sharedInstance.callEventJoinListWebService(withParams: dictParams) { data in
            self.EventJoinListData = data
           //   UserDefaults.standard.set(self.EventJoinListData?.listdata.id, forKey: "id")
         

            completionClosure()
          }
        }

}
@available(iOS 16.0, *)
extension EventJoinListViewController: UITableViewDataSource, UITableViewDelegate{
    
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
        cell.lblAttendes.font = UIFont(name: "Montserrat-Regular", size: 15)
        

        
        cell.ProfileCallback = { [weak self] value in
            guard let self = self else { return }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            vc.Oid = self.EventJoinListData?.listdata?[indexPath.row].userid ?? ""
            
            if let presentingVC = self.presentingViewController as? UINavigationController {
                self.dismiss(animated: true) {
                    presentingVC.pushViewController(vc, animated: true)
                }
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

       
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController")as! MyProfileViewController
//        vc.Oid = EventJoinListData?.listdata?[indexPath.row].eID ?? ""
//
//
//        self.navigationController?.pushViewController(vc, animated: true)
//
//
//    }

    
    
}
