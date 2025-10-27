//
//  MyItemCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 07/09/24.
//

import UIKit

class MyItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewItems: UIView!
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var SoldImgView : UIImageView!
    @IBOutlet weak var rsLbl: UILabel!
    @IBOutlet weak var secttLbl: UILabel!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var lblSellDonate: CustomLabelHeadingUseranme!
    @IBOutlet weak var imgWishlist: UIImageView!
    
    var DetailCallback : ((UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBAction func btnEventDetail(_ sender: UIButton) {
        DetailCallback?(sender)
    }
}
