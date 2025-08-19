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
    var FullImgCallback : ((UIButton) -> Void)?
    var controlVisibilityTimer: Timer?
    private var currentImageURL: String?

    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        currentImageURL = nil
        profileImage.layer.sublayers?.removeAll(where: { $0 is AVPlayerLayer })
        player?.pause()
        player = nil
        playerLayer = nil
        controlVisibilityTimer?.invalidate()
        pauseButton.isHidden = true
        muteButton.isHidden = true
    }


    
    func configure(with BussImage: ImageBussi) {
        profileImage.image = nil
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        player = nil
        playerLayer = nil

        if let imageUrl = BussImage.img, !imageUrl.isEmpty {
            currentImageURL = imageUrl
            profileImage.isHidden = false
            pauseButton.isHidden = true
            muteButton.isHidden = true
            loadImage(from: imageUrl)
        } else if let videoUrl = BussImage.video, !videoUrl.isEmpty {
            currentImageURL = nil
            profileImage.isHidden = false
            pauseButton.isHidden = false
            muteButton.isHidden = false
            playVideo(from: videoUrl)
        } else {
            currentImageURL = nil
            profileImage.image = nil
            pauseButton.isHidden = true
            muteButton.isHidden = true
        }
    }

    
    private func loadImage(from urlString: String) {
        profileImage.image = nil
        guard let url = URL(string: urlString) else { return }

        let expectedURL = urlString
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let image = UIImage(data: data), error == nil {
                DispatchQueue.main.async {
                    // ❗ Only set image if still the same URL
                    if self.currentImageURL == expectedURL {
                        self.profileImage.image = image
                    }
                }
            }
        }.resume()
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
}



