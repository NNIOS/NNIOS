//
//  SettingNewViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 02/09/24.
//

import UIKit
@available(iOS 16.0, *)
class SettingNewViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblPublic: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblFaq: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var lblAbout: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.lblNotification.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblPublic.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblAccount.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblFaq.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblPrivacy.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblAbout.font = UIFont(name: "Montserrat-Regular", size: 16)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnNoticication(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingNotificationViewController") as? SettingNotificationViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnPublicProfile(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublicProfileViewController") as? PublicProfileViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnAcct(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountManagmentViewController") as? AccountManagmentViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnFAQ(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as? FAQViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnAboutus(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as? AboutUsViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnTerms$Condition(_ sender: UIButton) {
     
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewControllerViewController") as? WebViewControllerViewController else {return}
        vc.heading = "Privacy Policy"
        vc.urlString = "http://neighbrsnook.com/privacy-policy/"
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }

}
