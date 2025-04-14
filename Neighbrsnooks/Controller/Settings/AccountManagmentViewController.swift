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
    
    @IBOutlet weak var AccountFullView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var DeactivateView: UIView!
    @IBOutlet weak var LogoutView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.lblPassword.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblDeactive.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblLogout.font = UIFont(name: "Montserrat-Regular", size: 17)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
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
            updateColors()
        }
    }
    
    @IBAction func btnChangePassword(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            // Title and message customization
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
            
            // Confirm Logout Action
            let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.performLogout()
            }
            
            // Cancel Action
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
    }
    
    func performLogout() {
        // Clear user session data
        UserDefaults.standard.removeObject(forKey: "userid") // Clear the user ID or other session data
        UserDefaults.standard.synchronize()
        
        // Optionally, clear other data such as authentication tokens
        // UserDefaults.standard.removeObject(forKey: "authToken")

        // Navigate to the login screen
        navigateToLoginScreen()
    }
    
    func navigateToLoginScreen() {
        // Assuming your login screen is the initial view controller in your storyboard
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
