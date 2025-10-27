//
//  FollowViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 02/04/24.
//

import UIKit

//protocol ConfirmDelegate {
//  func tapConfirm() -> Void
//}

@available(iOS 16.0, *)
class FollowViewController: BottomPopupViewController {
    
    
    
    @IBOutlet weak var contraintLeft: NSLayoutConstraint!
    @IBOutlet weak var contraintRight: NSLayoutConstraint!
    @IBOutlet weak var sectorLbl: UILabel!
    @IBOutlet weak var followView: UIView!
    
    var neighbrhoodData : MyNeighbhoodModel?
    var followData : FollowModel?
    var suggestion = ""
    
    var otherid : String?
    
   // var delegate: ConfirmDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        var data = neighbrhoodData
//        self.sectorLbl.text = self.neighbrhoodData?.nearestNeighbrhood.first?.name
        var data = neighbrhoodData
        self.sectorLbl.text = neighbrhoodData?.nearestNeighbrhood.first?.name

        
        //sectorLbl.text = UserDefaults.standard.object(forKey: "name") as? String
        
       // self.sectorLbl.text = self.neighbrhoodData?.nearestNeighbrhood.first?.id
       // self.SectorLbl.text = self.HomeData?.listdata?.first?.emojilistdata?.first?.neighbrhood
        
      //  cell.SecLbl.text = neighbrhoodData?.nearestNeighbrhood[indexPath.row].name
      // self.lblTeamSecond.text = data["teamTwoName"].stringValue
        
     
       
    }
    
    @IBAction func tapDismiss(_ sender: UIButton) {
          self.dismiss(animated: true)
    }
    
    
    @IBAction func btnFollow(_ : UIButton){

        callFollowWebService { [self] in
            followView.isHidden = true
        }

       }
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
   // override var popupHeight: CGFloat { return height ?? CGFloat(SCREEN_HEIGHT - 110) }
    
//    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(0) }
//    
//    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
//    
//    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
//    
//    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
//    
    
    func callFollowWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "neighbrhood":idName ?? "",
                                                    "sub_stat": "1"
                                                                        ]
//          WebService.sharedInstance.callFollowWebService(withParams: dictParams) { data in
//            self.followData = data
//          //    UserDefaults.standard.set(self.neighbrhoodData?.nearestNeighbrhood.name, forKey: "neighbrshood")
////              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
//             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
//             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
//
//            completionClosure()
//          }
        }

    

}
