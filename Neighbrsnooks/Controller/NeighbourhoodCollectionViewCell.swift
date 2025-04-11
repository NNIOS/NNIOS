//
//  NeighbourhoodCollectionViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 05/03/24.
//

import UIKit

class NeighbourhoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var SecLbl: UILabel!
    @IBOutlet weak var FollowMemberLbl: UILabel!
    @IBOutlet weak var viewMember:UIView!
    @IBOutlet weak var btnTransfer:UIButton!
    
    var transferCallback : ((UIButton) -> Void)?
    var followCallback : ((UIButton) -> Void)?
    var DetailsCallback : ((UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadowForViewMember()
    }

    
    @IBAction func btnTransfer(_ sender: UIButton) {
        transferCallback?(sender)
    }
    @IBAction func btnFollow(_ sender: UIButton) {
        followCallback?(sender)
    }
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }
    
    private func setupShadowForViewMember() {
        viewMember.layer.shadowColor = UIColor.black.cgColor
        viewMember.layer.shadowOpacity = 0.2 // Adjust opacity (0 to 1)
        viewMember.layer.shadowOffset = CGSize(width: 0, height: 2) // Horizontal and vertical offset
        viewMember.layer.shadowRadius = 4 // Spread of the shadow
        viewMember.layer.masksToBounds = false
    }
    
    @IBOutlet weak var viewCard: UIView!
    
    @IBOutlet weak var btnEdit: UIButton!
    
}


