//
//  PublicProfileViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 03/09/24.
//

import UIKit
import SVProgressHUD
@available(iOS 16.0, *)
class PublicProfileViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var btnEmergencyHide: UIButton!
    @IBOutlet weak var btnEmergencyShow: UIButton!
    @IBOutlet weak var btnContactHide: UIButton!
    @IBOutlet weak var btnContactShow: UIButton!
    @IBOutlet weak var btnAdd1Hide: UIButton!
    @IBOutlet weak var btnAdd1Show: UIButton!
    @IBOutlet weak var btnAdd2Hide: UIButton!
    @IBOutlet weak var btnAdd2Show: UIButton!
    
    @IBOutlet weak var hide1: UILabel!
    @IBOutlet weak var hide2: UILabel!
    @IBOutlet weak var hide3: UILabel!
    @IBOutlet weak var hide4: UILabel!
    
    @IBOutlet weak var show1: UILabel!
    @IBOutlet weak var show2: UILabel!
    @IBOutlet weak var show3: UILabel!
    @IBOutlet weak var show4: UILabel!
    
    @IBOutlet weak var lblEmer: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblAdd1: UILabel!
    @IBOutlet weak var lblAdd2: UILabel!
   
    
    var UpdateNewNotificationsData : NewNotificationModel?
    var EmerCo = ""
    var Add1 = ""
    var Add2 = ""
    var contact = ""

    var isEmerCoChanged = false
    var isContactChanged = false
    var isAdd1Changed = false
    var isAdd2Changed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.hide1.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.hide2.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.hide3.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.hide4.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.show1.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.show2.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.show3.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.show4.font = UIFont(name: "Montserrat-Regular", size: 13)
        
        self.lblEmer.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblContact.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblAdd1.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblAdd2.font = UIFont(name: "Montserrat-Regular", size: 16)
        callNewNotificationWebService {
            // Check if addresslinetwo exists
            self.updateRadioButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callNewNotificationWebService {
            // Check if addresslinetwo exists
            self.updateRadioButtons()
        }
      
    }
    
    
    func updateRadioButtons() {
        // Check and update the image for 'notificationForEventMB'
        if let emergencyContactno = self.UpdateNewNotificationsData?.emergencyContactno {
            if emergencyContactno == "1" {
                self.btnEmergencyShow.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            } else if emergencyContactno == "0" {
                self.btnEmergencyHide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            }
        }
        
       
        
        // Check and update the image for 'addresslineone'
        if let contactNo = self.UpdateNewNotificationsData?.contactNo {
            if contactNo == "1" {
                self.btnContactShow.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            } else if contactNo == "0" {
                self.btnContactHide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            }
        }
        
       
        
        if let addresslineone = self.UpdateNewNotificationsData?.addresslineone {
            if addresslineone == "1" {
                self.btnAdd1Show.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            } else if addresslineone == "0" {
                self.btnAdd1Hide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            }
        }
        
       
        if let addresslinetwo = self.UpdateNewNotificationsData?.addresslinetwo {
            if addresslinetwo == "1" {
                self.btnAdd2Show.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            } else if addresslinetwo == "0" {
                self.btnAdd2Hide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            }
        }
       
    }
    

    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        SVProgressHUD.show()
        callUpdateNewNotificationWebService{
            SVProgressHUD.dismiss()
        }

   }
    
    @IBAction func EmerHideBtnAction(_ sender: UIButton) {
        btnEmergencyHide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnEmergencyShow.setImage(UIImage(named: "radio-blank"), for: .normal)
        EmerCo = "0"
        isEmerCoChanged = true
   }
   
   @IBAction func EmerShowBtnAction(_ sender: UIButton) {
       btnEmergencyShow.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btnEmergencyHide.setImage(UIImage(named: "radio-blank"), for: .normal)
       EmerCo = "1"
       isEmerCoChanged = true
   }
    
    @IBAction func Add1HideBtnAction(_ sender: UIButton) {
        btnAdd1Hide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnAdd1Show.setImage(UIImage(named: "radio-blank"), for: .normal)
        Add1 = "0"
        isAdd1Changed = true
   }
   
   @IBAction func Add1ShowBtnAction(_ sender: UIButton) {
       btnAdd1Show.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btnAdd1Hide.setImage(UIImage(named: "radio-blank"), for: .normal)
       Add1 = "1"
       isAdd1Changed = true
   }
    
    @IBAction func Add2HideBtnAction(_ sender: UIButton) {
        btnAdd2Hide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnAdd2Show.setImage(UIImage(named: "radio-blank"), for: .normal)
        Add2 = "0"
        isAdd2Changed = true
   }
   
   @IBAction func Add2ShowBtnAction(_ sender: UIButton) {
       btnAdd2Show.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btnAdd2Hide.setImage(UIImage(named: "radio-blank"), for: .normal)
       Add2 = "1"
       isAdd2Changed = true
   }
    
    @IBAction func ContactHideBtnAction(_ sender: UIButton) {
        btnContactHide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnContactShow.setImage(UIImage(named: "radio-blank"), for: .normal)
        contact = "0"
        isContactChanged = true
   }
   
   @IBAction func ContactShowBtnAction(_ sender: UIButton) {
       btnContactShow.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btnContactHide.setImage(UIImage(named: "radio-blank"), for: .normal)
       contact = "1"
       isContactChanged = true
   }
    

    func callNewNotificationWebService(_ completionClosure: @escaping () -> ()) {
        // Set up the parameters for the API request
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? ""
        ]
        
        // Call the web service
        WebService.sharedInstance.callNewNotificationWebService(withParams: dictParams) { responseData in
            // If `responseData` is already of type `NewNotificationModel`, assign it directly
            if let notificationData = responseData as? NewNotificationModel {
                self.UpdateNewNotificationsData = notificationData
                print("Decoded data: \(self.UpdateNewNotificationsData)")
                
                // Call the completion handler to update the UI
                completionClosure()
            } else {
                print("Error: Could not cast responseData to NewNotificationModel")
            }
        }
    }
    
    func callUpdateNewNotificationWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        var dictParams: Dictionary<String, Any> = [
            "userid": id ?? ""
        ]

        // Add only the fields that have been changed
        if isEmerCoChanged {
            dictParams["emergencyContactno"] = EmerCo
        }

        if isContactChanged {
            dictParams["contactNo"] = contact
        }

        if isAdd1Changed {
            dictParams["addresslineone"] = Add1
        }

        if isAdd2Changed {
            dictParams["addresslinetwo"] = Add2
        }

        WebService.sharedInstance.callNewNotificationWebService(withParams: dictParams) { responseData in
            // If `responseData` is already of type `NewNotificationModel`, assign it directly
            if let notificationData = responseData as? NewNotificationModel {
                self.UpdateNewNotificationsData = notificationData
                print("Decoded data: \(self.UpdateNewNotificationsData)")
                completionClosure()
            } else {
                print("Error: Could not cast responseData to NewNotificationModel")
            }
        }
    }


}
