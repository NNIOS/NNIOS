//
//  PostDetailsNewViewController.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 11/05/25.
//

import UIKit
import SVProgressHUD
import AVKit
@available(iOS 16.0, *)

class PostDetailsNewViewController:BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate {
    
    @IBOutlet weak var tableviewHeightMess: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var collectionViewBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewMessageHeight: NSLayoutConstraint!
    @IBOutlet weak var tvmessageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableviewPost: UITableView!
    @IBOutlet weak var MembersLbl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblGeneral: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblmonth: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var UserPicImgView : UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tvmessage: UITextView!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnCommentReply: UIButton!
    @IBOutlet weak var btnClickComment: UIButton!
    @IBOutlet weak var lblCmndLikePopup: UILabel!
    @IBOutlet weak var lblCmndReplyPopup: UILabel!
    @IBOutlet weak var lblCmndDeletePopup: UILabel!
    @IBOutlet weak var  imgcmndLike : UIImageView!
    @IBOutlet weak var  imgcmndReply : UIImageView!
    @IBOutlet weak var  imgcmndDelete : UIImageView!
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView! // Bottom popup view
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var createdBy: String?
    var selectedCommentIndexPath: IndexPath?
    var fullText: String = "" // Full text from backend
    var customView: UIView?
    var truncatedText: String = ""
    var isExpanded = false
    var isReplyVisible: [Int: Bool] = [:] // Dictionary to track reply visibility per section
    var PostDetailData : PostDetailModel?
    var selectedEmoji: String?
    var isLikedByUser = false // Track if user has already liked
    var likeCount = 0
    var emojiSelectionHandler: ((String) -> Void)?
    var imgData: [PostImage] = [] // Images list
    var videoData: [PostImage] = [] // Videos list
    //    var mediaData: [PostImageD] = []
    var thisWidth:CGFloat = 0
    var CommentPostListData : CommentPostModel? // data fatch
    var PostCommentData : PostCommentModel?
    var deletePostCmnd : DeletePostCommentModel?
    var likeComModel : LikeResponseModel?
    var UserName = ""
    var sectorName = ""
    var MonthName = ""
    var GeneralName = ""
    var DescriptionlName = ""
    var CommentName = ""
    var likeName = ""
    var postid = ""
    var emoji = ""
    var timer: Timer?
    var counter = 0
    var parentID = "" // Replace with actual parent ID if replying
    var topLevelUsername = "" // Replace with actual top-level username
    var topLevelUserID = ""
    var postId: String = ""
    var favouritstatus: Int = 0
    //var imgData = [PostImage]()
    var imgDataF = [PostImageF]()
    var PostidDe = [Postlistdatum]()
    var PostListData : PostListModel?
    var isReplyCellSelected = false
    var selectedPCID: String?
    var selectedPostID: String?
    var selectedUserID: String?
    var selectRreateOn : String?
    let loader = UIActivityIndicatorView(style: .large)
    var mediaData: [PostImageD] = [] {
        didSet {
            updateCollectionViewHeight()
            collectionViewBanner.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("postId: \(postid) irshad")
        setupLoader()
        loader.startAnimating()
        self.callPostLikelistWebService(postid: postid) {
        }
        
        tvmessage.delegate = self
        tvmessage.isScrollEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        setupContainerView()
        containerView.frame = self.view .frame
        self.view.addSubview(self.containerView)
        containerView.isHidden = true
        // Long Press Gesture add karein
        let longPressGestureV = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGestureV.minimumPressDuration = 1.0  // 1 second ka long press
        tableviewPost.addGestureRecognizer(longPressGestureV)
        let tapGestureV = UITapGestureRecognizer(target: self, action: #selector(hideBottomSheet))
        self.view.addGestureRecognizer(tapGestureV)
        // Get the saved user ID
        
        if let userId = UserDefaults.standard.string(forKey: "userid") {
            print("Current user ID: \(userId)")
            self.createdBy = userId // Assign to your property
        } else {
            print("No user ID found in UserDefaults")
        }
        
        callpostDetailWebService(postid: postid) {
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                self.collectionViewBanner.reloadData()
            }
        }
        setupLabel()
        tableviewPost.rowHeight = UITableView.automaticDimension
        //        tableviewPost.estimatedRowHeight = 80 // Approximate height
        fullText = self.PostDetailData?.listdata?.first?.postMessage ?? ""
        // Ensure selection is enabled
        collectionViewBanner.isUserInteractionEnabled = true
        collectionViewBanner.allowsSelection = true
        (collectionViewBanner as? UIScrollView)?.delaysContentTouches = false
        // ✅ Gesture Recognizer Add Karo (But `cancelsTouchesInView = true`)
        let tapGestureC = UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap(_:)))
        tapGestureC.cancelsTouchesInView = true  // Ye ensure karega ki `didSelectItemAt` extra call na ho
        collectionViewBanner.addGestureRecognizer(tapGestureC)
        collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
        collectionViewBanner.reloadData()
        self.lblSector.font = UIFont(name: "Montserrat-Regular", size: 11)
        self.lblmonth.font = UIFont(name: "Montserrat-Regular", size: 11)
        self.lblDescription.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblGeneral.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.tvmessage.font = UIFont(name: "Montserrat-Regular", size: 16)
        placeholderLabel.text = "Type a message..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTableView), userInfo: nil, repeats: true)
        btnComment.isHidden = false
        btnCommentReply.isHidden = true
        //        btnLike.setImage(UIImage(named: "Unlike"), for: .normal)
        btnLike.setImage(UIImage(systemName: "hand.thumbsup.circle"), for: .normal)
        btnLike.tintColor =  #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblLike.text = "\(likeCount)"
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showEmojis(_:)))
        longPressGesture.minimumPressDuration = 2.0 // Only trigger after 2 seconds
        btnLike.addGestureRecognizer(longPressGesture)
        // Initialize all sections as hidden by default
        if let postDataCount = CommentPostListData?.postlistdata.count {
            for section in 0..<postDataCount {
                isReplyVisible[section] = false // Default hidden
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.MembersLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        // ✅ Call your post detail API
        callpostDetailWebService(postid: self.postid) {
            self.collectionViewBanner.reloadData()
            // ✅ Safely unwrap the first item from listdata
            guard let data = self.PostDetailData?.listdata?.first else {
                print("🚫 No post data available.")
                return
            }
            
            // ✅ Set your labels
            self.lblName.text = data.username
            self.lblSector.text = data.neighborhood
            self.lblGeneral.text = data.postType
            self.lblDescription.text = data.postMessage
            self.lblmonth.text = data.createdOn
            self.lblComment.text = "\(data.totcomment ?? 0)"
            
            // ✅ Load user profile image
            if let imageUrlString = data.userpic,
               let imageUrl = URL(string: imageUrlString) {
                print("📸 Image URL: \(imageUrl)")
                self.UserPicImgView.kf.indicatorType = .activity
                self.UserPicImgView.kf.setImage(
                    with: imageUrl,
                    placeholder: UIImage(named: "My-profile"),
                    options: [.transition(.fade(0.3))],
                    completionHandler: { result in
                        switch result {
                        case .success(let value):
                            print("✅ Image loaded: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("❌ Image load error: \(error.localizedDescription)")
                        }
                    }
                )
            } else {
                print("🚫 No image URL found.")
            }
        }
        
        SVProgressHUD.show()
        DispatchQueue.main.async {
            self.callPostCommenteWebService {
                SVProgressHUD.dismiss()
                self.tableviewPost.reloadData()
            }
        }
    }
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        self.bottomConstraint.constant = -keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCollectionViewHeight()
    }
    
    func setupLoader() {
        loader.center = view.center
        loader.color = .gray
        loader.hidesWhenStopped = true
        view.addSubview(loader)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
    
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let touchPoint = gesture.location(in: tableviewPost)
            if let indexPath = tableviewPost.indexPathForRow(at: touchPoint) {
                // Get the selected comment data
                if let commentData = CommentPostListData?.postlistdata[indexPath.section] {
                    var selectedComment = commentData
                    // Handle reply if needed
                    if indexPath.row > 0, let reply = commentData.replies?[indexPath.row - 1] {
                        selectedComment = reply
                    }
                    // Get IDs
                    guard let currentUserId = UserDefaults.standard.string(forKey: "userid") else {
                        print("No user ID found in UserDefaults")
                        return
                    }
                    let commentUserId = selectedComment.userid
                    // Only proceed if same user
                    if currentUserId == commentUserId {
                        self.selectedPCID = selectedComment.pcID
                        self.selectedPostID = selectedComment.postid
                        self.selectedUserID = selectedComment.userid
                        self.selectRreateOn = selectedComment.createon
                        print("Showing options for comment:")
                        print("pc_id: \(selectedComment.pcID)")
                        print("postid: \(selectedComment.postid)")
                        print("userid: \(selectedComment.userid)")
                        showBottomSheet()
                    } else {
                        print("Silently ignoring - user not authorized")
                    }
                }
            }
        }
    }
    
    
    
    
    func setupContainerView() {
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        // 🎯 `containerView` ko bottom pe rakho
        containerView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 200)
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 20  // 🎯 Smooth rounded corners for better UI
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: -5)
        containerView.layer.shadowRadius = 10
        
        self.view.addSubview(containerView)
        containerView.isHidden = true
    }
    
    func showBottomSheet() {
        let screenHeight = self.view.frame.height
        func showBottomSheet() {
            guard let pcID = selectedPCID,
                  let postID = selectedPostID,
                  let createUserID = createdBy,
                  let userID = selectedUserID else {
                print("No comment selected")
                return
            }
            
            print("Showing options for:")
            print("Comment ID: \(pcID)")
            print("Post ID: \(postID)")
            print("User ID: \(userID)")
            
            // Your bottom sheet implementation...
        }
        containerView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.frame.origin.y = screenHeight - 200  // 🎯 Proper bottom position
        })
    }
    
    @objc func hideBottomSheet() {
        let screenHeight = self.view.frame.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.frame.origin.y = screenHeight  // 🎯 Hide animation (niche le jaayega)
        }) { _ in
            self.containerView.isHidden = true
        }
    }
    
  
    
    func setupLabel() {
        lblDescription.numberOfLines = 2  // Initially, show only 2 lines
        lblDescription.isUserInteractionEnabled = true  // Enable user interaction
        
        // If the text exceeds 2 lines, truncate it and add "More"
        if isTruncated() {
            truncatedText = getTruncatedText()  // Calculate truncated text
            lblDescription.text = truncatedText + " ... More"  // Add "More" at the end
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleText))
            lblDescription.addGestureRecognizer(tapGesture)
        } else {
            lblDescription.text = fullText  // If text fits within 2 lines, display it fully
        }
    }
    
    @objc func toggleText() {
        // Toggle the expanded/collapsed state
        isExpanded.toggle()
        
        if isExpanded {
            // If expanded, show full text and change "More" to "Less"
            lblDescription.numberOfLines = 0  // Show all lines
            lblDescription.text = fullText + " ... Less"  // Add "Less" at the end
        } else {
            // If collapsed, show only 2 lines and add "More"
            lblDescription.numberOfLines = 2  // Show only 2 lines
            lblDescription.text = truncatedText + " ... More"  // Add "More" at the end
        }
        
        // Animate the change smoothly
        UIView.animate(withDuration: 0.3) {
            self.lblDescription.layoutIfNeeded()  // Apply changes with animation
        }
    }
    
    func isTruncated() -> Bool {
        // Check if the text exceeds 2 lines by calculating the height
        let size = CGSize(width: lblDescription.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: lblDescription.font!]
        let boundingRect = (fullText as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let lineHeight = lblDescription.font.lineHeight
        let maxHeight = lineHeight * 2  // Maximum height allowed for 2 lines
        return boundingRect.height > maxHeight  // If text height exceeds 2 lines, return true
    }
    
    func getTruncatedText() -> String {
        // Calculate and return the truncated text that fits within 2 lines
        var truncated = ""
        let words = fullText.split(separator: " ")
        for word in words {
            let tempText = truncated.isEmpty ? String(word) : truncated + " " + word
            let size = CGSize(width: lblDescription.frame.width, height: CGFloat.greatestFiniteMagnitude)
            let attributes: [NSAttributedString.Key: Any] = [.font: lblDescription.font!]
            let boundingRect = (tempText as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            let lineHeight = lblDescription.font.lineHeight
            let maxHeight = lineHeight * 2  // Maximum height allowed for 2 lines
            if boundingRect.height > maxHeight {
                break
            }
            truncated = tempText
        }
        return truncated
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @IBAction func actionCommentDelete(_ sender: Any) {
        // 1. Get the stored IDs
        guard let postId = selectedPostID,
              let userId = selectedUserID,
              let commentId = selectedPCID else {
            print("Missing required IDs")
            return
        }
        // 2. Call delete API
        callDeletePostWebService(postId: postId, userId: userId, commentId: commentId) {
            // 3. Show success message and update UI
            DispatchQueue.main.async {
                // Hide container view
                self.containerView.isHidden = true
                // Refresh comments list
                self.callPostCommenteWebService {
                    // Any completion after refresh
                }
                // Reload post detail to update comment count label
                self.callpostDetailWebService(postid: self.postid) {
                    self.lblComment.text = "\(self.PostDetailData?.listdata?.first?.totcomment ?? 0)"
                }
            }
        }
    }
    
    
    @IBAction func actionLike(_ sender: UIButton) {
        if selectedEmoji == nil {
            isLikedByUser.toggle() // Flip like status
            likeCount += isLikedByUser ? 1 : -1
            likeCount = max(0, likeCount)
            lblLike.text = "\(likeCount)"
            // Button style
            btnLike.setTitle("", for: .normal)
            btnLike.setImage(UIImage(systemName: isLikedByUser ? "hand.thumbsup.circle.fill" : "hand.thumbsup.circle"), for: .normal)
            btnLike.tintColor = isLikedByUser ? #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) : #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
            
            // 🔁 Call Like/Unlike API
            if isLikedByUser {
                callPostLikeWebService(postId: postId, emoji: nil) {
                    print("✅ Liked without emoji")
                }
            } else {
                callPostUnLikeWebService(postId: postId) {
                    print("❌ Unliked")
                }
            }
        } else {
            updateLikeWithEmoji() // Emoji already selected
        }
    }
    
    
    
    // Show emoji selection view
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
        selectedEmoji = emoji
        updateLikeWithEmoji()
        // Remove emoji selection popup
        sender.superview?.superview?.removeFromSuperview()
    }
    
    // Update like button with selected emoji
    func updateLikeWithEmoji() {
        guard let emoji = selectedEmoji else { return }
        if !isLikedByUser {
            likeCount += 1
            isLikedByUser = true
        }
        
        lblLike.text = "\(likeCount)"
        btnLike.setTitle(emoji, for: .normal)
        btnLike.setImage(nil, for: .normal)
        btnLike.setNeedsLayout()
        btnLike.layoutIfNeeded()
        // 🔁 Call like API with emoji
        callPostLikeWebService(postId: postId, emoji: emoji) {
            print("✅ Emoji like API called with emoji: \(emoji)")
        }
    }
    
    // Long press gesture to show emoji selection
    @objc func showEmojis(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            if let button = gesture.view as? UIButton {
                showEmojiSelectionView(button: button)
            }
        }
    }
    
    
    @IBAction func actionShare(_ sender: Any) {
    }
    
    
    //MARK: - favtk post
    
    @IBAction func actionFavt(_ sender: Any) {
        if postid.isEmpty {
            self.showAlert(Message: "Post ID not found.")
            return
        }
        
        if favouritstatus == 1 {
            // Currently favourite → remove it
            self.callFavouriteRemoveBussinessWebService(postId: postid) { [weak self] newStatus, message in
                guard let self = self else { return }
                self.favouritstatus = newStatus
                self.updateFavIcon()
                //                self.showAlert(Message: message)
            }
        } else {
            // Currently not favourite → add it
            self.callFavouriteBussinessWebService(postId: postid) { [weak self] newStatus, message in
                guard let self = self else { return }
                self.favouritstatus = newStatus
                self.updateFavIcon()
                //                self.showAlert(Message: message)
            }
        }
    }
    
    // MARK: - Update Favourite Icon
    func updateFavIcon() {
        let imageName = favouritstatus == 1 ? "favorites" : "Un favorites" // Image names from Assets
        let image = UIImage(named: imageName)
        btnFav.setImage(image, for: .normal)
    }
    
    
    
    @IBAction func actionReplyPopup(_ sender: Any) {
        // Hide the popup first
        containerView.isHidden = true
        // Use the stored selected index path or fallback to default
        guard let indexPath = selectedCommentIndexPath ??
                tableviewPost.indexPathForSelectedRow ??
                tableviewPost.indexPathsForVisibleRows?.first else {
            return
        }
        
        // Clear the selection after use
        selectedCommentIndexPath = nil
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            // Get the post data
            guard let postData = self.CommentPostListData?.postlistdata[indexPath.section] else {
                return
            }
            
            // Determine if we're dealing with a main comment or reply
            var selectedComment = postData
            if indexPath.row > 0, let reply = postData.replies?[indexPath.row - 1] {
                selectedComment = reply
            }
            // Set up the reply UI
            self.btnComment.isHidden = true
            self.btnCommentReply.isHidden = false
            self.tvmessage.isHidden = false
            self.tvmessage.becomeFirstResponder()
            self.tvmessage.text = ""
            // Set the reply target information
            self.topLevelUsername = selectedComment.username
            self.topLevelUserID = selectedComment.userid
            self.parentID = selectedComment.pcID
            self.isReplyCellSelected = true
            
            // Highlight and scroll to the comment
            self.tableviewPost.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableviewPost.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    
    @IBAction func actionCommentClick(_ sender: Any) {
        btnComment.isHidden = false  // Show btnComment
        btnCommentReply.isHidden = true // Hide btnCommentReply
        // Show and focus the text view
        tvmessage.isHidden = false
        tvmessage.becomeFirstResponder() // Open the keyboard
        
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @objc func refreshTableView() {
        DispatchQueue.main.async {
            self.tableviewPost.reloadData()
            self.updateTableViewHeight()
        }
    }
    
    //    func textViewDidChange(_ textView: UITextView) {
    //        // Show or hide placeholder label based on text view content
    //        placeholderLabel.isHidden = !textView.text.isEmpty
    //    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        placeholderLabel.isHidden = !textView.text.isEmpty
        // ✅ Limit max height to 150
        let finalHeight = min(estimatedSize.height, 150)
        // ✅ Update constraints
        tvmessageHeightConstraint.constant = finalHeight
        viewMessageHeight.constant = finalHeight
        // ✅ Enable scrolling if content > 150
        textView.isScrollEnabled = estimatedSize.height >= 150
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func SendBtn(_ sender: UIButton){
        self.tvmessage.resignFirstResponder()
        if tvmessage.text == "" {
            let alert = UIAlertController(title: "", message: "Please Enter Your Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            callCommentePostWebService { [weak self] in
                guard let self = self else { return }
                self.tvmessage.text = ""
                
                self.callPostCommenteWebService {
                    self.refreshTableView()
                }
                
                self.callpostDetailWebService(postid: self.postid) {
                    self.lblComment.text = "\(self.PostDetailData?.listdata?.first?.totcomment ?? 0)"
                }
            }
        }
    }
    
    
    
    @IBAction func actionCommentReply(_ sender: UIButton) {
        self.tvmessage.resignFirstResponder()
        guard let text = tvmessage.text, !text.isEmpty else {
            let alert = UIAlertController(title: "", message: "Please Enter Your Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        callCommenteReplyPostWebService(parentID: self.parentID,
                                        topLevelUsername: self.topLevelUsername,
                                        topLevelUserID: self.topLevelUserID) { [weak self] in
            guard let self = self else { return }
            print("✅ Reply successfully added")
            
            // Reset UI
            self.tvmessage.text = ""
            self.btnComment.isHidden = false
            self.btnCommentReply.isHidden = true
            self.tvmessage.resignFirstResponder()
            
            // Refresh comments
            self.callPostCommenteWebService {
                DispatchQueue.main.async {
                    // 🔹 Scroll parent comment ke last reply tak
                    if let sectionIndex = self.CommentPostListData?.postlistdata.firstIndex(where: { $0.pcID == self.parentID }),
                       let replies = self.CommentPostListData?.postlistdata[sectionIndex].replies {
                        
                        let lastRow = replies.count - 1
                        let indexPath = IndexPath(row: lastRow, section: sectionIndex)
                        self.tableviewPost.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
            
            // Update comment count
            self.callpostDetailWebService(postid: self.postid) {
                self.lblComment.text = "\(self.PostDetailData?.listdata?.first?.totcomment ?? 0)"
            }
        }
    }

    
    
    func loadPostData() {
        if let listData = PostDetailData?.listdata?.first {
            mediaData = listData.postImages ?? [] // Fetch all images and videos
            print("MediaData count: \(mediaData.count)") // Debug log
        } else {
            print("ListData is nil")
        }
        collectionViewBanner.reloadData()
    }
    
    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionViewBanner)
        if let indexPath = collectionViewBanner.indexPathForItem(at: location) {
            // ✅ Yaha `didSelectItemAt` ko call NAHI karna hai, bas direct navigation karo
            pushToDetailVC(indexPath: indexPath)
        }
    }
    
    // ✅ Single function to handle navigation
    private func pushToDetailVC(indexPath: IndexPath) {
        let postDetailsShowDataVC = self.storyboard?.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as! PostViewShowImgVideosDataVC
        postDetailsShowDataVC.allMediaData = mediaData
        self.navigationController?.pushViewController(postDetailsShowDataVC, animated: true)
    }
    
    //MARK: - updateCollectionViewHeight
    func updateCollectionViewHeight() {
        if mediaData.isEmpty {
            collectionViewBannerHeight.constant = -30
            collectionViewBanner.isHidden = true
        } else {
            collectionViewBannerHeight.constant = 546 // Your desired height
            collectionViewBanner.isHidden = false
        }
        updateMainHeight()
    }
    
    func updateMainHeight() {
        // Make sure both heights are calculated before calling this
        let bannerHeight = collectionViewBannerHeight.constant
        let tableHeight = tableviewHeightMess.constant
        mainHeight.constant = 210 + bannerHeight + tableHeight
    }
    
    
    //MARK: -     ---------------- call collectionview --------------------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostDetailsCollectionViewCell", for: indexPath) as! PostDetailsCollectionViewCell
        let currentMedia = mediaData[indexPath.row]
        if let imgURL = currentMedia.img, !imgURL.isEmpty {
            cell.configureCell(mediaURL: imgURL, isVideo: false)
        } else if let videoURL = currentMedia.video, !videoURL.isEmpty {
            cell.configureCell(mediaURL: videoURL, isVideo: true)
        } else {
            print("Invalid media data at index \(indexPath.row): \(currentMedia)")
        }
        return cell
    }
    
    // ✅ `didSelectItemAt` ka alag handling (Gesture Recognizer ke saath conflict avoid karne ke liye)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushToDetailVC(indexPath: indexPath) // ✅ Same function call kar diya (Duplicate avoid ho gaya)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collectionViewBanner.width) / 1
        return CGSize(width: thisWidth, height: 546)
    }
    
    
    func callpostDetailWebService(postid: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "userid": id,
            "postid": postid
        ]
        print(dictParams)
        WebService.sharedInstance.callpostDetailWebService(withParams: dictParams) { data in
            self.PostDetailData = data
            if let listData = self.PostDetailData?.listdata?.first {
                print("Post Detail Response: \(listData)")
                self.mediaData = listData.postImages ?? [] // Fetch all media
                print("Media Data Count: \(self.mediaData.count)")
            } else {
                print("List Data is nil or empty")
            }
            completionClosure()
        }
    }
    
    
    func callPostCommenteWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let dictParams: [String: Any] = [
            "userid": id ?? "",
            "postid": postid ?? ""
        ]
        WebService.sharedInstance.callPostCommenteWebService(withParams: dictParams) { (data: CommentPostModel?) in
            // Now data is properly optional
            self.CommentPostListData = data
            self.tableviewPost.reloadData()
            // Debug print to check response
            if let comments = data?.postlistdata {
                print("Received \(comments.count) comments")
                for comment in comments {
                    print("Comment ID: \(comment.pcID), Post ID: \(comment.postid), User ID: \(comment.userid)")
                    if let replies = comment.replies {
                        print("Has \(replies.count) replies")
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.updateTableViewHeight()
                self.scrollToBottom()
            }
            completionClosure()
        }
    }
    
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async {
            let sections = self.tableviewPost.numberOfSections
            if sections > 0 {
                let lastSection = sections - 1
                let rows = self.tableviewPost.numberOfRows(inSection: lastSection)
                if rows > 0 {
                    let indexPath = IndexPath(row: rows - 1, section: lastSection)
                    self.tableviewPost.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }
    
    func updateTableViewHeight() {
        tableviewPost.layoutIfNeeded()
        let contentHeight = tableviewPost.contentSize.height
        //        print("Content Height: \(contentHeight)")
        let dataCount = CommentPostListData?.postlistdata.count ?? 0
        tableviewHeightMess.constant = dataCount == 0 ? 0 : contentHeight
        updateMainHeight()
    }
    
    
    func callCommenteReplyPostWebService(parentID: String?, topLevelUsername: String?, topLevelUserID: String?, completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        var dictParams: [String: Any] = [
            "userid": id ?? "",
            "postid": self.postid,
            "commenttext": self.tvmessage.text ?? "",
            "parent_id": parentID ?? "",
            "top_level_username": topLevelUsername ?? "",
            "top_level_userid": topLevelUserID ?? ""
        ]
        print(dictParams)
        WebService.sharedInstance.callCommentePostWebService(withParams: dictParams) { data in
            self.PostCommentData = data
            
            if self.PostCommentData?.status == "success" {
                completionClosure()
            } else {
                self.showAlert(Message: self.PostCommentData?.message ?? "")
            }
        }
    }
    
    // MARK: - Comment Delete post
    
    func callDeletePostWebService(postId: String, userId: String, commentId: String, _ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "comment_id": commentId  // Added the new parameter
        ]
        print("Delete API Parameters: \(dictParams)")
        WebService.sharedInstance.callDeletePostComentWebService(withParams: dictParams) { data in
            self.deletePostCmnd = data
            completionClosure()
        }
    }
    
    
    func callCommLikePostWebService(postId: String, userId: String, commentId: String, _ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "comment_id": commentId
        ]
        print(dictParams)
        WebService.sharedInstance.callLikeCommentWebService(withParams: dictParams) { data in
            self.likeComModel = data
            completionClosure()
        }
    }
    
    
    func callCommentePostWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        // let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "postid":postid ?? "",
            "commenttext":self.tvmessage.text ?? "",
        ]
        WebService.sharedInstance.callCommentePostWebService(withParams: dictParams) { data in
            self.PostCommentData = data
            
            if self.PostCommentData?.status == "success"{
                completionClosure()
            }else{
                self.showAlert(Message: self.PostCommentData?.message ?? "")
            }
        }
    }
}

