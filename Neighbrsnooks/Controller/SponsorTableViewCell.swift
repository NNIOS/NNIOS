//
//  SponsorTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 03/07/24.
//

import UIKit

class SponsorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblSponsor: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var BannerImgView : UIImageView!
    @IBOutlet weak var LogoImg : UIImageView!
    
    @IBOutlet weak var viewAction: UIView!
    var actionTappedCallback: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewAction.layer.cornerRadius = 10
        viewAction.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        viewAction.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionLabelTapped))
           lblAction.isUserInteractionEnabled = true
           lblAction.addGestureRecognizer(tapGesture)
        
        LogoImg.layer.cornerRadius = LogoImg.frame.height/2
        LogoImg.clipsToBounds = true
        // Initialization code
    }
    
    @objc func actionLabelTapped() {
        actionTappedCallback?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func btnSponsor(_ sender: UIButton) {
//        SponsCallback?(sender)
//    }
    
   
}
