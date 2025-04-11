//
//  BusinessDetailsCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/08/24.
//

import UIKit
import AVKit
import AVFoundation

class BusinessDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalImagesLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var FullImgCallback : ((UIButton) -> Void)?
    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    
    
    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        if let player = player {
            player.isMuted.toggle()
            let buttonImage = player.isMuted ? UIImage(systemName: "speaker.slash.fill") : UIImage(systemName: "speaker.fill")
            muteButton.setImage(buttonImage, for: .normal)
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
                sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                player.play()
                sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
    }
    
    // Function to configure the cell with image or video data
    func configureCell(with data: ImageBd) {
        if let imgUrl = data.img, !imgUrl.isEmpty {
            // Display Image
            if let url = URL(string: imgUrl) {
                profileImgView.kf.indicatorType = .activity
                profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "NewEvents"))
            }
            stopVideoPlayback() // Stop video if image is displayed
            muteButton.isHidden = true // Hide mute button
            pauseButton.isHidden = true // Hide play/pause button
        } else if let videoUrl = data.video, !videoUrl.isEmpty {
            // Display Video Thumbnail
            if let url = URL(string: videoUrl) {
                generateThumbnail(for: url) { [weak self] thumbnail in
                    DispatchQueue.main.async {
                        self?.profileImgView.image = thumbnail // Set video thumbnail as image
                    }
                }
                startVideoPlayback(for: videoUrl) // Start video playback
                muteButton.isHidden = false // Show mute button
                pauseButton.isHidden = false // Show play/pause button
            }
        }
    }
    
    // Start video playback using AVPlayer
    private func startVideoPlayback(for videoUrl: String) {
        guard let url = URL(string: videoUrl) else { return }
        
        // Remove existing player and layer if any
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        // Set up AVPlayer
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = profileImgView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            profileImgView.layer.addSublayer(playerLayer)
        }
        
        // Mute by default
        player?.isMuted = true
        muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal) // Set mute icon
        
        player?.play()
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    // Stop video playback
    private func stopVideoPlayback() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
    }
    
    // Generate thumbnail from video URL
    private func generateThumbnail(for url: URL, completion: @escaping (UIImage) -> Void) {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTimeMake(value: 1, timescale: 2) // Midpoint of the video
        assetImageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, _, _ in
            if let image = image {
                completion(UIImage(cgImage: image))
            }
        }
    }
    
}

