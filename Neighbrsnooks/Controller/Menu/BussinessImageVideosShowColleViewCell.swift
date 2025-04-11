//
//  BussinessImageVideosShowColleViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 30/10/24.
//

import UIKit

class BussinessImageVideosShowColleViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with item: ImageBussi) {
        if let imageURL = item.img {
            imageView.kf.setImage(with: URL(string: imageURL))
            imageView.contentMode = .scaleAspectFit // Image ko fill aur crop karke dikhane ke liye
            imageView.clipsToBounds = true // Extra portion ko crop karne ke liye
        }
    }
}
