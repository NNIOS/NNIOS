//
//  DeleteAccountVC.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 05/06/25.
//

import UIKit

class DeleteAccountVC: UIViewController {
    @IBOutlet weak var lblFullName: UITextField!
    @IBOutlet weak var lblPhoneNumber: UITextField!
    @IBOutlet weak var lblEmail_ID: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyRoundedCorners()
    }
    
    func applyRoundedCorners() {
        let cornerRadius: CGFloat = 15
        // TextFields
        [lblFullName, lblPhoneNumber, lblEmail_ID].forEach { textField in
            textField?.layer.cornerRadius = cornerRadius
            textField?.clipsToBounds = true
        }
        
        // TextView
        messageTextView.layer.cornerRadius = cornerRadius
        messageTextView.clipsToBounds = true
        // Button
        btnSubmit.layer.cornerRadius = cornerRadius
        btnSubmit.clipsToBounds = true
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
    }
    
    
    @IBAction func action_Back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
}
