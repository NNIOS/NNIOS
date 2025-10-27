//
//  DeleteGroupPopupViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/06/24.
//

import UIKit

protocol ConfirmNewDelegate {
  func tapConfirm() -> Void
}

@available(iOS 16.0, *)
class DeleteGroupPopupViewController: UIViewController {
    
    var GrouDeleteData : GroupDeleteModel?
    var groupid : String?
    var userid : String?
    var delegate: ConfirmNewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapDismiss(_ sender: UIButton) {
          self.dismiss(animated: true)
    }
    
    
    @IBAction func ExitYesBtn(_ sender: UIButton){
        
       
        callGroupDeleteWebService{
            self.delegate?.tapConfirm()
                self.dismiss(animated: true)
               
            }
        
        
      
    }
    

    func callGroupDeleteWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                     "userid":id ?? "",
                                                    "groupid": groupid ?? "",
                                                   
                                                                        ]
//          WebService.sharedInstance.callGroupDeleteWebService(withParams: dictParams) { data in
//            self.GrouDeleteData = data
//         
//
//            completionClosure()
//          }
        }
}
