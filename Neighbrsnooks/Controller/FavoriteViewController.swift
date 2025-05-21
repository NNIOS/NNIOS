//
//  FavoriteViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 01/03/24.
//

import UIKit
import SVProgressHUD
import AVFoundation
import AVKit
@available(iOS 16.0, *)
class FavoriteViewController: BaseViewController, FavoriteTableViewCellDelegate {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    var profileData : ProfileModel?
    var PostListData : PostListModel?
    var FavoriteListData : FavouriteListModel?
    var imgDataF = [PostImageF]()
    var deletePost : DeletePostModel?
    var sortedSections: [(type: String, items: [Any])] = []
    //    var NeighData = [NeighbrhoodF]()
    private let bottomPanelView = BottomPanelView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        callFavouriteListPostWebService{
        SVProgressHUD.dismiss()
        self.tableviewMembers.reloadData()
     
        }
        NetworkMonitor.shared.startMonitoring()
        
        // Initialize the refresh control page
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPageAction), for: .valueChanged)
        
        // Add the refresh control to your UITableView or UICollectionView
        tableviewMembers.refreshControl = refreshControl
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndex = selectedTabIndex {
                       bottomPanelView.updateTabAppearance(selectedIndex: selectedIndex)
                   }
       // SVProgressHUD.show()
        
        
        callFavouriteListPostWebService{
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
    }
    
    
    
    func refreshPage() {
        // Start loading data again (Web service calls)
        callFavouriteListPostWebService {
            // This closure will be called once the user profile data is loaded
           
                // This closure will be called once the post list data is loaded
               
                    // After all the web service calls are completed, reload the UI
                    self.tableviewMembers.reloadData()
                    
                    // Stop the refresh control spinner once everything is loaded
                    self.tableviewMembers.refreshControl?.endRefreshing()
                }
            
       
    }

    // To trigger the refresh, you can call this function when needed
    func triggerPageRefresh() {
        refreshPage()
    }
    // @objc function for triggering the refresh
    @objc func refreshPageAction() {
        refreshPage() // This will refresh the page data
    }
    
    
    
     func callFavouriteListPostWebService(_ completionClosure: @escaping () -> ()) {
         self.prepareSortedData(favModel: self.FavoriteListData)  // Ensure it's using updated data
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let dictParams: Dictionary<String, Any> = [
                                                  "userid":id ?? "" ,
                                                 // "neighbrhood":idNeighbour ?? "",
        ]
          WebService.sharedInstance.callFavouriteListPostWebService(withParams: dictParams) { data in
            self.FavoriteListData = data
            
              self.prepareSortedData(favModel: self.FavoriteListData)  // Ensure it's using updated data
            completionClosure()
          }
        }
    
    
    // MARK: - Call api delete for post
    
    func callDeletePostWebService(postId: String, userId: String, _ completionClosure: @escaping () -> ()) {
        let dictParams: Dictionary<String, Any> = [
            "userid": userId,
            "postid": postId
        ]
        
        WebService.sharedInstance.callDeletePostWebService(withParams: dictParams) { data in
            self.deletePost = data
            completionClosure()
        }
    }
    

}