@available(iOS 16.0, *)
extension PostDetailsNewViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let postData = CommentPostListData?.postlistdata[section] else { return 0 }
        let repliesCount = postData.replies?.count ?? 0
        if isReplyVisible[section] == true {
            return 1 + repliesCount // Main comment + Replies
        } else {
            return 1 // Sirf main comment dikhayein
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CommentPostListData?.postlistdata.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableviewPost.separatorStyle = .none
        guard let postData = CommentPostListData?.postlistdata[indexPath.section] else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            // Main comment cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailsTableViewCell", for: indexPath) as! PostDetailsTableViewCell
            // Configure cell content
            cell.lblName.text = postData.username
            cell.lblSec.text = postData.neighbrhood
            cell.lblComment.text = postData.commenttext
            cell.lblTime.text = postData.createon
            cell.lblReplyMessCount.text = postData.totalComments
            let url = URL(string: postData.userpic)
            cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
            // Set like state
            let isLiked = postData.isLiked
            cell.configure(with: isLiked)
            // Set initial hide/show state (default to false/hidden)
            let isVisible = isReplyVisible[indexPath.section] ?? false
            cell.lblHideShow.text = isVisible ? "Hide" : "Show"
            // Handle reply button action
            cell.replyButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.btnComment.isHidden = true
                self.btnCommentReply.isHidden = false
                self.tvmessage.isHidden = false
                self.tvmessage.becomeFirstResponder()
                self.tvmessage.text = ""
                self.topLevelUsername = postData.username
                self.topLevelUserID = postData.userid
                self.parentID = postData.pcID
                self.postid = postData.postid
            }
            cell.configureCell(for: indexPath.section)
            cell.profileTapHandler = { [weak self] section in
                guard let self = self else { return }
                guard let postData = self.CommentPostListData?.postlistdata[section] else { return }
                let userID = postData.userid
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                    vc.Oid = userID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.likeButtonTapped = { [weak self] newState in
                guard let self = self else { return }
                let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
                let postId = postData.postid
                let commentId = postData.pcID
                // ✅ First, update your model
                self.CommentPostListData?.postlistdata[indexPath.section].isLiked = newState
                // ✅ Then, call API (don't care about API response for now)
                self.callCommLikePostWebService(postId: postId, userId: userId, commentId: commentId) {
                    // Optional: handle response
                    print("API called successfully")
                }
            }
            
            // Handle hide/show button action
            cell.toggleReplyCellAction = { [weak self] in
                guard let self = self else { return }
                let section = indexPath.section
                let isCurrentlyVisible = self.isReplyVisible[section] ?? false
                let newState = !isCurrentlyVisible
                // Update the state
                self.isReplyVisible[section] = newState
                // Update the button label
                cell.lblHideShow.text = newState ? "Hide" : "Show"
                // Get replies count
                let repliesCount = postData.replies?.count ?? 0
                // Only proceed if there are replies
                if repliesCount > 0 {
                    let indexPaths = (1...repliesCount).map { IndexPath(row: $0, section: section) }
                    // Perform updates with animation
                    tableView.performBatchUpdates({
                        if newState {
                            tableView.insertRows(at: indexPaths, with: .automatic)
                        } else {
                            tableView.deleteRows(at: indexPaths, with: .automatic)
                        }
                    }, completion: nil)
                }
            }
            
            return cell
        } else {
            // Reply cell (unchanged)
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell", for: indexPath) as! ReplyTableViewCell
            if let reply = postData.replies?[indexPath.row - 1] {
                cell.userNameLabel.text = reply.username
                cell.replyLabel.text = reply.commenttext
                cell.lblTime.text = reply.createon
                cell.lblneighbrhood.text = reply.neighbrhood
                let url = URL(string: reply.userpic)
                cell.userPicImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
                cell.lblReplyUserName.text = "@\(reply.top_level_username ?? "")"
                cell.replyButtonTapped = { [weak self] in
                    guard let self = self else { return }
                    self.btnComment.isHidden = true
                    self.btnCommentReply.isHidden = false
                    self.tvmessage.isHidden = false
                    self.tvmessage.becomeFirstResponder()
                    self.tvmessage.text = ""
                    // ParentID = jis reply pe click kiya
                    self.parentID = reply.pcID
                    // Top-level username & userID = API se directly
                    self.topLevelUsername = reply.top_level_username ?? ""
                    self.topLevelUserID = reply.top_level_userid ?? ""
                    self.isReplyCellSelected = true
                    self.postid = reply.postid
                }
                
                cell.configureCell(for: indexPath.section, reply: reply)
                cell.profileTapHandler = { [weak self] replyObj, section in
                    guard let self = self else { return }
                    let userID = replyObj.userid // Reply user id!
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                        vc.Oid = userID
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            return cell
        }
    }
}


