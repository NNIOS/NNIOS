//
//  MarketEnlargmentCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 21/09/24.
//

import UIKit
import AVFoundation

class MarketEnlargmentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImgView : UIImageView!
    
    
    // Function to display video thumbnail
      func configureWithMedia(postImage: PostImage) {
          if let imageUrlString = postImage.img, let url = URL(string: imageUrlString) {
              // Display image in profileImgView
              loadImage(from: url)
          } else if let videoUrlString = postImage.video, let url = URL(string: videoUrlString) {
              // Display video thumbnail in profileImgView
              generateVideoThumbnail(from: url)
          }
      }

      // Load image from URL
      private func loadImage(from url: URL) {
          DispatchQueue.global().async {
              if let data = try? Data(contentsOf: url) {
                  DispatchQueue.main.async {
                      self.profileImgView.image = UIImage(data: data)
                  }
              }
          }
      }

      // Generate video thumbnail
      // Change the access level to 'internal' (or 'public' if needed)
      func generateVideoThumbnail(from url: URL) {
          DispatchQueue.global().async {
              let asset = AVAsset(url: url)
              let imageGenerator = AVAssetImageGenerator(asset: asset)
              imageGenerator.appliesPreferredTrackTransform = true

              do {
                  let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                  let thumbnail = UIImage(cgImage: cgImage)
                  DispatchQueue.main.async {
                      self.profileImgView.image = thumbnail
                  }
              } catch {
                  DispatchQueue.main.async {
                      self.profileImgView.image = UIImage(named: "video-placeholder") // Set placeholder if thumbnail generation fails
                  }
              }
          }
      }
  }
