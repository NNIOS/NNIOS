//
//  ImageLoader.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 09/07/25.
//

import UIKit
import Foundation
import Kingfisher

class ImageLoader {
    
    static func loadImage(
        into imageView: UIImageView,
        from urlString: String,
        placeholder: UIImage? = UIImage(named: "MarketDefault"),
        targetSize: CGSize? = nil
    ) {
        guard let url = URL(string: urlString) else { return }
        let size = targetSize ?? imageView.bounds.size
        let processor = DownsamplingImageProcessor(size: size)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.1)),
            .cacheOriginalImage,
            .memoryCacheExpiration(.days(1)),
            .diskCacheExpiration(.days(7))
        ]
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: placeholder, options: options)
    }
}