@available(iOS 16.0, *)
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate, FavTableViewCellDelegate, BussFavDelegate {
    
    
    
    
    func prepareSortedData(favModel: FavouriteListModel?) {
        guard let favModel = favModel else {
            print("❌ homeModel is NIL")
            return
        }
        
        let data = favModel.listdata
        
        // Check if the listdata is empty
        if data.isEmpty {
            print("❌ listdata is EMPTY")
            return
        }
        
        print("✅ listdata found, Count: \(data.count)")
        
        sortedSections.removeAll()
        
        // **Maintain Exact API Order**
        for item in data {
            let type = item.type ?? "" // ✅ Optional handling
            sortedSections.append((type, [item])) // ✅ Correct tuple format
            print("✅ Section Added: \(type) - Count: 1 (Individual Item)")
        }
        
        print("🔢 Total Sections: \(sortedSections.count)")
        print("🟡 Final Sorted Sections: \(sortedSections)")
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("🔢 Total Sections: \(sortedSections.count)")
        return sortedSections.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = sortedSections[section]
        print("📌 Section \(section) - \(sectionData.0): Rows Count = \(sectionData.1.count)")
        return sectionData.1.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = sortedSections[indexPath.section] // Access sectionData based on indexPath.section
        let item = sectionData.1[indexPath.row]
        switch sectionData.0 {
        case "Post":
            print("🟢 Calling Post Cell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
            //  var postData = FavoriteListData?.listdata.filter { $0.type == "Post" }[indexPath.row]
            if let postData = item as? FavoriteListData {
                // Configure the cell using postData
                cell.delegateCell = self // Delegate assign karo
                cell.delegate = self
                cell.lblName.text = postData.username
                cell.delegateFav = self
                cell.userId = postData.createdby
                cell.lblGeneral.text = postData.postType
                cell.lblDescription.text = postData.postMessage
                cell.lblSec.text = postData.neighborhood
                cell.lblMonth.text = postData.createdOn
                cell.lblLikeCount.text = postData.totallike
                cell.lblCommentCount.text = postData.totcomment
                cell.configureDescription(with: postData.postMessage ?? "N/A")
                cell.addTapGestureToLabel()
                let url = URL(string: (postData.userpic ?? ""))
                cell.profileImgView.kf.indicatorType = .activity
                cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "NewBusiness"))
                
                cell.imgData = postData.postImagesN ?? []
                cell.UserName = postData.username ?? ""
                
                cell.shareAction = { [weak self] in
                    // Share action logic here
                }
                
                if traitCollection.userInterfaceStyle == .dark {
                       cell.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1) // Dark mode background  // Dark mode background
                   } else {
                       cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1) // Light mode background
                   }

                // Update button icon based on favouritstatus
                cell.updateFavouriteButton(isFavourite: postData.favouritstatus == 1)
                
                // Handle Favourite Button Tap
                cell.favouriteButtonCallback = { [weak self] in
                    guard let self = self else { return }
                    
                    // Fetch mutable copy of postData
                    guard var postData = self.sortedSections[indexPath.section].items[indexPath.row] as? FavoriteListData else { return }
                    
                    guard let postId = postData.postid, !postId.isEmpty else { return }
                    
                    if postData.favouritstatus == 1 {
                        // Unfavourite Action
                        self.callFavouriteRemoveBussinessWebService(postId: postId) { message in
                            postData.favouritstatus = 0 // Update status
                            cell.updateFavouriteButton(isFavourite: false) // Update button icon
                            self.showAlert(message: message) // Show alert
                        }
                    } else {
                        // Favourite Action
                        self.callFavouriteBussinessWebService(postId: postId) { message in
                            postData.favouritstatus = 1 // Update status
                            cell.updateFavouriteButton(isFavourite: true) // Update button icon
                            self.showAlert(message: message) // Show alert
                        }
                    }
                }
                
                
                
               
                
                cell.FullImgCallback = { [self] value in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteImageEnlargementViewController") as! FavouriteImageEnlargementViewController
                    vc.UserName = postData.username ?? ""
                    vc.imgDataF = postData.postImagesN ?? []
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                //            if FavoriteListData?.emojiStatus == "0" {
                //                cell.HeartImgView.image = UIImage(systemName: "heart")
                //
                //            } else if FavoriteListData?.postlike == "1" {
                //
                //               // cell.HeartImgView.image = UIImage(systemName: "heart")
                //                cell.HeartImgView.isHidden = true
                //
                //            }
                
                cell.LikeListCallback = { [self] value in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikeListViewController") as! LikeListViewController
                    vc.Postid = postData.postid ?? ""
                    vc.height = 300
                    vc.topCornerRadius = 10.0
                    vc.presentDuration = 0.5
                    vc.dismissDuration = 0.5
                    vc.view.backgroundColor = .white
                    self.present(vc, animated: true, completion: nil)
                }
                // like code
                //            if postData?.postlike == "0" {
                //                cell.HeartImgView.image = UIImage(systemName: "heart")
                //            } else if postData?.postlike == "1" {
                //                cell.HeartImgView.isHidden = true
                //            }
                
                
                
                cell.userId = postData.createdby
                print("✅ PostData CreatedBy: \(postData.createdby ?? "nil")")
                let createdByUser = postData.createdby
                
                cell.DotCallback = { [weak self] value in
                    guard let self = self else { return }
                    
                    // Ensure PostListData and listdata are non-nil and indexPath.row is valid
                    guard let postListData = self.FavoriteListData?.listdata, indexPath.row < postListData.count else { return }
                    
                    // Safely unwrap PostDotViewController
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDotViewController") as? PostDotViewController else { return }
                    
                    // Pass required data to PostDotViewController
                    vc.business_id = postListData[indexPath.row].postid
                    vc.poststs = postListData[indexPath.row].favouritstatus
                    vc.createdBy = createdByUser
                    vc.height = 250
                    vc.topCornerRadius = 10.0
                    vc.presentDuration = 0.5
                    vc.dismissDuration = 0.5
                    vc.view.backgroundColor = .white
                    // Configure callback to handle actions in PostDotViewController
                    vc.callback = { status in
                        print("Callback received with status: \(status)")
                    }
                    
                    // Navigate to ReportPostViewController
                    vc.navigateToReportCallback = { [weak self] in
                        guard let self = self else { return }

                        if let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportPostViewController") as? ReportPostViewController {
                            
                            let selectedPost = postListData[indexPath.row] // Yaha se direct fetch karo
                            
                            reportVC.UserName = selectedPost.username ?? ""
                            reportVC.sectorName = selectedPost.neighborhood ?? ""
                            reportVC.MonthName = selectedPost.createdOn ?? ""
                            reportVC.GeneralName = selectedPost.postType ?? ""
                            reportVC.DescriptionlName = selectedPost.postMessage ?? ""
                            reportVC.CommentName = selectedPost.totcomment ?? ""
                            reportVC.likeName = selectedPost.totallike ?? ""
                            reportVC.postid = selectedPost.postid ?? ""

                            reportVC.mediaData = selectedPost.postImagesN?.map { postImageF in
                                PostImage(img: postImageF.img, video: postImageF.video)
                            } ?? []

                            print("✅ Passing Media Data for Post ID: \(selectedPost.postid ?? "No ID")")
                            
                            self.dismiss(animated: true)
                            self.navigationController?.pushViewController(reportVC, animated: true)
                        }
                    }




                    
//                    // Handle delete action
//                    vc.navigateToMDCallback = { [weak self] in
//                        guard let self = self else { return }
//                        guard let postId = postListData[indexPath.row].postid,
//                              let userId = UserDefaults.standard.string(forKey: "userid") else {
//                            print("Post ID or User ID is missing")
//                            return
//                        }
//                        self.callDeletePostWebService(postId: postId, userId: userId) {
//                            print("Post Deleted Successfully")
//                        }
//                    }
                    
                    
                    vc.navigateToDeleteCallback = { [weak self] in
                        guard let self = self else { return }
                        
                        // Fetching postId and userId
                        guard let postId = postListData[indexPath.row].postid,
                              let userId = UserDefaults.standard.string(forKey: "userid") else {
                            print("Post ID or User ID is missing")
                            return
                        }
                        
                        // Call the delete post service
                        self.callDeletePostWebService(postId: postId, userId: userId) {
                            print("Post Deleted Successfully")
                            
                            // Popup hide karna
                            self.dismiss(animated: true)
                            
                            // Message dikhana
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Success", message: "Post Deleted Successfully", preferredStyle: .alert)
                                self.present(alert, animated: true)
                                
                                // 2 second ke baad alert dismiss karna
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    alert.dismiss(animated: true)
                                    self.callFavouriteListPostWebService{
                                        self.tableviewMembers.reloadData()
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    vc.navigateToMDCallback = { [weak self] in
                       guard let self = self else { return }
                       if let dmVC = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as? MessageViewController {
                           
                           dmVC.otherid = postData.createdby ?? ""
                           dmVC.userName = postData.username ?? ""
                           dmVC.userImage = postData.userpic ?? ""
                           
                           self.navigationController?.pushViewController(dmVC, animated: true)
                       }
                   }

                    
                    
                    
                    // Present PostDotViewController
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
                // ... (the rest of the Post cell configuration)
                return cell
            
        case "Poll":
            print("🟢 Calling Poll Cell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollsTableViewCell", for: indexPath) as! PollsTableViewCell
            //            let pollData = FavoriteListData?.listdata.filter { $0.type == "Poll" }[indexPath.row]
            if let pollData = item as? FavoriteListData {
                // Configure the cell using pollData
                
                
                cell.lblCreaterName.text = pollData.username
                // ... (the rest of the Poll cell configuration)
                cell.lblSec.text = pollData.neighborhood
                cell.lblPolls.text = pollData.pollQuestion
                cell.lblStartDate.text = pollData.createdby
                cell.lblEndDate.text = pollData.pollEndDate
                cell.lblFavorite.text = pollData.isvoted
                cell.delegateFav = self
                cell.userId = pollData.createdby
                
                cell.lblCreaterName.font = UIFont(name: "Montserrat-Medium", size: 13)
                cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.lblPolls.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.lblStartDate.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.lblEndDate.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.lblFavorite.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.lblStart.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.lblEnd.font = UIFont(name: "Montserrat-Regular", size: 13)
                
                if traitCollection.userInterfaceStyle == .dark {
                       cell.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1) // Dark mode background  // Dark mode background
                   } else {
                       cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1) // Light mode background
                   }
                
                let url = URL(string: (pollData.userpic ?? ""))
                cell.profileImgView.kf.indicatorType = .activity
                cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "NewBusiness"))
                
                cell.DetailsCallback = { [weak self] value in
                    guard let strongSelf = self else { return }
                    let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "PollsDetailViewController") as! PollsDetailViewController
                    vc.pollid = pollData.pollid ?? ""
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                }
                
                
                cell.DotCallback = { [self] value in
                    
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollDotViewController") as? PollDotViewController else {return}
                    // vc.business_id = business_id
                    //   vc.business_id = postListData[indexPath.row].postid
                    vc.business_id = pollData.pollid ?? ""
                    vc.height = 150
                    vc.topCornerRadius = 10.0
                    vc.presentDuration = 0.5
                    vc.dismissDuration = 0.5
                    vc.view.backgroundColor = .white
                    
                    
                    
                    vc.callback = { range in
                        
                    }
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
                
                
                
            }
                
                
                return cell
            
        case "Business":
            print("🟢 Calling Business Cell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "BussFavTableViewCell", for: indexPath) as! BussFavTableViewCell
            //            let businessData = FavoriteListData?.listdata.filter { $0.type == "Business" }[indexPath.row]
            if let businessData = item as? FavoriteListData {
                cell.delegate = self
                // Configure the cell using businessData
                cell.lblUserName.text = businessData.username
                // ... (the rest of the Business cell configuration)
                cell.lblSector.text = businessData.neighborhood
                cell.lblProduct.text = businessData.businessName
                cell.lblHealth.text = businessData.category
                cell.delegateFav = self
                cell.userId = businessData.createdby
                
                cell.lblUserName.font = UIFont(name: "Montserrat-SemiBold", size: 15)
                cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 15)
                cell.lblProduct.font = UIFont(name: "Montserrat-SemiBold", size: 15)
                cell.lblHealth.font = UIFont(name: "Montserrat-Regular", size: 15)
                
                if traitCollection.userInterfaceStyle == .dark {
                       cell.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1) // Dark mode background  // Dark mode background
                   } else {
                       cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1) // Light mode background
                   }
                //  cell.lblRating.font = UIFont(name: "Montserrat-SemiBold", size: 14)
                
                let url = URL(string: (businessData.userpic ?? ""))
                cell.BussinessImgView.kf.indicatorType = .activity
                cell.BussinessImgView.kf.setImage(with: url, placeholder: UIImage(named: "NewBusiness"))
                
                cell.FavoriteListData = businessData.businessImage?.map {
                    BusinessImage(img: $0.img, video: $0.video)
                } ?? []
                
                
                
                
                cell.DotCallback = { [self] value in
                    
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDotViewController") as? BusinessDotViewController else {return}
                    vc.business_id = businessData.bID ?? ""
                    vc.height = 150
                    vc.topCornerRadius = 10.0
                    vc.presentDuration = 0.5
                    vc.dismissDuration = 0.5
                    vc.view.backgroundColor = .white
                    
                    
                    
                    vc.callback = { range in
                        
                    }
                    
                    self.present(vc, animated: true, completion: nil)
                    
                    
                }
                
                
                
                //            let urlB = URL(string: (businessData?.businessImage?.first?.img ?? ""))
                //            cell.BussinessImgView.kf.indicatorType = .activity
                //            cell.BussinessImgView.kf.setImage(with: urlB, placeholder: UIImage(named: "NewBusiness"))
                //
                cell.DetailsCallback = { [self] value in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as! BusinessDetailsViewController
                    vc.business_id = businessData.bID ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                cell.DotCallback = { [self] value in
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDotViewController") as? BusinessDotViewController else { return }
                    vc.business_id = FavoriteListData?.listdata[indexPath.row].bID ?? ""
                    vc.height = 200
                    vc.topCornerRadius = 10.0
                    vc.presentDuration = 0.5
                    vc.dismissDuration = 0.5
                    vc.view.backgroundColor = .white
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
                return cell
            
            
        case "Event":
            print("🟢 Calling Event Cell")
            //  let dataSource = isSearching ? filteredData : HomeNewData
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventHomeTableViewCell", for: indexPath) as! EventHomeTableViewCell
            //                    let eventData = FavoriteListData?.listdata.filter { $0.type == "Event" }[indexPath.row]
            if let eventData = item as? FavoriteListData {
                // Configure the cell using businessData
                cell.lblName.text = eventData.username
                cell.lblCreateOn.text = eventData.createdOn
                cell.lblSector.text = eventData.neighborhood
                cell.lblEventTitle.text = eventData.eventName
                
                cell.lblStartDate.text = eventData.eventStartDate
                cell.lblEndDate.text = eventData.eventEndDate
                
                cell.delegateFav = self
                cell.userId = eventData.createdby
                
                cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 16)
                cell.lblCreateOn.font = UIFont(name: "Montserrat-Regular", size: 10)
                cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblEventTitle.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblStartDate.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblEndDate.font = UIFont(name: "Montserrat-Regular", size: 14)
                
                let url = URL(string: (eventData.eventCoverImage ?? ""))
                cell.BannerImgView.kf.indicatorType = .activity
                cell.BannerImgView.kf.setImage(with:url ,placeholder: UIImage(named: "EventImage"))
                
                let urlBan = URL(string: (eventData.userpic ?? ""))
                cell.ProfileImgView.kf.indicatorType = .activity
                cell.ProfileImgView.kf.setImage(with:urlBan ,placeholder: UIImage(named: "defaultImage"))
                print(eventData.eventid)
                
                if traitCollection.userInterfaceStyle == .dark {
                       cell.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1) // Dark mode background  // Dark mode background
                   } else {
                       cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1) // Light mode background
                   }
                
                
                // MARK: - Call for button push toh eventDitails
                cell.eventCallAction = { [weak self] value in
                    guard let self = self else { return }
                    guard let postListData = self.FavoriteListData?.listdata, indexPath.row < postListData.count else { return }
                    
                    // Safely unwrap PostDotViewController
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController") as? EventsDetailViewController else { return }
                    vc.eventid = eventData.eventid ?? ""
                      self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                
                cell.DotFCallback = { [weak self] value in
                    guard let self = self else { return }
                    
                    
                    // Ensure PostListData and listdata are non-nil and indexPath.row is valid
                    guard let postListData = self.FavoriteListData?.listdata, indexPath.row < postListData.count else { return }
                    
                    // Safely unwrap PostDotViewController
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventThreeDotViewController") as? EventThreeDotViewController else { return }
                    
                    // Set properties for PostDotViewController
                    vc.business_id = eventData.eventid
                    vc.poststs = postListData[indexPath.row].favouritstatus // Make sure 'favouritstatus' is an Int
                    print(eventData.eventid)
                    
                    
                    // Configure PostDotViewController appearance and presentation
                    vc.height = 150
                    vc.topCornerRadius = 10.0
                    vc.presentDuration = 0.2
                    vc.dismissDuration = 0.2
                    vc.view.backgroundColor = .white
                    
                    // Modify the callback to accept an 'Int' instead of 'Range<Int>' (if required)
                    vc.callback = { status in
                        // Handle the status (status should be an Int, not Range<Int>)
                        print("Callback received with status: \(status)")
                    }
                    
                    
                    // Present PostDotViewController
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
            return cell
            
            
        case "Group":
            print("🟢 Calling Group Cell")
            //  let dataSource = isSearching ? filteredData : HomeNewData
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            //  let GroupsData = FavoriteListData?.listdata.filter { $0.type == "Group" }[indexPath.row]
            if let groupsData = item as? FavoriteListData {
                // Configure the cell using businessData
                cell.lblName.text = groupsData.username
                cell.lblGroupName.text = groupsData.groupName
                cell.lblPrivate.text = groupsData.groupType
                cell.lblSec.text = groupsData.neighborhood
                cell.lblTime.text = groupsData.createdOn
                
                cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 16)
                cell.lblGroupName.font = UIFont(name: "Montserrat-Regular", size: 13)
                
                cell.lblPrivate.font = UIFont(name: "Montserrat-Regular", size: 15)
                cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.lblTime.font = UIFont(name: "Montserrat-Regular", size: 13)
                
                let url = URL(string: (groupsData.groupImage ?? ""))
                cell.profileImgView.kf.indicatorType = .activity
                cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "NewBusiness"))
                
                let urlBan = URL(string: (groupsData.userpic ?? ""))
                cell.UserImgView.kf.indicatorType = .activity
                cell.UserImgView.kf.setImage(with:urlBan ,placeholder: UIImage(named: "defaultImage"))
                
                cell.delegateFav = self
                cell.userId = groupsData.createdby
                
                if traitCollection.userInterfaceStyle == .dark {
                       cell.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1) // Dark mode background  // Dark mode background
                   } else {
                       cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1) // Light mode background
                   }
                
                cell.DotCallback = { [weak self] value in
                    guard let self = self else { return }
                    if profileData?.verfiedMsg == "User Verification is completed!" {
                        
                        // Ensure PostListData and listdata are non-nil and indexPath.row is valid
                        guard let postListData = self.FavoriteListData?.listdata, indexPath.row < postListData.count else { return }
                        
                        // Safely unwrap PostDotViewController
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupThreeDotViewController") as? GroupThreeDotViewController else { return }
                        
                        // Set properties for PostDotViewController
                        vc.business_id = groupsData.groupid
                        vc.poststs = postListData[indexPath.row].favouritstatus // Make sure 'favouritstatus' is an Int
                        print(groupsData.groupid)
                        // Configure PostDotViewController appearance and presentation
                        vc.height = 150
                        vc.topCornerRadius = 10.0
                        vc.presentDuration = 0.2
                        vc.dismissDuration = 0.2
                        vc.view.backgroundColor = .white
                        
                        // Modify the callback to accept an 'Int' instead of 'Range<Int>' (if required)
                        vc.callback = { status in
                            // Handle the status (status should be an Int, not Range<Int>)
                            print("Callback received with status: \(status)")
                        }
                        
                        
                        // Present PostDotViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        
                        let alert = UIAlertController(title: "", message: "Your have limited access till verification is complete. We thank you for your patience.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            // Dismiss the popup
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }

    

    // MARK: - FavoriteTableViewCellDelegate
    func didTapCommentsButton(cell: FavoriteTableViewCell) {
        DispatchQueue.main.async { [self] in
            guard let indexPath = self.tableviewMembers.indexPath(for: cell) else {
                print("Error: Unable to fetch indexPath for cell.")
                return
            }
            
            // Filter the data for posts
            let filteredData = FavoriteListData?.listdata.filter { $0.type == "Post" }
            guard let selectedPost = filteredData?[indexPath.row] else {
                print("Error: Unable to fetch post data for index \(indexPath.row)")
                return
            }
            
            // Push PostDetailsNewViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let postDetailsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailsNewViewController") as? PostDetailsNewViewController {
                // Data pass karo
                postDetailsVC.postid = selectedPost.postid ?? ""
                print("Passing Post ID: \(postDetailsVC.postid)")
                self.navigationController?.pushViewController(postDetailsVC, animated: true)
            }
        }
    }



    
    
    
    func didSelectItem(with postImage: PostImageF, username: String, allImages: [PostImageF]) {
        if let videoUrl = postImage.video, let url = URL(string: videoUrl) {
            let player = AVPlayer(url: url)
            player.isMuted = true // ✅ By default video mute rahega
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true) {
                player.pause()
            }
        } else if let imageUrl = postImage.img, !imageUrl.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as! PostViewShowImgVideosDataVC
            
            // ✅ Pura array pass kar rahe hain
            destinationVC.imgDataF = allImages
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    
    
    
    func didSelectItem(with bussImage: BusinessImage) {
        if let videoUrl = bussImage.video, let url = URL(string: videoUrl) {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.play()
            }
        } else if let imageUrl = bussImage.img, !imageUrl.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as! PostViewShowImgVideosDataVC
//            destinationVC.imgData = [PostImage(img: bussImage.img, video: bussImage.video)] // Correct data pass
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    

}







extension String {
    var decodeEmojiFav: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}


@available(iOS 16.0, *)
extension FavoriteViewController {
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

@available(iOS 16.0, *)
extension FavoriteViewController: ProfileFavTapDelegate {
    func didTapProfile(userId: String) {
        print("🔵 Profile Tapped for UserID: \(userId)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
            profileVC.Oid = userId  // 🟢 Pass UserID
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
}
