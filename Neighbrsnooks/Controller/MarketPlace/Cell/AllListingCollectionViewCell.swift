//
//  AllListingCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 09/09/24.
//

import UIKit

class AllListingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewItems: UIView!
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var rsLbl: UILabel!
    @IBOutlet weak var secttLbl: UILabel!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var SoldImgView : UIImageView!
    
    var DetailCallback : ((UIButton) -> Void)?
    @IBAction func btnEventDetail(_ sender: UIButton) {
        DetailCallback?(sender)
    }
    
}
