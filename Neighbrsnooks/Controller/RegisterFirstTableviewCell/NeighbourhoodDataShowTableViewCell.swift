//
//  NeighbourhoodDataShowTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 30/09/24.
//

import UIKit

class NeighbourhoodDataShowTableViewCell: UITableViewCell {
    
    
    var isCheckedNeig: Bool = false
    
    @IBOutlet weak var checkboxButtonNei: UIButton!
    
    func updateButtonAppearanceN() {
        // SF Symbols configuration for circle size
        let config = UIImage.SymbolConfiguration(pointSize: 25) // Circle size
        let selectedImage = UIImage(systemName: "largecircle.fill.circle", withConfiguration: config) // Filled circle
        let unselectedImage = UIImage(systemName: "circle", withConfiguration: config) // Empty circle
        
        // Update image and tint color based on state
        checkboxButtonNei.setImage(isCheckedNeig ? selectedImage : unselectedImage, for: .normal)
        checkboxButtonNei.tintColor = isCheckedNeig
        ? UIColor(red: 0, green: 100/255.0, blue: 0, alpha: 1) // Dark green for selected
        : .black // Black for unselected
    }
    
    @IBAction func checkboxTappedN(_ sender: UIButton) {
        isCheckedNeig.toggle()
        updateButtonAppearanceN()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonAppearanceN() // Initial setup
    }
}
