//
//  PostTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 22/04/24.
//

import UIKit
import AVFoundation
import AVKit
import AVFoundation

//protocol CustomTableViewCellDelegate: AnyObject {
//    func collectionViewCellTapped(with data: PostListModel)
//}

protocol PostTableViewCellDelegate: AnyObject {
    func didSelectItem(with postImage: PostImage, username: String, allImages: [PostImage])
}

protocol PostvTableViewCellDelegate: AnyObject {
    func didTapCommentsButton(cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGeneral: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var viewToHide: UIView!
    @IBOutlet weak var viewDesc: UIView!
    @IBOutlet weak var UnlikeImageView : UIButton!
    @IBOutlet weak var btnCommentsImg : UIButton!
    @IBOutlet weak var btnShareImg : UIButton!
    @IBOutlet weak var btnDotsImg : UIButton!
    // @IBOutlet weak var viewPopup: UIView!
//    @IBOutlet weak var btnLikes: UIButton!
    var LikesCallback : ((UIButton) -> Void)?
    var CommentCallback : ((UIButton) -> Void)?
    var FullImgCallback : ((UIButton) -> Void)?
    var LikeListCallback : ((UIButton) -> Void)?
    var UmlikeCallback : ((UIButton) -> Void)?
    var DotCallback: ((String?) -> Void)?
    var postid: String?
    var imgData = [PostImage]()
    var imgEmojiData = [Emojilistdata]()
    var UserName = ""
    
    @IBOutlet weak var btnUnlikepost: UIButton!
    var UnlikeCallback : ((UIButton) -> Void)?
    @IBOutlet weak var shareButton: UIButton!
    weak var delegate: PostTableViewCellDelegate?
    weak var delegateCell: PostvTableViewCellDelegate?
    weak var delegateM: MemberCellDelegate?
    var userId: String?
    var isLikedByUser = false // Track if user has already liked
    var isLiked = false
    var likeCount = 0
    var selectedEmoji: String?
    var commentCount = 0
    var shareCount = 0
    var isFavourite = false
    var favouriteButtonCallback: (() -> Void)?
    var emojiSelectionHandler: ((String) -> Void)?
    private var defaultTextColor: UIColor?
    
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShareCount: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
  
    let reactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🤍", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emojiContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        view.isHidden = true
        return view
    }()
    let emojis: [String] = ["👍", "❤️", "😂", "😮", "😎", "🥳","♡"]
    
    
    var shareAction: (() -> Void)?
    var emojiAction: ((_ emoji : String?) ->())?
    var unselectedemojiAction: ((_ emoji : String?) ->())?
    
//    @IBAction func shareButtonTapped(_ sender: UIButton) {
//        shareAction?()
//    }
    
    var thisWidth:CGFloat = 0
    var PostListData : PostListModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionViewBanner.delegate = self
        self.collectionViewBanner.dataSource = self
        self.collectionViewBanner.allowsSelection = true
        setupEmojis()
//        self.HeartImgView.image = UIImage(systemName: "heart")
        addTapGestures()
        
