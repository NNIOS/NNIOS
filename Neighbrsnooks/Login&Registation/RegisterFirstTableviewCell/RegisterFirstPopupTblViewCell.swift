//
//  RegisterFirstPopupTblViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 21/09/24.
//

import UIKit

class RegisterFirstPopupTblViewCell: UITableViewCell {
    
    var isChecked: Bool = false
    
    @IBOutlet weak var checkboxButton: UIButton!
    
    func updateButtonAppearance() {
            let config = UIImage.SymbolConfiguration(pointSize: 25)
            let selectedImage = UIImage(systemName: "circle.fill", withConfiguration: config)
            let unselectedImage = UIImage(systemName: "circle", withConfiguration: config)
            checkboxButton.setImage(isChecked ? selectedImage : unselectedImage, for: .normal)
            
            // Set the border color and tint based on the state
            checkboxButton.tintColor = isChecked
                ? UIColor(red: 0, green: 100/255.0, blue: 0, alpha: 1) // Dark green for selected
                : .black // Black for unselected
        }

    

       @IBAction func checkboxTapped(_ sender: UIButton) {
           isChecked.toggle()
                  updateButtonAppearance()
           // Notify the delegate or handle selection
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonAppearance() // Initial setup
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
