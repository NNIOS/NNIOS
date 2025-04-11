//
//  PostDetailsShowDataCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 19/11/24.
//

import UIKit
import AVKit
import AVFoundation

class PostDetailsShowDataCollectionViewCell: UICollectionViewCell {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var timeObserverToken: Any?
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var totaltime: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    

    override func prepareForReuse() {
            super.prepareForReuse()
            
            // Reset player when the cell is reused
            player?.pause()
            player = nil
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
            
            // Remove time observer when the cell is reused
            if let token = timeObserverToken {
                player?.removeTimeObserver(token)
            }
            timeObserverToken = nil
        }

        func configureCell(mediaURL: String?, isVideo: Bool) {
            if isVideo {
                muteButton.isHidden = false
                playPauseButton.isHidden = false
                currentTime.isHidden = false
                totaltime.isHidden = false
                timeSlider.isHidden = false

                if let urlString = mediaURL, let url = URL(string: urlString) {
                    setupVideoPlayer(with: url) // Set up video player
                } else {
                    print("Invalid video URL")
                }
            } else {
                muteButton.isHidden = true
                playPauseButton.isHidden = true
                currentTime.isHidden = true
                totaltime.isHidden = true
                timeSlider.isHidden = true

                if let url = URL(string: mediaURL ?? "") {
                    profileImgView.loadImage(from: url) // Load image from URL
                } else {
                    profileImgView.image = nil // Fallback image if URL is invalid
                }
            }
        }

    private func setupVideoPlayer(with url: URL) {
        // Remove any existing player layers before adding new one
        playerLayer?.removeFromSuperlayer()

        // Initialize AVPlayer with video URL
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)

        // Ensure the player layer takes the full size of the profileImgView (full screen)
        playerLayer?.frame = profileImgView.bounds // Make sure it's profileImgView.bounds
        playerLayer?.videoGravity = .resizeAspectFill // Ensures the video fills the screen while maintaining aspect ratio

        // Add the player layer to the profile image view
        if let playerLayer = playerLayer {
            profileImgView.layer.addSublayer(playerLayer)
        }

        // Set the initial state: Pause video and mute by default
        player?.pause()
        player?.isMuted = true

        // Set the total time on the label and slider (check player availability)
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)

            // Check for invalid or NaN duration
            if totalSeconds.isNaN || totalSeconds.isInfinite || totalSeconds <= 0 {
                totaltime.text = "00:00" // Fallback time for invalid duration
                timeSlider.maximumValue = 0
            } else {
                totaltime.text = formatTime(seconds: totalSeconds)
                timeSlider.maximumValue = Float(totalSeconds)
            }
        } else {
            totaltime.text = "00:00" // Fallback if no duration is available
            timeSlider.maximumValue = 0
        }

        // Update play/pause button icon to "Play"
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        // Set the mute button icon to indicate muted state
        muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)

        // Add periodic time observer to update current time and slider
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 600), queue: DispatchQueue.main, using: { [weak self] time in
            self?.updatePlaybackUI()
        })
    }

    private func updatePlaybackUI() {
        // Update current time and slider value
        if let currentTime = player?.currentTime() {
            let currentSeconds = CMTimeGetSeconds(currentTime)
            self.currentTime.text = formatTime(seconds: currentSeconds)
            timeSlider.value = Float(currentSeconds)
        }
    }

    private func formatTime(seconds: Float64) -> String {
        // Ensure seconds is a valid number
        if seconds.isNaN || seconds.isInfinite {
            return "00:00" // Return a fallback string when the value is invalid
        }

        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
        // Mute button action
        @IBAction func muteButtonTapped(_ sender: UIButton) {
            if let player = player {
                player.isMuted.toggle()
                let buttonImage = player.isMuted ? UIImage(systemName: "speaker.slash.fill") : UIImage(systemName: "speaker.fill")
                muteButton.setImage(buttonImage, for: .normal)
            } else {
                print("Player not initialized")
            }
        }

        // Play/Pause button action
        @IBAction func pauseButtonTapped(_ sender: UIButton) {
            if let player = player {
                if player.timeControlStatus == .playing {
                    player.pause()
                    sender.setImage(UIImage(systemName: "play.fill"), for: .normal) // Show play icon
                } else {
                    player.play()
                    sender.setImage(UIImage(systemName: "pause.fill"), for: .normal) // Show pause icon
                }
            } else {
                print("Player not initialized")
            }
        }

        // Time Slider action
    @IBAction func timeSliderChanged(_ sender: UISlider) {
        if let player = player {
            // Set the video to the new time when slider value changes
            let targetTime = CMTimeMakeWithSeconds(Float64(sender.value), preferredTimescale: 600)
            player.seek(to: targetTime, toleranceBefore: CMTimeMakeWithSeconds(0.1, preferredTimescale: 600), toleranceAfter: CMTimeMakeWithSeconds(0.1, preferredTimescale: 600))
            
            // Optionally, play the video from the new position if it's not playing already
            if player.timeControlStatus != .playing {
                player.play()
                playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        } else {
            print("Player not initialized")
        }
    }
    }
