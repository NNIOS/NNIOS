//
//  HomeCollectionViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 08/03/24.
//

import UIKit
import AVKit
import AVFoundation


protocol HomeCollectionViewCellDelegate: AnyObject {
    func didSelectItem(at indexPath: IndexPath)
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalImagesLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    weak var delegate: HomeCollectionViewCellDelegate?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // ✅ Reset image
        profileImgView.image = nil
        profileImgView.isHidden = true
        
        // ✅ Stop & remove video
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        
        // ✅ Reset button states
        pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        
        pauseButton.isHidden = true
        muteButton.isHidden = true
    }
    
    func configure(with postImage: postImagesN) {
        if let videoUrl = postImage.video, !videoUrl.isEmpty {
            // ✅ Video available, load video
            print("✅ Loading Video: \(videoUrl)")
            profileImgView.isHidden = false
            setupVideo(from: videoUrl)
            pauseButton.isHidden = false
            muteButton.isHidden = false
            muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal) // Default mute
        } else if let imageUrl = postImage.img, !imageUrl.isEmpty {
            // ✅ Image available, load image
            print("✅ Loading Image: \(imageUrl)")
            profileImgView.isHidden = false
            loadImage(from: imageUrl)
            pauseButton.isHidden = true
            muteButton.isHidden = true
        } else {
            // ❌ No video or image, hide everything
            print("⚠️ No Image or Video available")
            profileImgView.isHidden = true
            pauseButton.isHidden = true
            muteButton.isHidden = true
        }
    }
    
    private func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.profileImgView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    private func setupVideo(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        // ✅ Remove old video layer if it exists
        profileImgView.layer.sublayers?.forEach { layer in
            if layer is AVPlayerLayer {
                layer.removeFromSuperlayer()
            }
        }

        player = AVPlayer(url: url)
        player?.isMuted = true // Default to mute
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = profileImgView.bounds
        playerLayer?.videoGravity = .resizeAspectFill

        if let playerLayer = playerLayer {
            profileImgView.layer.addSublayer(playerLayer)
        }

        pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal) // Default to play state
        // ❌ Removed `player?.play()` so it doesn't auto-play
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let playerLayer = playerLayer {
            playerLayer.frame = profileImgView.bounds
        }
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
