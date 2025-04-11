//
//  followPopUpViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 26/11/24.
//

import UIKit

//protocol ConfirmfollowDelegate {
//  func tapConfirm() -> Void
//}

protocol ConfirmfollowDelegate: AnyObject {
    func tapConfirm()
}

@available(iOS 16.0, *)
class followPopUpViewController: BaseViewC {
    
    @IBOutlet weak var lblFollowUnFollow: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFollow: UILabel!
    var delegate: ConfirmfollowDelegate?
    var FollowName : String?
    var Nid : String?
    var Nstats : String?
    var neighbrhoodData : MyNeighbhoodModel?
    var followData : FollowModel?
    var follow = "Are you sure you want to follow this?"
    var unFollow = "Are you sure you want to Unfollow this?"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        self.lblFollow.font = UIFont(name: "Montserrat-Regular", size: 15)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        self.lblFollow.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblName.text = FollowName
        if let followName = FollowName {
            self.title = followName
        }
        
        // Dynamically set lblFollowUnFollow text based on Nstats
            if let status = Nstats {
                if status == "0" {  // Unfollow status
                    self.lblFollowUnFollow.text = "Are you sure you want to unfollow this?"
                } else if status == "1" {  // Follow status
                    self.lblFollowUnFollow.text = "Are you sure you want to follow this?"
                }
            }
        
        
    }

    
    @IBAction func tapDismiss(_ sender: UIButton) {
        delegate?.tapConfirm()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ExitYesBtn(_ sender: UIButton) {
        // Call follow web service first
           callFollowWebService {
               // Once follow web service is done, call the neighborhood web service
               self.callMyNeighbrhoodWebService {
                   // Once both are done, notify the delegate
                   self.delegate?.tapConfirm()
                   // Dismiss the view
                   self.dismiss(animated: true)
               }
            }
       
    }
    

    
    // Follow WebService Call
    func callFollowWebService(_ completionClosure: @escaping () -> ()) {
        let UserName = UserDefaults.standard.string(forKey: "username")
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "sub_stat": Nstats ?? "", // This will be "1" for Follow, "0" for Unfollow
            "neighbrhood": FollowName ?? ""
        ]
        
        WebService.sharedInstance.callFollowWebService(withParams: dictParams) { data in
            self.followData = data
            
            // Check if the status is "success" before calling the next API
            if self.followData?.status == "success" {
                // If success, call the completion closure
                completionClosure()
            } else {
                // If failure, show an alert with the message
                self.showAlert(Message: self.followData?.message ?? "Something went wrong")
            }
        }
    }

    
    // Neighborhood WebService Call
    func callMyNeighbrhoodWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrhood")
        
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "neighbrhood": idNeighbour ?? ""
        ]
        
        WebService.sharedInstance.callMyNeighbrhoodWebService(withParams: dictParams) { data in
            self.neighbrhoodData = data
            UserDefaults.standard.set(self.neighbrhoodData?.nearestNeighbrhood.first?.name, forKey: "name")
            
            // Call the completion closure once this is done
            completionClosure()
        }
    }
    
}
@available(iOS 16.0, *)
extension UIViewController {
    func showAlert(title: String = "", message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
