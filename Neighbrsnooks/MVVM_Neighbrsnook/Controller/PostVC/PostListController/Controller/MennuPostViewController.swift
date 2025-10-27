//
//  MennuPostViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/07/24.
//

import UIKit
import SVProgressHUD
import AVFoundation
import AVKit

@available(iOS 16.0, *)
class MennuPostViewController: BaseViewController, MemberCellDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tableviewPost: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var postView: UIView!
   
     var PostListData : PostListModel?
    var PostLikeData : LikePostModel?
    var imgEmojiData = [Emojilistdata]()
    var imgData = [PostImage]()
    var filteredPostData: PostListModel?
    var profileData : ProfileModel?
    var searchWorkItem: DispatchWorkItem?
    var UserName = ""
    var sectorName = ""
    var MonthName = ""
    var GeneralName = ""
    var DescriptionlName = ""
    var deletePost : DeletePostModel?
    var postList: [PostItem] = []
    
    let items = [
        (id: "1", name: "Item 1"),
        (id: "2", name: "Item 2"),
        (id: "3", name: "Item 3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.searchView.isHidden = true
        tfSearch.delegate = self
        tableviewPost.dataSource = self
        tableviewPost.delegate = self
         self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        // Do any additional setup after loading the view.
       
        let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshPageData), for: .valueChanged)
            tableviewPost.refreshControl = refreshControl
        
        callPostListAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            
            postView.backgroundColor = .black
            tableviewPost.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            
            
            // Light mode mein PollsView ka background red karna
            postView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            tableviewPost.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
        }
    }
    
    @objc func refreshData() {
        fetchPostListData()
    }
    @objc func refreshPageData() {
        // Call all web services you want to refresh
        
    }

    
    @IBAction func btnSearch(_ : UIButton){
        
        self.searchView.isHidden = false
        self.lblHeading.isHidden = true
        
    }
    
    func fetchPostListData() {
         
    }
    
    @IBAction func btncancelSearch(_ : UIButton){
        
        self.searchView.isHidden = true
        self.lblHeading.isHidden = false
        self.tfSearch.text = ""
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Cancel the previous work item to avoid multiple API calls
        searchWorkItem?.cancel()
        
        // Create a new work item for the search
        searchWorkItem = DispatchWorkItem {
            // Call the API with the updated search text
            
        }
        
        // Execute the work item after a delay of 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchWorkItem!)
        
        return true
    }
    
 
    
    
    @IBAction func btnCreatePost(_ : UIButton){
            if PostListData?.verfiedMsg == "User Verification is completed!" {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else {return}
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                verifieldAlert(message: "You have limited access till verification is complete. We thank you for your patience.")
            }
        }
        
        func verifieldAlert(message: String) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let attributedMessage = NSAttributedString(
                string: message,
                attributes: [.font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)])
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    
    
    func shareContent(for item: (id: String, name: String)) {
        let shareText = "Check out this item: \(item.name)"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // For iPad, set the source view.
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
}

@available(iOS 16.0, *)
extension MennuPostViewController: UITableViewDataSource, UITableViewDelegate, PostMenuTableViewCellDelegate, MennuPostTableViewCellDelegate{
  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postList.count
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MennuPostTableViewCell", for: indexPath) as! MennuPostTableViewCell
        cell.delegate = self
        cell.delegateCell = self
        cell.delegateM = self
        let userId = filteredPostData?.listdata?[indexPath.row].createdby
        cell.userId = userId
        let post = postList[indexPath.row]     // POST KI ARRAY USE KARO
          cell.setPostData(post: post)
        
        cell.lblName.text = postList[indexPath.row].userFullName
        //  cell.lblGeneral.text = PostListData?.listdata[indexPath.row].postType
        cell.lblGeneral.text = postList[indexPath.row].postType
        //        cell.lblDescription.text = filteredPostData?.listdata?[indexPath.row].postMessage
        cell.configureDescription(with: postList[indexPath.row].postDescription ?? "N/A")
        cell.addTapGestureToLabel()
        //  cell.lblSec.text = PostListData?.listdata[indexPath.row].neighborhood
        cell.lblSec.text = postList[indexPath.row].neighborhoodID
        cell.lblMonth.text = postList[indexPath.row].createdAt
        cell.lblLikeCount.text = "\(postList[indexPath.row].totallike)"

        cell.lblCommentCount.text = "\(postList[indexPath.row].totcomment)"
        let media = post.media
        cell.imgData = media

        let imageExists = media.contains { $0.img != nil && !$0.img!.isEmpty }
        let videoExists = media.contains { $0.video != nil && !$0.video!.isEmpty }

       
        if imageExists || videoExists {
            cell.collectionViewBanner.isHidden = false
            cell.collectionViewMenuHeight.constant = 523
        } else {
            cell.collectionViewBanner.isHidden = true
            cell.collectionViewMenuHeight.constant = 0
        }


        
        
