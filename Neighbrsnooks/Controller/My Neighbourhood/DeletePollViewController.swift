//
//  DeletePollViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 12/11/24.
//

import UIKit
protocol ConfirmPollDelDelegate {
  func tapConfirm() -> Void
}

protocol DeletePollViewControllerDelegate: AnyObject {
    func tapConfirm() // Delegate method for notifying the parent VC
}
@available(iOS 16.0, *)
class DeletePollViewController: UIViewController {
    
    weak var delegate: DeletePollViewControllerDelegate?
    
    var PollDeleteData : DeletePollModel?
   // var delegate: ConfirmPollDelDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tapDismiss(_ sender: UIButton) {
          self.dismiss(animated: true)
    }
    
    
    @IBAction func ExitYesBtn(_ sender: UIButton){
        
       
        callPollDeleteWebService {
                // Notify the parent view controller (if necessary)
                self.delegate?.tapConfirm()
                
                // Dismiss the DeletePollViewController
                self.dismiss(animated: true, completion: nil)
            }
        
    }
    
    func callPollDeleteWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let Pollid = UserDefaults.standard.string(forKey: "Pollid")
          let dictParams: Dictionary<String, Any> = [
                                                     "userid":id ?? "",
                                                    "pollid": Pollid ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callPollDeleteWebService(withParams: dictParams) { data in
         //   self.GrouDeleteData = data
         

            completionClosure()
          }
        }

}