        // Add tap gesture recognizer single tab
        let tapGestureS = UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap(_:)))
        collectionViewBanner.addGestureRecognizer(tapGestureS)
        defaultTextColor = lblName.textColor
        updateColors()
        
        
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            lblName.textColor = .white
            lblSec.textColor = .white
            lblMonth.textColor = .white
            lblGeneral.textColor = .white
            lblDescription.textColor = .white
            viewToHide.backgroundColor = .black
            UnlikeImageView.tintColor = .white // Arrow tint for dark mode
            btnCommentsImg.tintColor = .white
            btnShareImg.tintColor = .white
            UnlikeImageView.tintColor = .white
            btnDotsImg.tintColor = .white
            
        } else {
            // Light mode
            lblName.textColor = defaultTextColor
            lblSec.textColor = UIColor.secondaryLabel
            lblMonth.textColor = UIColor.secondaryLabel
            lblGeneral.textColor = UIColor.secondaryLabel
            lblDescription.textColor = UIColor.secondaryLabel
            UnlikeImageView.tintColor = .black // Arrow tint for light mode
            btnCommentsImg.tintColor = .black
            btnShareImg.tintColor = .black
            btnDotsImg.tintColor = .black
            viewToHide.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        }
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
   
    
    private func addTapGestures() {
          let nameTap = UITapGestureRecognizer(target: self, action: #selector(handleTapPost))
          lblName.isUserInteractionEnabled = true
          lblName.addGestureRecognizer(nameTap)

          let secTap = UITapGestureRecognizer(target: self, action: #selector(handleTapPost))
          lblSec.isUserInteractionEnabled = true
          lblSec.addGestureRecognizer(secTap)

          let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleTapPost))
          profileImgView.isUserInteractionEnabled = true
          profileImgView.addGestureRecognizer(profileTap)
      }

      @objc private func handleTapPost() {
          if let userId = userId {
              delegateM?.didTapProfile(for: userId)
          }
      }
    
    @IBAction func btnUnlikePost(_ sender: UIButton) {
        UnlikeCallback?(sender)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        collectionViewBanner.reloadData()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    @IBAction func actionThreeDotCall(_ sender: Any) {
        DotCallback?(postid)
        
    }
    
    
     
    
    
    @IBAction func btnLikes(_ sender: UIButton) {
        LikesCallback?(sender)
    }
    @IBAction func btnComment(_ sender: UIButton) {
        CommentCallback?(sender)
    }
    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    
    @IBAction func btnLikeList(_ sender: UIButton) {
        LikeListCallback?(sender)
    }
    
    @IBAction func btnUnLikePost(_ sender: UIButton) {
        UmlikeCallback?(sender)
    }
    
    @IBAction func btnClose(_ : UIButton){
        
        //   viewPopup.isHidden = true
        
    }
    
    
    
    private func setupView() {
        contentView.addSubview(reactionButton)
        contentView.addSubview(emojiContainerView)
        
        
        
        NSLayoutConstraint.activate([
            reactionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,constant: 155),
            // reactionButton.centerYAnchor.constraint(equalTo: btnComment.centerYAnchor, constant: 40),
            
            
            reactionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reactionButton.heightAnchor.constraint(equalToConstant: 60),
            reactionButton.widthAnchor.constraint(equalToConstant: 60),
            
            emojiContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,constant: 90),
            emojiContainerView.bottomAnchor.constraint(equalTo: reactionButton.topAnchor, constant: 50),
            emojiContainerView.heightAnchor.constraint(equalToConstant: 50),
            emojiContainerView.widthAnchor.constraint(equalToConstant: CGFloat(emojis.count * 50)),
            
            
        ])
        
        setupEmojis()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showEmojiContainer))
        reactionButton.addGestureRecognizer(longPressGesture)
    }
    
    
    
    
    
    
    private func setupEmojis() {
        for (index, emoji) in emojis.enumerated() {
            let button = UIButton(type: .system)
            let fontSize: CGFloat = 30
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            button.tag = index
            button.frame = CGRect(x: index * 50, y: 5, width: 40, height: 40)
            button.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
            
            
            emojiContainerView.addSubview(button)
        }
    }
    
    @objc private func showEmojiContainer() {
        emojiContainerView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) { [weak self] in
            self?.emojiContainerView.isHidden = true
        }
    }
    
    @objc func handleTap() {
        emojiContainerView.isHidden = true
    }
    
    @objc private func emojiTapped(sender: UIButton) {
        let selectedEmoji = emojis[sender.tag]
        reactionButton.setTitle(selectedEmoji, for: .normal)
        emojiAction?(selectedEmoji)
        emojiContainerView.isHidden = true
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionViewBanner {
            pauseAllVideosInVisibleCells()
        }
    }

    func pauseAllVideosInVisibleCells() {
        let visibleCells = collectionViewBanner.visibleCells.compactMap { $0 as? NewPostCollectionViewCell }

        // Visible cells mein sabhi videos pause karein
        visibleCells.forEach { cell in
            if let player = cell.player {
                player.pause()
                cell.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal) // Button ko update karein
            }
        }
    }
    

    
    
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
    
    
    
    // single tab
    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionViewBanner)
        if let indexPath = collectionViewBanner.indexPathForItem(at: location) {
            pauseAllVideosInVisibleCells()
            let selectedData = imgData[indexPath.row]
            delegate?.didSelectItem(with: selectedData, username: UserName, allImages: imgData)
        }
    }
    
    
    
}

extension PostTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgData.count ?? 0
    }
    
    //     videos show and image
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewPostCollectionViewCell", for: indexPath) as! NewPostCollectionViewCell
        let postImage = imgData[indexPath.row]  // Current item
        cell.configure(with: postImage)  // Image ya video ko cell mein configure karna
        cell.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
        cell.numberLabel.text = "\(indexPath.item + 1)"
        let totalNumberOfImages = imgData.count
        cell.totalImagesLabel.text = "/ \(totalNumberOfImages)"
        // Setting fonts for labels
        cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        return cell
    }
    
    
    // UICollectionViewDelegate Method - DidSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pauseAllVideosInVisibleCells()
           let selectedData = imgData[indexPath.row]
           // Assuming UserName is defined in your PostTableViewCell
        delegate?.didSelectItem(with: selectedData, username: UserName, allImages: imgData)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collectionViewBanner.width) / 1
        return CGSize(width: thisWidth, height: 500
        )
    }
    
    
}



