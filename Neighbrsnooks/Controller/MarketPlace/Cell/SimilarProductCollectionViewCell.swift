//
//  SimilarProductCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 11/09/24.
//

import UIKit

class SimilarProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewItems: UIView!
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var rsLbl: UILabel!
    @IBOutlet weak var secttLbl: UILabel!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var ViewSimilar: UIView!
    
    var DetailCallback : ((UIButton) -> Void)?
    @IBAction func btnEventDetail(_ sender: UIButton) {
        DetailCallback?(sender)
    }
    
}
