//
//  ContactUsViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 21/05/24.
//

import UIKit
import SVProgressHUD
@available(iOS 16.0, *)
class ContactUsViewController: BaseViewC, UITextViewDelegate {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var SecLbl: UILabel!
    @IBOutlet weak var EmailLbl: UILabel!
    @IBOutlet weak var MobileLbl: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tvmessage: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var profileData : ProfileModel?
    var ContactUsData : ContactUsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderLabel.text = "Type a message..."
               placeholderLabel.textColor = UIColor.lightGray
               placeholderLabel.isHidden = !tvmessage.text.isEmpty

        tvmessage.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
            // Show or hide placeholder label based on text view content
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.NameLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.SecLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
      
        
        SVProgressHUD.show()
        callUserProfileWebService{ [self] in
            
            SVProgressHUD.dismiss()
            
            
            
            self.NameLbl.text = self.profileData?.firstname
            self.SecLbl.text = self.profileData?.lastname
           
            
            self.EmailLbl.text = self.profileData?.emailid
            self.MobileLbl.text = self.profileData?.phoneno
            
           
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SendBtn(_ sender: UIButton){
        
        if tvmessage.text == "" {
        let alert = UIAlertController(title: "", message: "Please Enter Your Message", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
                         
        }
        else{
            callContactUsWebService{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController")as! NeigbrnookViewController

                 self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
      
    }
   
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                    
                                                    "userid":id ?? "",
                                                   
                                                   
                                                                        ]
          WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
            self.profileData = data
              UserDefaults.standard.set(self.profileData?.emerPhone, forKey: "emer_phone")
              UserDefaults.standard.set(self.profileData?.userpic, forKey: "profileImage")

            completionClosure()
          }
        }
    
    func callContactUsWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
       // let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "textmessage":self.tvmessage.text ?? ""
                                                   
                                                                        ]
          WebService.sharedInstance.callContactUsWebService(withParams: dictParams) { data in
            self.ContactUsData = data


            completionClosure()
          }
        }
}
//"https://dev.neighbrsnook.com/admin/groupimage/UP_665d91a80a243.png";
//"https://dev.neighbrsnook.com/admin/groupimage/UP_665d922457ef9.png";
