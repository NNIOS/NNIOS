//
//  ForgotViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
@available(iOS 16.0, *)
class ForgotViewController: UIViewController {

    @IBOutlet weak var tfOtp1: UITextField!
    @IBOutlet weak var tfOtp2: UITextField!
    @IBOutlet weak var tfOtp3: UITextField!
    @IBOutlet weak var tfOtp4: UITextField!
    @IBOutlet weak var tfOtp5: UITextField!
    @IBOutlet weak var tfOtp6: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    
    var forgetOTPData : ForgetOTPModel?
   // var verifyOTPData : VerifyOTPModel?
    var otp : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        otpViewSetUp()
        // Do any additional setup after loading the view.
    }
    
    private func otpViewSetUp(){
        tfOtp1.delegate = self
        tfOtp2.delegate = self
        tfOtp3.delegate = self
        tfOtp4.delegate = self
        tfOtp5.delegate = self
        tfOtp6.delegate = self
    }

    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func SendOTPBtn(_ sender: UIButton){
        
        if tfMobile.text == "" {
        let alert = UIAlertController(title: "Alert", message: "Please Enter Your Number", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
                         
        }
        else{
            callForgetOTPWebService{
//                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MatchOTP") as? MatchOTP else {return}
//                vc.phnnoEmail = self.emailTxtFld.text ?? ""
//                vc.pin = "\(self.SendOTPData?.data ?? 0)"
////                vc.otp = self.loginData?.data.otp
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    deinit {
            // Stop monitoring when the view controller is deallocated
            NetworkMonitor.shared.stopMonitoring()
        }
    
    @IBAction func NewVerifyOTPBtn(_ sender: UIButton){
        
        if tfOtp1.text == "" {
        let alert = UIAlertController(title: "", message: "Please Enter Your otp", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
                         
        } else if tfOtp2.text == ""{
        let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }else if tfOtp3.text == ""{
            let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }else if tfOtp4.text == ""{
                let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
        else if tfOtp5.text == ""{
            let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        else if tfOtp6.text == ""{
            let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        
        else{
//            callVerifyOTPWebService{
//                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
//
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }

    func callForgetOTPWebService(_ completionClosure: @escaping () -> ()) {
          
          let dictParams: Dictionary<String, Any> = [
                                                    "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
                                                    "reqestmobileno":self.tfMobile.text ?? ""
                                                   // "password":self.PasswordTxtFld.text ?? ""
                                                                        ]
          WebService.sharedInstance.callForgetOTPWebService(withParams: dictParams) { data in
            self.forgetOTPData = data
//              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")

            completionClosure()
          }
        }
    
//    func callVerifyOTPWebService(_ completionClosure: @escaping () -> ()) {
//          
//          let dictParams: Dictionary<String, Any> = [
//                                                    "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
//                                                    "otp":self.otp ?? ""
//                                                   // "password":self.PasswordTxtFld.text ?? ""
//                                                                        ]
//          WebService.sharedInstance.callVerifyOTPWebService(withParams: dictParams) { data in
//            self.verifyOTPData = data
////              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
//             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
//
//            completionClosure()
//          }
//        }
}
@available(iOS 16.0, *)
extension ForgotViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            if textField == tfOtp1 {
                tfOtp2.becomeFirstResponder()
            }
            if textField == tfOtp2 {
                tfOtp3.becomeFirstResponder()
            }
            if textField == tfOtp3 {
                tfOtp4.becomeFirstResponder()
            }
            if textField == tfOtp4 {
                tfOtp5.becomeFirstResponder()
            }
            if textField == tfOtp5 {
                tfOtp6.becomeFirstResponder()
                
                DispatchQueue.main.async {
                  let otp = String.getString(self.tfOtp1.text) + String.getString(self.tfOtp2.text) + String.getString(self.tfOtp3.text) + String.getString(self.tfOtp4.text) + String.getString(self.tfOtp5.text) + String.getString(self.tfOtp5.text)
                  self.otp = otp
                }
            }
            textField.text = string
            return false
            
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == tfOtp1 {
                tfOtp1.becomeFirstResponder()
            }
            if textField == tfOtp2 {
                tfOtp1.becomeFirstResponder()
            }
            if textField == tfOtp3 {
                tfOtp2.becomeFirstResponder()
            }
            if textField == tfOtp4 {
                tfOtp3.becomeFirstResponder()
            }
            if textField == tfOtp5 {
                tfOtp4.becomeFirstResponder()
            }
            if textField == tfOtp6 {
                tfOtp5.becomeFirstResponder()
            }
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        return true
    }
    
}




//import Foundation
//
//struct GropsListModel: Codable {
//
//  var status     : String?     = nil
//  var message    : String?     = nil
//  var verfiedMsg : String?     = nil
//  var listdata   : [GroupListData]? = []
//
//  enum CodingKeys: String, CodingKey {
//
//    case status     = "status"
//    case message    = "message"
//    case verfiedMsg = "verfied_msg"
//    case listdata   = "listdata"
//  
//  }
//
//  init(from decoder: Decoder) throws {
//    let values = try decoder.container(keyedBy: CodingKeys.self)
//
//    status     = try values.decodeIfPresent(String.self     , forKey: .status     )
//    message    = try values.decodeIfPresent(String.self     , forKey: .message    )
//    verfiedMsg = try values.decodeIfPresent(String.self     , forKey: .verfiedMsg )
//   // listdata   = try values.decodeIfPresent([Listdata].self , forKey: .listdata   )
// 
//  }
//
//  init() {
//
//  }
//
//}
//
//import Foundation
//
//struct GroupListData: Codable {
//
//  var groupid             : String? = nil
//  var groupname           : String? = nil
//  var groupType           : String? = nil
//  var neighbrhood         : String? = nil
//  var username            : String? = nil
//  var membercount         : Int?    = nil
//  var getjoin             : String? = nil
//  var pendingRequestCount : String? = nil
//  var description         : String? = nil
//  var image               : String? = nil
//  var userid              : String? = nil
//  var status              : String? = nil
//  var favouritstatus      : Int?    = nil
//
//  enum CodingKeys: String, CodingKey {
//
//    case groupid             = "groupid"
//    case groupname           = "groupname"
//    case groupType           = "group_type"
//    case neighbrhood         = "neighbrhood"
//    case username            = "username"
//    case membercount         = "membercount"
//    case getjoin             = "getjoin"
//    case pendingRequestCount = "pendingRequestCount"
//    case description         = "description"
//    case image               = "image"
//    case userid              = "userid"
//    case status              = "status"
//    case favouritstatus      = "favouritstatus"
//  
//  }
//
//  init(from decoder: Decoder) throws {
//    let values = try decoder.container(keyedBy: CodingKeys.self)
//
//    groupid             = try values.decodeIfPresent(String.self , forKey: .groupid             )
//    groupname           = try values.decodeIfPresent(String.self , forKey: .groupname           )
//    groupType           = try values.decodeIfPresent(String.self , forKey: .groupType           )
//    neighbrhood         = try values.decodeIfPresent(String.self , forKey: .neighbrhood         )
//    username            = try values.decodeIfPresent(String.self , forKey: .username            )
//    membercount         = try values.decodeIfPresent(Int.self    , forKey: .membercount         )
//    getjoin             = try values.decodeIfPresent(String.self , forKey: .getjoin             )
//    pendingRequestCount = try values.decodeIfPresent(String.self , forKey: .pendingRequestCount )
//    description         = try values.decodeIfPresent(String.self , forKey: .description         )
//    image               = try values.decodeIfPresent(String.self , forKey: .image               )
//    userid              = try values.decodeIfPresent(String.self , forKey: .userid              )
//    status              = try values.decodeIfPresent(String.self , forKey: .status              )
//    favouritstatus      = try values.decodeIfPresent(Int.self    , forKey: .favouritstatus      )
// 
//  }
//
//  init() {
//
//  }
//
//}
