//
//  PostDetailsViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/06/24.
//

import UIKit
import SVProgressHUD
import AVKit


@available(iOS 16.0, *)
class PostDetailsViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate {
    
    @IBOutlet weak var tableviewHeightMess: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBanner: UICollectionView!
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
    @IBOutlet weak var btnShareImg : UIButton!
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
    var mediaData: [PostImageD] = []
    
    var thisWidth:CGFloat = 0
    var CommentPostListData : CommentPostModel? // data fatch
    var PostCommentData : PostCommentModel?
    var deletePostCmnd : DeletePostCommentModel?
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
    //var imgData = [PostImage]()
    var imgDataF = [PostImageF]()
    var PostidDe = [Postlistdatum]()
    var PostListData : PostListModel?
    var isReplyCellSelected = false
    var selectedPCID: String?
    var selectedPostID: String?
    var selectedUserID: String?
    var selectRreateOn : String?
    private var defaultTextColor: UIColor?
    @IBOutlet weak var containerView: UIView! // Bottom popup view
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lblShare: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultTextColor = lblName.textColor
        updateColors()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           view.addGestureRecognizer(tapGesture)
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
        
        
        
        // Call the web service with the passed postid
        callpostDetailWebService(postid: postid) {
            DispatchQueue.main.async {
                self.collectionViewBanner.reloadData()
            }
        }
        
        setupLabel()
        tableviewPost.rowHeight = UITableView.automaticDimension
        tableviewPost.estimatedRowHeight = 80 // Approximate height
        
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
        
        placeholderLabel.text = "Type a message..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTableView), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableviewHeightMess.constant = self.tableviewPost.contentSize.height
            self.tableviewHeightMess.constant = self.collectionViewBanner.contentSize.height
            
        }
        
        btnComment.isHidden = false
        btnCommentReply.isHidden = true
        //        self.tvmessage.becomeFirstResponder() // Open the keyboard
        
        
        btnLike.setImage(UIImage(named: "Unlike"), for: .normal)
        lblLike.text = "\(likeCount)"
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showEmojis(_:)))
        longPressGesture.minimumPressDuration = 2.0 // Set duration to 3 seconds
        btnLike.addGestureRecognizer(longPressGesture)
        
        //        // Initialize the dictionary
        //               CommentPostListData?.postlistdata.enumerated().forEach { index, _ in
        //                   isReplyVisible[index] = false // Set all replies as hidden initially
        //               }
        
        // Initialize all sections as hidden by default
        if let postDataCount = CommentPostListData?.postlistdata.count {
            for section in 0..<postDataCount {
                isReplyVisible[section] = false // Default hidden
            }
        }
        
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            lblName.textColor = .white
            lblSector.textColor = .white
            lblmonth.textColor = .white
            lblGeneral.textColor = .white
            lblDescription.textColor = .white
            
            btnLike.tintColor = .white // Arrow tint for dark mode
            btnClickComment.tintColor = .white
            btnShareImg.tintColor = .white
            
            
        } else {
            // Light mode
            lblName.textColor = defaultTextColor
            lblSector.textColor = UIColor.secondaryLabel
            lblmonth.textColor = UIColor.secondaryLabel
            lblGeneral.textColor = UIColor.secondaryLabel
            lblDescription.textColor = UIColor.secondaryLabel
            btnLike.tintColor = .black // Arrow tint for dark mode
            btnClickComment.tintColor = .black
            btnShareImg.tintColor = .black
           
        }
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    
    @objc override func dismissKeyboard() {
        view.endEditing(true) // Hides all keyboards in the view
    }
    
    
