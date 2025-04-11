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
    
    @IBAction func btnChangePassword(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        // Confirm Logout Action
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.performLogout()
        }
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        // Add actions to the alert
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // Show the alert
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
