//
//  DeleteEventViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 22/08/24.
//

import UIKit

protocol ConfirmDeleteEvent {
  func tapConfirm() -> Void
}
@available(iOS 16.0, *)
class DeleteEventViewController: UIViewController {
    
    var EventDeleteData : DeleteEventModel?
    var delegate: ConfirmDeleteEvent?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapDismiss(_ sender: UIButton) {
          self.dismiss(animated: true)
    }
    
    
    @IBAction func ExitYesBtn(_ sender: UIButton){
        
       
        callEventDeleteListWebService{
            self.delegate?.tapConfirm()
                self.dismiss(animated: true)
               
            }
        
        
      
    }
    
    func callEventDeleteListWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
          let dictParams: Dictionary<String, Any> = [
                                                     "userid":id ?? "",
                                                    "e_id": idEvent ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callEventDeleteListWebService(withParams: dictParams) { data in
         //   self.GrouDeleteData = data
         

            completionClosure()
          }
        }

}