//    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
//        if gesture.state == .began {
//            let touchPoint = gesture.location(in: tableviewPost)
//            if let indexPath = tableviewPost.indexPathForRow(at: touchPoint) {
//                print("Long pressed on section: \(indexPath.section), row: \(indexPath.row)")
//                
//                // Get the selected comment data
//                if let commentData = CommentPostListData?.postlistdata[indexPath.section] {
//                    // For main comment
//                    var selectedComment = commentData
//                    
//                    // If it's a reply (row > 0)
//                    if indexPath.row > 0, let reply = commentData.replies?[indexPath.row - 1] {
//                        selectedComment = reply
//                    }
//                    
//                    // Save the IDs you need
//                    let pcID = selectedComment.pcID
//                    let postid = selectedComment.postid
//                    let userid = selectedComment.userid
//                    let creatON = selectedComment.createon
//                    
//                    // Print them
//                    print("Selected Comment IDs:")
//                    print("pc_id: \(pcID)")
//                    print("postid: \(postid)")
//                    print("userid: \(userid)")
//                    print("Creatye: \(creatON)")
//                    
//                    // Store them if needed (in properties or UserDefaults)
//                    self.selectedPCID = pcID
//                    self.selectedPostID = postid
//                    self.selectedUserID = userid
//                    self.selectRreateOn = creatON
//                    
//                    // Show bottom sheet
//                    showBottomSheet()
//                }
//            }
//        }
//    }
    
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.MembersLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
           // Ensure `postid` is passed here
        callpostDetailWebService(postid: self.postid) {
            self.collectionViewBanner.reloadData()
            self.lblName.text = self.PostDetailData?.listdata?.first?.username
            self.lblSector.text = self.PostDetailData?.listdata?.first?.neighborhood
            self.lblGeneral.text = self.PostDetailData?.listdata?.first?.postType
            self.lblDescription.text = self.PostDetailData?.listdata?.first?.postMessage
            self.lblmonth.text = self.PostDetailData?.listdata?.first?.createdOn
            self.lblComment.text = "\(self.PostDetailData?.listdata?.first?.totcomment ?? 0)"
        }
         let urlString = UserDefaults.standard.object(forKey: "userphoto") as? String
        let url = URL(string: (urlString ?? ""))
        self.UserPicImgView.kf.indicatorType = .activity
        self.UserPicImgView.kf.setImage(with:url,placeholder:UIImage(named: "My-profile"))
        SVProgressHUD.show()
        DispatchQueue.main.async {
            self.callPostCommenteWebService{
                SVProgressHUD.dismiss()
                self.tableviewPost.reloadData()
             }
         }
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
                // Show success alert
               
                        // Hide container view
                        self.containerView.isHidden = true
                         // Refresh comments list
                        self.callPostCommenteWebService {
                            // Any completion after refresh
                  }
            }
        }
    }
    
    
    @IBAction func actionLike(_ sender: Any) {
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
            lblLike.text = "\(likeCount)"
            btnLike.setImage(UIImage(named: isLikedByUser ? "Unlike" : "Like"), for: .normal)
        } else {
            // If emoji is already selected, update like with emoji
            updateLikeWithEmoji()
        }
        
        // Show emoji selection view above the button
        showEmojiSelectionView(button: sender as! UIButton)
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
        // Show the custom emoji selection view
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
        lblLike.text = "\(likeCount)"
        btnLike.setTitle(emoji, for: .normal)
        btnLike.setImage(nil, for: .normal)
        
        // Force layout update for button
        btnLike.setNeedsLayout()
        btnLike.layoutIfNeeded()
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
    
    @IBAction func actionShare(_ sender: Any) {
    }
    
    
    
    //MARK: - favtk post
    
    @IBAction func actionFavt(_ sender: Any) {
    }
    
    
//    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
//        if gesture.state == .began {
//            let touchPoint = gesture.location(in: tableviewPost)
//            if let indexPath = tableviewPost.indexPathForRow(at: touchPoint) {
//                self.selectedCommentIndexPath = indexPath // Store the selected index
//                // ... rest of your existing long press code ...
//            }
//        }
//    }

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
        // Call reloadData to refresh the table view
        tableviewPost.reloadData()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Show or hide placeholder label based on text view content
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
 
    
    
    @IBAction func SendBtn(_ sender: UIButton){
        self.tvmessage.resignFirstResponder()
          if tvmessage.text == "" {
            let alert = UIAlertController(title: "", message: "Please Enter Your Message", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else{
            
            callCommentePostWebService{ [self] in
                tvmessage.text = ""
                
            }
            DispatchQueue.main.async {
                self.callPostCommenteWebService{ [self] in
                    
                    
                }
            }
            
        }
        
    }
    
    
    @IBAction func actionCommentReply(_ sender: UIButton){
        self.tvmessage.resignFirstResponder()
        if tvmessage.text == "" {
            let alert = UIAlertController(title: "", message: "Please Enter Your Message", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            callCommenteReplyPostWebService(parentID: parentID, topLevelUsername: topLevelUsername, topLevelUserID: topLevelUserID) {
                DispatchQueue.main.async {
                    print("Reply posted successfully!")
                    self.tvmessage.text = "" // Clear the text after posting
                    self.callPostCommenteWebService{ [self] in
                        
                    }
                }
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
        return CGSize(width: thisWidth, height: 500)
    }
    
    
    func callpostDetailWebService(postid: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "userid": id,
            "postid": postid
        ]
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
            
            completionClosure()
        }
    }
    
    
    func callCommenteReplyPostWebService(parentID: String?, topLevelUsername: String?, topLevelUserID: String?, completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        
        var dictParams: [String: Any] = [
            "userid": id ?? "",
            "postid": idPost ?? "",
            "commenttext": self.tvmessage.text ?? "",
            "parent_id": parentID ?? "",
            "top_level_username": topLevelUsername ?? "",
            "top_level_userid": topLevelUserID ?? ""
        ]
        
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
extension PostDetailsViewController: UITableViewDataSource, UITableViewDelegate{
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
                    self.isReplyCellSelected = true
                }
            }
            return cell
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacerView = UIView()
        spacerView.backgroundColor = .clear // Ya phir light gray for visible spacing
        return spacerView
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    
    func heightForText(_ text: String, maxWidth: CGFloat) -> CGFloat {
        let font = UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = 4 // Add some line spacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        
        return ceil(boundingBox.height)
    }
    
}



@available(iOS 16.0, *)
extension PostDetailsViewController: UIScrollViewDelegate {
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
extension PostDetailsViewController {
    func callFavouriteBussinessWebService(postId: String, _ completionClosure: @escaping (String) -> Void) {
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
               let message = json["message"] as? String {
                completionClosure(message) // Pass message to closure
            } else {
                completionClosure("Added to favorite successfully!")
            }
        }
    }
    
    func callFavouriteRemoveBussinessWebService(postId: String, _ completionClosure: @escaping (String) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        
        let dictParams: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "type": "Post"
        ]
        
        WebService.sharedInstance.callFavouriteRemoveBussinessWebService(withParams: dictParams) { data in
            if let json = data as? [String: Any],
               let message = json["message"] as? String {
                completionClosure(message) // Pass message to closure
            } else {
                completionClosure("Removed to favorite successfully!")
            }
        }
    }
}



