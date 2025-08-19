//
//  ContactUsViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 21/05/24.
//

import UIKit
import SVProgressHUD
@available(iOS 16.0, *)
class ContactUsViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var MobileLbl: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tvmessage: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tfMail: UITextField!
    
    // MARK: - Variables
    var profileData: ProfileModel?
    var ContactUsData: ContactUsModel?
    var loadingAlert: UIAlertController?
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        didloadSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppearSetup()
    }
    
    // MARK: - Button's Action
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SendBtn(_ sender: UIButton) {
        guard let messageText = tvmessage.text?.trimmingCharacters(in: .whitespacesAndNewlines), !messageText.isEmpty else {
            showEmtyAlert(message: "Please Enter Your Message")
            return
        }
        if containsBadWords(messageText) { showEmtyAlert(message: "Contains inappropriate words."); return }
        callContactUsWebService { self.navigationController?.popViewController(animated: true) }
    }
}

// MARK: - Extension for ViewController
extension ContactUsViewController {
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) { // function for user profile api
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = ["userid":id ?? "", "loggeduser": id ?? ""]
        print("Param is: \(dictParams)")
        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
            self.profileData = data
            completionClosure()
        }
    }
    
    func callContactUsWebService(_ completionClosure: @escaping () -> ()) { // function for contact us api
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams:Dictionary<String,Any> = ["userid":id ?? "", "textmessage":self.tvmessage.text!, "emailid":self.tfMail.text!, "phoneno":self.MobileLbl.text!]
        print("Param is: \(dictParams)")
        self.loadingAlert = self.showLoadingAlert(on: self)
        WebService.sharedInstance.callContactUsWebService(withParams: dictParams) { data in
            self.ContactUsData = data
            self.loadingAlert?.dismiss(animated: true, completion: {
                if self.ContactUsData?.status == "success" {
                    self.showAlert(message: self.ContactUsData?.message ?? "" ,yesNo: "OK")
                    completionClosure()
                } else if self.ContactUsData?.status == "failed" {
                    completionClosure()
                }
            })
        }
    }
    
    func didloadSetup() { // function for handle UI in viewDidLoad
        tvmessage.delegate = self
        placeholderLabel.text = "Type a message..."
        placeholderLabel.textColor = UIColor.lightGray
        tvmessage.tintColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        tfMail.tintColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
    }
    
    func willAppearSetup() { // function for handle UI in viewWillAppear
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.lblHello.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        self.NameLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.tfMail.font = UIFont(name: "Montserrat-Regular", size: 15)
        callUserProfileWebService{ [self] in
            self.tvmessage.leftPadding()
            self.NameLbl.text = self.profileData?.username
            self.tfMail.text = self.profileData?.emailid
            self.MobileLbl.text = self.profileData?.phoneno
        }
    }
    
    func showEmtyAlert(message:String) { //function for show Alert
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let attributedMessage = NSAttributedString( string:message,
                                                    attributes: [.font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)])
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extension for UITextViewDelegate
extension ContactUsViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) { placeholderLabel.isHidden = true }
    func textViewDidChange(_ textView: UITextView) { placeholderLabel.isHidden = !textView.text.isEmpty }
    func textViewDidEndEditing(_ textView: UITextView) { placeholderLabel.isHidden = !textView.text.isEmpty }
}

// MARK: - Extension for UITextView
extension UITextView {
    
    func leftPadding() { self.textContainerInset = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 30) } } //function for handle left padding in textview

// MARK: - Ends here
