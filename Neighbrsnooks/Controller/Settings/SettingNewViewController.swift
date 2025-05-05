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
    
    @IBOutlet weak var SettingsView: UIView!
    @IBOutlet weak var NotificationView: UIView!
    @IBOutlet weak var PublicView: UIView!
    @IBOutlet weak var AccountView: UIView!
    @IBOutlet weak var FaqView: UIView!
    @IBOutlet weak var PrivacyView: UIView!
    @IBOutlet weak var aboutUs: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            SettingsView.backgroundColor = .black
            AccountView.backgroundColor = .black
            PublicView.backgroundColor = .black
            AccountView.backgroundColor = .black
            FaqView.backgroundColor = .black
            PrivacyView.backgroundColor = .black
            aboutUs.backgroundColor = .black
            NotificationView.backgroundColor = .black
            
            NotificationView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            PublicView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            NotificationView.layer.borderWidth = 1.0
            
            PublicView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
            AccountView.layer.borderWidth = 1.0
            
            AccountView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            PrivacyView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            aboutUs.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
            PrivacyView.layer.borderWidth = 1.0
            PublicView.layer.borderWidth = 1.0
            aboutUs.layer.borderWidth = 1.0
            
            FaqView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
            FaqView.layer.borderWidth = 1.0
            
            lblNotification.textColor = .white
            lblPublic.textColor = .white
            lblAccount.textColor = .white
            lblFaq.textColor = .white
            lblPrivacy.textColor = .white
            lblAbout.textColor = .white
           
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          //  questionView.textColor = UIColor.secondaryLabel
            NotificationView.backgroundColor = .white
            PublicView.backgroundColor = .white
            AccountView.backgroundColor = .white
            FaqView.backgroundColor = .white
            PrivacyView.backgroundColor = .white
            aboutUs.backgroundColor = .white
           
           
            FaqView.layer.borderWidth = 0
            PrivacyView.layer.borderWidth = 0
            aboutUs.layer.borderWidth = 0
           
            PublicView.layer.borderWidth = 0
            NotificationView.layer.borderWidth = 0
            
            AccountView.layer.borderWidth = 0
            SettingsView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
            lblNotification.textColor = UIColor.secondaryLabel
            lblPublic.textColor = UIColor.secondaryLabel
            lblAccount.textColor = UIColor.secondaryLabel
            lblFaq.textColor = UIColor.secondaryLabel
            lblPrivacy.textColor = UIColor.secondaryLabel
            lblAbout.textColor = UIColor.secondaryLabel
            
            
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
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
