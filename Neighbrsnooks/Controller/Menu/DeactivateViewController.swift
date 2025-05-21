//
//  DeactivateViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 28/05/24.
//

import UIKit

class DeactivateViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btn30: UIButton!
    @IBOutlet weak var btn60: UIButton!
    @IBOutlet weak var btn90: UIButton!
    
    var DeactivateData : DeactivateModel?
    var account = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func Days30BtnAction(_ sender: UIButton) {
        btn30.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btn60.setImage(UIImage(named: "radio-blank"), for: .normal)
        btn90.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "30"
//        btnPrivate.setImage(UIImage(named: "radio-blank"), for: .normal)
//        whoCanSeeList = "EveryOne"
   }
   
   @IBAction func Days60BtnAction(_ sender: UIButton) {
       btn60.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btn90.setImage(UIImage(named: "radio-blank"), for: .normal)
       btn30.setImage(UIImage(named: "radio-blank"), for: .normal)
       account = "60"
      
   }
    
    @IBAction func Days90BtnAction(_ sender: UIButton) {
        btn90.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btn60.setImage(UIImage(named: "radio-blank"), for: .normal)
        btn30.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "90"
       
    }
    
    @IBAction func CreateBtn(_ sender: UIButton){
        
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to deactivate?", preferredStyle: .alert)
            
            // "Yes" action
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.callDeactivateWebService {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            // "Cancel" action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
      
    }
    
    func callDeactivateWebService(_ completionClosure: @escaping () -> ()) {
        let UserName = UserDefaults.standard.string(forKey: "username")
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "days": account ?? "", // This will be "1" for Follow, "0" for Unfollow
           
        ]
        
        if #available(iOS 16.0, *) {
            WebService.sharedInstance.callDeactivateWebService(withParams: dictParams) { data in
                self.DeactivateData = data
                
                // Check if the status is "success" before calling the next API
                //            if self.DeactivateData?.status == "success" {
                //                // If success, call the completion closure
                //                completionClosure()
                //            } else {
                // If failure, show an alert with the message
                //  self.showAlert(Message: self.followData?.message ?? "Something went wrong")
            }
        } else {
            // Fallback on earlier versions
        }
        }
    }
