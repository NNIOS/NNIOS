//
//  EventLikeListViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/03/25.
//

import UIKit

@available(iOS 16.0, *)
class EventLikeListViewController: UIViewController {

    @IBOutlet weak var tableviewMembers: UITableView!
    
    var EventLikeListData : EventLikeListModel?
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
        
        
        
        
        callEventLikeListWebService{
            
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
    
    func callEventLikeListWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "eventid": eventid ?? "",
                                                    "type": "1",
                                                   
                                                                        ]
          WebService.sharedInstance.callEventLikeListWebService(withParams: dictParams) { data in
            self.EventLikeListData = data
           //   UserDefaults.standard.set(self.EventJoinListData?.listdata.id, forKey: "id")
         

            completionClosure()
          }
        }

}

@available(iOS 16.0, *)
extension EventLikeListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return EventLikeListData?.listdata?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessReviwDetailTableViewCell", for: indexPath) as! BusinessReviwDetailTableViewCell
        
        cell.lblName.text = EventLikeListData?.listdata?[indexPath.row].username
        
        cell.lblSec.text = EventLikeListData?.listdata?[indexPath.row].neighbrhood
        let url = URL(string: (EventLikeListData?.listdata?[indexPath.row].userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
       
     //   cell.lblDSec.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblLikelist.font = UIFont(name: "Montserrat-Regular", size: 15)

        
        cell.ProfileCallback = { [weak self] value in
            guard let self = self else { return }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            vc.Oid = self.EventLikeListData?.listdata?[indexPath.row].userid ?? ""
            
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
    

    
    
}
