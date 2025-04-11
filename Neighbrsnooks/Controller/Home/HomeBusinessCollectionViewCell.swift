//
//  HomeBusinessCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 08/01/25.
//

import UIKit
import AVKit
import AVFoundation

class HomeBusinessCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalImagesLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    
    
    func configureVideoPlayer(with url: URL) {
           // Remove previous player if any
           removeVideoPlayer()

           // Initialize player
           player = AVPlayer(url: url)
           player?.isMuted = true // Default to muted
           playerLayer = AVPlayerLayer(player: player)
           playerLayer?.frame = profileImgView.bounds
           playerLayer?.videoGravity = .resizeAspectFill
           if let playerLayer = playerLayer {
               profileImgView.layer.addSublayer(playerLayer)
           }
           player?.play()
       }

       func removeVideoPlayer() {
           player?.pause()
           player = nil
           playerLayer?.removeFromSuperlayer()
           playerLayer = nil
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

       override func prepareForReuse() {
           super.prepareForReuse()
           removeVideoPlayer() // Clean up video player for reuse
       }
   }
