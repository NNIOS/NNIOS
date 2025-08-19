//
//  followPopUpViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 26/11/24.
//

//import UIKit
//
////protocol ConfirmfollowDelegate {
////  func tapConfirm() -> Void
////}
//
//protocol ConfirmfollowDelegate: AnyObject {
//    func tapConfirm()
//}
//
//@available(iOS 16.0, *)
//class followPopUpViewController: BaseViewController {
//    
//    @IBOutlet weak var lblFollowUnFollow: UILabel!
//    var delegate: ConfirmfollowDelegate?
//    var FollowName : String?
//    var Nid : String?
//    var Nstats : String?
//    var neighbrhoodData : MyNeighbhoodModel?
//    var followData : FollowModel?
//    var follow = "Are you sure you want to follow this?"
//    var unFollow = "Are you sure you want to Unfollow this?"
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.lblFollowUnFollow.font = UIFont(name: "Montserrat-Regular", size: 15)
//    }
//    override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            lblFollowUnFollow.numberOfLines = 2
//            if let status = Nstats {
//                if status == "0" {
//                    self.lblFollowUnFollow.text = "Are you sure you\n want to unfollow \(FollowName ?? "")?"
//                    
//                } else if status == "1" {
//                    self.lblFollowUnFollow.text = "Are you sure you\n want to follow \(FollowName ?? "")?"
//                }
//            }
//        }
//    
//    
//    @IBAction func tapDismiss(_ sender: UIButton) {
//        delegate?.tapConfirm()
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    @IBAction func ExitYesBtn(_ sender: UIButton) {
//        callFollowWebService {
//            self.callMyNeighbrhoodWebService {
//                self.delegate?.tapConfirm()
//                self.dismiss(animated: true)
//            }
//        }
//    }
//    
//    // Follow WebService Call
//    func callFollowWebService(_ completionClosure: @escaping () -> ()) {
//        let UserName = UserDefaults.standard.string(forKey: "username")
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let dictParams: Dictionary<String, Any> = [
//            "userid": id ?? "",
//            "sub_stat": Nstats ?? "", // This will be "1" for Follow, "0" for Unfollow
//            "neighbrhood": FollowName ?? ""
//        ]
//        
//        WebService.sharedInstance.callFollowWebService(withParams: dictParams) { data in
//            self.followData = data
//            if self.followData?.status == "success" {
//                completionClosure()
//            } else {
//                self.showAlert(Message: self.followData?.message ?? "Something went wrong")
//            }
//        }
//    }
//    
//    
//    // Neighborhood WebService Call
//    func callMyNeighbrhoodWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrhood")
//        
//        let dictParams: Dictionary<String, Any> = [
//            "userid": id ?? "",
//            "neighbrhood": idNeighbour ?? ""
//        ]
//        
//        WebService.sharedInstance.callMyNeighbrhoodWebService(withParams: dictParams) { data in
//            self.neighbrhoodData = data
//            UserDefaults.standard.set(self.neighbrhoodData?.nearestNeighbrhood.first?.name, forKey: "name")
//            completionClosure()
//        }
//    }
//    
//}
//@available(iOS 16.0, *)
//extension UIViewController {
//    func showAlert(title: String = "", message: String, buttonTitle: String = "OK") {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//        
//        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
//        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
//        
//        let attributedTitle = NSAttributedString(string: title, attributes: titleFont)
//        let attributedMessage = NSAttributedString(string: message, attributes: messageFont)
//
//        alert.setValue(attributedTitle, forKey: "attributedTitle")
//        alert.setValue(attributedMessage, forKey: "attributedMessage")
//
//        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
//        
//        self.present(alert, animated: true, completion: nil)
//    }
//
//}


import UIKit

protocol ConfirmfollowDelegate: AnyObject {
    func tapConfirm()
}

@available(iOS 16.0, *)
class followPopUpViewController: BaseViewController {
    @IBOutlet weak var lblFollowNeighbrhood: UILabel!
    @IBOutlet weak var lblFollowUnFollow: UILabel!
    
    var Nid: String?
    var Nstats: String?
    var FollowName: String?
    var followData: FollowModel?
    var delegate: ConfirmfollowDelegate?
    var neighbrhoodData: MyNeighbhoodModel?
    var follow:String =  "Are you sure you want to follow?"
    var unFollow:String =  "Are you sure you want to Unfollow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let status = Nstats {
            if status == "0" {
                self.lblFollowNeighbrhood.text = "Unfollow Neighbourhood"
                self.lblFollowUnFollow.text = "\(unFollow)\n\(FollowName ?? "")?"
                
            } else if status == "1" {
                self.lblFollowNeighbrhood.text = "Follow Neighbourhood"
                self.lblFollowUnFollow.text = "\(follow)\n\(FollowName ?? "")?"
            }
        }
    }
    
    @IBAction func tapDismiss(_ sender: UIButton) {
        delegate?.tapConfirm()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ExitYesBtn(_ sender: UIButton) {
        callFollowWebService {
            self.callMyNeighbrhoodWebService {
                self.delegate?.tapConfirm()
                self.dismiss(animated: true)
            }
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

@available(iOS 16.0, *)
extension followPopUpViewController {
    
    func setupUI() {
        self.lblFollowNeighbrhood.textColor = #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        self.lblFollowNeighbrhood.font  = UIFont(name: "Montserrat-SemiBold", size: 17)
        self.lblFollowUnFollow.font = UIFont(name: "Montserrat-Regular", size: 16)
    }
    
    func callFollowWebService(_ completionClosure: @escaping () -> ()) {  // Follow WebService API Call
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "sub_stat": Nstats ?? "",
            "neighbrhood": FollowName ?? ""
        ]
        print("Param is : \(dictParams)")
        WebService.sharedInstance.callFollowWebService(withParams: dictParams) { data in
            self.followData = data
            if self.followData?.status == "success" {
                completionClosure()
            } else {
                self.showAlert(Message: self.followData?.message ?? "Something went wrong")
            }
        }
    }

    func callMyNeighbrhoodWebService(_ completionClosure: @escaping () -> ()) { // Neighborhood WebService API Call
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrhood")
        
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "neighbrhood": idNeighbour ?? ""
        ]
        print("Param is : \(dictParams)")
        WebService.sharedInstance.callMyNeighbrhoodWebService(withParams: dictParams) { data in
            self.neighbrhoodData = data
            UserDefaults.standard.set(self.neighbrhoodData?.nearestNeighbrhood.first?.name, forKey: "name")
            completionClosure()
        }
    }
}
