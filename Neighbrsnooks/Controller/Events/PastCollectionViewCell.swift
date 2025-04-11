//
//  PastCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 13/06/24.
//

import UIKit

class PastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    
    var DetailCallback : ((UIButton) -> Void)?
    var isOffsetAppliedPast : Bool = false
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0))
//    }
    
    override func prepareForReuse() {
           super.prepareForReuse()
           // Reset the frame and the flag
           self.frame = self.frame.offsetBy(dx: 0, dy: 70) // Reverse the offset
        isOffsetAppliedPast = false
       }
    
    @IBAction func btnEventDetail(_ sender: UIButton) {
        DetailCallback?(sender)
    }
    
}
