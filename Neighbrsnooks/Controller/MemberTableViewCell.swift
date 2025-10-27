//
//  MemberTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 01/03/24.
//

import UIKit


protocol HomeTableViewCellDelegate: AnyObject {
    func didSelectItem(with data: HomePostMedia, username: String, allImages: [HomePostMedia])
}



@available(iOS 16.0, *)
protocol MemberTableViewCellDelegate: AnyObject {
    func didTapCommentsButton(cell: MemberTableViewCell)
}

protocol MemberCellDelegate: AnyObject {
    func didTapProfile(for userId: String)
}


@available(iOS 16.0, *)
protocol ThreeDotMemberTableViewCellDelegate: AnyObject {
    func didTapDotButton(cell: MemberTableViewCell)
}
protocol MemberTableViewLikeUnlikeCellDelegate: AnyObject {
    func didTapLike(postId: String, isLiked: Bool, emoji: String?)
}




@available(iOS 16.0, *)
class MemberTableViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionViewBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGeneral: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    weak var delegateM: MemberCellDelegate?
    var userId: String?
    @IBOutlet weak var HeartImgView : UIImageView!
    @IBOutlet weak var LargeImgView : UIImageView!
    @IBOutlet weak var lblStLikes: UILabel!
    @IBOutlet weak var lblStComment: UIButton!
    @IBOutlet weak var viewToHide: UIView!
    @IBOutlet weak var btnDotsImg : UIButton!
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShareCount: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    
    var business_id : String?
    var BussinessFavouriteData : FavouriteBussinessModel?
    var BussinessRemoveFavouriteData : RemoveFavouriteBussiness?
    var isLikedByUser = false // Track if user has already liked
    //    new outlet
    weak var delegateCell: MemberTableViewCellDelegate?
    weak var delegateThreDot: ThreeDotMemberTableViewCellDelegate?
    weak var delegateLikeUnlikeCell: MemberTableViewLikeUnlikeCellDelegate?
    var postId: String = ""
    var isExpanded = false
    var profileData : ProfileModel?
    var isLiked = false
    var likeCount = 0
    var selectedEmoji: String?
    var commentCount = 0
    var shareCount = 0
    var isFavourite = false
    var fullDescriptionText: String = ""
    var emojiSelectionHandler: ((String) -> Void)?
    var showAlertCallback: ((String) -> Void)?
    var shareAppCallback: (() -> Void)?
    
    
    weak var delegate: HomeTableViewCellDelegate?
     var UserName = ""
    private var defaultTextColor: UIColor?
    var FullImgCallback : ((UIButton) -> Void)?
    var DotCallback: ((String?) -> Void)?
    var thisWidth:CGFloat = 0
    var favouriteButtonCallback: (() -> Void)?
    var likeUnLikeTab: (() -> Void)?
    var postid: String?
    var showVerificationAlertCallback: (() -> Void)?
    
    var postData: HomePostItem?
    var imgDataAll: [HomePostMedia] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        defaultTextColor = lblName.textColor
        //        updateColors()
        collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
        lblMonth.font = UIFont(name: "Montserrat-Regular", size: 12)
        lblSec.font = UIFont(name: "Montserrat-Regular", size: 12)
        lblGeneral.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        lblDescription.font = UIFont(name: "Montserrat-Regular", size: 14)
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        collectionViewBanner.showsHorizontalScrollIndicator = false
        collectionViewBanner.showsVerticalScrollIndicator = false
        addTapGestures()
        collectionViewBanner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap)))
        // Initialization code
        //        likebtn.setImage(UIImage(systemName:"hand.thumbsup.circle.fill"), for: .normal)
        likebtn.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblLikeCount.text = "\(likeCount)"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0 // Space between items should be 0
        collectionViewBanner.collectionViewLayout = layout
        collectionViewBanner.isPagingEnabled = false // We'll handle custom snapping
        collectionViewBanner.decelerationRate = .fast // Fast scrolling stop
        collectionViewBanner.showsHorizontalScrollIndicator = false
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showEmojis(_:)))
        longPressGesture.minimumPressDuration = 0.2  // Adjust as needed (default is 0.5 sec)
        likebtn.addGestureRecognizer(longPressGesture)
        likebtn.isUserInteractionEnabled = true
        
    }
    
    
    
    private func addTapGestures() {
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        lblName.isUserInteractionEnabled = true
        lblName.addGestureRecognizer(nameTap)
        let secTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        lblSec.isUserInteractionEnabled = true
        lblSec.addGestureRecognizer(secTap)
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        profileImgView.isUserInteractionEnabled = true
        profileImgView.addGestureRecognizer(profileTap)
    }
    
    @objc private func handleTap() {
        if let userId = userId {
            delegateM?.didTapProfile(for: userId)
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        DispatchQueue.main.async {
            self.collectionViewBanner.reloadData()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
     }
    
    
    
    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionViewBanner)
        if let indexPath = collectionViewBanner.indexPathForItem(at: location) {
            let selectedData = imgDataAll[indexPath.row]
            print("Selected data: \(selectedData)") // Debugging print
            delegate?.didSelectItem(with: selectedData, username: UserName, allImages: imgDataAll)
        }
    }
    
    
    func addTapGestureToLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblDescription.isUserInteractionEnabled = true
        lblDescription.addGestureRecognizer(tapGesture)
    }
    
    // Action when label is tapped (toggle between expanded/collapsed state)
    @objc func labelTapped() {
        isExpanded.toggle()
        //  updateDescriptionText() // Update the description based on new state
        DispatchQueue.main.async {
            self.updateDescriptionText()
        }
    }
    
    // Function to configure description text
    func configureDescription(with text: String) {
        fullDescriptionText = text
        //          updateDescriptionText()
        DispatchQueue.main.async {
            self.updateDescriptionText()
        }
    }
    
    
    private func updateDescriptionText() {
            // ✅ If text is 100 chars or less, show as plain text and return
            if fullDescriptionText.count <= 100 {
                lblDescription.numberOfLines = 0
                lblDescription.text = fullDescriptionText
                lblDescription.gestureRecognizers?.forEach { recognizer in
                    lblDescription.removeGestureRecognizer(recognizer)
                }
                lblDescription.isUserInteractionEnabled = false
                return
            }
            
            guard let font = lblDescription.font else { return }
            
            let maxLines = 2
            let maxWidth = lblDescription.frame.width > 0 ? lblDescription.frame.width : UIScreen.main.bounds.width - 40
            let lineHeight = "A".size(withAttributes: [.font: font]).height
            let maxHeight = lineHeight * CGFloat(maxLines)
            
            let fullTextAttr = NSAttributedString(string: fullDescriptionText, attributes: [
                .font: font
            ])
            
            let fullBoundingRect = fullTextAttr.boundingRect(
                with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            )
            
            let lineCount = Int(ceil(fullBoundingRect.height / lineHeight))
            
            if isExpanded {
                // Show full description with "Less"
                let fullText = NSMutableAttributedString(string: "\(fullDescriptionText) ", attributes: [
                    .font: font,
                    .foregroundColor: #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
                ])
                let lessText = NSAttributedString(string: "Less", attributes: [
                    .font: font,
                    .foregroundColor: #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                ])
                fullText.append(lessText)
                
                lblDescription.numberOfLines = 0
                lblDescription.attributedText = fullText
            } else {
                if lineCount > maxLines {
                    // Show trimmed text + "... More"
                    let trailingText = "... More"
                    let trailingAttr = NSAttributedString(string: trailingText, attributes: [
                        .font: font,
                        .foregroundColor: #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                    ])
                    
                    var fittingText = fullDescriptionText
                    var finalText = NSMutableAttributedString()
                    
                    for i in stride(from: fittingText.count, through: 0, by: -1) {
                        let sub = String(fittingText.prefix(i)).trimmingCharacters(in: .whitespacesAndNewlines)
                        let testAttr = NSMutableAttributedString(string: sub, attributes: [
                            .font: font,
                            .foregroundColor: #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
                        ])
                        testAttr.append(trailingAttr)
                        
                        let boundingRect = testAttr.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                                                                 options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                 context: nil)
                        
                        if boundingRect.height <= maxHeight {
                            finalText = testAttr
                            break
                        }
                    }
                    
                    lblDescription.numberOfLines = maxLines
                    lblDescription.attributedText = finalText
                } else {
                    // Show plain full text, no "More"
                    lblDescription.numberOfLines = 0
                    lblDescription.text = fullDescriptionText
                }
            }
            
            // Disable tap if only 1 line
            if lineCount <= 1 {
                lblDescription.gestureRecognizers?.forEach { recognizer in
                    lblDescription.removeGestureRecognizer(recognizer)
                }
                lblDescription.isUserInteractionEnabled = false
            } else {
                // Re-add tap gesture if missing
                if lblDescription.gestureRecognizers?.isEmpty ?? true {
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
                    lblDescription.addGestureRecognizer(tapGesture)
                    lblDescription.isUserInteractionEnabled = true
                }
            }
            
            lblDescription.setNeedsLayout()
            lblDescription.layoutIfNeeded()
            
            if let tableView = self.superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    
    
    @IBAction func btnDotPost(_ sender: UIButton) {
        DotCallback?(postid)
    }
    
    func configure(with post: HomePostItem) {
        self.postData = post
        self.imgDataAll = post.postMedia

        lblName.text = post.username
        if let url = URL(string: post.userpic), !post.userpic.isEmpty {
            profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            profileImgView.image = UIImage(named: "placeholder")
        }
        lblDescription.text = post.postDescription
        lblMonth.text = post.postCreatedAt
        lblSec.text = post.neighborhoodName
        lblLikeCount.text = "\(post.postTotallike)"
        lblCommentCount.text = "\(post.postTotcomment)"
        lblGeneral.text = post.postType

        collectionViewBanner.reloadData()
    }
    
    
    //MARK: - Collection view

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgDataAll.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        let media = imgDataAll[indexPath.row]
        cell.configure(with: media, totalCount: imgDataAll.count)
        cell.numberLabel.text = "\(indexPath.item + 1)"
        cell.totalImagesLabel.text = "/ \(imgDataAll.count)"
        return cell
    }

    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.row < imgDataAll.count else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
        
        let postImage = imgDataAll[indexPath.row]
        
        if (postImage.img == nil || postImage.img!.isEmpty) && (postImage.video == nil || postImage.video!.isEmpty) {
            return CGSize(width: collectionView.frame.width, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 500)
        }
    }
    
    
    
    // Snapping effect to stop at the nearest item
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionViewBanner.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = collectionViewBanner.frame.width // Full screen width
        
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: CGFloat
        
        if velocity.x > 0 {
            index = ceil(estimatedIndex)
        } else if velocity.x < 0 {
            index = floor(estimatedIndex)
        } else {
            index = round(estimatedIndex)
        }
        
        targetContentOffset.pointee = CGPoint(x: index * cellWidthIncludingSpacing, y: 0)
    }
    
    
    
    // UICollectionViewDelegate Method - DidSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedData = imgDataAll[indexPath.row]
//        delegate?.didSelectItem(with: selectedData, username: UserName, allImages: imgDataAll)
    }
    
    
    
    
    
    func pauseAllVideosInVisibleCells() {
        let visibleCells = collectionViewBanner.visibleCells.compactMap { $0 as? FavoriteCollectionViewCell }
        
        visibleCells.forEach { cell in
            cell.player?.pause()
            cell.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionViewBanner {
            pauseAllVideosInVisibleCells()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionViewBanner {
            playVisibleVideo() // Scroll stop hone ke baad ek video play ho
        }
    }
    
    private func playVisibleVideo() {
        let visibleCells = collectionViewBanner.visibleCells.compactMap { $0 as? FavoriteCollectionViewCell }
        
        visibleCells.forEach { cell in
            cell.player?.pause()
            cell.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        
        if let centerCell = getCenterCell() {
            centerCell.player?.play()
            centerCell.pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    private func getCenterCell() -> FavoriteCollectionViewCell? {
        let centerPoint = CGPoint(x: collectionViewBanner.bounds.midX + collectionViewBanner.contentOffset.x,
                                  y: collectionViewBanner.bounds.midY + collectionViewBanner.contentOffset.y)
        
        if let indexPath = collectionViewBanner.indexPathForItem(at: centerPoint),
           let cell = collectionViewBanner.cellForItem(at: indexPath) as? FavoriteCollectionViewCell {
            return cell
        }
        return nil
    }
    
    
    
    
    
    
    
    //    new code emoji code
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        if isLikedByUser {
            // Unlike
            isLikedByUser = false
            selectedEmoji = nil
            likeCount = max(0, likeCount - 1)
            lblLikeCount.text = "\(likeCount)"
            resetLikeButtonUI()
            
            delegateLikeUnlikeCell?.didTapLike(postId: postId, isLiked: false, emoji: nil)
        } else {
            // Normal Like
            isLikedByUser = true
            likeCount += 1
            lblLikeCount.text = "\(likeCount)"
            setLikedUI()
            
            delegateLikeUnlikeCell?.didTapLike(postId: postId, isLiked: true, emoji: nil)
        }
    }
    
    func resetLikeButtonUI() {
        likebtn.setImage(UIImage(named: "Unlike"), for: .normal)
        likebtn.setTitle("", for: .normal)
        likebtn.tintColor = .gray
    }

    
    
    
    
    func setLikedUI() {
        likebtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        likebtn.setTitle("", for: .normal)
        likebtn.tintColor = .systemGreen
    }
    
    func setEmojiUI(_ emoji: String) {
        likebtn.setImage(nil, for: .normal)
        likebtn.setTitle(emoji, for: .normal)
        likebtn.tintColor = .clear
    }
    
    
    func showEmojiSelectionView(button: UIButton) {
        // Remove previous emoji view if it exists
        if let existingEmojiView = UIApplication.shared.windows.first?.viewWithTag(9999) {
            existingEmojiView.removeFromSuperview()
        }
        
        guard let rootView = UIApplication.shared.windows.first?.rootViewController?.view else { return }
        let buttonFrame = button.convert(button.bounds, to: rootView)
        
        // Create custom view for emoji selection (wider & taller for bigger emojis)
        let emojiSelectionView = UIView(frame: CGRect(x: buttonFrame.midX - 2, y: buttonFrame.minY - 70, width: 350, height: 80))
        emojiSelectionView.backgroundColor = .white
        emojiSelectionView.layer.cornerRadius = 12
        emojiSelectionView.layer.shadowColor = UIColor.black.cgColor
        emojiSelectionView.layer.shadowOpacity = 0.3
        emojiSelectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        emojiSelectionView.layer.shadowRadius = 6
        emojiSelectionView.tag = 9999
        
        let emojis = ["👍", "❤️", "😂", "😮", "😎", "🥳"]
        
        // Horizontal scroll view
        let scrollView = UIScrollView(frame: emojiSelectionView.bounds)
        scrollView.contentSize = CGSize(width: emojis.count * 70, height: 80)
        scrollView.showsHorizontalScrollIndicator = false
        
        for (index, emoji) in emojis.enumerated() {
            let button = UIButton(frame: CGRect(x: CGFloat(index) * 70, y: 0, width: 70, height: 80))
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40) // 👈 Bigger emoji font
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
        }
        
        emojiSelectionView.addSubview(scrollView)
        rootView.addSubview(emojiSelectionView)
        
        // Auto remove after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            emojiSelectionView.removeFromSuperview()
        }
    }
    
    
    
    
    // Handle emoji selection
    @objc func emojiSelected(_ sender: UIButton) {
        guard let emoji = sender.titleLabel?.text else { return }
        
        if selectedEmoji == emoji {
            print("Same emoji selected again — ignored.")
            return
        }
        
        if !isLikedByUser {
            likeCount += 1
        }
        
        selectedEmoji = emoji
        isLikedByUser = true
        lblLikeCount.text = "\(likeCount)"
        setEmojiUI(emoji)
        
        sender.superview?.superview?.removeFromSuperview()
        delegateLikeUnlikeCell?.didTapLike(postId: postId, isLiked: true, emoji: emoji)
    }
    
    
    // Update like button with selected emoji
    func updateLikeWithEmoji() {
        guard let emoji = selectedEmoji else { return }
        
        lblLikeCount.text = "\(likeCount)"
        likebtn.setTitle(emoji, for: .normal)
        likebtn.setImage(nil, for: .normal)
    }
    
    
    // Long press gesture to show emoji selection
    @objc func showEmojis(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("👆 Long press detected")
            if let button = gesture.view as? UIButton {
                showEmojiSelectionView(button: button)
            }
        }
    }
    
    
    func configureLikeButton(likestatus: String, totalLike: Int, selectedEmoji: String?) {
        if likestatus == "0" {
            // Show unlike icon
            likebtn.setImage(UIImage(named: "Unlike"), for: .normal)
            likebtn.setTitle("", for: .normal)
        } else if totalLike == 1 {
            if let emoji = selectedEmoji, !emoji.isEmpty {
                // Show emoji selected by user
                likebtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                likebtn.setTitle("", for: .normal)
                likebtn.tintColor = .systemGreen
            } else {
                // Show like icon (simple like)
                likebtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                likebtn.setTitle("", for: .normal)
                likebtn.tintColor = .systemGreen
            }
        } else {
            // Optional: Handle other cases (like count > 1)
            likebtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            likebtn.setTitle("", for: .normal)
            likebtn.tintColor = .systemGreen
        }
    }

    
    
    
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        delegateCell?.didTapCommentsButton(cell: self)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        // Step 1: Internet Check
        shareAppCallback?()
        shareCount += 1
        lblShareCount.text = "\(shareCount)"
    }
    
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        favouriteButtonCallback?()
    }
    
    // Update UI based on fav/unfav status
    func updateFavouriteButton(isFavourite: Bool) {
        let imageName = isFavourite ? "favorites" : "Un favorites"
        if let image = UIImage(named: imageName) {
            btnFavourite.setImage(image, for: .normal)
        } else {
            btnFavourite.setImage(UIImage(systemName: "heart"), for: .normal) // fallback icon, just in case
        }
    }

    
    
}



