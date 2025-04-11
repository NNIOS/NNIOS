//
//  EventDetailCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 19/08/24.
//

import UIKit

protocol CustomNewTableViewCellDelegate: AnyObject {
    func collectionViewCellTapped(with data: EventDetailModel)
}

class EventDetailCollectionViewCell: UICollectionViewCell {
    var EventDetauilData : EventDetailModel?
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var lblDSec: UILabel!
    @IBOutlet weak var btnDel: UIButton!
    
    var FullImgCallback : ((UIButton) -> Void)?
   // @IBOutlet weak var lblImgId: UILabel!
    
    var DelCallback : ((UIButton) -> Void)?
    var indexPath: IndexPath?
    
    @IBAction func btnDelImg(_ sender: UIButton) {
        DelCallback?(sender)
    }
    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    
    func configure(with imageData: ImageEvent) {
           // lblImgId.text = "\(imageData.imgid)"
        }
}
