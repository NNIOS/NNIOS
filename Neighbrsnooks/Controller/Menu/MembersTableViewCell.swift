//
//  MembersTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 04/04/24.
//

import UIKit

class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    
    @IBOutlet weak var BgView: UIView!
    
   
    @IBOutlet weak var btnThreeDots: UIButton!
    private var defaultTextColor: UIColor?
    // One callback with sender view
       var onAnyTap: ((_ tappedView: UIView) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        defaultTextColor = lblName.textColor
        setupTapGestures()
    }
    
    private func setupTapGestures() {
            [lblName, lblSec, profileImgView].forEach { view in
                view?.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                view?.addGestureRecognizer(tapGesture)
            }
        }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
            if let tappedView = gesture.view {
                onAnyTap?(tappedView)
            }
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            updateColors()
        }
    }
    
    @IBOutlet weak var btnOtherProfile: UIButton!

}
