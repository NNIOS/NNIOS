//
//  WelcomeTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 01/03/24.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblWelcmMsg: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblWelcmCount: UILabel!
    @IBOutlet weak var lblBookaCount: UILabel!
    @IBOutlet weak var WelcomeView: UIView!
    
    var WelLikeCallback : ((UIButton) -> Void)?
    var bookayCallback : ((UIButton) -> Void)?
    private var defaultTextColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors()
        defaultTextColor = lblName.textColor
        defaultTextColor = lblWelcmMsg.textColor
        // Initialization code
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            lblName.textColor = .white
            lblWelcmMsg.textColor = .white
           // WelcomeView.backgroundColor = .black
           
            
        } else {
            // Light mode
            lblName.textColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
            lblWelcmMsg.textColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
           // WelcomeView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
        }
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnWelcm(_ sender: UIButton) {
        WelLikeCallback?(sender)
    }
    
    @IBAction func btnBookay(_ sender: UIButton) {
        bookayCallback?(sender)
    }
}
