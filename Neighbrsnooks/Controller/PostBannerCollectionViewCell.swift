//
//  PostBannerCollectionViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 22/04/24.
//

import UIKit
import AVKit

protocol PostBannerCollectionViewCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: PostBannerCollectionViewCell)
}

class PostBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cratePostMuteButton: UIButton!
    @IBOutlet weak var cratePostplayPauseButton: UIButton!
    weak var delegate: PostBannerCollectionViewCellDelegate?
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var videoSlider: UISlider!
    @IBOutlet weak var btnPostBannerDelete: UIButton!
    @IBOutlet weak var imageView : UIImageView!
    var FullImgCallback : ((UIButton) -> Void)?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isPlaying: Bool = false
    private var isMuted: Bool = false
    var imgDataF = [PostImageF]()
    var PostListData : PostListModel?
    var imgData = [PostImage]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPostBannerDelete.layer.cornerRadius = btnPostBannerDelete.frame.height/2
        btnPostBannerDelete.clipsToBounds = true
        btnPostBannerDelete.layer.borderWidth = 1
        btnPostBannerDelete.layer.borderColor = UIColor.white.cgColor
        profileImgView.contentMode = .scaleAspectFill
        profileImgView.clipsToBounds = true
        
    }
    
    func configureVideo(with url: URL) {
        guard let profileImgView = profileImgView else {
            print("❌ profileImgView is nil")
            return
        }
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = profileImgView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let playerLayer = playerLayer {
            profileImgView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }  // Remove old layers
            profileImgView.layer.addSublayer(playerLayer)
        }
        
        // 🔹 **Video by default pause rahega**
        player?.pause()
        
        // 🔹 **By default mute rakho**
        player?.isMuted = true
        
        // 🎛 **Buttons ko show/hide karein**
        if let playPauseButton = cratePostplayPauseButton, let muteButton = cratePostMuteButton {
            playPauseButton.isHidden = false
            muteButton.isHidden = false
            
            // **Play button ka default icon 'play' hona chahiye**
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
            // **Mute button ka default icon 'mute' hona chahiye**
            muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        } else {
            print("❌ Play/Pause button ya Mute button nil hai")
        }
    }
    
    
    
    // Function to configure cell for image
    func configureImage(with image: UIImage) {
        profileImgView.image = image
        
        // Hide video controls for image
        cratePostplayPauseButton.isHidden = true
        cratePostMuteButton.isHidden = true
    }
    
    
    
    
    
    @IBAction func actionDeletePostImgVid(_ sender: UIButton) {
        delegate?.didTapDeleteButton(in: self)
    }
    
    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    @IBAction func actionCreatePostPlayPause(_ sender: Any) {
        guard let player = player else { return }
        
        if player.timeControlStatus == .playing {
            player.pause()
            cratePostplayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal) // Set Play icon
        } else {
            player.play()
            cratePostplayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal) // Set Pause icon
        }
    }
    private var closestCollectionView: UICollectionView? {
        var view: UIView? = self
        while view != nil {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
            view = view?.superview
        }
        return nil
    }
    
    @IBAction func actionCreatePostMute(_ sender: Any) {
        guard let player = player else { return }
        
        player.isMuted = !player.isMuted
        if player.isMuted {
            cratePostMuteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal) // Set Mute icon
        } else {
            cratePostMuteButton.setImage(UIImage(systemName: "speaker.fill"), for: .normal) // Set Unmute icon
        }
    }
}





