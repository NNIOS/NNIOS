//
//  MyProfilePostCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 20/11/24.
//

import UIKit
import AVKit
import AVFoundation

class MyProfilePostCollectionViewCell: UICollectionViewCell {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalImagesLabel: UILabel!
    var didSelectImage: ((UIImage) -> Void)?
    weak var delegate: PostCollectionViewCellDelegate?
    var FullImgCallback : ((UIButton) -> Void)?
    
    
    // Video Controls
    @IBOutlet weak var muteButton: UIButton!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("Preparing cell for reuse")
        profileImgView.image = nil
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = profileImgView.bounds
    }

    func configure(with postImage: PostImage) {
        if let imageUrl = postImage.img {
            profileImgView.isHidden = false
            loadImage(from: imageUrl)
            pauseButton.isHidden = true // Hide for images
            muteButton.isHidden = true // Hide for images
        } else if let videoUrl = postImage.video {
            profileImgView.isHidden = false
            playVideo(from: videoUrl) // Load video without playing
            pauseButton.isHidden = false // Show for videos
            muteButton.isHidden = false // Show for videos
            muteButton.setTitle("", for: .normal) // Set default title
        }
    }
    
    private func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.profileImgView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    private func playVideo(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid video URL: \(urlString)")
            return
        }
        print("Playing video from URL: \(url)")
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = profileImgView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            profileImgView.layer.addSublayer(playerLayer)
        }
    }


    
    // Helper function to format time
    private func formatTime(from seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        if let player = player {
            player.isMuted.toggle() // Mute status toggle karein
            let buttonImage = player.isMuted ? UIImage(systemName: "speaker.slash.fill") : UIImage(systemName: "speaker.fill")
            muteButton.setImage(buttonImage, for: .normal) // Button icon update karein
        }
    }
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
                print("Video paused")
                sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                player.play()
                print("Video playing")
                sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        } else {
            print("Player not initialized")
        }
    }

    
}