        cell.lblDescription.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 11)
        cell.lblMonth.font = UIFont(name: "Montserrat-Regular", size: 11)
        cell.lblGeneral.font = UIFont(name: "Montserrat-Medium", size: 15)
      
        cell.UserName = filteredPostData?.listdata?[indexPath.row].username ?? ""
        let text = PostListData?.listdata?[indexPath.row].postemojiunicode?.decodeEmoji
        
   
        
        
        cell.DotCallback = { [weak self] postID in
            guard let self = self else { return }
            if profileData?.verfiedMsg == "User Verification is completed!" {

            // `PostDotViewController` ko storyboard se instantiate karo
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDotViewController") as? PostDotViewController else { return }
            
            // `postID` pass karo
            vc.business_id = postID
            vc.onUpdateForBlock = { [weak self] in
                
            }
            print("✅ Passing Post ID to PostDotViewController: \(postID ?? "No Post ID")")
            
            // Agar `PostListData` available hai to `favouritstatus` bhi pass kar sakte hain
            if let homeData = self.PostListData?.listdata, indexPath.row < homeData.count {
                let selectedPostData = homeData[indexPath.row]
                vc.poststs = selectedPostData.favouritstatus
                vc.createdBy = selectedPostData.createdby
                print("✅ Passing CreatedBy to PostDotViewController: \(selectedPostData.createdby ?? "nil")")
            }
            
            vc.topCornerRadius = 10.0
            vc.presentDuration = 0.2
            vc.dismissDuration = 0.2
            // Callback handle karne ke liye
            vc.callback = { status in
                print("Callback received with status: \(status)")
            }
            
            //MARK: -            callPostListWebService
            
            vc.navigateToDeleteCallback = { [weak self] in
                guard let self = self else { return }
                
                // `postId` aur `userId` fetch karein
                guard let postData = self.PostListData?.listdata?[indexPath.row],
                      let postId = postData.postid,
                      let userId = UserDefaults.standard.string(forKey: "userid") else {
                    print("Post ID or User ID is missing")
                    return
                }
                

            }
            
            
            // Navigate to MessageViewController
            vc.navigateToMDCallback = { [weak self] in
                guard let self = self else { return }
                
                // ✅ `postData` ko yahan define karein
                guard let postData = self.PostListData?.listdata?[indexPath.row] else {
                    print("Post Data not found")
                    return
                }
                
                if let dmVC = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as? MessageViewController {
                    dmVC.otherid = postData.createdby ?? ""
                    dmVC.userName = postData.username ?? ""
                    dmVC.userImage = postData.userpic ?? ""
                    
                    self.navigationController?.pushViewController(dmVC, animated: true)
                }
            }
            vc.navigateToReportCallback = { [weak self] in
                
                guard let self = self else { return }
                if let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportPostViewController") as? ReportPostViewController {
                    // ✅ Ensure `PostListData` is available and index is valid
                    if let postList = self.PostListData?.listdata, indexPath.row < postList.count {
                        let selectedPost = postList[indexPath.row] // ✅ Corrected
                        reportVC.UserName = selectedPost.username ?? ""
                        reportVC.sectorName = selectedPost.neighborhood ?? ""
                        reportVC.MonthName = selectedPost.createdOn ?? ""
                        reportVC.GeneralName = selectedPost.postType ?? ""
                        reportVC.DescriptionlName = selectedPost.postMessage ?? ""
                        reportVC.CommentName = selectedPost.totcomment ?? ""
                        reportVC.likeName = selectedPost.totallike ?? ""
                        
                        // ✅ Extract images and videos properly
                        let imgDataAll = selectedPost.postImages?.compactMap { $0.img }.filter { !$0.isEmpty } ?? []
                        let videoDataAll = selectedPost.postImages?.compactMap { $0.video }.filter { !$0.isEmpty } ?? []
                        
                        print("🖼 Image Data: \(imgDataAll)")
                        print("📹 Video Data: \(videoDataAll)")
                        
                        // Populate mediaData array
                        reportVC.mediaData = selectedPost.postImages ?? []
                        
                        reportVC.postid = postID ?? ""
                        print("✅ Passing Post ID to ReportPostViewController: \(postID ?? "No Post ID")")
                        
                        self.dismiss(animated: true)
                        self.navigationController?.pushViewController(reportVC, animated: true)
                    } else {
                        print("⚠️ Post Data Not Found")
                    }
                }
            }
            
            self.present(vc, animated: true, completion: nil)
            
        }else {
                   // Create the alert controller
                   let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
                   
                   // Define font and color attributes
                   let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
                   let messageAttributes: [NSAttributedString.Key: Any] = [
                       .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                       .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                   ]
                   
                   // Create attributed strings
                   let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
                   let attributedMessage = NSAttributedString(
                       string: "You have limited access till verification is complete. We thank you for your patience.",
                       attributes: messageAttributes
                   )
                   
                   // Set the title and message of the alert
                   alert.setValue(attributedTitle, forKey: "attributedTitle")
                   alert.setValue(attributedMessage, forKey: "attributedMessage")
                   
                   // Add an action to the alert
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                       alert.dismiss(animated: true, completion: nil)
                   }))
                   
                   // Present the alert
                   self.present(alert, animated: true, completion: nil)
               }
        }
   
        
        cell.FullImgCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostEnlargeImageViewController")as! PostEnlargeImageViewController
            vc.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
            
            vc.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
            //  vc.UserimgData = (PostListData?.listdata?[indexPath.row].userpic ?? [])
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        cell.LikeListCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikeListViewController") as! LikeListViewController
            vc.Postid = PostListData?.listdata?[indexPath.row].postid ?? ""
            vc.height = 300
            vc.topCornerRadius = 10.0
            vc.presentDuration = 0.5
            vc.dismissDuration = 0.5
            vc.view.backgroundColor = .white
            
            vc.callback = { range in
                
            }
            
            self.present(vc, animated: true, completion: nil)
            
        }
       
        let url = URL(string: (PostListData?.listdata?[indexPath.row].userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewBusiness"))
          return cell
    }
    
    func didTapProfile(for userId: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        vc.Oid = userId
        print(userId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func didTapCommentsButton(cell: MennuPostTableViewCell) {
        if profileData?.verfiedMsg == "User Verification is completed!" {
            
            // Cell ke indexPath ko fetch karo from the specific table view
            guard let indexPath = self.tableviewPost.indexPath(for: cell) else { // Replace 'myTableView' with your table view IBOutlet name
                print("Error: Unable to fetch indexPath for cell.")
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let postDetailsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailsNewViewController") as? PostDetailsNewViewController {
                // Data pass karo
                postDetailsVC.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
                postDetailsVC.sectorName = PostListData?.listdata?[indexPath.row].neighborhood ?? ""
                postDetailsVC.MonthName = PostListData?.listdata?[indexPath.row].createdOn ?? ""
                postDetailsVC.GeneralName = PostListData?.listdata?[indexPath.row].postType ?? ""
                postDetailsVC.DescriptionlName = PostListData?.listdata?[indexPath.row].postMessage ?? ""
                postDetailsVC.CommentName = PostListData?.listdata?[indexPath.row].totcomment ?? ""
                postDetailsVC.likeName = PostListData?.listdata?[indexPath.row].totallike ?? ""
                postDetailsVC.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
                postDetailsVC.videoData = PostListData?.listdata?[indexPath.row].postImages?.filter { ($0.video ?? "").isEmpty == false } ?? []
                postDetailsVC.postid = PostListData?.listdata?[indexPath.row].postid ?? ""
                // Navigate to PostDetailsNewViewController
                self.navigationController?.pushViewController(postDetailsVC, animated: true)
            }
        }else {
            // Create the alert controller
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            // Define font and color attributes
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            
            // Create attributed strings
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            
            // Set the title and message of the alert
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Add an action to the alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    //MARK: - did selcet
    
    func didSelectItem(with postMedia: PostMedia, username: String, allMedia: [PostMedia]) {
        
        // Agar video hai
        if let videoUrl = postMedia.video, let url = URL(string: videoUrl) {
            let player = AVPlayer(url: url)
            player.isMuted = true
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            present(playerVC, animated: true) {
                player.pause()
            }
            return
        }
        
        // Agar image hai ya collection show karna hai
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as? PostViewShowImgVideosDataVC {
            
            // Map [PostMedia] to [PostDetailsMedia] for the VC
            destinationVC.imgDataAll = allMedia.map { media in
                PostDetailsMedia(img: media.img, video: media.video)
            }
            
            destinationVC.UserName = username
            print("✅ Media successfully passed: \(postMedia)")
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    

 
    
    
    
}


extension MennuPostViewController {
    func callPostListAPI() {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""

        // ✅ Prepare parameters
        let parameters: Parameters = [
            "post_type": "user",
            "page": "1",
            "neighbr_id": "",
            "other_user_id": userId
        ]
        print(parameters)

        // ✅ Call API
        PostListV_M.shared.PostListData(parameters: parameters) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("❌ API Error: \(error)")
                }
                return
            }

            guard let encryptedData = result?.data else {
                DispatchQueue.main.async {
                    print("❌ No encrypted data found")
                }
                return
            }

            // ✅ Decrypt API response
            PostListV_M.shared.PostListDataDecrypt(encryptedString: encryptedData) { decryptResponse in
                guard let decryptResponse = decryptResponse else {
                    DispatchQueue.main.async {
                        print("❌ Failed to decrypt response")
                    }
                    return
                }
                let posts = decryptResponse.data.data.posts
                print("✅ Post Count: \(posts.count)")
                self.postList = posts // ✅ Save posts in variable

                DispatchQueue.main.async {
                    // 🔹 Reload table view always on main!
                    self.tableviewPost.reloadData()
                    for post in posts {
                        print("📄 Post Title: \(post.postTitle)")
                        print("📝 Description: \(post.postDescription)")
                    }
                }
            }
        }
    }
}
