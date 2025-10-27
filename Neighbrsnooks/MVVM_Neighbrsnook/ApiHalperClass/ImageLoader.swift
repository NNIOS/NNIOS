//
//  ImageLoader.swift
//  MarketVC
//
//  Created by Abdul Aleem on 15/09/25.
//


import UIKit
import Kingfisher

class ImageLoader {
    
    static let shared = ImageLoader()
    private init() {}
    
    @MainActor
    func setImage(
        on imageView: UIImageView,
        urlString: String?,
        placeholder: String = "person.circle",
        cornerRadius: CGFloat = 5
    ) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = UIImage(named: placeholder)
            return
        }
        
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: placeholder),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        ) { result in
            if case .failure(let error) = result {
                print("❌ Failed to load image: \(error.localizedDescription)")
            }
        }
    }
}

