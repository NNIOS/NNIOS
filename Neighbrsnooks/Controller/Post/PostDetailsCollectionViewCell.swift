//
//  PostDetailsCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 19/11/24.
//

import UIKit
import AVKit
import AVFoundation

class PostDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Remove player and its layer
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    func configureCell(mediaURL: String?, isVideo: Bool) {
        profileImgView.image = nil // Reset image view
        if isVideo {
            muteButton.isHidden = false
            playPauseButton.isHidden = false
            if let urlString = mediaURL, let url = URL(string: urlString) {
                setupVideoPlayer(with: url) // Video player setup
            } else {
                print("Invalid video URL: \(String(describing: mediaURL))")
            }
        } else {
            if let urlString = mediaURL, let url = URL(string: urlString) {
                profileImgView.loadImage(from: url) // Load image
            } else {
                print("Invalid image URL: \(String(describing: mediaURL))")
                profileImgView.image = UIImage(named: "placeholder") // Default placeholder
            }
            muteButton.isHidden = true
            playPauseButton.isHidden = true
        }
    }


    
    private func setupVideoPlayer(with url: URL) {
        // Remove existing player layers
        playerLayer?.removeFromSuperlayer()
        
        // Initialize AVPlayer
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        
        // Set playerLayer frame to match profileImgView
        playerLayer?.frame = profileImgView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        // Add playerLayer to profileImgView
        if let playerLayer = playerLayer {
            profileImgView.layer.addSublayer(playerLayer)
        }
        
        // Set default state to pause
        player?.pause()
        
        // Mute the player by default
        player?.isMuted = true
        
        // Update play/pause button icon to "Play"
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        // Update mute button icon to "Muted"
        muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
    }

    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        if let player = player {
            player.isMuted.toggle()
            let buttonImage = player.isMuted ? UIImage(systemName: "speaker.slash.fill") : UIImage(systemName: "speaker.fill")
            muteButton.setImage(buttonImage, for: .normal)
        } else {
            print("Player not initialized")
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
                sender.setImage(UIImage(systemName: "play.fill"), for: .normal) // Play icon
            } else {
                player.play()
                sender.setImage(UIImage(systemName: "pause.fill"), for: .normal) // Pause icon
            }
        } else {
            print("Player not initialized")
        }
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
