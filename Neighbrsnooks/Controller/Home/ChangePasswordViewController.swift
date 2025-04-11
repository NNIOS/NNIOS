//
//  ChangePasswordViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 27/05/24.
//

import UIKit

@available(iOS 16.0, *)
class ChangePasswordViewController: BaseViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var btnOldEye: UIButton!
    
    @IBOutlet weak var btnNewEye: UIButton!
    @IBOutlet weak var btnConfirmEye: UIButton!
    
    
    var ChangePasswordData : ChangePasswordModel?
    var show = false
    var showNew = false
    var showConfirm = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnOldEye(_ sender: UIButton) {
        
        if show
        {
            show = false
            btnOldEye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            tfOldPassword.isSecureTextEntry = !tfOldPassword.isSecureTextEntry
        }
        else
        {
            show = true
            btnOldEye.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            tfOldPassword.isSecureTextEntry = !tfOldPassword.isSecureTextEntry
        }
    }
    
    @IBAction func btnNewEye(_ sender: UIButton) {
        
        if showNew
        {
            showNew = false
            btnNewEye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            tfNewPassword.isSecureTextEntry = !tfNewPassword.isSecureTextEntry
        }
        else
        {
            showNew = true
            btnNewEye.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            tfNewPassword.isSecureTextEntry = !tfNewPassword.isSecureTextEntry
        }
    }
    
    @IBAction func btnConfirmEye(_ sender: UIButton) {
        
        if showConfirm
        {
            showConfirm = false
            btnConfirmEye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            tfConfirmPassword.isSecureTextEntry = !tfConfirmPassword.isSecureTextEntry
        }
        else
        {
            showConfirm = true
            btnConfirmEye.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            tfConfirmPassword.isSecureTextEntry = !tfConfirmPassword.isSecureTextEntry
        }
    }
    
    @IBAction func SaveBtn(_ sender: UIButton){
        
        if tfOldPassword.text == "" {
        let alert = UIAlertController(title: "", message: "Please Enter Old Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
                         
        } else if tfNewPassword.text == ""{
        let alert = UIAlertController(title: "", message: "Please Enter New Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        else if tfConfirmPassword.text == ""{
            let alert = UIAlertController(title: "", message: "Please Confirm Password", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        
        else if tfNewPassword.text != tfConfirmPassword.text {
            // self.view.makeToast("Password You Enter Didn't Match", duration: 3.0, position: .bottom)
            
            let alert = UIAlertController(title: "", message: "Password You Enter Didn't Match", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            callChangePasswordWebService{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController")as! NeigbrnookViewController
//                vc.name = self.tfFirstName.text ?? ""
//                vc.secname = self.tfLastName.text ?? ""
            //    vc.id = id
             //  vc.loginData = self.loginData
                 self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
      
    }
    
    func callChangePasswordWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "actualpassword":self.tfOldPassword.text ?? "",
                                                    "newpassword":self.tfNewPassword.text ?? "",
                                                    "confirm_password":self.tfConfirmPassword.text ?? ""
                                                                        ]
          WebService.sharedInstance.callChangePasswordWebService(withParams: dictParams) { data in
              
              self.ChangePasswordData = data
            //  UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
             
              if self.ChangePasswordData?.status == "success"{
                  completionClosure()
              }else{
                  self.showAlert(Message: self.ChangePasswordData?.message ?? "")
              }
          }
        }

}
