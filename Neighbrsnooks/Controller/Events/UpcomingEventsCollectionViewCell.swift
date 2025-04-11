//
//  UpcomingEventsCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 13/06/24.
//

import UIKit

class UpcomingEventsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    var isOffsetApplied: Bool = false
    var DetailCallback : ((UIButton) -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: -55, left: 0, bottom: 0, right: 0))
    }
    @IBAction func btnEventDetail(_ sender: UIButton) {
        DetailCallback?(sender)
    }
    
    override func prepareForReuse() {
           super.prepareForReuse()
           // Reset the frame and the flag
           self.frame = self.frame.offsetBy(dx: 0, dy: 40) // Reverse the offset
           isOffsetApplied = false
       }
}
