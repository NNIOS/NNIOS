//
//  ChatMemberTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 01/05/24.
//

import UIKit

class ChatMemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    
    @IBOutlet weak var viewItems: UIView!
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var profileImgNewView : UIImageView!
    @IBOutlet weak var rsLbl: UILabel!
    @IBOutlet weak var secttLbl: UILabel!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var BgView: UIView!
    
    var DetailCallback : ((UIButton) -> Void)?
    private var defaultTextColor: UIColor?
    @IBAction func btnEventDetail(_ sender: UIButton) {
        DetailCallback?(sender)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        defaultTextColor = lblName.textColor
        updateColors()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            BgView.layer.borderColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            lblName.textColor = .white
            lblSec.textColor = UIColor.secondaryLabel
           
            BgView.layer.borderWidth = 1.0
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            BgView.isUserInteractionEnabled = true
            BgView.layer.borderWidth = 0
           // lblName.textColor = defaultTextColor
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
