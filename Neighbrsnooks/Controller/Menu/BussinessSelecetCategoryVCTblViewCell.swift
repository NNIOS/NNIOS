//
//  BussinessSelecetCategoryVCTblViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 16/11/24.
//

import UIKit

class BussinessSelecetCategoryVCTblViewCell: UITableViewCell {
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var selectBussinessLbl: UILabel!
    var isChecked: Bool = false {
           didSet {
               updateButtonAppearance()
           }
       }

       override func awakeFromNib() {
           super.awakeFromNib()
           updateButtonAppearance() // Initial appearance set
       }

       func updateButtonAppearance() {
           checkboxButton.setTitle(isChecked ? "●" : "", for: .normal) // Filled circle for selected
           checkboxButton.layer.cornerRadius = checkboxButton.bounds.size.width / 2
           checkboxButton.layer.borderWidth = 2
           
           let darkGreenColor = UIColor(red: 0.0, green: 128/255.0, blue: 0.0, alpha: 1.0)
           checkboxButton.layer.borderColor = isChecked ? darkGreenColor.cgColor : UIColor.clear.cgColor
           
           checkboxButton.clipsToBounds = true
       }
   
     

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
