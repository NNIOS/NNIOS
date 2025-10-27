//
//  LoginViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
import Kingfisher
import FirebaseMessaging
import SwiftKeychainWrapper

@available(iOS 16.0, *)
class LoginViewController: BaseViewController {
    
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var EventPostPrcntgLbl: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    var fireBaseToken : UpdateTokenModel?
    var show = false
    var get_LoginData: LoginApiResponse? = nil
     var encryptedData: DecryptProfileApiResponse? = nil
    // Example: Agar UserData.swift me define hai
 

    // irshad code
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        EventPostPrcntgLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.additionalSafeAreaInsets.top = -50
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
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistationFirstStepVC") as? RegistationFirstStepVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnForget(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as? ForgotViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LoginBtn(_ sender: UIButton){
        if Reach().isInternet() {
            goToLogin()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }

    
    func showCustomAlert(message: String) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ])
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        closeAction.setValue(UIColor.systemBlue, forKey: "titleTextColor") // Optional: Change button color
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
//    MARK: - API Call
    func goToLogin() {
        let request = Login_Request(user: tfMobile.text ?? "", password: tfPassword.text ?? "")
        let param = ["user": tfMobile.text ?? "", "password": tfPassword.text ?? ""]
        
        // Step 1: LOGIN API
        Login_VM().goToLogin(parameter: param, request: request) { loginResponse in
            DispatchQueue.main.async {
                if let encryptedData = loginResponse?.data {
                    // Step 2: DECRYPT API (Login Response) - gets token/id
                    HttpUtility().decryptLoginData(encryptedData: encryptedData) { tokenResponse in
                        DispatchQueue.main.async {
                            if let tokenData = tokenResponse {
                                print("✅ Login successful. User ID: \(tokenData.id ?? 0), Token: \(tokenData.token ?? "")")
                                // ⭐️ ADD THIS LINE FOR API TOKEN SYNC
                                UserDefaults.standard.set(tokenData.token, forKey: "authToken")
                                UserDefaults.standard.set(tokenData.id, forKey: "userid")
                                // Step 3: USER PROFILE API - get encrypted user data
                                let profileParam = ["userId": "\(tokenData.id ?? 0)"]
                                let profileReq = Login_Request(user: "\(tokenData.id ?? 0)", password: "")
                                User_Profile().goToUserProfile(parameter: profileParam, request: profileReq) { profileResponse in
                                    DispatchQueue.main.async {
                                        if let encryptedProfileData = profileResponse?.data {
                                            print("✅ Got encrypted profile data")
                                            // Step 4: DECRYPT API (Profile Response) - get full user data
                                            HttpUtility().decryptUserProfileData(encryptedData: encryptedProfileData) { userData in
                                                DispatchQueue.main.async {
                                                    if let user = userData {
                                                        print("🎉 Final Profile: \(user.name ?? "")")
                                                        self.saveUserData(user: user)
                                                        self.handlePostLoginNavigation(user: user)
                                                    } else {
                                                        print("❌ Failed to decrypt user profile")
                                                    }
                                                }
                                            }
                                        } else {
                                            print("❌ Failed to get user profile data")
                                        }
                                    }
                                }
                            } else {
                                print("❌ Decrypt failed")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func FierbaseTokenUpdateApi(firebaseToken: String) {
        // Step 1: Prepare parameters
        let parameters: Parameters = [
            "firebase_token": firebaseToken
        ]

        // Step 2: Call API
        FierbaseTokenUpdateV_M.shared.FierbaseTokenUpdate(parameters: parameters) { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Firebase Token Update Error: \(error)")
                    
                } else if let response = response {
                    print("Firebase Token Update Success: \(response.message)")
                    if response.status {
                        print("Token updated successfully!")
                    } else {
                        print("Token update failed: \(response.message)")
                    }
                }
            }
        }
    }
    
    // MARK: - Save User Data
    func saveUserData(user: UserData) {
        // Save user data to UserDefaults
        UserDefaults.standard.set(user.user_id?.intValue(), forKey: "userID")
        UserDefaults.standard.set(user.name, forKey: "userFullName")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        // Save other user data as needed
    }


    // MARK: - Push to handlePostLoginNavigation
   
    func handlePostLoginNavigation(user: UserData) {
        // Use BoolOrInt helper for safe checks
        let isFirstStep = user.first_step?.boolValue() ?? false
        let isSecondStep = user.second_step?.boolValue() ?? false
        let isThirdStep = user.third_step?.boolValue() ?? false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        Messaging.messaging().token { token, error in
            if let token = token {
                print("🔥 FCM Token: \(token)")
                // 2️⃣ Call your FierbaseTokenUpdateApi function
                self.FierbaseTokenUpdateApi(firebaseToken: token)
            } else if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
            }
        }
        if isFirstStep && !isSecondStep && !isThirdStep {
            // RegistrationFirstStepVC
            if let regVC = storyboard.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
                self.navigationController?.pushViewController(regVC, animated: true)
            }
        } else if isFirstStep && isSecondStep && !isThirdStep {
            // RegistrationAdressProofVC
            if let addressVC = storyboard.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                self.navigationController?.pushViewController(addressVC, animated: true)
            }
        } else if isThirdStep {
            // Main Home page
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController {
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
    }

    
    
    
}

 

extension UIViewController{
    func showOkAlertWithHandler(_ msg: String, handler: @escaping ()->Void){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (type) -> Void in
            handler()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

 
