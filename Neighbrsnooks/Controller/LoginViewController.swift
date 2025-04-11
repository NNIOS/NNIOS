//
//  LoginViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
import Kingfisher

@available(iOS 16.0, *)
class LoginViewController: BaseViewC {
    
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var EventPostPrcntgLbl: UILabel!
    
    var show = false
    var loginData : LoginModel?
    // irshad code
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        //        // 8126177819    9454680972  9812221111 Admin@00 8700520555 new user 9810397561 5555555555
        //                self.tfMobile.text = "9958981387"
        //                tfPassword.text = "Malik@123"
        
        EventPostPrcntgLbl.font = UIFont(name: "Montserrat-Medium", size: 18)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnEye(_ sender: UIButton) {
        
        if show
        {
            show = false
            btnEye.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
        }
        else
        {
            show = true
            btnEye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
        }
        
    }
    
    @IBAction func btnRegister(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnForget(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as? ForgotViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func LoginBtn(_ sender: UIButton){
        
        // Mobile and Password Check
        if tfMobile.text == "" {
            let alert = UIAlertController(title: "", message: "Please Enter Your Mobile Number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if tfPassword.text == "" {
            let alert = UIAlertController(title: "", message: "Please Enter Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            // Call the login web service
            callLoginWebService { [weak self] in
                guard let self = self else { return }
                
                // Ensure loginData is not nil
                guard let loginData = self.loginData else {
                    print("Login data is nil.")
                    return
                }
                
                // Check if message exists in the loginData
                if let message = loginData.message {
                    print("Received Message: \(message)") // Debugging log
                    
                    // Trim and convert message to lowercase for case-insensitive matching
                    let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    
                    switch trimmedMessage {
                    case "login successfully.":
                        print("Navigating to NeigbrnookViewController")
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController {
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    case "address incomplete":
                        print("Navigating to RegisterSecondViewController")
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterSecondViewController") as? RegisterSecondViewController {
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    case "dob incomplete":
                        print("Navigating to RegisterFirstViewController")
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController") as? RegisterFirstViewController {
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    default:
                        print("Showing alert for message: \(message)")
                        self.showAlert(Message: message)
                    }
                } else {
                    print("No message received in response.")
                }
            }
            
        }
    }
    
    
    func callLoginWebService(_ completionClosure: @escaping () -> Void) {
        let dictParams: [String: Any] = [
            "mobtoken": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "login": tfMobile.text ?? "",
            "pass": tfPassword.text ?? ""
        ]
        
        WebService.sharedInstance.callLoginWebService(withParams: dictParams) { data in
            self.loginData = data
            
            print("Full API Response: \(String(describing: data))") // Debug print
            
            guard let loginData = self.loginData else {
                print("Login data is nil.")
                self.showAlert(Message: "Unable to process response.")
                return
            }
            
            // Save user data to UserDefaults
            if let logindata = loginData.logindata {
                // Save user ID as String
                let userIdString = "\(logindata.id ?? 0)"
                UserDefaults.standard.set(userIdString, forKey: "userid")
                
                // Save other user data
                UserDefaults.standard.set(logindata.username, forKey: "username")
                UserDefaults.standard.set(logindata.neighbrshood, forKey: "neighbrshood")
                UserDefaults.standard.set(logindata.userphoto, forKey: "userphoto")
                
                // Synchronize to save immediately
                UserDefaults.standard.synchronize()
                
                print("Saved User Data:")
                print("User ID: \(userIdString)")
                print("Username: \(logindata.username ?? "N/A")")
                print("Neighborhood: \(logindata.neighbrshood ?? 0)")
            } else {
                print("logindata is nil in API response")
            }
            
            // Handle login status
            if loginData.status == "success" {
                completionClosure()
            } else {
                if let message = loginData.message {
                    switch message {
                    case "Address Incomplete":
                        self.navigateToViewController(identifier: "RegisterSecondViewController", type: RegisterSecondViewController.self)
                    case "DOB Incomplete":
                        self.navigateToViewController(identifier: "RegisterFirstViewController", type: RegisterFirstViewController.self)
                    default:
                        self.showAlert(Message: message)
                    }
                } else {
                    self.showAlert(Message: "Something went wrong.")
                }
            }
        }
    }
    
    
    
}



extension UIViewController {
    func navigateToViewController<T: UIViewController>(identifier: String, type: T.Type) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) as? T {
            print("Navigating to \(identifier) successfully.")
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Failed to find or cast view controller with identifier: \(identifier).")
            print("Ensure storyboard ID and custom class mapping are correct.")
        }
    }
    
}
