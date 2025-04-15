//
//  NotificationTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 02/03/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var BgView: UIView!
    var DetailsCallback : ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            BgView.backgroundColor = .black
           // BgView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           // BgView.layer.borderWidth = 1.0
            lblName.textColor = .white
            lblSec.textColor = .white
            lblDate.textColor = .white
        } else {
            // Light mode colors
            BgView.backgroundColor = .white
            BgView.layer.borderWidth = 0
            lblName.textColor = .label // Use default label color
            lblSec.textColor = .secondaryLabel
            lblDate.textColor = .secondaryLabel
        }
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }

}