@available(iOS 16.0, *)
extension PostDetailsNewViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Remove emoji selection view when user starts scrolling
        removeEmojiSelectionView()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Continuously check and remove emoji selection view
        removeEmojiSelectionView()
    }
    
    private func removeEmojiSelectionView() {
        // Find and remove the emoji selection view from the superview
        if let emojiView = UIApplication.shared.windows.first?.viewWithTag(9999) { // Using tag to identify
            emojiView.removeFromSuperview()
        }
    }
}

@available(iOS 16.0, *)
extension PostDetailsNewViewController {
    func callFavouriteBussinessWebService(postId: String, _ completionClosure: @escaping (Int, String) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        let neighborhoodId = UserDefaults.standard.string(forKey: "neighbrshood") ?? ""
        let dictParams: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "type": "Post",
            "neighbrhood": neighborhoodId
        ]
        WebService.sharedInstance.callFavouriteBussinessWebService(withParams: dictParams) { data in
            if let json = data as? [String: Any],
               let message = json["message"] as? String,
               let favStatus = json["favouritstatus"] as? Int {
                completionClosure(favStatus, message)
            } else {
                completionClosure(1, "Added to favourite successfully!")
            }
        }
    }
    
    func callFavouriteRemoveBussinessWebService(postId: String, _ completionClosure: @escaping (Int, String) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        
        let dictParams: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "type": "Post"
        ]
        WebService.sharedInstance.callFavouriteRemoveBussinessWebService(withParams: dictParams) { data in
            if let json = data as? [String: Any],
               let message = json["message"] as? String,
               let favStatus = json["favouritstatus"] as? Int {
                completionClosure(favStatus, message)
            } else {
                completionClosure(0, "Removed from favourite successfully!")
            }
        }
    }
    
    func callPostLikeWebService(postId: String, emoji: String?, completion: @escaping () -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        let params: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "likestatus": "1",
            "emojiunicode": emoji ?? ""
        ]
        WebService.sharedInstance.callPostLikeWebService(withParams: params) { data in
            completion()
        }
        self.callPostLikelistWebService(postid: postid) {
        }
    }
    
    func callPostUnLikeWebService(postId: String, completion: @escaping () -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        let params: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "likestatus": "0",
            "emojiunicode": ""
        ]
        WebService.sharedInstance.callPostUnLikeWebService(withParams: params) { data in
            completion()
        }
        self.callPostLikelistWebService(postid: postid) {
        }
    }
    
    
    func callPostLikelistWebService(postid: String, completion: @escaping () -> Void) {
        let currentUserId = UserDefaults.standard.string(forKey: "userid") ?? ""
        let params: [String: Any] = ["postid": postid]
        WebService.sharedInstance.callLikeListPostWebService(withParams: params) { data in
            if let status = data.status, status == "success" {
                DispatchQueue.main.async {
                    // ✅ Update like count
                    self.lblLike.text = "\(data.totalEmojis ?? 0)"
                    // ✅ Check if current user liked this post
                    if let likeList = data.listdata.first(where: { $0.userid == currentUserId }) {
                        if let emoji = likeList.emojiunicode, !emoji.isEmpty {
                            // ✅ User already liked with emoji
                            self.selectedEmoji = emoji
                            self.isLikedByUser = true
                            self.btnLike.setTitle(emoji, for: .normal)
                            self.btnLike.setImage(nil, for: .normal)
                        } else {
                            // ✅ User liked without emoji
                            self.selectedEmoji = nil
                            self.isLikedByUser = true
                            self.btnLike.setImage(UIImage(systemName: "hand.thumbsup.circle.fill"), for: .normal)
                            self.btnLike.setTitle("", for: .normal)
                            self.btnLike.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                        }
                    } else {
                        // ❌ User has not liked yet
                        self.selectedEmoji = nil
                        self.isLikedByUser = false
                        self.btnLike.setImage(UIImage(systemName: "hand.thumbsup.circle"), for: .normal)
                        self.btnLike.setTitle("", for: .normal)
                        self.btnLike.tintColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
                    }
                }
            }
            completion()
        }
    }
    
}



