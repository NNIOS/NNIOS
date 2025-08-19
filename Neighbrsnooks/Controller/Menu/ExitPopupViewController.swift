//
//  ExitPopupViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 04/06/24.
//

import UIKit

protocol ConfirmDelegate {
  func tapConfirm() -> Void
}

@available(iOS 16.0, *)
class ExitPopupViewController: UIViewController {
    
    var groupid : String?
    var userid : String?
    var ExitGrouData : ExitGroupModel?
    var delegate: ConfirmDelegate?
    var onUpdateForGroup: (() -> Void)?
    @IBOutlet weak var lblPopup: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblPopup.font = UIFont(name: "Montserrat-Regular", size: 17)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func tapDismiss(_ sender: UIButton) {
          self.dismiss(animated: true)
    }
    
//    @IBAction func tapExit(_ sender: UIButton) {
//      self.delegate?.tapConfirm()
//          self.dismiss(animated: true)
//    }
    
    @IBAction func ExitYesBtn(_ sender: UIButton){
        
       
        callExitGroupWebService{
            self.delegate?.tapConfirm()
                self.dismiss(animated: true)
            self.onUpdateForGroup
            }
        
        
      
    }
    
    func callExitGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "groupid": groupid ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callExitGroupWebService(withParams: dictParams) { data in
            self.ExitGrouData = data
          //    UserDefaults.standard.set(self.neighbrhoodData?.nearestNeighbrhood.name, forKey: "neighbrshood")
//              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")

            completionClosure()
          }
        }

}
