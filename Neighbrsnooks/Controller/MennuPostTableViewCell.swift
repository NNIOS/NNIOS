//
//  MennuPostTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/07/24.
//

import UIKit

 

protocol PostMenuTableViewCellDelegate: AnyObject {
    func didSelectItem(with postImage: PostImage,  username: String, allImages: [PostImage])
}


protocol MennuPostTableViewCellDelegate: AnyObject {
    func didTapCommentsButton(cell: MennuPostTableViewCell)
}


class MennuPostTableViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionViewBanner: UICollectionView!
    
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
    var isLikedByUser = false // Track if user has already liked
    var emojiSelectionHandler: ((String) -> Void)?
    
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShareCount: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
   // @IBOutlet weak var UnlikeImageView : UIButton!
   // @IBOutlet weak var btnCommentsImg : UIButton!
   // @IBOutlet weak var btnShareImg : UIButton!
    @IBOutlet weak var btnDotsImg : UIButton!
    
    var DotCallback: ((String?) -> Void)?
    var CommentCallback : ((UIButton) -> Void)?
    var FullImgCallback : ((UIButton) -> Void)?
    var LikeListCallback : ((UIButton) -> Void)?
    var imgData = [PostImage]()
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
        updateColors()
        collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
        
        
        
        if let layout = collectionViewBanner.collectionViewLayout as? UICollectionViewFlowLayout {
              layout.scrollDirection = .horizontal
          }

          // Add tap gesture recognizer single tab
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap(_:)))
          collectionViewBanner.addGestureRecognizer(tapGesture)
        
        
        
        
        
        //viewPopup.isHidden = true
      //  self.HeartImgView.image = UIImage(systemName: "heart")
        // Initialization code
        addTapGestures()
        addTapGestureToLabel()
        
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            lblName.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblSec.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblMonth.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblGeneral.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblDescription.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            viewToHide.backgroundColor =  .black
            likebtn.tintColor = .white // Arrow tint for dark mode
            btnShare.tintColor = .white
            btnComments.tintColor = .white
            btnDotsImg.tintColor = .white
            
        } else {
            // Light mode
            lblName.textColor = defaultTextColor
            lblSec.textColor = UIColor.secondaryLabel
            lblMonth.textColor = UIColor.secondaryLabel
            lblGeneral.textColor = UIColor.secondaryLabel
            lblDescription.textColor = UIColor.secondaryLabel
            likebtn.tintColor = .black // Arrow tint for light mode
            btnShare.tintColor = .black
            btnComments.tintColor = .black
            btnDotsImg.tintColor = .black
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

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
             
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
         }
    
//       required init?(coder: NSCoder) {
//           fatalError("init(coder:) has not been implemented")
//       }
    
    
    // single tab
    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionViewBanner)
        if let indexPath = collectionViewBanner.indexPathForItem(at: location) {
            pauseAllVideosInVisibleCells()
            let selectedData = imgData[indexPath.row]
            delegate?.didSelectItem(with: selectedData, username: UserName, allImages: imgData)
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
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgData.count ?? 0
       
        
    }
    
    @IBAction func categoryTapped(sender: UITapGestureRecognizer) {
        
       // self.sectorLbl.text = neighbrhoodData?.nearestNeighbrhood[viewTag!].name

        let tappedView = sender.view
        let viewTag = tappedView?.tag
        
        
  
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        let postImage = imgData[indexPath.row]  // Current item
        cell.configure(with: postImage)
        
//        let url = URL(string: (imgData[indexPath.row].img ?? ""))
//        cell.profileImgView.kf.indicatorType = .activity
//        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
        
        let totalNumberOfImages = imgData.count
        cell.totalImagesLabel.text =  "/ \(totalNumberOfImages)"
        cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
  
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  thisWidth = CGFloat(self.collectionViewBanner.width) / 1
                  return CGSize(width: thisWidth, height: 500)
              }
     
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pauseAllVideosInVisibleCells()
        let selectedData = imgData[indexPath.row]
        delegate?.didSelectItem(with: selectedData, username: UserName , allImages: imgData)
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
               let emojis = ["👍", "❤️", "😂", "😮", "😎", "🥳", "♡"]
               
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

