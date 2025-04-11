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
    // emojiLabel.text = "😊🚀🌟"
    private let bottomPanelView = BottomPanelView()
    var PostListData : PostListModel?
    var PostLikeData : LikePostModel?
    var imgEmojiData = [Emojilistdata]()
    var imgData = [PostImage]()
    var filteredPostData: PostListModel?
    var searchWorkItem: DispatchWorkItem?
    var UserName = ""
    var sectorName = ""
    var MonthName = ""
    var GeneralName = ""
    var DescriptionlName = ""
    var deletePost : DeletePostModel?
    
    let items = [
        (id: "1", name: "Item 1"),
        (id: "2", name: "Item 2"),
        (id: "3", name: "Item 3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchView.isHidden = true
        tfSearch.delegate = self
        
        if let selectedIndex = selectedTabIndex {
            bottomPanelView.updateTabAppearance(selectedIndex: selectedIndex)
        }
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // SVProgressHUD.show()
        
        
        callPostListWebService(searchQuery: "") {
            SVProgressHUD.dismiss()
            self.tableviewPost.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
    }
    
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @objc func refreshData() {
        fetchPostListData()
    }

    
    @IBAction func btnSearch(_ : UIButton){

        self.searchView.isHidden = false
        self.lblHeading.isHidden = true

       }
    
    func fetchPostListData() {
        callPostListWebService(searchQuery: "") {
            SVProgressHUD.dismiss()
            self.tableviewPost.reloadData()
        }
    }
    
    @IBAction func btncancelSearch(_ : UIButton){

        self.searchView.isHidden = true
        self.lblHeading.isHidden = false
               self.tfSearch.text = ""
        callPostListWebService(searchQuery: "") {
                   self.tableviewPost.reloadData()
               }

       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           let currentText = textField.text ?? ""
           let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

           // Cancel the previous work item to avoid multiple API calls
           searchWorkItem?.cancel()

           // Create a new work item for the search
           searchWorkItem = DispatchWorkItem {
               // Call the API with the updated search text
               self.callPostListWebService(searchQuery: updatedText) {
                   self.tableviewPost.reloadData()
               }
           }

           // Execute the work item after a delay of 0.5 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchWorkItem!)

           return true
       }
    
    @IBAction func btnCreatePost(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
        
        return filteredPostData?.listdata!.count ?? 0
        
        //BusinessListData?.listdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MennuPostTableViewCell", for: indexPath) as! MennuPostTableViewCell
        cell.delegate = self
        cell.delegateCell = self
        
        
        cell.delegateM = self
        let userId = filteredPostData?.listdata?[indexPath.row].createdby
        cell.userId = userId
        
        
        cell.lblName.text = filteredPostData?.listdata?[indexPath.row].username
        //  cell.lblGeneral.text = PostListData?.listdata[indexPath.row].postType
        cell.lblGeneral.text = filteredPostData?.listdata?[indexPath.row].postType
        cell.lblDescription.text = filteredPostData?.listdata?[indexPath.row].postMessage
        //  cell.lblSec.text = PostListData?.listdata[indexPath.row].neighborhood
        cell.lblSec.text = filteredPostData?.listdata?[indexPath.row].neighborhood
        cell.lblMonth.text = filteredPostData?.listdata?[indexPath.row].createdOn
        cell.lblLikeCount.text = filteredPostData?.listdata?[indexPath.row].totallike
        cell.lblCommentCount.text = filteredPostData?.listdata?[indexPath.row].totcomment
        
        
        cell.lblDescription.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 11)
        cell.lblMonth.font = UIFont(name: "Montserrat-Regular", size: 11)
        cell.lblGeneral.font = UIFont(name: "Montserrat-Medium", size: 15)
        cell.imgData = filteredPostData?.listdata?[indexPath.row].postImages ?? []
        cell.UserName = filteredPostData?.listdata?[indexPath.row].username ?? ""
        let text = PostListData?.listdata?[indexPath.row].postemojiunicode?.decodeEmoji
        
        
        if let favouriteStatus = PostListData?.listdata?[indexPath.row].favouritstatus {
            cell.updateFavouriteButton(isFavourite: favouriteStatus == 1)
        } else {
            cell.updateFavouriteButton(isFavourite: false) // Default to non-favorite
        }

        
        
        
        cell.favouriteButtonCallback = { [weak self] in
            guard let self = self else { return }
            
            // Get the current post data
            guard var mutablePostData = self.PostListData?.listdata?[indexPath.row] else { return }
            
            guard let postId = mutablePostData.postid, !postId.isEmpty else { return }
            
            if mutablePostData.favouritstatus == 1 {
                // Unfavourite Action
                self.callFavouriteRemoveBussinessWebService(postId: postId) { message in
                    mutablePostData.favouritstatus = 0 // Update status
                    cell.updateFavouriteButton(isFavourite: false) // Update button icon
                    self.showAlert(Message: message) // Show alert
                }
            } else {
                // Favourite Action
                self.callFavouriteBussinessWebService(postId: postId) { message in
                    mutablePostData.favouritstatus = 1 // Update status
                    cell.updateFavouriteButton(isFavourite: true) // Update button icon
                    self.showAlert(Message: message) // Show alert
                }
            }
        }
        
        
        
        cell.DotCallback = { [weak self] postID in
            guard let self = self else { return }
            
            // `PostDotViewController` ko storyboard se instantiate karo
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDotViewController") as? PostDotViewController else { return }
            
            // `postID` pass karo
            vc.business_id = postID
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
                
                // Delete post API call karein
                self.callDeletePostWebService(postId: postId, userId: userId) {
                    print("Post Deleted Successfully")
                    
                    // Popup dismiss karein
                    vc.dismiss(animated: true)
                    
                    // Success message show karein
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success", message: "Post Deleted Successfully", preferredStyle: .alert)
                        self.present(alert, animated: true)
                        
                        // Alert 2 second ke baad dismiss karein
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            alert.dismiss(animated: true)
                            self.callPostListWebService(searchQuery: "") {
                                self.tableviewPost.reloadData()
                            }
                        }
                    }
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
        }
        
        
        
        //        cell.emojiAction = { emoji in
        //            print(emoji ?? "")
        //            let emo = emoji ?? ""
        //            self.callPostLikeWebService(postId: self.PostListData?.listdata?[indexPath.row].postid, emoji: emoji, { [self] in
        //
        //                callPostListWebService{
        //                    SVProgressHUD.dismiss()
        //                    self.tableviewPost.reloadData()
        //
        //
        //                    // Do any additional setup after loading the view.
        //                }
        //            })
        //
        //               }
        //
        //
        
        
        //        cell.CommentCallback = { [self] value in
        //
        //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController")as! PostDetailsViewController
        //            vc.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
        //          //  vc.sectorName =  PostListData?.listdata![indexPath.row].neighborhood ?? ""
        //            vc.sectorName = PostListData?.listdata?[indexPath.row].neighborhood ?? ""
        //            vc.MonthName = PostListData?.listdata?[indexPath.row].createdOn ?? ""
        //            vc.GeneralName = PostListData?.listdata?[indexPath.row].postType ?? ""
        //         //   vc.GeneralName =  PostListData?.listdata?[indexPath.row].postType ??
        //            vc.DescriptionlName = PostListData?.listdata?[indexPath.row].postMessage ?? ""
        //            vc.CommentName =  PostListData?.listdata?[indexPath.row].totcomment ?? ""
        //            vc.likeName = PostListData?.listdata?[indexPath.row].totallike ?? ""
        //            vc.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
        //            vc.videoData = PostListData?.listdata?[indexPath.row].postImages?.filter { ($0.video ?? "").isEmpty == false } ?? []
        //          //  vc.UserimgData = (PostListData?.listdata?[indexPath.row].userpic ?? [])
        //            self.navigationController?.pushViewController(vc, animated: true)
        //
        //        }
        
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
        // Cell ke indexPath ko fetch karo from the specific table view
        guard let indexPath = self.tableviewPost.indexPath(for: cell) else { // Replace 'myTableView' with your table view IBOutlet name
            print("Error: Unable to fetch indexPath for cell.")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let postDetailsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailsViewController") as? PostDetailsViewController {
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
            // Navigate to PostDetailsViewController
            self.navigationController?.pushViewController(postDetailsVC, animated: true)
        }
        
        
    }
    
    
    //MARK: - did selcet
    
    func didSelectItem(with postImage: PostImage, username: String, allImages: [PostImage]) {
        if let videoUrl = postImage.video, let url = URL(string: videoUrl) {
            let player = AVPlayer(url: url)
            player.isMuted = true // ✅ By default video mute rahega
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.pause()
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationVC = storyboard.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as? PostViewShowImgVideosDataVC {
                // Pass the selected image/video and username
                destinationVC.imgData = allImages
                destinationVC.UserName = username
                print("✅ Image successfully passed: \(postImage)")
                // Navigate to the next view controller
                self.navigationController?.pushViewController(destinationVC, animated: true)
            } else {
                print("❌ Failed to instantiate PostViewShowImgVideosDataVC")
            }
        }
    }
    
    
    
     
    
    func callPostListWebService(searchQuery: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "" ,
            "postlist": "postlist",]
        WebService.sharedInstance.callPostListWebService(withParams: dictParams) { data in
            self.PostListData = data
            
            // Filter the GroupListData based on the search query
            if searchQuery.isEmpty {
                self.filteredPostData = self.PostListData // No filtering if search is empty
            } else {
                self.filteredPostData = PostListModel(
                    status: data.status,
                    message: data.message,
                    verfiedMsg: data.verfiedMsg, // Corrected property name
                    listdata: data.listdata?.filter {
                        $0.postMessage?.lowercased().contains(searchQuery.lowercased()) ?? false // Safely unwrap optional
                    }
                )
            }
            
            // Reload the table view after filtering the data
            completionClosure()
            self.tableviewPost.reloadData()
        }
    }
        
        
    @objc private func emojiTapped(sender: UIButton) {
        callPostUnLikeWebService{
            self.tableviewPost.reloadData()
        }
    }
    
    func callPostLikeWebService(postId : String?,emoji : String?, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "" ,
            "postid":postId ?? "",
            "likestatus": "1",
            "emojiunicode": emoji ?? "",
        ]
        
        WebService.sharedInstance.callPostLikeWebService(withParams: dictParams) { data in
            self.PostLikeData = data
            
            completionClosure()
        }
    }
    
    func callPostUnLikeWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "" ,
            "postid":idPost ?? "",
            "likestatus": "0",
            "emojiunicode":  "",
        ]
        
        WebService.sharedInstance.callPostUnLikeWebService(withParams: dictParams) { data in
            
            
            completionClosure()
        }
    }
    
    
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
    
    
    
    
    // MARK: - Call api delete for post
    func callDeletePostWebService(postId: String, userId: String, _ completionClosure: @escaping () -> ()) {
        let dictParams: Dictionary<String, Any> = [
            "userid": userId,
            "postid": postId
        ]
        print(dictParams)
        
        WebService.sharedInstance.callDeletePostWebService(withParams: dictParams) { data in
            self.deletePost = data
            completionClosure()
        }
    }
    
    
    
}
