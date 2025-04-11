//
//  photoCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/07/24.
//

import UIKit
import AVKit

class photoCollectionViewCell: UICollectionViewCell {
    
    var FullImgCallback : ((UIButton) -> Void)?
    var playButtonCallback: (() -> Void)?
    @IBOutlet weak var LargeImgView : UIImageView!
    var DeleteCallback: ((Int) -> Void)?

    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

   
    
}

