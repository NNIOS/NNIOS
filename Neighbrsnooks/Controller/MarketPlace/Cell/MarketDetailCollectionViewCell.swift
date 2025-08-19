//
//  MarketDetailCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/09/24.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher


class MarketDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImgView: UIImageView!
       @IBOutlet weak var numberLabel: UILabel!
       @IBOutlet weak var totalImagesLabel: UILabel!
       @IBOutlet weak var pauseButton: UIButton!
       @IBOutlet weak var muteButton: UIButton!

       var player: AVPlayer?
       var playerLayer: AVPlayerLayer?

       override func prepareForReuse() {
           super.prepareForReuse()
           // Reset state
           profileImgView.image = nil
           player?.pause()
           playerLayer?.removeFromSuperlayer()
           player = nil
           playerLayer = nil
           muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
       }

    func configure(with postImage: ProductImage) {
        if let imageUrl = postImage.img {
            // Image setup
            profileImgView.isHidden = false
            pauseButton.isHidden = true
            muteButton.isHidden = true
            loadImage(from: imageUrl)
        } else if let videoUrl = postImage.video {
            // Video setup
            profileImgView.isHidden = false
            pauseButton.isHidden = false
            muteButton.isHidden = false
            playVideo(from: videoUrl) // Load video without autoplay
            muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal) // Default mute icon
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal) // Default play icon
        }
    }


    private func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            // Optionally show a loading indicator
            self.profileImgView.kf.indicatorType = .activity

            // Load image with placeholder and caching
            self.profileImgView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "MarketDefault") // जो आपकी default image है
            )
        }
    }


    private func playVideo(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = profileImgView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            profileImgView.layer.addSublayer(playerLayer)
        }
        
        player?.isMuted = true // Always start muted
        // No autoplay
    }

       @IBAction func muteButtonTapped(_ sender: UIButton) {
           guard let player = player else { return }
              player.isMuted.toggle()
              let buttonImage = player.isMuted ? UIImage(systemName: "speaker.slash.fill") : UIImage(systemName: "speaker.fill")
              muteButton.setImage(buttonImage, for: .normal)
       }

    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
   }
