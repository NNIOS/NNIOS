//
//  File.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 12/02/25.
//

import Foundation
import UIKit

class FontUtility {
    // Static function to set font on UILabel or any text-based view
    static func applyFont(to label: UILabel, size: CGFloat = 15) {
        label.font = UIFont(name: "Montserrat-Regular", size: size)
    }
    
    // You can also add more functions for UITextField, UITextView, etc.
    static func applyFont(to textField: UITextField, size: CGFloat = 15) {
        textField.font = UIFont(name: "Montserrat-Regular", size: size)
    }
    
    static func applyFont(to textView: UITextView, size: CGFloat = 15) {
        textView.font = UIFont(name: "Montserrat-Regular", size: size)
    }
}



@IBDesignable
class CustomTextView: UITextView {
    @IBInspectable var customFontSize: CGFloat = 14 {
        didSet {
            self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
    }
}


//
//class CustomLabelFirstName: UITextField {
//    
//    @IBInspectable var customFontSize: CGFloat = 16 {
//        didSet {
//            updateAppearance()
//        }
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        updateAppearance()
//    }
//
//    private func updateAppearance() {
//        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
//        self.textColor = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0)
//    }
//}



@IBDesignable
class CustomLabelFirstName: UITextField {
     @IBInspectable var customFontSize: CGFloat = 16 {
        didSet {
            self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
            self.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        self.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)

    }
}


@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var customFontSize: CGFloat = 14 {
        didSet {
            self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
    }
}


//UIFont(name: "Montserrat-Regular", size: 16)

@IBDesignable
class CustomLabelHeadingname: UILabel {
    @IBInspectable var customFontSize: CGFloat = 16 {
        didSet {
            self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
    }
}



@IBDesignable
class CustomLabelSelectPost: UILabel {
    @IBInspectable var customFontSize: CGFloat = 18 {
        didSet {
            self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
    }
}


 
 

@IBDesignable
class CustomLabel: UILabel {
    @IBInspectable var customFontSize: CGFloat = 15 {
        didSet {
            self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
    }
}

 
@IBDesignable
class CustomLabelComment: UILabel {
    
    @IBInspectable var customFontSize: CGFloat = 14 {
        didSet {
            updateAppearance()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateAppearance()
    }

    private func updateAppearance() {
        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        self.textColor = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0)
    }
}



@IBDesignable
class CustomLabelHedingComment: UILabel {
    
    @IBInspectable var customFontSize: CGFloat = 20 {
        didSet {
            updateAppearance()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateAppearance()
    }

    private func updateAppearance() {
        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        self.textColor = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0)
    }
}







// font size user name profile and side menu
@IBDesignable
class ProfileSideMenuLabel: UILabel {
    
    @IBInspectable var customFontSize: CGFloat = 16 {
        didSet {
            self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
    }
}



@IBDesignable
class CustomButton: UIButton {

    @IBInspectable var customFontSize: CGFloat = 14 {
        didSet {
            self.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
    }
}



@IBDesignable
class CustomButtonMenu: UIButton {

    @IBInspectable var customFontSize: CGFloat = 14 {
        didSet {
            self.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: customFontSize)
    }
}


 

class UIHelper {
    static func showLoader(on button: UIButton, show: Bool, title: String = "Button") {
        let tag = 9999 // Unique tag to identify loader
        if show {
            // Check if loader already exists
            if button.viewWithTag(tag) == nil {
                let activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.color = .white
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                activityIndicator.tag = tag
                button.addSubview(activityIndicator)

                // Center the loader in button
                NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor)
                ])

                activityIndicator.startAnimating()
                button.isUserInteractionEnabled = false // Disable button while loading
                button.setTitle("", for: .normal) // Hide button title
            }
        } else {
            if let activityIndicator = button.viewWithTag(tag) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                button.isUserInteractionEnabled = true // Enable button again
                button.setTitle(title, for: .normal) // Restore button title
            }
        }
    }
}
