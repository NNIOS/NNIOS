//
//  AccountManagmentViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 03/09/24.
//

import UIKit

@available(iOS 16.0, *)
class AccountManagmentViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblDeactive: UILabel!
    @IBOutlet weak var lblLogout: UILabel!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var AccountFullView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var DeactivateView: UIView!
    @IBOutlet weak var LogoutView: UIView!
    var deleteModel : DeleteAccountModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.lblPassword.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblDeactive.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblLogout.font = UIFont(name: "Montserrat-Regular", size: 17)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDeleteAccountLink))
        deleteView.isUserInteractionEnabled = true
        deleteView.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func openDeleteAccountLink() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: """
            Are you sure you want to delete your account? Once deleted your data cannot be recovered after 60 days.
            """,
            preferredStyle: .alert
        )
        
        
        // Do you really want to delete your account? Once deleted your data cannot be recovered after 60 days.  Are you sure you want to delete your account…
        
        // YES button
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.callDeleteAccountAPI()
        }
        // NO button
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func callDeleteAccountAPI() {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        
        let parameters: [String: Any] = [
            "userid": id
        ]
        //dev.
        
        print(parameters)
        guard let url = URL(string: "https://neighbrsnook.com/admin/api/delete-account-request") else {
            print("❌ Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {             request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("❌ JSON encoding error: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ API Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(DeleteAccountModel.self, from: data)
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: result.status == 200 ? "Success" : "Failed",
                        message: result.message ?? "Something went wrong",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        if result.status == 200 {
                            // ✅ 1️⃣ Clear UserDefaults (logout)
                            UserDefaults.standard.removeObject(forKey: "userid")
                            UserDefaults.standard.removeObject(forKey: "isRegistered")
                            UserDefaults.standard.synchronize()
                            // ✅ 2️⃣ Go to Login screen
                            // Example: Assuming your LoginVC is initial ViewController in Main storyboard
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                                let navController = UINavigationController(rootViewController: loginVC)
                                navController.navigationBar.isHidden = true
                                UIApplication.shared.windows.first?.rootViewController = navController
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                            }
                        }
                    }))
                    
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                }
            }
            
            catch {
                print("❌ JSON decode error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
 
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            
            AccountFullView.backgroundColor = .black
            PasswordView.backgroundColor = .black
            DeactivateView.backgroundColor = .black
            LogoutView.backgroundColor = .black
            
            PasswordView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            DeactivateView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            PasswordView.layer.borderWidth = 1.0
            
            LogoutView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            
            DeactivateView.layer.borderWidth = 1.0
            
            
            
            LogoutView.layer.borderWidth = 1.0
            
            
            
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            
            AccountFullView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            PasswordView.backgroundColor = .white
            DeactivateView.backgroundColor = .white
            LogoutView.backgroundColor = .white
            
            
            
        }
        //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            //            updateColors()
        }
    }
    
    @IBAction func btnChangePassword(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        // Title and message
        let titleText = "Logout"
        let messageText = "Are you sure you want to logout?"
        
        let titleColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .label
        let messageColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .secondaryLabel
        
        let attributedTitle = NSAttributedString(string: titleText, attributes: [
            .foregroundColor: titleColor,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ])
        
        let attributedMessage = NSAttributedString(string: messageText, attributes: [
            .foregroundColor: messageColor,
            .font: UIFont.systemFont(ofSize: 15)
        ])
        
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        // Confirm Logout
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.performLogout()
        }
        
        // Cancel
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func performLogout() {
        // 1. Remove stored user data and correct token key
        UserDefaults.standard.removeObject(forKey: "userid")
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.set(false, forKey: "isLoginComplete")
        UserDefaults.standard.synchronize()
        
        // 2. Navigate to Login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navController = UINavigationController(rootViewController: loginVC)

        // 3. Reset rootViewController via SceneDelegate
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.rootNavigator = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    
    
    
    
    
    
    @IBAction func btnDeactivate(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeactivateViewController") as? DeactivateViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}
