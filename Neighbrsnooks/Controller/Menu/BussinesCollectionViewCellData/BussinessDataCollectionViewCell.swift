//
//  BussinessDataCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 25/10/24.
//

import UIKit
import AVKit
import AVFoundation

//protocol BusinessCollectionViewCellDelegate: AnyObject {
//    func BussDidSelectItem(with bussImage: ImageBussi)
//}


//protocol BusinessCollectionViewCellDelegate: AnyObject {
//    func BussDidSelectItem(at indexPath: IndexPath)
//}

class BussinessDataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalImagesLabel: UILabel!
    
    @IBOutlet weak var countlblView: UIView!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
//    weak var delegate: BusinessCollectionViewCellDelegate?
    var FullImgCallback : ((UIButton) -> Void)?
    var controlVisibilityTimer: Timer?
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        controlVisibilityTimer?.invalidate() // Timer ko invalidate karein
        muteButton.isHidden = false
        pauseButton.isHidden = false
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
    }
    
    func configure(with BussImage: ImageBussi) {
        if let imageUrl = BussImage.img {
            profileImage.isHidden = false
            loadImage(from: imageUrl)
            pauseButton.isHidden = true // Hide for images
            muteButton.isHidden = true // Hide for images
        } else if let videoUrl = BussImage.video {
            profileImage.isHidden = false
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
                    self.profileImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }

    private func playVideo(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = profileImage.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            profileImage.layer.addSublayer(playerLayer)
        }
        // Do not call player?.play() here
    }
  
  // Helper function to format time
  private func formatTime(from seconds: Double) -> String {
      let mins = Int(seconds) / 60
      let secs = Int(seconds) % 60
      return String(format: "%02d:%02d", mins, secs)
  }
  
    override func awakeFromNib() {
            super.awakeFromNib()
        self.isUserInteractionEnabled = true
            

        }
    

    
    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        if let player = player {
                   player.isMuted.toggle()
                   let buttonImage = player.isMuted ? UIImage(systemName: "speaker.slash.fill") : UIImage(systemName: "speaker.fill")
                   muteButton.setImage(buttonImage, for: .normal)
               }
//               startControlVisibilityTimer() // Button action par bhi timer reset karein
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
//                startControlVisibilityTimer() // Button action par bhi timer reset karein
            }
    }
    
    

