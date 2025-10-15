//
//  ReferListNeighbourhoodTableViewCell.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 13/10/25.
//

import UIKit

class ReferListNeighbourhoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var selectListDataLbl: UILabel!
    
    var isChecked: Bool = false {
        didSet {
            updateButtonAppearance()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonAppearance()
    }
    
    func updateButtonAppearance() {
        checkboxButton.setTitle(isChecked ? "●" : "", for: .normal)
        checkboxButton.layer.cornerRadius = checkboxButton.bounds.size.width / 2
        checkboxButton.layer.borderWidth = 2
        let darkGreenColor = UIColor(red: 0.0, green: 128/255.0, blue: 0.0, alpha: 1.0)
        checkboxButton.layer.borderColor = isChecked ? darkGreenColor.cgColor : UIColor.clear.cgColor
        checkboxButton.clipsToBounds = true
    }
}
