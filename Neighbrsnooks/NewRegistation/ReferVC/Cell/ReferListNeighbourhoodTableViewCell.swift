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
        setupButton()
        updateButtonAppearance()
        selectListDataLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
    }
    
    private func setupButton() {
        checkboxButton.layer.cornerRadius = checkboxButton.frame.height / 2
        checkboxButton.layer.borderWidth = 2
        checkboxButton.layer.borderColor = UIColor.systemGray4.cgColor
        checkboxButton.backgroundColor = .clear
        checkboxButton.clipsToBounds = true
    }
    
    private func updateButtonAppearance() {
        if isChecked {
            checkboxButton.backgroundColor = UIColor.systemGreen
            checkboxButton.layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            checkboxButton.backgroundColor = .clear
            checkboxButton.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
}
