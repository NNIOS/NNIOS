//
//  PublicDirectoryTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 03/10/24.
//

import UIKit

class PublicDirectoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var AddLbl: UILabel!
    @IBOutlet weak var Number1Lbl: UILabel!
    @IBOutlet weak var Number2Lbl: UILabel!
    @IBOutlet weak var WebLbl: UILabel!
    
    @IBOutlet weak var Number1Btn: UIButton!
    @IBOutlet weak var Number2Btn: UIButton!
    @IBOutlet weak var MapButton: UIButton!
    @IBOutlet weak var Number2View: UIView!
    
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var arrowImageView : UIImageView!
    
    var ShareCallback : ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnShare(_ sender: UIButton) {
        ShareCallback?(sender)
    }
   
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            EventLbl.textColor = .white
            AddLbl.textColor = .white
            Number1Lbl.textColor = .white
            Number2Lbl.textColor = .white
            WebLbl.textColor = .white
            arrowImageView.tintColor = .white // Arrow tint for dark mode
            
        } else {
            // Light mode
            EventLbl.textColor = UIColor.secondaryLabel
            AddLbl.textColor = UIColor.secondaryLabel
            Number1Lbl.textColor = UIColor.secondaryLabel
            Number2Lbl.textColor = UIColor.secondaryLabel
            WebLbl.textColor = UIColor.secondaryLabel
            arrowImageView.tintColor = .black // Arrow tint for light mode
            WebLbl.textColor = UIColor.blue
        }
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }

}
