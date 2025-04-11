//
//  EventsCollectionViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 05/04/24.
//

import UIKit

class EventsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    
    var DetailCallback : ((UIButton) -> Void)?
    
    @IBAction func btnEventDetail(_ sender: UIButton) {
        DetailCallback?(sender)
    }
}
