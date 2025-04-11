//
//  CamPostCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 19/07/24.
//

import UIKit

class CamPostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var LargeImgView : UIImageView!
    
    var FullImgCallback : ((UIButton) -> Void)?
    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.LargeImgView.layer.cornerRadius = 10
    }

}
