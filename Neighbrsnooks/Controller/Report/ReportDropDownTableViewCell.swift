//
//  ReportDropDownTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 29/10/24.
//

import UIKit

class ReportDropDownTableViewCell: UITableViewCell {

    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var selectPostLbl: UILabel!
    
    var isChecked: Bool = false {
           didSet {
               updateButtonAppearance()
           }
       }

       override func awakeFromNib() {
           super.awakeFromNib()
           updateButtonAppearance() // Initial appearance set
           self.selectPostLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
       }

       func updateButtonAppearance() {
           checkboxButton.setTitle(isChecked ? "●" : "", for: .normal) // Filled circle for selected
           checkboxButton.layer.cornerRadius = checkboxButton.bounds.size.width / 2
           checkboxButton.layer.borderWidth = 2
           
           let darkGreenColor = UIColor(red: 0.0, green: 128/255.0, blue: 0.0, alpha: 1.0)
           checkboxButton.layer.borderColor = isChecked ? darkGreenColor.cgColor : UIColor.clear.cgColor
           
           checkboxButton.clipsToBounds = true
       }
   }
    
    
 



