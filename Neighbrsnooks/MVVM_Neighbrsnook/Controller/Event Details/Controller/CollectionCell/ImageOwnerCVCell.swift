//
//  ImageOwnerCVCell.swift
//  EventDeatilDemo
//
//  Created by Abdul Aleem on 29/09/25.
//

import UIKit

import UIKit
import Kingfisher

class ImageOwnerCVCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var btnDeleteImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ownerImage.clipsToBounds = true
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 8
        mainView.backgroundColor = .clear
        btnDeleteImage.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    func configure(with ownerImg: EventImage) {
        print("Loading image from URL:", ownerImg.image_path)
        if let imgUrl = URL(string: ownerImg.image_path) {
            ownerImage.kf.indicatorType = .activity
            ImageLoader.shared.setImage(on: self.ownerImage, urlString: imgUrl.absoluteString, placeholder: "EventImage")
        } else {
            ownerImage.image = UIImage(named: "default_group")
        }
        
        ownerImage.layer.cornerRadius = 5
    }
}
