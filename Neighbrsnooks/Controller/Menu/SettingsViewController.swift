//
//  SettingsViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 22/05/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var lblPublic: UILabel!
    
    @IBOutlet weak var lblEmerHide: UILabel!
    @IBOutlet weak var lblEmerShow: UILabel!
    @IBOutlet weak var lblAddLine1Hide: UILabel!
    @IBOutlet weak var lblAddLine1Show: UILabel!
    @IBOutlet weak var lblAddLine2Hide: UILabel!
    @IBOutlet weak var lblAddLine2Show: UILabel!
    
    @IBOutlet weak var btnHide: UIButton!
    @IBOutlet weak var btnShow: UIButton!
    var account = ""
    
    @IBOutlet weak var btnAdd1Hide: UIButton!
    @IBOutlet weak var btnAdd1Show: UIButton!
    var add1 = ""
    
    @IBOutlet weak var btnAdd2Hide: UIButton!
    @IBOutlet weak var btnAdd2Show: UIButton!
    var add2 = ""
    
    @IBOutlet weak var btnAPhoneHide: UIButton!
    
    @IBOutlet weak var btnAPhonePost: UIButton!
    @IBOutlet weak var btnMailPost: UIButton!
    @IBOutlet weak var lblPost: UILabel!
    
    var SettingData : SettingsModel?
    var GetSettingData : SettingsModel?
    
    @IBOutlet weak var NameLbl: UILabel!
    
    var PhonePost = ""
    var MailPost = ""
    var MailPoll = ""
    var PhonePoll = ""
    var MailEvent = ""
    var PhoneEvent = ""
    var MailGroup = ""
    var PhoneGroup = ""
    var MailBusiness = ""
    var PhoneBusiness = ""
    var MailDM = ""
    var PhoneDM = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.lblNotification.font = UIFont(name: "Montserrat-SemiBold", size: 17)
        self.lblActivity.font = UIFont(name: "Montserrat-SemiBold", size: 17)
        self.lblPublic.font = UIFont(name: "Montserrat-SemiBold", size: 17)
        
        self.lblEmerHide.font = UIFont(name: "Montserrat-Regular", size: 11)
        self.lblEmerShow.font = UIFont(name: "Montserrat-Regular", size: 11)
        self.lblAddLine1Hide.font = UIFont(name: "Montserrat-Regular", size: 11)
        self.lblAddLine1Show.font = UIFont(name: "Montserrat-Regular", size: 11)
        self.lblAddLine2Hide.font = UIFont(name: "Montserrat-Regular", size: 11)
        self.lblAddLine2Show.font = UIFont(name: "Montserrat-Regular", size: 11)
        callGetSettingsWebService{}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
        callGetSettingsWebService{ [self] in
            if SettingData?.address == "1" {
                btnAPhonePost.setImage(UIImage(named: "icons8-tick-30"), for: .normal)
            } else if SettingData?.addresslinetwo == "0" {
                self.btnAPhonePost.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        
    }
    

    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnChangePassword(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnDeactivate(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeactivateViewController") as? DeactivateViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func EmerHideBtnAction(_ sender: UIButton) {
        btnHide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnShow.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "0"

   }
   
   @IBAction func EmerShowBtnAction(_ sender: UIButton) {
       btnShow.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btnHide.setImage(UIImage(named: "radio-blank"), for: .normal)
       account = "1"
      
   }
    
    @IBAction func Add1HideBtnAction(_ sender: UIButton) {
        btnAdd1Hide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnAdd1Show.setImage(UIImage(named: "radio-blank"), for: .normal)
        add1 = "0"

   }
   
   @IBAction func Add1ShowBtnAction(_ sender: UIButton) {
       btnAdd1Show.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btnAdd1Hide.setImage(UIImage(named: "radio-blank"), for: .normal)
       add1 = "1"
      
   }
    
    @IBAction func Add2HideBtnAction(_ sender: UIButton) {
        btnAdd2Hide.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnAdd2Show.setImage(UIImage(named: "radio-blank"), for: .normal)
        add2 = "0"

   }
   
   @IBAction func Add2ShowBtnAction(_ sender: UIButton) {
       btnAdd2Show.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btnAdd2Hide.setImage(UIImage(named: "radio-blank"), for: .normal)
       add2 = "1"
      
   }
   
   
    @IBAction func btnPostPhnTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            PhonePost = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            PhonePost = "0"
        }
    }
    
    @IBAction func btnPostMailTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            MailPost = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            MailPost = "0"
        }
    }
    
    @IBAction func btnPollPhnTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            PhonePoll = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            PhonePoll = "0"
        }
    }
    
    @IBAction func btnPollMailTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            MailPoll = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            MailPoll = "0"
        }
    }
    
    @IBAction func btnEventMailTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            MailEvent = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            MailEvent = "0"
        }
    }
    
    @IBAction func btnEventPhoneTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            PhoneEvent = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            PhoneEvent = "0"
        }
    }
    
    @IBAction func btnGroupPhoneTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            PhoneGroup = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            PhoneGroup = "0"
        }
    }
    
    @IBAction func btnGroupMailTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            MailGroup = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            MailGroup = "0"
        }
    }

    @IBAction func btnBusinessMailTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            MailBusiness = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            MailBusiness = "0"
        }
    }
    
    @IBAction func btnBusinessPhoneTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            PhoneBusiness = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            PhoneBusiness = "0"
        }
    }
    
    @IBAction func btnDMPhoneTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            PhoneDM = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            PhoneDM = "0"
        }
    }
    
    @IBAction func btnDMPMailTapped(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "radio-blank"){

            sender.setImage(UIImage(named: "icons8-tick-32"), for: .normal)
            MailDM = "1"

        }else{

            sender.setImage(UIImage(named: "radio-blank"), for: .normal)
            MailDM = "0"
        }
    }
    
    @IBAction func SendBtn(_ sender: UIButton){
        
        
        callSettingsWebService{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController")as! NeigbrnookViewController
//                vc.name = self.tfFirstName.text ?? ""
//                vc.secname = self.tfLastName.text ?? ""
            //    vc.id = id
             //  vc.loginData = self.loginData
                 self.navigationController?.pushViewController(vc, animated: false)
            }
          
        }
      
    

    
    func callSettingsWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idRating = UserDefaults.standard.string(forKey: "Ratingid")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "commentOnYourPostsMb":PhonePost,
                                                    "commentpostmail": MailPost,
                                                    "commentLikesOnYourSuggestionMb": PhoneEvent,
                                                    "commentsuggestionmail": MailEvent,
                                                    "pollForVoteMb": PhonePoll,
                                                    "pollvotemail": MailPoll,
                                                    "notificationForEventMb":PhoneEvent,
                                                    "notificationeventmail":MailEvent,
                                                    "directMessageMb": PhoneDM,
                                                    "directmsgmail": MailDM,
                                                    "newGroupMb": PhoneGroup,
                                                    "groupcreatemail": MailGroup,
                                                    "rating_reviewsOnYourBusinessMb": PhoneBusiness,
                                                    "rating_commentbusinessmail": MailBusiness,
                                                    "emergencyContactno":account,
                                                    "addresslineone":add1,
                                                    "addresslinetwo": add2,
                                                    

                                                                        ]
//          WebService.sharedInstance.callSettingsWebService(withParams: dictParams) { data in
//              
//              self.SettingData = data
//            
//          }
        }
//
    func callGetSettingsWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idRating = UserDefaults.standard.string(forKey: "Ratingid")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    
                                                    

                                                                        ]
//          WebService.sharedInstance.callGetSettingsWebService(withParams: dictParams) { data in
//              
//              self.GetSettingData = data
//            
//          }
        }

}
