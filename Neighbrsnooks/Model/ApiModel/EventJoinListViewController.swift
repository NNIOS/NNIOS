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
        let cornerRadius: CGFloat = 10.0
        tableviewMembers.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableviewMembers.layer.cornerRadius = cornerRadius
        
        viewAtt.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewAtt.layer.cornerRadius = cornerRadius
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)

        // 👇 Check if tap is outside the tableview
        if !tableviewMembers.frame.contains(location) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callEventJoinListWebService {
            self.tableviewMembers.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.updateTableViewHeight()
            }
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
            "eventid": eventid ,
            "type": "1",
            
        ]
//        WebService.sharedInstance.callEventJoinListWebService(withParams: dictParams) { data in
//            self.EventJoinListData = data
//            completionClosure()
//        }
    }
    
}


@available(iOS 16.0, *)
extension EventJoinListViewController: UITableViewDataSource, UITableViewDelegate {
    
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
}
