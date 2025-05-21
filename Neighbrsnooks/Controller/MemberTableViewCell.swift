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
    
   
    var business_id : String?
    var BussinessFavouriteData : FavouriteBussinessModel?
    var BussinessRemoveFavouriteData : RemoveFavouriteBussiness?
    var isLikedByUser = false // Track if user has already liked
    //    new outlet
    weak var delegateCell: MemberTableViewCellDelegate?
    weak var delegateThreDot: ThreeDotMemberTableViewCellDelegate?
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
    private var defaultTextColor: UIColor?
    var FullImgCallback : ((UIButton) -> Void)?
    var DotCallback: ((String?) -> Void)?
    var thisWidth:CGFloat = 0
    var favouriteButtonCallback: (() -> Void)?
    var likeUnLikeTab: (() -> Void)?
    var postid: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultTextColor = lblName.textColor
        updateColors()
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
        likebtn.setImage(UIImage(named: "Unlike"), for: .normal)
        lblLikeCount.text = "\(likeCount)"
        
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
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            lblName.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblSec.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblMonth.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) ////
            lblGeneral.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblDescription.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) ///
            viewToHide.backgroundColor = .black
            btnComments.tintColor = .white // Arrow tint for dark mode
            btnShare.tintColor = .white
            
            likebtn.tintColor = .white
            btnDotsImg.tintColor = .white
            
        } else {
            // Light mode
            lblName.textColor = defaultTextColor
            lblSec.textColor = UIColor.secondaryLabel
            lblMonth.textColor = UIColor.secondaryLabel
            lblGeneral.textColor = UIColor.secondaryLabel
            lblDescription.textColor = UIColor.secondaryLabel
            likebtn.tintColor = .black // Arrow tint for light mode
            btnComments.tintColor = .black
            btnShare.tintColor = .black
            btnDotsImg.tintColor = .black
            viewToHide.backgroundColor = .white
        }
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Data in imgDataAll: \(imgDataAll)") // Prints the entire data
        print("Total items in section: \(imgDataAll.count)") // Prints the count of items
         return imgDataAll.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        let postImage = imgDataAll[indexPath.row]  // Current item
        
        let totalCount = imgDataAll.count
        cell.configure(with: postImage, totalCount: totalCount)
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
        
        if profileData?.verfiedMsg == "User Verification is completed!" {
                    likeUnLikeTab?()
                    
                    if selectedEmoji == nil {
                        isLikedByUser.toggle()
                        likeCount += isLikedByUser ? 1 : -1
                        lblLikeCount.text = "\(likeCount)"
                        likebtn.setImage(UIImage(named: isLikedByUser ? "Unlike" : "Like"), for: .normal)
                    } else {
                        updateLikeWithEmoji()
                    }
                } else {
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
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    // Use parentViewController to present the alert
                    if let parentVC = sender.parentViewController {
                        parentVC.present(alert, animated: true, completion: nil)
                    } else {
                        print("❌ Could not find parent view controller.")
                    }
                }
           }

           func updateLikeWithEmoji() {
               guard let emoji = selectedEmoji else { return }
               if !isLikedByUser {
                   likeCount += 1
                   isLikedByUser = true
               }
               lblLikeCount.text = "\(likeCount)"
               likebtn.setTitle(emoji, for: .normal)
               likebtn.setImage(nil, for: .normal)
           }

           @objc func emojiSelected(_ sender: UIButton) {
               guard let emoji = sender.titleLabel?.text else { return }
               selectedEmoji = emoji
               isLikedByUser = true
               updateLikeWithEmoji()
               sender.superview?.superview?.removeFromSuperview()
           }

           func showEmojiSelectionView(button: UIButton) {
               if let existingEmojiView = UIApplication.shared.windows.first?.viewWithTag(9999) {
                   existingEmojiView.removeFromSuperview()
               }

               guard let rootView = UIApplication.shared.windows.first?.rootViewController?.view else { return }
               let buttonFrame = button.convert(button.bounds, to: rootView)

               let emojiSelectionView = UIView(frame: CGRect(x: buttonFrame.midX - 2, y: buttonFrame.minY - 70, width: 300, height: 70))
               emojiSelectionView.backgroundColor = .white
               emojiSelectionView.layer.cornerRadius = 10
               emojiSelectionView.layer.shadowColor = UIColor.black.cgColor
               emojiSelectionView.layer.shadowOpacity = 0.5
               emojiSelectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
               emojiSelectionView.layer.shadowRadius = 4
               emojiSelectionView.tag = 9999

               let emojis = ["👍", "❤️", "😂", "😮", "😎", "🥳", "♡"]
               let scrollView = UIScrollView(frame: emojiSelectionView.bounds)
               scrollView.contentSize = CGSize(width: emojis.count * 50, height: 80)
               scrollView.showsHorizontalScrollIndicator = false

               for (index, emoji) in emojis.enumerated() {
                   let button = UIButton(frame: CGRect(x: CGFloat(index) * 50, y: 0, width: 50, height: 70))
                   button.setTitle(emoji, for: .normal)
                   button.setTitleColor(.black, for: .normal)
                   button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                   button.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchUpInside)
                   scrollView.addSubview(button)
               }

               emojiSelectionView.addSubview(scrollView)
               rootView.addSubview(emojiSelectionView)

               DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                   emojiSelectionView.removeFromSuperview()
               }
           }

           @objc func showEmojis(_ gesture: UILongPressGestureRecognizer) {
               if gesture.state == .began {
                   if let button = gesture.view as? UIButton {
                       showEmojiSelectionView(button: button)
                   }
               }
           }
    
    
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        delegateCell?.didTapCommentsButton(cell: self)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        if profileData?.verfiedMsg == "User Verification is completed!" {
                    shareCount += 1
                    lblShareCount.text = "\(shareCount)"
                    let textToShare = "Check out this post!"
                    let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                } else {
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
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    // Use parentViewController to present the alert
                    if let parentVC = sender.parentViewController {
                        parentVC.present(alert, animated: true, completion: nil)
                    } else {
                        print("❌ Could not find parent view controller.")
                    }
                }
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        
        favouriteButtonCallback?()
    }
    
    // Update UI based on fav/unfav status
       func updateFavouriteButton(isFavourite: Bool) {
           let imageName = isFavourite ? "favorites" : "Un favorites" // ✅ Image names from Assets
           let image = UIImage(named: imageName)
           btnFavourite.setImage(image, for: .normal)
       }
   
    
}



