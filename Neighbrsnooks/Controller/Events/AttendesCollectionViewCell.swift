//
//  AttendesCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 03/03/25.
//

import UIKit

protocol CustomAttendeTableViewCellDelegate: AnyObject {
    func collectionViewCellTapped(with data: EventDetailModel)
}


class AttendesCollectionViewCell: UICollectionViewCell {
    var EventDetauilData : EventDetailModel?
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var lblDSec: UILabel!
    @IBOutlet weak var btnDel: UIButton!
    
    var FullImgCallback : ((UIButton) -> Void)?
   // @IBOutlet weak var lblImgId: UILabel!
    
    var DelAttendeCallback : ((UIButton) -> Void)?
    var indexPath: IndexPath?
    
    @IBAction func btnDelImg(_ sender: UIButton) {
        DelAttendeCallback?(sender)
    }
    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    
    func configure(with imageData: ImageEvent) {
           // lblImgId.text = "\(imageData.imgid)"
        }
}
