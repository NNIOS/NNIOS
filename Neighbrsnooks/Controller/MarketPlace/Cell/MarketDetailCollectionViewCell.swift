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
        profileImgView.image = nil
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
    }
    
    func configure(with postImage: ProductMedia) {
        if let img = postImage.img, !img.isEmpty {
            // Image setup
            profileImgView.isHidden = false
            pauseButton.isHidden = true
            muteButton.isHidden = true
            loadImage(from: img)
        } else if let video = postImage.video, !video.isEmpty {
            // Video setup
            profileImgView.isHidden = false
            pauseButton.isHidden = false
            muteButton.isHidden = false
            playVideo(from: video)
            muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            profileImgView.image = UIImage(named: "MarketDefault")
            pauseButton.isHidden = true
            muteButton.isHidden = true
        }
    }
    
    private func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            profileImgView.kf.indicatorType = .activity
            profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "MarketDefault"))
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
        player?.isMuted = true
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
