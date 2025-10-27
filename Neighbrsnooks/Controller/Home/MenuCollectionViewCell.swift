//
//  MenuCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 20/11/24.
//

import UIKit
import AVKit
import AVFoundation

class MenuCollectionViewCell: UICollectionViewCell {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalImagesLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
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

    func configure(with media: PostMedia) {
        if let imageUrl = media.img, !imageUrl.isEmpty {
            playImage(urlString: imageUrl)
        } else if let videoUrl = media.video, !videoUrl.isEmpty {
            playVideo(urlString: videoUrl)
        } else {
            profileImgView.image = nil
            player?.pause()
            playerLayer?.removeFromSuperlayer()
        }
    }


    private func playImage(urlString: String) {
        pauseButton.isHidden = true
        muteButton.isHidden = true
        playerLayer?.removeFromSuperlayer()

        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImgView.image = image
                    }
                }
            }
        }
    }

    private func playVideo(urlString: String) {
        pauseButton.isHidden = false
        muteButton.isHidden = false
        guard let url = URL(string: urlString) else { return }

        player = AVPlayer(url: url)
        player?.isMuted = true

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = profileImgView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let layer = playerLayer {
            profileImgView.layer.addSublayer(layer)
        }

        // 🔹 Autoplay off by default
        player?.pause()
        pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }

    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    @IBAction func muteButtonTapped(_ sender: UIButton) {
        guard let player = player else { return }
        player.isMuted.toggle()
        let imageName = player.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill"
        muteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
