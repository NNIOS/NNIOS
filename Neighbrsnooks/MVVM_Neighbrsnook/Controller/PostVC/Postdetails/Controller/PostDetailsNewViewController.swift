//
//  PostDetailsNewViewController.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 11/05/25.
//

import UIKit
import AVKit
import IQKeyboardManagerSwift
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
    var parentID = ""
    var topLevelUsername = "" 
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
    var getCommentData: PostCommentListDecryptModel?
    var PostDetailData: postDetailsdecryptModel?
    var imgDataAll: [PostDetailsMedia] = []
    var mediaData: [PostDetailsMedia] = [] {
        didSet {
            updateCollectionViewHeight()
            collectionViewBanner.reloadData()
        }
    }
    var replyParentCommentID: Int?
    var replyParentCommentUserID: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("postId: \(postId) irshad")
        tableviewPost.delegate = self
        tableviewPost.dataSource = self
        tvmessage.delegate = self
        tvmessage.isScrollEnabled = false
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
        
        
        setupLabel()
        tableviewPost.rowHeight = UITableView.automaticDimension
        //        tableviewPost.estimatedRowHeight = 80 // Approximate height
//        fullText = self.PostDetailData?.listdata?.first?.postMessage ?? ""
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
        btnComment.isHidden = false
        btnCommentReply.isHidden = true
        //        btnLike.setImage(UIImage(named: "Unlike"), for: .normal)
        btnLike.setImage(UIImage(systemName: "hand.thumbsup.circle"), for: .normal)
        btnLike.tintColor =  #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
       
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showEmojis(_:)))
        longPressGesture.minimumPressDuration = 2.0 // Only trigger after 2 seconds
        btnLike.addGestureRecognizer(longPressGesture)
        // Initialize all sections as hidden by default
        if let postDataCount = getCommentData?.data.data.count {
            for section in 0..<postDataCount {
                isReplyVisible[section] = false // Default hidden
            }
        }
        self.fetchComments()
        self.fetchLikeStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.MembersLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        postDetailsApi(postId: self.postId) { decrypted in
            DispatchQueue.main.async {
                guard let decrypted = decrypted,
                      let post = decrypted.data.data.posts.first else {
                    print("No post detail found")
                    return
                }
                self.mediaData = post.media
                self.lblName.text = post.userFullName
                self.lblSector.text = post.neighborhoodID
                self.lblGeneral.text = post.postType
                self.lblDescription.text = post.description
                self.lblmonth.text = post.createdAt
                self.lblComment.text = "\(post.totcomment)"

                if let imageUrl = URL(string: post.userpic) {
                    self.UserPicImgView.kf.setImage(
                        with: imageUrl,
                        placeholder: UIImage(named: "My-profile"),
                        options: [.transition(.fade(0.3))]
                    )
                }
                self.collectionViewBanner.reloadData()
            }
        }
        
        
        
         
    }
    
    
    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//        let keyboardHeight = keyboardFrame.height
