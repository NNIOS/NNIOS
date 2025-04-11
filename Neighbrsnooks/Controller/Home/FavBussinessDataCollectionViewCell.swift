//
//  FavBussinessDataCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 05/12/24.
//

import UIKit

import AVKit
import AVFoundation

protocol FavBussCollectionViewCellDelegate: AnyObject {
    func didSelectItem(at indexPath: IndexPath)
}


class FavBussinessDataCollectionViewCell: UICollectionViewCell {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalImagesLabel: UILabel!
    
    var didSelectImage: ((UIImage) -> Void)?
    weak var delegate: FavBussCollectionViewCellDelegate?
    var FullImgCallback : ((UIButton) -> Void)?
    
    
    // Video Controls
    @IBOutlet weak var muteButton: UIButton!
     
    
    override func prepareForReuse() {
           super.prepareForReuse()
           // Reset the cell state
           profileImgView.image = nil
           player?.pause()  // Pause the video
           playerLayer?.removeFromSuperlayer()  // Reset the video player
           player = nil
           playerLayer = nil
           muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal) // Mute button by default
       }

    func configure(with businessImage: BusinessImage) {
        if let imageUrl = businessImage.img {
            profileImgView.isHidden = false
            loadImage(from: imageUrl)
            pauseButton.isHidden = true // Hide for images
            muteButton.isHidden = true // Hide for images
        } else if let videoUrl = businessImage.video {
            profileImgView.isHidden = false
            playVideo(from: videoUrl) // Load video without playing
            pauseButton.isHidden = false // Show for videos
            muteButton.isHidden = false // Show for videos
            muteButton.setTitle("", for: .normal) // Set default title
        }
    }


    private func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            print("Image URL: \(url)")  // Debugging to check URL
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error loading image: \(String(describing: error))")  // Debugging error
                    return
                }
                DispatchQueue.main.async {
                    self.profileImgView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            print("Invalid image URL: \(urlString)")  // Debugging if URL is invalid
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
           
           player?.isMuted = true // Mute by default
           player?.pause() // Pause the video initially
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
                sender.setImage(UIImage(systemName: "play.fill"), for: .normal) // Play icon set karein
            } else {
                player.play()
                sender.setImage(UIImage(systemName: "pause.fill"), for: .normal) // Pause icon set karein
            }
        }
    }
}
