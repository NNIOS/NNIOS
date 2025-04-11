//
//  MemberTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 01/03/24.
//

import UIKit


protocol HomeTableViewCellDelegate: AnyObject {
    func didSelectItem(with postImage: postImagesN, username: String, allImages: [postImagesN])
}



protocol MemberTableViewCellDelegate: AnyObject {
    func didTapCommentsButton(cell: MemberTableViewCell)
}

protocol MemberCellDelegate: AnyObject {
    func didTapProfile(for userId: String)
}


protocol ThreeDotMemberTableViewCellDelegate: AnyObject {
    func didTapDotButton(cell: MemberTableViewCell)
}

class MemberTableViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionViewBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGeneral: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    var isExpanded = false
    
    @IBOutlet weak var profileImgView : UIImageView!
    weak var delegateM: MemberCellDelegate?
    var userId: String?
    @IBOutlet weak var HeartImgView : UIImageView!
    @IBOutlet weak var LargeImgView : UIImageView!
    @IBOutlet weak var lblStLikes: UILabel!
    @IBOutlet weak var lblStComment: UIButton!
    @IBOutlet weak var viewToHide: UIView!
    
    var business_id : String?
    var BussinessFavouriteData : FavouriteBussinessModel?
    var BussinessRemoveFavouriteData : RemoveFavouriteBussiness?
    var isLikedByUser = false // Track if user has already liked
    //    new outlet
    weak var delegateCell: MemberTableViewCellDelegate?
    weak var delegateThreDot: ThreeDotMemberTableViewCellDelegate?
    
    var profileData : ProfileModel?
    var isLiked = false
    var likeCount = 0
    var selectedEmoji: String?
    var commentCount = 0
    var shareCount = 0
    var isFavourite = false
    var emojiSelectionHandler: ((String) -> Void)?
    
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShareCount: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    
    weak var delegate: HomeTableViewCellDelegate?
    var imgDataAll = [postImagesN]()
    var UserName = ""
    
    var FullImgCallback : ((UIButton) -> Void)?
    var DotCallback: ((String?) -> Void)?
    var thisWidth:CGFloat = 0
    var favouriteButtonCallback: (() -> Void)?
    var postid: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
        lblMonth.font = UIFont(name: "Montserrat-Regular", size: 12)
        lblSec.font = UIFont(name: "Montserrat-Regular", size: 14)
        lblGeneral.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        lblDescription.font = UIFont(name: "Montserrat-Regular", size: 14)
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        
        collectionViewBanner.showsHorizontalScrollIndicator = false
        collectionViewBanner.showsVerticalScrollIndicator = false
        
        addTapGestures()
        collectionViewBanner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap)))
        // Initialization code
        
        likebtn.setImage(UIImage(named: "Unlike"), for: .normal)
        lblLikeCount.text = "\(likeCount)"
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showEmojis(_:)))
        longPressGesture.minimumPressDuration = 1.0 // Set duration to 3 seconds
        likebtn.addGestureRecognizer(longPressGesture)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0 // Space between items should be 0
        
        collectionViewBanner.collectionViewLayout = layout
        collectionViewBanner.isPagingEnabled = false // We'll handle custom snapping
        collectionViewBanner.decelerationRate = .fast // Fast scrolling stop
        collectionViewBanner.showsHorizontalScrollIndicator = false
        
       
        
        
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
        // Reset the collection view's data to avoid displaying incorrect images
        collectionViewBanner.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionViewBanner)
        if let indexPath = collectionViewBanner.indexPathForItem(at: location) {
            let selectedData = imgDataAll[indexPath.row]
            print("Selected data: \(selectedData)") // Debugging print
            delegate?.didSelectItem(with: selectedData, username: UserName, allImages: imgDataAll)
        }
    }
    
    
    // Function to configure description text
    func configureDescription(with text: String) {
        // If the text is expanded, show all the text (0 means no limit)
        lblDescription.numberOfLines = isExpanded ? 0 : 2  // If expanded, show all lines, otherwise show 2 lines
        
        var displayText = text
        
        if !isExpanded {
            // If not expanded, truncate the text and add '... More' at the end
            let maxLength = 80  // You can adjust this as per your requirement
            if text.count > maxLength {
                let truncatedText = "\(text.prefix(maxLength))... "
                displayText = truncatedText
            } else {
                displayText = text  // If the text is short, just display it
            }
        } else {
            // If expanded, show full text and add 'Less' at the end
            displayText = "\(text) "
        }
        
        lblDescription.text = displayText
        lblDescription.setNeedsLayout()  // Mark for layout update
        lblDescription.layoutIfNeeded() // Force immediate layout update
    }
    
    // Add tap gesture to handle clicks on label for expanding/collapsing
    func addTapGestureToLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblDescription.isUserInteractionEnabled = true
        lblDescription.addGestureRecognizer(tapGesture)
    }
    
    // Action when label is tapped (toggle between expanded/collapsed state)
    @objc func labelTapped() {
        isExpanded.toggle()  // Toggle between expanded and collapsed state
        configureDescription(with: lblDescription.text ?? "")  // Update the description based on new state
    }
    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    
    
    @IBAction func btnDotPost(_ sender: UIButton) {
        DotCallback?(postid)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Data in imgDataAll: \(imgDataAll)") // Prints the entire data
        print("Total items in section: \(imgDataAll.count)") // Prints the count of items
        
        return imgDataAll.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let postImage = imgDataAll[indexPath.row]  // Current item
        cell.configure(with: postImage)
        cell.numberLabel.text = "\(indexPath.item + 1)"
        cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        let totalNumberOfImages = imgDataAll.count
        cell.totalImagesLabel.text =  "/ \(totalNumberOfImages)"
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
        let selectedData = imgDataAll[indexPath.row]
        delegate?.didSelectItem(with: selectedData, username: UserName, allImages: imgDataAll)
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
        // Check if no emoji is selected
        if selectedEmoji == nil {
            if isLikedByUser {
                // If already liked, unlike and decrement the count
                isLikedByUser = false
                likeCount -= 1
            } else {
                // If not liked, like and increment the count
                isLikedByUser = true
                likeCount += 1
            }
            
            // Update UI
            lblLikeCount.text = "\(likeCount)"
            likebtn.setImage(UIImage(named: isLikedByUser ? "Unlike" : "Like"), for: .normal)
        } else {
            // If emoji is already selected, update like with emoji
            updateLikeWithEmoji()
        }
    }
    
    func showEmojiSelectionView(button: UIButton) {
        // Remove previous emoji view if it exists
        if let existingEmojiView = UIApplication.shared.windows.first?.viewWithTag(9999) {
            existingEmojiView.removeFromSuperview()
        }
        
        // Calculate button frame relative to the main window
        guard let rootView = UIApplication.shared.windows.first?.rootViewController?.view else { return }
        let buttonFrame = button.convert(button.bounds, to: rootView)
        
        // Create custom view for emoji selection
        let emojiSelectionView = UIView(frame: CGRect(x: buttonFrame.midX - 2, y: buttonFrame.minY - 70, width: 300, height: 70))
        emojiSelectionView.backgroundColor = .white
        emojiSelectionView.layer.cornerRadius = 10
        emojiSelectionView.layer.shadowColor = UIColor.black.cgColor
        emojiSelectionView.layer.shadowOpacity = 0.5
        emojiSelectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        emojiSelectionView.layer.shadowRadius = 4
        emojiSelectionView.tag = 9999 // Unique tag for easy identification and removal
        
        // Emojis list
        let emojis = ["👍", "❤️", "😂", "😮", "😎", "🥳", "♡"]
        
        // Create a horizontal scroll view to hold emoji buttons
        let scrollView = UIScrollView(frame: emojiSelectionView.bounds)
        scrollView.contentSize = CGSize(width: emojis.count * 50, height: 80)
        scrollView.showsHorizontalScrollIndicator = false
        
        for (index, emoji) in emojis.enumerated() {
            let button = UIButton(frame: CGRect(x: CGFloat(index) * 50, y: 0, width: 50, height: 70))
            button.setTitle(emoji, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40) // Increased font size for bigger emoji
            button.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
        }
        
        emojiSelectionView.addSubview(scrollView)
        rootView.addSubview(emojiSelectionView)
        
        // Add a 3-second timer to remove the emoji selection view
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            emojiSelectionView.removeFromSuperview()
        }
    }
    
    
    // Handle emoji selection
    @objc func emojiSelected(_ sender: UIButton) {
        guard let emoji = sender.titleLabel?.text else { return }
        selectedEmoji = emoji
        isLikedByUser = true // Mark as liked since emoji is selected
        updateLikeWithEmoji()
        
        // Remove the emoji selection view
        sender.superview?.superview?.removeFromSuperview()
    }
    
    // Update like button with selected emoji
    func updateLikeWithEmoji() {
        guard let emoji = selectedEmoji else { return }
        
        // If user hasn't liked yet, increment the count
        if !isLikedByUser {
            likeCount += 1
            isLikedByUser = true
        }
        
        // Update the UI
        lblLikeCount.text = "\(likeCount)"
        likebtn.setTitle(emoji, for: .normal)
        likebtn.setImage(nil, for: .normal)
    }
    
    // Long press gesture to show emoji selection
    @objc func showEmojis(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Ensure the gesture's view is a UIButton
            if let button = gesture.view as? UIButton {
                showEmojiSelectionView(button: button)
            }
        }
    }
    
    
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        delegateCell?.didTapCommentsButton(cell: self)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        shareCount += 1
        lblShareCount.text = "\(shareCount)"
        let textToShare = "Check out this post!"
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        
        favouriteButtonCallback?()
    }
    
    func updateFavouriteButton(isFavourite: Bool) {
        let imageName = isFavourite ? "favorites" : "Un favorites" // Set your image names
        btnFavourite.setImage(UIImage(named: imageName), for: .normal)
    }
    
    
    
    
    
    
    
    
}



