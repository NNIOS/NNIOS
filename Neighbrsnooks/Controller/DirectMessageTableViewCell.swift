//
//  DirectMessageTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 30/04/24.
//

import UIKit

class DirectMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    
    @IBOutlet weak var BgView: UIView!
    
    var MessageCallback : ((UIButton) -> Void)?
    private var defaultTextColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Store the storyboard default color before anything else
           defaultTextColor = lblName.textColor

           // Then update for dark/light mode
           updateColors()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnMessage(_ sender: UIButton) {
        MessageCallback?(sender)
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            BgView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
            BgView.layer.borderWidth = 1.0
            lblName.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            lblSec.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            BgView.isUserInteractionEnabled = true
            BgView.layer.borderWidth = 0
            lblName.textColor = defaultTextColor

            lblSec.textColor = UIColor.secondaryLabel
           // BgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
}
