//
//  GroupOwnerableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/06/24.
//

import UIKit


class GroupOwnerableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var BgView: UIView!
    var ProfileDetailCallback : ((UIButton) -> Void)?
    private var defaultTextColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
        defaultTextColor = lblName.textColor
//        updateColors()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnProfileDetail(_ sender: UIButton) {
        ProfileDetailCallback?(sender)
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            BgView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            BgView.backgroundColor = .black
            lblName.textColor = .white
            lblSector.textColor = UIColor.secondaryLabel
           
            BgView.layer.borderWidth = 1.0
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            BgView.isUserInteractionEnabled = true
            BgView.layer.borderWidth = 0
           // lblName.textColor = defaultTextColor
            lblName.textColor = defaultTextColor
            lblSector.textColor = UIColor.secondaryLabel
            BgView.backgroundColor = .white
           // BgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            updateColors()
        }
    }

}
