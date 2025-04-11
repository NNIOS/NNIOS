import UIKit
import AVKit
import AVFoundation

class PostViewShowImgVideosColleViewCell: UICollectionViewCell {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var timeObserver: Any?
    
    @IBOutlet weak var profileImgVdoView: UIImageView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    

    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var videoSlider: UISlider!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImgVdoView.image = nil
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        removeTimeObserver()
        
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        muteButton.setTitle("", for: .normal)

        // 🎯 Buttons visible karein
        playPauseButton.isHidden = false
        muteButton.isHidden = false
        totalTimeLabel.isHidden = false
        currentTimeLabel.isHidden = false
        videoSlider.isHidden = false
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 🎯 Tap Gesture Add Karein
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
        contentView.addGestureRecognizer(tapGesture)
    }

    
    @objc private func videoTapped() {
        guard let player = player else { return }

        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            // 🎯 Play ke 2 second baad button hide karna
            hideControlsAfterDelay()
        }

        // 🎯 Jab bhi tap ho, button visible ho jaye
        showControls()
    }

    private func hideControlsAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.playPauseButton.isHidden = true
            self.muteButton.isHidden = true
            self.totalTimeLabel.isHidden = true
            self.currentTimeLabel.isHidden = true
            self.videoSlider.isHidden = true
        }
    }

    
    private func showControls() {
        playPauseButton.isHidden = false
        muteButton.isHidden = false
        totalTimeLabel.isHidden = false
        currentTimeLabel.isHidden = false
        videoSlider.isHidden = false
    }

    
    func configure(with postImage: postImagesN) {
        if let imageUrl = postImage.img {
            profileImgVdoView.isHidden = false
            loadImage(from: imageUrl)
            
            // Video controls hide karne hain agar sirf image hai
            playPauseButton.isHidden = true
            muteButton.isHidden = true
            totalTimeLabel.isHidden = true
            currentTimeLabel.isHidden = true
            videoSlider.isHidden = true
        } else if let videoUrl = postImage.video {
            profileImgVdoView.isHidden = true
            playVideo(from: videoUrl)
            
            // Video controls show karne hain jab video aaye
            playPauseButton.isHidden = false
            muteButton.isHidden = false
            totalTimeLabel.isHidden = false
            currentTimeLabel.isHidden = false
            videoSlider.isHidden = false
        }
    }

    
    private func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.profileImgVdoView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    private func playVideo(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        // AVPlayer setup
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill

        if let playerLayer = playerLayer {
            contentView.layer.insertSublayer(playerLayer, at: 0)
            updatePlayerFrame() // ✅ Call function to set frame
        }

        // 🎯 By Default: Video Mute Rakhein, but Play na ho
        player?.isMuted = true
        updateMuteButton()
        observeTimeUpdates()

        DispatchQueue.main.async {
            self.totalTimeLabel.isHidden = false
            self.currentTimeLabel.isHidden = false
            self.videoSlider.isHidden = false

            // Controls ko upar laana
            self.contentView.bringSubviewToFront(self.playPauseButton)
            self.contentView.bringSubviewToFront(self.muteButton)
            self.contentView.bringSubviewToFront(self.totalTimeLabel)
            self.contentView.bringSubviewToFront(self.currentTimeLabel)
            self.contentView.bringSubviewToFront(self.videoSlider)

            // 🎯 Play button ko "Play" set karein
            self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    

    private func updatePlayerFrame() {
        let videoHeight: CGFloat = 350
        playerLayer?.frame = CGRect(x: 0, y: (contentView.bounds.height - videoHeight) / 2, width: contentView.bounds.width, height: videoHeight)
    }



    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = profileImgVdoView.bounds  // 🎯 Ensure video layer updates
        
        updatePlayerFrame()
    }


    @objc private func videoDidEnd() {
        player?.seek(to: .zero)
        player?.play()
    }

    @IBAction func muteButtonTapped(_ sender: UIButton) {
        if let player = player {
            player.isMuted.toggle()
            updateMuteButton()
        }
    }
    
    private func updateMuteButton() {
        let buttonImage = (player?.isMuted == true) ? UIImage(systemName: "speaker.slash.fill") : UIImage(systemName: "speaker.wave.2.fill")
        muteButton.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
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
    
    
    
    
    private func observeTimeUpdates() {
        guard let player = player else { return }

        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }

            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)

            if currentTime.isFinite, duration.isFinite, duration > 0 {
                self.currentTimeLabel.text = self.formatTime(time: currentTime)
                self.totalTimeLabel.text = self.formatTime(time: duration)

                let progress = Float(currentTime / duration)
                self.videoSlider.value = progress
            } else {
                self.currentTimeLabel.text = "00:00"
                self.totalTimeLabel.text = "00:00"
                self.videoSlider.value = 0
            }
        }
    }

    
    func stopVideo() {
        player?.pause() // 🎯 Video pause karein
        player?.seek(to: .zero) // 🎯 Seek to Start
    }

    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        guard let player = player else { return }
        
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
        let seekTime = duration * Double(sender.value)
        let newTime = CMTime(seconds: seekTime, preferredTimescale: 1)
        
        player.seek(to: newTime)
    }
    
    private func formatTime(time: Double) -> String {
        guard time.isFinite, !time.isNaN else { return "00:00" }
        
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    
    private func removeTimeObserver() {
        if let player = player, let observer = timeObserver {
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}