//        
//        self.bottomConstraint.constant = -keyboardHeight
//        
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    @objc func keyboardWillHide(_ notification: Notification) {
//        self.bottomConstraint.constant = 0
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
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
            self.containerView.frame.origin.y = screenHeight - 200
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
        
       
    }
    
    
    
    @IBAction func actionLike(_ sender: UIButton) {
        isLikedByUser.toggle()
           let likeStatus = isLikedByUser ? 1 : 0
           postLikeApi(p_id: postId, like_status: likeStatus)
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
            isLikedByUser = true
        }
        lblLike.text = "\(likeCount)"
        btnLike.setTitle(emoji, for: .normal)
        btnLike.setImage(nil, for: .normal)
        postLikeApi(p_id: postId, emoji_type: emoji, like_status: 1)
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
         tvmessage.isHidden = false
        tvmessage.becomeFirstResponder() // Open the keyboard
        
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
//    @objc func refreshTableView() {
//        DispatchQueue.main.async {
//            self.tableviewPost.reloadData()
//            self.updateTableViewHeight()
//        }
//    }
    
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
        let postId = self.postId
        createPostCommentApi(postId: postId)
    }
    
    
    
    @IBAction func actionCommentReply(_ sender: UIButton) {
        self.tvmessage.resignFirstResponder()
        
        guard let text = tvmessage.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            let alert = UIAlertController(title: "", message: "Please Enter Your Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default))
            self.present(alert, animated: true)
            return
        }

        let postId = self.postId
        let parentId = self.replyParentCommentID != nil ? "\(self.replyParentCommentID!)" : ""

        createPostCommentApi(postId: postId, parentId: parentId)

        // Reset UI
        self.tvmessage.text = ""
        self.btnComment.isHidden = false
        self.btnCommentReply.isHidden = true
        self.replyParentCommentID = nil
        self.replyParentCommentUserID = nil
    }


    
    
    func loadPostData() {
        // PostDetailData se post extract karo
        if let post = PostDetailData?.data.data.posts.first {
            mediaData = post.media  // yeh [PostDetailsMedia] assign kar rahe hain
            print("MediaData count: \(mediaData.count)")
        } else {
            print("ListData is nil")
            mediaData = []
        }
        
    }

    
    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionViewBanner)
        if let indexPath = collectionViewBanner.indexPathForItem(at: location) {
            pushToDetailVC(indexPath: indexPath)
        }
    }

    private func pushToDetailVC(indexPath: IndexPath) {
        guard let postDetailsShowDataVC = self.storyboard?.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as? PostViewShowImgVideosDataVC else {
            print("VC not found!")
            return
        }
        postDetailsShowDataVC.imgDataAll = mediaData
        postDetailsShowDataVC.selectedIndex = indexPath.row // jisse scroll directly select pe ho sake (optional)
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
            let media = mediaData[indexPath.row]
            if let imgURL = media.img, !imgURL.isEmpty {
                cell.configureCell(mediaURL: imgURL, isVideo: false)
            } else if let videoURL = media.video, !videoURL.isEmpty {
                cell.configureCell(mediaURL: videoURL, isVideo: true)
            } else {
                print("Invalid media data at index \(indexPath.row): \(media)")
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
    
  
    
    
}

@available(iOS 16.0, *)
extension PostDetailsNewViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return getCommentData?.data.data.count ?? 0
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         guard let postData = getCommentData?.data.data[section] else { return 0 }
         let repliesCount = postData.replies?.count ?? 0
         if isReplyVisible[section] == true {
             return 1 + repliesCount // Main comment + Replies
         } else {
             return 1 // Only main comment
         }
     }

     // MARK: - UITableViewDelegate
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         tableviewPost.separatorStyle = .none
         guard let postData = getCommentData?.data.data[indexPath.section] else {
             return UITableViewCell()
         }
         if indexPath.row == 0 {
             // Main comment cell
             let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailsTableViewCell", for: indexPath) as! PostDetailsTableViewCell
             cell.lblName.text = postData.userFullName
             cell.lblSec.text = postData.neighborhoodName
             cell.lblComment.text = postData.message
             cell.lblTime.text = postData.createdAt
             cell.lblReplyMessCount.text = "\(postData.commentCount ?? 0)"
             if let url = URL(string: postData.userpic) {
                 cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
             }
             cell.configure(with: postData.authLiked)
             let isVisible = isReplyVisible[indexPath.section] ?? false
             cell.lblHideShow.text = isVisible ? "Hide" : "Show"
             // Reply button action
             cell.replyButtonTapped = { [weak self] in
                 guard let self = self else { return }

                 // Parent comment की details save करो
                 self.replyParentCommentID = postData.commentID
                 self.replyParentCommentUserID = postData.userID

                
                 self.tvmessage.becomeFirstResponder()
                 self.btnComment.isHidden = true
                 self.btnCommentReply.isHidden = false
             }

             // Expand/collapse replies
             cell.toggleReplyCellAction = { [weak self] in
                 guard let self = self else { return }
                 let section = indexPath.section
                 let newState = !(self.isReplyVisible[section] ?? false)
                 self.isReplyVisible[section] = newState
                 let repliesCount = postData.replies?.count ?? 0
                 if repliesCount > 0 {
                     let indexPaths = (1...repliesCount).map { IndexPath(row: $0, section: section) }
                     tableView.performBatchUpdates({
                         if newState {
                             tableView.insertRows(at: indexPaths, with: .automatic)
                         } else {
                             tableView.deleteRows(at: indexPaths, with: .automatic)
                         }
                     }, completion: nil)
                 }
                 cell.lblHideShow.text = newState ? "Hide" : "Show"
             }

             // Profile tap action
             cell.profileTapHandler = { [weak self] section in
                 guard let self = self else { return }
                 // Implement profile navigation logic as needed
             }
             // Like button tapped
             cell.likeButtonTapped = { [weak self] newIsLiked in
                 guard let self = self else { return }
                 let commentId = "\(postData.commentID)"
                 print("❤️ Like tapped for commentId: \(commentId), newState: \(newIsLiked)")
                 self.commentPostLikeApi(commentId: commentId)
             }
             // Configure other cell properties if any
             cell.configureCell(for: indexPath.section)

             return cell

         } else {
             // Reply cell
             let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell", for: indexPath) as! ReplyTableViewCell
             if let reply = postData.replies?[indexPath.row - 1] {
                 cell.userNameLabel.text = reply.userFullName
                 cell.replyLabel.text = reply.message
                 cell.lblTime.text = reply.createdAt
                 cell.lblneighbrhood.text = reply.neighborhoodName
                 if let url = URL(string: reply.userpic) {
                     cell.userPicImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
                 }
                 cell.lblReplyUserName.text = "@\(reply.parentCommentUserFullName ?? "")"
                 cell.replyButtonTapped = { [weak self] in
                     guard let self = self else { return }
                     self.replyParentCommentID = postData.commentID
                     self.replyParentCommentUserID = postData.userID
                     self.tvmessage.becomeFirstResponder()
                     self.btnComment.isHidden = true
                     self.btnCommentReply.isHidden = false
                 }
                 
                 cell.profileTapHandler = { [weak self] replyObj, section in
                     guard let self = self else { return }
                     // Implement profile navigation as needed
                 }
                 cell.configureCell(for: indexPath.section, reply: reply)
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
    //MARK: - Call Api Post Details
    
    func postDetailsApi(postId: String, completion: @escaping (postDetailsdecryptModel?) -> Void) {
        UtilityMethods.showIndicator()
        let parameters: Parameters = ["id": postId]
        PostDetailsV_M.shared.PostDetails(parameters: parameters) { result, error in
            if let error = error {
                UtilityMethods.hideIndicator() // 👈 Loader Stop
                print("Error fetching post details: \(error)")
                completion(nil)
                return
            }
            if let encryptedString = result?.data {
                PostDetailsDecrypt(encryptedString: encryptedString) { [self] decryptedModel in
                    UtilityMethods.hideIndicator()
                    completion(decryptedModel)
                    DispatchQueue.main.async {
                        fetchComments()
                    }
                }
            } else {
                UtilityMethods.hideIndicator()
                print("No encrypted string found to decrypt")
                completion(nil)
            }
        }
    }


    func postCommentListApi(
        postId: String,
        completion: @escaping (PostCommentListDecryptModel?) -> Void
    ) {
        UtilityMethods.showIndicator()
        let parameters: Parameters = ["post_id": postId]

        PostCommentListV_M.shared.PostCommentList(parameters: parameters) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    UtilityMethods.hideIndicator()
                    print("Error fetching post details: \(error)")
                    completion(nil)
                }
                return
            }

            guard let encryptedString = result?.data, !encryptedString.isEmpty else {
                DispatchQueue.main.async {
                    UtilityMethods.hideIndicator()
                    print("No encrypted string found to decrypt")
                    completion(nil)
                }
                return
            }

            postCommentListDecrypt(encryptedString: encryptedString) { decryptedModel in
                DispatchQueue.main.async {
                    UtilityMethods.hideIndicator()
                    self.getCommentData = decryptedModel
                    completion(decryptedModel)
                }
            }
        }
    }

    private func fetchComments() {
        postCommentListApi(postId: postId) { [weak self] model in
            guard let self = self else { return }
            
            // Data assign karo
            self.getCommentData = model
            
            // Reply expand state reset karo
            let count = model?.data.data.count ?? 0
            self.isReplyVisible = [:]
            for section in 0..<count {
                self.isReplyVisible[section] = false
            }
            
            // TableView reload karo - Hamesha main thread pe!
            DispatchQueue.main.async {
                self.tableviewPost.reloadData()
                self.updateTableViewHeight()
            }
        }
        
        
        
    }
    
    private func fetchLikeStatus() {
        fetchPostLikeStatus(postId: postId) { [weak self] postLikeStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let status = postLikeStatus {
                    // Total likes dikhana
                    self.lblLike.text = "\(status.data.totalLikes)"
                    
                    // Like button state ke liye
                    let isLiked = status.data.authLike
                    let currentUserID = UserDefaults.standard.integer(forKey: "user_id")
                    let currentUser = status.data.data.first(where: { $0.userID == currentUserID }) ?? status.data.data.first
                    let emojiCode = currentUser?.emojiCode.decodedEmoji ?? ""

                    if isLiked {
                        if emojiCode.isEmpty {
                            // Default like fill show
                            self.btnLike.setTitle("", for: .normal)
                            self.btnLike.setImage(UIImage(systemName: "hand.thumbsup.circle.fill"), for: .normal)
                        } else {
                            // Emoji show
                            self.btnLike.setTitle(emojiCode, for: .normal)
                            self.btnLike.setImage(nil, for: .normal)
                        }
                    } else {
                        // Unlike: default outline show
                        self.btnLike.setTitle("", for: .normal)
                        self.btnLike.setImage(UIImage(systemName: "hand.thumbsup.circle"), for: .normal)
                    }
                } else {
                    self.lblLike.text = "0"
                    self.btnLike.setTitle("", for: .normal)
                    self.btnLike.setImage(UIImage(systemName: "hand.thumbsup.circle"), for: .normal)
                }
            }
        }
    }


    
    
    
    func createPostCommentApi(postId: String, parentId: String = "") {
        // 1️⃣ Message validate
        guard let message = tvmessage.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !message.isEmpty else {
            print("⚠️ Please enter a comment")
            return
        }

        // 2️⃣ Indicator show
        UtilityMethods.showIndicator()

        // 3️⃣ Parameters ready
        let parameters: Parameters = [
            "post_id": postId,
            "parent_id": parentId,
            "message": message
        ]
        print(parameters)

        // 4️⃣ API Call
        PostCreateCommentV_M.shared.PostCreateComment(parameters: parameters) { result, error in
            DispatchQueue.main.async {
                UtilityMethods.hideIndicator()

                if let error = error {
                    print("❌ API Error:", error)
                    return
                }

                guard let result = result else {
                    print("❌ No response from API")
                    return
                }

                if result.status == true {
                    print("✅ Comment Created Successfully: \(result.message)")
                    self.tvmessage.text = ""
                    self.fetchComments() // comment list reload
                } else {
                    print("⚠️ Failed: \(result.message)")
                }
            }
        }
    }
    
    //MARK: - Like Comment post Api
    func commentPostLikeApi(commentId: String) {
        // 1️⃣ Indicator show करो
        UtilityMethods.showIndicator()
        
        // 2️⃣ Parameters ready करो
        let parameters: Parameters = [
            "comment_id": commentId
        ]
        print("📤 Sending parameters:", parameters)
        
        // 3️⃣ API call करो
        PostCommentLikeV_M.shared.PostDetails(parameters: parameters) { result, error in
            DispatchQueue.main.async {
                // 4️⃣ Indicator hide करो
                UtilityMethods.hideIndicator()
                
                if let error = error {
                    print("❌ API Error:", error)
                    return
                }
                
                guard let result = result else {
                    print("❌ No response from API")
                    return
                }
                
                // 5️⃣ Handle response
                if result.status == true {
                    print("✅ Comment Like API Success:", result.message)
                    self.fetchComments() // Refresh list (optional)
                } else {
                    print("⚠️ Failed:", result.message)
                }
            }
        }
    }


    // MARK: - Like API Function
    
    func postLikeApi(p_id: String, emoji_type: String = "", like_status: Int) {
        let parameters: Parameters = [
            "p_id": p_id,
            "emoji_type": emoji_type,
            "like_status": like_status
        ]
        print(parameters)
        
        UtilityMethods.showIndicator()
        
        PostLikeV_M.shared.PostLike(parameters: parameters) { result, error in
            DispatchQueue.main.async {
                UtilityMethods.hideIndicator()
                if let error = error {
                    print("❌ Like API Error:", error)
                    return
                }
                guard let encryptedString = result?.data, !encryptedString.isEmpty else {
                    print("❌ No encrypted data found")
                    return
                }
                DecryptUtility.decryptPostLike(encryptedString: encryptedString) { decryptedModel in
                    DispatchQueue.main.async {
                        if let data = decryptedModel?.data.data {
                            print("✅ Like updated successfully:")
                            print("Total Likes:", data.totalLikes)
                            print("Like Status:", data.likeStatus)
                            print("Emoji Type:", data.emojiType)

                            // 🔹 Update UI
                            self.fetchLikeStatus()
                            
                            if data.emojiType.isEmpty {
                                self.btnLike.setTitle("", for: .normal)
                                self.btnLike.setImage(
                                    UIImage(systemName: data.likeStatus ? "hand.thumbsup.circle.fill" : "hand.thumbsup.circle"),
                                    for: .normal
                                )
                            } else {
                                self.btnLike.setTitle(data.emojiType, for: .normal)
                                self.btnLike.setImage(nil, for: .normal)
                            }
                        } else {
                            print("❌ Failed to decrypt Like data")
                        }
                    }
                }
            }
        }
    }


    func fetchPostLikeStatus(postId: String, completion: @escaping (PostLikeStatus?) -> Void) {
        // "like_status" yahan add karo
        let parameters: Parameters = [
            "p_id": postId
        ]
        print(parameters)
        
        PostLikeStatusV_M.shared.PostLike(parameters: parameters) { result, error in
            if let error = error {
                print("API error: \(error)")
                completion(nil)
                return
            }
            guard let result = result else {
                print("No data received from API")
                completion(nil)
                return
            }
            let encryptedString = result.data
            DecryptUtilityPostLikeStatus.decryptPostLikeStatus(encryptedString: encryptedString) { decryptedModel in
                completion(decryptedModel)
            }
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
        // print("Content Height: \(contentHeight)")
        let dataCount = getCommentData?.data.data.count ?? 0
        tableviewHeightMess.constant = dataCount == 0 ? 0 : contentHeight
        updateMainHeight()
    }

}



extension String {
    var decodedEmoji: String {
        let regex = try? NSRegularExpression(pattern: "&#(\\d+);")
        let nsString = self as NSString
        let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length)) ?? []
        var decoded = self
        for match in results.reversed() {
            if let range = Range(match.range(at: 1), in: self),
               let code = Int(self[range]),
               let scalar = UnicodeScalar(code) {
                decoded = (decoded as NSString).replacingCharacters(in: match.range, with: String(scalar))
            }
        }
        return decoded
    }
}
