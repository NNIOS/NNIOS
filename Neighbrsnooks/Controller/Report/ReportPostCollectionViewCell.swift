import UIKit
import AVKit

class ReportPostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    @IBOutlet weak var cratePostMuteButton: UIButton!
    @IBOutlet weak var cratePostplayPauseButton: UIButton!

    @IBOutlet weak var deleteAction: UIButton!

    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var videoSlider: UISlider!

    @IBOutlet weak var imageView: UIImageView!
    var FullImgCallback: ((UIButton) -> Void)?

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isPlaying: Bool = false
    private var isMuted: Bool = false

    var imgDataF = [PostImageF]()
    var PostListData: PostListModel?
    var imgData = [PostImage]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initial setup
        cratePostMuteButton.isHidden = true
        cratePostplayPauseButton.isHidden = true
    }

    // Configure cell for video
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
            profileImgView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            profileImgView.layer.addSublayer(playerLayer)
        }

        // **Video by default pause rahega**
        player?.pause()

        // **By default mute rakho**
        player?.isMuted = true

        // **Show video controls**
        showVideoControls(true)
    }

    // Configure cell for image
    func configureImage(with image: UIImage) {
        profileImgView.image = image

        // **Hide video controls**
        showVideoControls(false)
    }

    // **Toggle visibility of video controls**
    private func showVideoControls(_ show: Bool) {
        cratePostMuteButton.isHidden = !show
        cratePostplayPauseButton.isHidden = !show

        if show {
            // **Set default icons**
            cratePostplayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            cratePostMuteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        }
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
