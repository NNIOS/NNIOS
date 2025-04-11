//
//  BannerCollectionViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 07/03/24.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var PublicImgView : UIImageView!
    
    func configure(with imageURL: String) {
            if let url = URL(string: imageURL) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.PublicImgView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    
}
