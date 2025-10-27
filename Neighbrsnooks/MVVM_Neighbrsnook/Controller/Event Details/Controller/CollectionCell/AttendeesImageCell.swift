//
//  AttendeesImageCell.swift
//  EventDeatilDemo
//
//  Created by Abdul Aleem on 28/09/25.
//

import UIKit

class AttendeesImageCell: UICollectionViewCell {
    @IBOutlet weak var attenessImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnImgDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        btnImgDelete?.tintColor = .red   // ✅ safe, crash nahi hoga agar button connect na ho
    }

    
    func configure(with ownerImg: EventImage) {
        print("Loading image from URL:", ownerImg.image_path)
        if let imgUrl = URL(string: ownerImg.image_path) {
            attenessImage.kf.indicatorType = .activity
            ImageLoader.shared.setImage(on: self.attenessImage, urlString: imgUrl.absoluteString, placeholder: "EventImage")
        } else {
            attenessImage.image = UIImage(named: "default_group")
        }
        
        attenessImage.layer.cornerRadius = 5
    }

}
