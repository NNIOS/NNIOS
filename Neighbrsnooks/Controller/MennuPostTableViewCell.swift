//
//  MennuPostTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/07/24.
//

import UIKit



protocol PostMenuTableViewCellDelegate: AnyObject {
    func didSelectItem(with media: PostMedia, username: String, allMedia: [PostMedia])
}


protocol MennuPostTableViewCellDelegate: AnyObject {
    func didTapCommentsButton(cell: MennuPostTableViewCell)
}


class MennuPostTableViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var collectionViewMenuHeight: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGeneral: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var viewToHide: UIView!
    // @IBOutlet weak var viewPopup: UIView!
    var isExpanded = false
    var fullDescriptionText: String = ""
    
    var profileData : ProfileModel?
    weak var delegateCell: MennuPostTableViewCellDelegate?
    weak var delegateM: MemberCellDelegate?
    var userId: String?
    var postid: String?
    var isLiked = false
    var likeCount = 0
    var selectedEmoji: String?
    var commentCount = 0
    var shareCount = 0
    var isFavourite = false
    var isLikedByUser = false  
    var emojiSelectionHandler: ((String) -> Void)?
    
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShareCount: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    @IBOutlet weak var btnDotsImg : UIButton!
    
    var DotCallback: ((String?) -> Void)?
    var CommentCallback : ((UIButton) -> Void)?
    var FullImgCallback : ((UIButton) -> Void)?
    var LikeListCallback : ((UIButton) -> Void)?
    var imgData = [PostMedia]()
    var imgEmojiData = [Emojilistdata]()
    var UserName = ""
    var newStoryBoard:  UIStoryboard!
    var newNavigationController:  UINavigationController!
    weak var delegate: PostMenuTableViewCellDelegate?
    var thisWidth:CGFloat = 0
    var PostListData : PostListModel?
    var favouriteButtonCallback: (() -> Void)?
    private var defaultTextColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultTextColor = lblName.textColor
        
        collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
        if let layout = collectionViewBanner.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        // Add tap gesture recognizer single tab
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap(_:)))
        collectionViewBanner.addGestureRecognizer(tapGesture)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(showEmojis(_:)))
        longPress.minimumPressDuration = 2.0 // 2 second press
        likebtn.addGestureRecognizer(longPress)
        addTapGestures()
        addTapGestureToLabel()
        
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
        if profileData?.verfiedMsg == "User Verification is completed!" {
            if let userId = userId {
                delegateM?.didTapProfile(for: userId)
            }
        } else {
            // Show alert for unverified user
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
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
    
    
    
     
    
    // single tab
    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionViewBanner)
        if let indexPath = collectionViewBanner.indexPathForItem(at: location) {
            pauseAllVideosInVisibleCells()
            let selectedData = imgData[indexPath.row]
            delegate?.didSelectItem(with: selectedData, username: UserName, allMedia: imgData) // <-- allMedia
        }
    }

    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    @IBAction func actionThreeDotCall(_ sender: Any) {
        DotCallback?(postid)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionViewBanner {
            pauseAllVideosInVisibleCells()
        }
    }
    
    func pauseAllVideosInVisibleCells() {
        let visibleCells = collectionViewBanner.visibleCells.compactMap { $0 as? MenuCollectionViewCell }
        
        // Visible cells mein sabhi videos pause karein
        visibleCells.forEach { cell in
            if let player = cell.player {
                player.pause()
                cell.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal) // Button ko update karein
            }
        }
    }
    
    @IBAction func categoryTapped(sender: UITapGestureRecognizer) {
        
        // self.sectorLbl.text = neighbrhoodData?.nearestNeighbrhood[viewTag!].name
        
        let tappedView = sender.view
        let viewTag = tappedView?.tag
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        let media = imgData[indexPath.row]
        cell.configure(with: media)
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.totalImagesLabel.text = "/\(imgData.count)"
        return cell
    }

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collectionViewBanner.width) / 1
        return CGSize(width: thisWidth, height: 500)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pauseAllVideosInVisibleCells()
        let selectedData = imgData[indexPath.row]
        delegate?.didSelectItem(with: selectedData, username: UserName, allMedia: imgData)
    }

    
    
    func setPostData(post: PostItem) {
        lblName.text = post.userFullName
        lblDescription.text = post.postDescription
        lblMonth.text = post.createdAt
        imgData = post.media                 // POST KA MEDIA ARRAY
        collectionViewBanner.reloadData()    // Bina fail reload!
        // Profile image logic yahi raho

        // Reset/placeholder for image
        profileImgView.image = nil
        if let profileURL = URL(string: post.userpic), !post.userpic.isEmpty {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profileURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImgView.image = image
                    }
                }
            }
        }
    }

    
    //    new code emoji code
    @objc func showEmojis(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            if let button = gesture.view as? UIButton {
                showEmojiSelectionView(button: button)
            }
        }
    }
    
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
    }
    
    
    
    // Show emoji selection view
    func showEmojiSelectionView(button: UIButton) {
        // Remove previous emoji view if it exists
        if let existingEmojiView = UIApplication.shared.windows.first?.viewWithTag(9999) {
            existingEmojiView.removeFromSuperview()
        }
        
        // Calculate button frame relative to the main window
        guard let rootView = UIApplication.shared.windows.first?.rootViewController?.view else { return }
        let buttonFrame = button.convert(button.bounds, to: rootView)
        
        // Create custom view for emoji selection
        let emojiSelectionView = UIView(frame: CGRect(x: buttonFrame.midX - 2, y: buttonFrame.minY - 70, width: 300, height: 60))
        emojiSelectionView.backgroundColor = .white
        emojiSelectionView.layer.cornerRadius = 10
        emojiSelectionView.layer.shadowColor = UIColor.black.cgColor
        emojiSelectionView.layer.shadowOpacity = 0.5
        emojiSelectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        emojiSelectionView.layer.shadowRadius = 4
        emojiSelectionView.tag = 9999 // Unique tag for easy identification and removal
        
        // Emojis list
        let emojis = ["👍", "❤️", "😂", "😮", "😎", "🥳"]
        
        // Create a horizontal scroll view to hold emoji buttons
        let scrollView = UIScrollView(frame: emojiSelectionView.bounds)
        scrollView.contentSize = CGSize(width: emojis.count * 50, height: 60)
        scrollView.showsHorizontalScrollIndicator = false
        
        for (index, emoji) in emojis.enumerated() {
            let button = UIButton(frame: CGRect(x: CGFloat(index) * 50, y: 0, width: 50, height: 60))
            button.setTitle(emoji, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
        }
        
        emojiSelectionView.addSubview(scrollView)
        rootView.addSubview(emojiSelectionView)
        
        // Add a 3-second timer to remove the emoji selection view
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
        lblLikeCount.text = likeCount > 0 ? "\(likeCount)" : ""
        
        //               lblLikeCount.text = "\(likeCount)"
        likebtn.setTitle(emoji, for: .normal)
        likebtn.setImage(nil, for: .normal)
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

