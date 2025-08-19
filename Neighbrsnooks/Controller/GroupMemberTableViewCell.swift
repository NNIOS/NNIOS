//
//  GroupMemberTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/06/24.
//

import UIKit

class GroupMemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    
    @IBOutlet weak var profileImgView : UIImageView!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var BgView: UIView!
   
    private var defaultTextColor: UIColor?
    
    
    
    var ProfileDetailCallback : ((UIButton) -> Void)?
    
    var AcceptCallback : ((UIButton) -> Void)?
    var DeclineCallback : ((UIButton) -> Void)?
    var DelUserCallback : ((UIButton) -> Void)?
    var account = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultTextColor = lblName.textColor
//        updateColors()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAccept(_ sender: UIButton) {
        AcceptCallback?(sender)
        account = "1"
    }
    @IBAction func btnDecline(_ sender: UIButton) {
        DeclineCallback?(sender)
        account = "2"
    }
    
    @IBAction func btnDelUser(_ sender: UIButton) {
        DelUserCallback?(sender)
        
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
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            updateColors()
//        }
//    }
}
