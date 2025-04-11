//
//  SelectWeekDaysPopuptblViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 06/02/25.
//

import UIKit

class SelectWeekDaysPopuptblViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDayWeekly: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    var toggleSelection: (() -> Void)?  // ✅ Closure for handling selection

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func actionRadio(_ sender: Any) {
        toggleSelection?()  // ✅ Call closure to notify parent view controller

    }
    func configure(with day: String, isSelected: Bool) {
          lblDayWeekly.text = day
          // Customize the size of the circle icon
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)

        let selectedImage = UIImage(systemName: "circle.fill", withConfiguration: config) // Fully filled circle
        let unselectedImage = UIImage(systemName: "circle", withConfiguration: config) // Empty circle

        // Update image and tint color based on state
        checkboxButton.setImage(isSelected ? selectedImage : unselectedImage, for: .normal)

        // Set the border color and tint based on the state
        checkboxButton.tintColor = isSelected
            ? UIColor(red: 0, green: 100/255.0, blue: 0, alpha: 1) // Dark green for selected
            : .black // Black for unselected

      }

}
