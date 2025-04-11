//
//  CapitalizingTextField.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 08/05/24.
//

import UIKit

class CapitalizingTextField: UITextField {

    override var text: String? {
            get {
                return super.text
            }
            set {
                // Check if newValue is not nil and is not an empty string
                if let newValue = newValue, !newValue.isEmpty {
                    // Capitalize the first letter and assign the modified text
                    super.text = newValue.prefix(1).uppercased() + newValue.dropFirst()
                } else {
                    // If newValue is nil or an empty string, assign it directly
                    super.text = newValue
                }
            }
        }

}
