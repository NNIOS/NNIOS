//
//  DeleteBusinessPopUpViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 12/08/24.
//

import UIKit

protocol ConfirmBusinessDelegate {
  func tapConfirm() -> Void
}

@available(iOS 16.0, *)
class DeleteBusinessPopUpViewController: UIViewController {

    var BusinessDeleteData : DeleteBusinessModel?
    var delegate: ConfirmBusinessDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        // Do any additional setup after loading the view.
    }
    deinit {
          // Stop monitoring when the view controller is deallocated
          NetworkMonitor.shared.stopMonitoring()
      }

    @IBAction func tapDismiss(_ sender: UIButton) {
          self.dismiss(animated: true)
    }
    
    
    @IBAction func ExitYesBtn(_ sender: UIButton){
        
       
        callDeleteBusinessWebService{
            self.delegate?.tapConfirm()
                self.dismiss(animated: true)
               
            }
        
        
      
    }
    
    func callDeleteBusinessWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let Busid = UserDefaults.standard.string(forKey: "Businessid")
          let dictParams: Dictionary<String, Any> = [
                                                     "userid":id ?? "",
                                                    "businessid": Busid ?? "",
                                                   
                                                                        ]
//          WebService.sharedInstance.callDeleteBusinessWebService(withParams: dictParams) { data in
//         //   self.GrouDeleteData = data
//         
//
//            completionClosure()
//          }
        }
}
