//
//  HomeViewController.swift
//  NeighbrsNook Latest
//
//  Created on 01/03/24.
//

import UIKit
import SVProgressHUD
import AVFoundation
import AVKit
import FirebaseMessaging
@available(iOS 16.0, *)
class HomeViewController: BaseViewController, UITextFieldDelegate, BussinessTableViewCellDelegate {
    
    @IBOutlet weak var tableviewMember: UITableView!
    @IBOutlet weak var SectorLbl: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var sideMenu: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var veriyfiedView: UIView!
    @IBOutlet weak var imgVeriyfied: UIImageView!
    @IBOutlet weak var lblVeriyfied: UILabel!
    @IBOutlet weak var lblWelcomeVeriyfied: UILabel!
    
    var isFromProfile: Bool?
    var isSearching = false
    var Neighbourname : String! = nil
    var userid : String?
    var id : String?
    
    var selectedNeighborhoodId: String?
    var PopupVerifyData : PopUpVerificationModel?
    var deletePost : DeletePostModel?
    var savedProfileData: ProfileModel?
    var savedUploadedDocuments: UploadedDocumentsModel?
    var likeListModel : LikeListModel?
    private var activityIndicator: UIActivityIndicatorView?
    var loaderView: UIView?
    var currentPage = 1
    var isLoading = false // Prevent duplicate API calls
    var isLastPage = false // To determine if all data is loaded
    var isExpanded = false // Track if description is expanded or collapsed
    var dimmingLayer: UIView?
    var timer: Timer?
    var fireBaseToken : UpdateTokenModel?
    var welcomeIDList: [String] = []
    var bookay_Status:Int?
    var like_Status:Int?
    var isHomePageLoadedOnce = false
    var apiCallCount = 0
    var tableReloadCount = 0
    var userGivenLike = Set<String>()
    var userGivenBookay = Set<String>()
    var sortedSections: [(String, [Any])] = []
    var homeDataNewModel: HomeModelDecrypt?
    let refreshControl = UIRefreshControl()
    var imgDataAll: [HomePostMedia] = []
    var memberData: [HomePostItem] = []

    
    var userProfileData: UserData?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewMember.showsVerticalScrollIndicator = false
        tableviewMember.delegate = self
        tableviewMember.dataSource = self
        veriyfiedView.layer.shadowColor = UIColor.black.cgColor
        veriyfiedView.layer.shadowOpacity = 0.3
        veriyfiedView.layer.shadowOffset = CGSize(width: 0, height: 2)
        veriyfiedView.layer.shadowRadius = 4
        // Add view and hide initially
        self.view.addSubview(self.veriyfiedView)
        veriyfiedView.isHidden = true
        self.additionalSafeAreaInsets.top = -view.safeAreaInsets.top

        NetworkMonitor.shared.startMonitoring()
        self.searchView.isHidden = true
        tfSearch.delegate = self
        fetchHomeData(search: nil) {
            DispatchQueue.main.async {
                self.tableviewMember.reloadData()
            }
        }
        self.SectorLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.lblWelcomeVeriyfied.font = UIFont(name: "Montserrat-Medium", size: 25)
        lblVeriyfied.textColor = #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        fetchHomeData()
        fetchUserProfileAtHome()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHomeDataFromNotification), name: NSNotification.Name("RefreshHomePageNotification"), object: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let userID = UserDefaults.standard.string(forKey: "userid") {
                Messaging.messaging().token { token, error in
                    if let token = token {
                        //                        self.callUpdateFirebaseTokenPostWebServiceDirect(userId: userID, firebaseToken: token) {
                        //                            print("🎯 Token updated from viewDidLoad with direct URL")
                        //                        }
                    } else if let error = error {
                        print("❌ Firebase token fetch error: \(error)")
                    }
                }
            }
        }
        
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
           tableviewMember.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchView.isHidden = true
        print(userProfileData)
        fetchHomeData(search: nil) {
            DispatchQueue.main.async {
                self.tableviewMember.reloadData()
            }
        }
        // 👇 API call to refresh
        self.tableviewMember.setContentOffset(.zero, animated: false)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.shouldSupportAllOrientations = false
        }
        
        // Side menu dismiss handler on keyboard show
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc private func refreshHomeDataFromNotification() {
        // Optional: show a loader
        print("🔄 Refreshing Home data due to notification")
        
        fetchHomeData { [weak self] in
            // Optional: stop loader
            print("✅ Home data refreshed after notification")
            
            // If needed, you can also check awaitStatus and show alert automatically
            if let data = self?.homeDataNewModel?.data, data.awaitStatus {
                let missmatchMessage = data.missmatchRemarks
                self?.showAwaitPopup(message: missmatchMessage)
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(checkAwaitStatus), name: Notification.Name("CheckAwaitStatus"), object: nil)
    }
    
    @objc func checkAwaitStatus() {
        
    }

    @objc func refreshPage() {
        // Disable search/filter if needed
        self.fetchHomeData(search: nil) {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableviewMember.reloadData()
            }
        }
    }

   
    
    @objc func appWillEnterForeground() {
        print("✅ App came to foreground")
        if !isSearching {
            self.fetchHomeData {
                
                self.tableviewMember.reloadData()
            }
        }
    }

    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let presented = self.presentedViewController as? SidebarViewController {
            presented.dismiss(animated: false, completion: nil)
        }
    }
    
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Data not found"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
   
    deinit {
        timer?.invalidate()
        NetworkMonitor.shared.stopMonitoring()
        NotificationCenter.default.removeObserver(self)
        
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        hasRefreshedOnce = false
    }
    
    @IBAction func actionVerifiedOK(_ sender: Any) {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.veriyfiedView.alpha = 0
            }) { _ in
                self.veriyfiedView.isHidden = true
                
                // Remove all dimmed background views (tag == 999)
                self.view.subviews
                    .filter { $0.tag == 999 }
                    .forEach { $0.removeFromSuperview() }
                
                self.view.backgroundColor = .white
            }
        }
        
      
    }
    
    
    
    
    
    @IBAction func btnSliderMenu(_ sender: UIButton) {
        if let presentedVC = self.presentedViewController as? SidebarViewController {
            // Already open, do nothing or dismiss
            return
        }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SidebarViewController") as? SidebarViewController else {
            print("SidebarViewController not found")
            return
        }
        vc.userProfileData = self.userProfileData
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    
    @objc func handleSwipe() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func btnCreatePost(_ : UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
//        if !NetworkMonitor.shared.isConnected {
//            // Show your own alert or prevent API call
//            showAlert(message: "Internet not available. Please check your connection.")
//            return
//        }
        
        //        if profileData?.verfiedMsg == "User Verification is completed!" {
        //
        //            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else {return}
        //
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }else {
        //            // Create the alert controller
        //            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        //
        //            // Define font and color attributes
        //            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
        //            let messageAttributes: [NSAttributedString.Key: Any] = [
        //                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
        //                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        //            ]
        //
        //            // Create attributed strings
        //            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
        //            let attributedMessage = NSAttributedString(
        //                string: "You have limited access till verification is complete. We thank you for your patience.",
        //                attributes: messageAttributes
        //            )
        //
        //            // Set the title and message of the alert
        //            alert.setValue(attributedTitle, forKey: "attributedTitle")
        //            alert.setValue(attributedMessage, forKey: "attributedMessage")
        //
        //            // Add an action to the alert
        //            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        //                alert.dismiss(animated: true, completion: nil)
        //            }))
        //
        //            // Present the alert
        //            self.present(alert, animated: true, completion: nil)
        //        }
        
    }
    
    
    
    @IBAction func btnOpenMenu(_ : UIButton){
        
        self.searchView.isHidden = false
        self.SectorLbl.isHidden = true
        self.sideMenu.isHidden = true
        
    }
    
    @IBAction func btncancelSearch(_ : UIButton){
        
        self.searchView.isHidden = true
        self.tfSearch.text = ""
        self.SectorLbl.isHidden = false
        self.sideMenu.isHidden = false
    }
    
    
    
    func showLoader() {
        // Check if the loaderView already exists
        if loaderView == nil {
            // Create a full-screen semi-transparent background view
            let backgroundView = UIView(frame: self.view.bounds)
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            
            // Add an activity indicator
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            // Add a label for a loading message (optional)
            let loadingLabel = UILabel()
            loadingLabel.text = "Loading..."
            loadingLabel.textColor = .white
            loadingLabel.font = UIFont.boldSystemFont(ofSize: 18)
            loadingLabel.textAlignment = .center
            loadingLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Add subviews to the background view
            backgroundView.addSubview(activityIndicator)
            backgroundView.addSubview(loadingLabel)
            
            // Add constraints to center the activity indicator and label
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
                loadingLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20)
            ])
            
            // Add the background view to the main view
            self.view.addSubview(backgroundView)
            
            // Add constraints for the background view
            NSLayoutConstraint.activate([
                backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            
            // Start animating the activity indicator
            activityIndicator.startAnimating()
            
            // Save a reference to the loaderView
            loaderView = backgroundView
        }
    }
    
    func hideLoader() {
        // Remove the loaderView from the superview
        loaderView?.removeFromSuperview()
        loaderView = nil
    }
    
    
    // MARK: - Show Alert and Push Based on Missmatch
    func showAwaitPopup(message: String) {
        let fullMessage = "\(message)"

        // Title
        let title = "Mismatched Documents"
        let attributedTitle = NSMutableAttributedString(string: title)
        attributedTitle.addAttribute(.font, value: UIFont(name: "Montserrat-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: title.count))
        attributedTitle.addAttribute(.foregroundColor, value: UIColor(hexString: "#353535"), range: NSRange(location: 0, length: title.count))

        // Message
        let attributedMessage = NSMutableAttributedString(string: fullMessage)
        let nsRange = NSRange(location: 0, length: fullMessage.count)
        attributedMessage.addAttribute(.font, value: UIFont(name: "Montserrat-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15), range: nsRange)
        attributedMessage.addAttribute(.foregroundColor, value: UIColor(hexString: "#353535"), range: nsRange)

        // Alert
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")

        // OK Action
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let missmatchStatus = self.homeDataNewModel?.data.missmatchStatus else { return }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            if missmatchStatus.contains("name") {
                if let myProfileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                    myProfileVC.sourceViewController = "HomeViewController"
                    myProfileVC.userProfileData = self.userProfileData
                    self.navigationController?.pushViewController(myProfileVC, animated: true)
                }
            } else if missmatchStatus.contains("address") {
                if let registerVC = storyboard.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
                    registerVC.shouldCallAPIOnAppear = true
                    registerVC.sourceScreen = "home"
                    registerVC.userProfileData = self.userProfileData
                    self.navigationController?.pushViewController(registerVC, animated: true)
                }
            } else if missmatchStatus.contains("Address_Proof") {
                if let addressVC = storyboard.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                    addressVC.sourceScreen = "home"
                    addressVC.bntNameUpdate = "Update"
                    addressVC.userProfileData = self.userProfileData
                    self.navigationController?.pushViewController(addressVC, animated: true)
                }
            } else {
                // Default fallback
                if let addressVC = storyboard.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                    addressVC.sourceScreen = "secondStep"
                    addressVC.userProfileData = self.userProfileData
                    self.navigationController?.pushViewController(addressVC, animated: true)
                }
            }
        }

        okAction.setValue(UIColor(hexString: "#008000"), forKey: "titleTextColor")
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func callHomebookayWebService(welUserID: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let params: [String: Any] = [
            "userid": id ?? "",
            "welcomeid": "4",
            "weluserid": welUserID,
            "bokaystatus": "1"
        ]
        //        WebService.sharedInstance.callHomebookayWebService(withParams: params) { data in
        //            self.HomeBokkayData = data
        //            self.bookay_Status = data.bokayStatus
        //            completionClosure()
        //        }
    }
    
    func callHomeLikeWelWebService(welUserID: String,_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let params: [String: Any] = [
            "userid": id ?? "",
            "welcomeid": "4",
            "weluserid": welUserID,
            "likestatus": "1"
        ]
        //        WebService.sharedInstance.callHomeLikeWelWebService(withParams: params) { data in
        //            self.homeLikeData = data
        //            completionClosure()
        //        }
    }
    
    
    

    
    
    // MARK: - Call api delete for post
    func callDeletePostWebService(postId: String, userId: String, _ completionClosure: @escaping () -> ()) {
        let dictParams: Dictionary<String, Any> = [
            "userid": userId,
            "postid": postId
        ]
        print(dictParams)
        
        //        WebService.sharedInstance.callDeletePostWebService(withParams: dictParams) { data in
        //            self.deletePost = data
        //            self.refreshPage()
        //            completionClosure()
        //        }
    }
    
    
   
    
    
    // MARK: - API call to fetchHomeData Home Api
    
    

    private func fetchHomeData(search: String? = nil, completion: (() -> Void)? = nil) {
        var params: Parameters = [
            "page": "\(currentPage)"
        ]

        // Agar search mila toh parameters me daal do
        if let searchValue = search, !searchValue.isEmpty {
            params["search"] = searchValue
        }

        isLoading = true

        HomeV_M.shared.HomeAllData(parameters: params) { [weak self] response, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Failed to fetch home data: \(error)")
                self.isLoading = false
                completion?()
                return
            }

            if let homeData = response {
                let encryptedString = homeData.data
                self.decryptHomeData(encryptedString: encryptedString)
            } else {
                print("❌ Home data response is nil")
            }

            self.isLoading = false
            completion?()
        }
    }


    private func decryptHomeData(encryptedString: String) {
        Neighbrsnooks.decryptHomeData(encryptedString: encryptedString) { [weak self] decryptedData in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let decryptedData = decryptedData {
                    self.homeDataNewModel = decryptedData

                    // Debug print
                    if let data = self.homeDataNewModel?.data {
                        print("DATA ARRAY COUNT: \(data.data.count)")
                        for (i, item) in data.data.enumerated() {
                            switch item {
                            case .post(let postItem): print("Item \(i): type=POST (\(postItem.username))")
                            case .business: print("Item \(i): type=BUSINESS")
                            case .sponsor: print("Item \(i): type=SPONSOR")
                            case .welcome: print("Item \(i): type=WELCOME")
                            case .event: print("Item \(i): type=EVENT")
                            case .poll: print("Item \(i): type=POLL")
                            case .group: print("Item \(i): type=GROUP")
                            }
                        }

                        // ✅ Check for awaitStatus
                        if data.awaitStatus {
                            let missmatchMessage = data.missmatchRemarks
                            self.showAwaitPopup(message: missmatchMessage)
                        }
                    }

                    self.tableviewMember.reloadData()
                } else {
                    print("❌ Failed to decrypt home data")
                }
            }
        }
    }

    
}

@available(iOS 16.0, *)
extension HomeViewController: UITableViewDataSource, UITableViewDelegate, HomeTableViewCellDelegate, MemberTableViewCellDelegate, MemberCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = homeDataNewModel?.data else { return 0 }
        
        if section == 0 {
            return data.announcement.count
        } else {
            return data.data.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = homeDataNewModel?.data else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            // Announcements
            let announcement = data.announcement[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell", for: indexPath) as! AnnouncementTableViewCell
            cell.lblTitle.text = announcement.title
            cell.lblMessage.text = announcement.message
            return cell
        } else {
            // Feed (POST, BUSINESS, SPONSOR…)
            let item = data.data[indexPath.row]
            switch item {
            case .post(let postItem):
                let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
                cell.configure(with: postItem)
                cell.delegate = self
                cell.delegateCell = self
                return cell
                
            case .business(let businessItem):
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBusinessTableViewCell", for: indexPath) as! HomeBusinessTableViewCell
                cell.configure(with: businessItem)
                return cell
                
            case .sponsor(let sponsorItem):
                let cell = tableView.dequeueReusableCell(withIdentifier: "SponsorTableViewCell", for: indexPath) as! SponsorTableViewCell
                cell.configure(with: sponsorItem)
                return cell
                
            case .welcome(let welcomeItem):
                let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeTableViewCell", for: indexPath) as! WelcomeTableViewCell
                cell.configure(with: welcomeItem)
                return cell
                
            case .event(let eventItem):
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventHomeTableViewCell", for: indexPath) as! EventHomeTableViewCell
                cell.configure(with: eventItem)
                return cell
                
            case .poll(let pollItem):
                let cell = tableView.dequeueReusableCell(withIdentifier: "PollHomeTableViewCell", for: indexPath) as! PollHomeTableViewCell
                cell.configure(with: pollItem)
                return cell
                
            case .group(let groupItem):
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
                 cell.configure(with: groupItem)
                return cell
            }
        }
    }


    
    // MARK: - MemberTableViewCellDelegate
    func didTapCommentsButton(cell: MemberTableViewCell) {
        DispatchQueue.main.async { [self] in
            guard let indexPath = self.tableviewMember.indexPath(for: cell) else {
                print("❌ Error: Unable to fetch indexPath for cell.")
                return
            }
            print("✅ IndexPath found: \(indexPath.section) - \(indexPath.row)")

            if !NetworkMonitor.shared.isConnected {
                showAlert(message: "Internet not available. Please check your connection.")
                return
            }

            guard let data = homeDataNewModel?.data else { return }

            // Section and Row check
            if indexPath.section == 1, indexPath.row < data.data.count {
                let item = data.data[indexPath.row]
                var postId: String = ""
                if case let .post(postItem) = item {
                    postId = "\(postItem.id)"
                } else {
                    print("❌ Not a post item!")
                    return
                }

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let postDetailsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailsNewViewController") as? PostDetailsNewViewController {
                    postDetailsVC.postId = postId
                    self.navigationController?.pushViewController(postDetailsVC, animated: true)
                }
            } else {
                print("❌ Index out of range. Row: \(indexPath.row), Data Count: \(data.data.count)")
            }
        }
    }

    
    func didTapOnCollectionViewItem(data: ImageBussi, businessData: BusinessListData) {
        if let videoUrl = data.video, let url = URL(string: videoUrl) {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.play()
            }
        } else if let imageUrl = data.img {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationVC = storyboard.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as? BusinessDetailsViewController {
                destinationVC.business_id = businessData.id
                destinationVC.bussData = [data]
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // MARK: - didSelect for post
    
    func didSelectItem(with data: HomePostMedia, username: String, allImages: [HomePostMedia]) {
          if let videoUrl = data.video, let url = URL(string: videoUrl) {
              let player = AVPlayer(url: url)
              player.isMuted = true // Default mute
              
              let playerViewController = AVPlayerViewController()
              playerViewController.player = player
              
              present(playerViewController, animated: true) {
                  player.pause() // Pause initially
              }
          } else {
              if !NetworkMonitor.shared.isConnected {
                  showAlert(message: "Internet not available. Please check your connection.")
                  return
              }
              
              guard let verifiedMsg = homeDataNewModel?.data.verfiedMsg else {
                  showAlert(message: "Data not available. Try again later.")
                  return
              }
              
              if verifiedMsg == "User Verification is completed!" {
                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
                  if let destinationVC = storyboard.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as? PostViewShowImgVideosDataVC {
//                      destinationVC.imgDataAll = allImages
                      destinationVC.UserName = username
                      self.navigationController?.pushViewController(destinationVC, animated: true)
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
                      alert.dismiss(animated: true)
                  }))
                  
                  self.present(alert, animated: true)
              }
          }
      }
    
    func didTapProfile(for userId: String) {
        //        if HomeNewData?.verfiedMsg == "User Verification is completed!" {
        //            let vc = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        //            let loginUserId = UserDefaults.standard.string(forKey: "userid") ?? ""
        //            // Always pass selected userId
        //            vc.Oid = userId // Profile to show
        //            // Mark source
        //            vc.sourceViewController = (loginUserId == userId) ? "MyProfile" : "OtherProfile"
        //            // For matching later
        //            UserDefaults.standard.set(userId, forKey: "idOther")
        //            navigationController?.pushViewController(vc, animated: true)
        //        } else {
        //            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        //            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
        //            let messageAttributes: [NSAttributedString.Key: Any] = [
        //                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
        //                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        //            ]
        //            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
        //            let attributedMessage = NSAttributedString(
        //                string: "You have limited access till verification is complete. We thank you for your patience.",
        //                attributes: messageAttributes
        //            )
        //            alert.setValue(attributedTitle, forKey: "attributedTitle")
        //            alert.setValue(attributedMessage, forKey: "attributedMessage")
        //            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        //                alert.dismiss(animated: true, completion: nil)
        //            }))
        //            self.present(alert, animated: true, completion: nil)
        //        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        print("🔠 Current Text: \(currentText)")
        print("➕ New Input: \(string)")
        print("🔍 Updated Text: \(updatedText)")
        
        return true
    }
    
}
extension String {
    var decodeEmojiHome: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}
@available(iOS 16.0, *)
extension HomeViewController: UIScrollViewDelegate {
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        // Remove emoji selection view when user starts scrolling
//        removeEmojiSelectionView()
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//           removeEmojiSelectionView()
//           scrollViewDidPaginationScroll(scrollView)
//       }
//       
//       func scrollViewDidPaginationScroll(_ scrollView: UIScrollView) {
//           let offsetY = scrollView.contentOffset.y
//           let contentHeight = scrollView.contentSize.height
//           let scrollViewHeight = scrollView.frame.size.height
//           
//           // ✅ Prevent multiple API hits
//           guard !isLoading, !isLastPage else { return }
//           
//           // Next page
//           if offsetY > contentHeight - scrollViewHeight - 100 {
//               isLoading = true
//               currentPage += 1
//               fetchHomeData {
//                   DispatchQueue.main.async {
//                       self.tableviewMember.reloadData()
//                   }
//               }
//           }
//           
//           // Previous page (optional)
//           if offsetY < 0 && currentPage > 1 {
//               isLoading = true
//               currentPage -= 1
//               fetchHomeData {
//                   DispatchQueue.main.async {
//                       self.tableviewMember.reloadData()
//                   }
//               }
//           }
//       }
    
    private func removeEmojiSelectionView() {
        // Find and remove the emoji selection view from the superview
        if let emojiView = UIApplication.shared.windows.first?.viewWithTag(9999) { // Using tag to identify
            emojiView.removeFromSuperview()
        }
    }
}


@available(iOS 16.0, *)
extension HomeViewController {
    
    func callFavouriteBussinessWebService(postId: String, _ completionClosure: @escaping (String) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        let neighborhoodId = UserDefaults.standard.string(forKey: "neighbrshood") ?? ""
        let dictParams: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "type": "Post",
            "neighbrhood": neighborhoodId
        ]
        //        WebService.sharedInstance.callFavouriteBussinessWebService(withParams: dictParams) { data in
        //            if let json = data as? [String: Any],
        //               let message = json["message"] as? String {
        //                completionClosure(message) // Pass message to closure
        //            } else {
        //                completionClosure("Added to favorite successfully!")
        //            }
        //        }
    }
    
    func callFavouriteRemoveBussinessWebService(postId: String, _ completionClosure: @escaping (String) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "type": "Post"
        ]
        
        //        WebService.sharedInstance.callFavouriteRemoveBussinessWebService(withParams: dictParams) { data in
        //            if let json = data as? [String: Any],
        //               let message = json["message"] as? String {
        //                completionClosure(message) // Pass message to closure
        //            } else {
        //                completionClosure("Removed to favorite successfully!")
        //            }
        //        }
    }
    
    
    func fetchUserProfileAtHome() {
           // 1. Token UserDefaults se lo
           let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
           let profileParam = ["token": token]
           let profileReq = Login_Request(user: "", password: "")

           // 2. Profile API call karo
           User_Profile().goToUserProfile(parameter: profileParam, request: profileReq) { [weak self] profileResponse in
               DispatchQueue.main.async {
                   guard let encryptedProfileData = profileResponse?.data else {
                       print("❌ No encrypted profile data")
                       return
                   }
                   // 3. Decrypt API call karo
                   HttpUtility().decryptUserProfileData(encryptedData: encryptedProfileData) { userData in
                       DispatchQueue.main.async {
                           self?.userProfileData = userData
                           if let data = userData {
                               print("✅ Got final user profile:", data)
                               self?.SectorLbl.text = data.neighborhood_name
                               // Yahan UI update ya table reload karo, direct
                           } else {
                               print("❌ Failed to decrypt user profile")
                           }
                       }
                   }
               }
           }
       }
    

    
    
    
}



@available(iOS 16.0, *)
extension HomeViewController: EventHomeTableViewCellDelegate,ProfileTapDelegate {
    func didTapProfile(userId: String) {
        print("🔵 Profile Tapped for UserID: \(userId)")
        if !NetworkMonitor.shared.isConnected {
            // Show your own alert or prevent API call
            showAlert(message: "Internet not available. Please check your connection.")
            return
        }
        
        //        if HomeNewData?.verfiedMsg == "User Verification is completed!"{
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            if let profileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
        //                profileVC.Oid = userId
        //                profileVC.headingTitle = userId
        //                profileVC.isFromMessage = true
        //                if id == userId {
        //                    profileVC.sourceViewController = "MyProfile"
        //                    profileVC.Newid = userId
        //                } else {
        //                    profileVC.sourceViewController = "OtherProfile"
        //                    profileVC.Oid = userId
        //
        //                }
        //
        //
        //                self.navigationController?.pushViewController(profileVC, animated: true)
        //            }
        //        }
        else{
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
    }
}

@available(iOS 16.0, *)
extension HomeViewController: HomeBusinessCellDelegate {
    func didTapBusinessItem(_ businessID: String) {
        
        if !NetworkMonitor.shared.isConnected {
            // Show your own alert or prevent API call
            showAlert(message: "Internet not available. Please check your connection.")
            return
        }
        
        
        //        if HomeNewData?.verfiedMsg == "User Verification is completed!" {
        //            let vc = storyboard?.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as! BusinessDetailsViewController
        //            vc.business_id = businessID
        //            navigationController?.pushViewController(vc, animated: true)
        //        } else {
        //            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        //            let messageAttributes: [NSAttributedString.Key: Any] = [
        //                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
        //                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        //            ]
        //            let attributedMessage = NSAttributedString(
        //                string: "You have limited access till verification is complete. We thank you for your patience.",
        //                attributes: messageAttributes
        //            )
        //            alert.setValue(attributedMessage, forKey: "attributedMessage")
        //            alert.addAction(UIAlertAction(title: "OK", style: .default))
        //            present(alert, animated: true)
        //        }
    }
}





//MARK: - like unlike

extension HomeViewController: MemberTableViewLikeUnlikeCellDelegate {
    
    func didTapLike(postId: String, isLiked: Bool, emoji: String?) {
        if isLiked {
            callPostLikeWebService(postId: postId, emoji: emoji) { success in
                if success {
                    print("✅ Liked Post ID: \(postId)")
                    //                    if let index = self.HomeNewData?.listdata?.firstIndex(where: { $0.postid == postId }) {
                    //                        self.HomeNewData?.listdata?[index].postlike = "1"
                    //                        self.HomeNewData?.listdata?[index].userEmoji = emoji
                    //                        let currentLike = Int(self.HomeNewData?.listdata?[index].totallike ?? "0") ?? 0
                    //                        self.HomeNewData?.listdata?[index].totallike = "\(currentLike + 1)"
                    //                    }
                    DispatchQueue.main.async {
                        self.tableviewMember.reloadData()
                    }
                } else {
                    print("❌ Failed to like post — API error")
                }
            }
        } else {
            callPostUnLikeWebService(postId: postId) { success in
                if success {
                    print("🛑 Unliked Post ID: \(postId)")
                    //                    if let index = self.HomeNewData?.listdata?.firstIndex(where: { $0.postid == postId }) {
                    //                        self.HomeNewData?.listdata?[index].postlike = "0"
                    //                        self.HomeNewData?.listdata?[index].userEmoji = nil
                    //                        let currentLike = Int(self.HomeNewData?.listdata?[index].totallike ?? "0") ?? 1
                    //                        self.HomeNewData?.listdata?[index].totallike = "\(max(0, currentLike - 1))"
                    //                    }
                    DispatchQueue.main.async {
                        self.tableviewMember.reloadData()
                    }
                } else {
                    print("❌ Failed to unlike post — API error")
                }
            }
        }
    }
    
    func callPostLikeWebService(postId: String, emoji: String?, completion: @escaping (Bool) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        let params: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "likestatus": "1",
            "emojiunicode": emoji ?? ""
        ]
        
        //        WebService.sharedInstance.callPostLikeWebService(withParams: params) { data in
        //            let success = (Int(data.status ?? "0") == 1)
        //            completion(success)
        //        }
        
    }
    
    func callPostUnLikeWebService(postId: String, completion: @escaping (Bool) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        let params: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "likestatus": "0",
            "emojiunicode": ""
        ]
        
        //        WebService.sharedInstance.callPostUnLikeWebService(withParams: params) { data in
        //            let success = (Int(data.status ?? "0") == 1)
        //            completion(success)
        //        }
    }
    
    
    func callPostLikelistWebService(postId: String, completion: @escaping () -> Void) {
        let params: [String: Any] = [
            "postid": postId
        ]
        
        //        WebService.sharedInstance.callLikeListPostWebService(withParams: params) { data in
        //            // ✅ Replace dictionary subscript with property access
        //            if let likeCountFromServer = data.totalEmojis,
        //               let index = self.HomeNewData?.listdata?.firstIndex(where: { $0.postid == postId }) {
        //                self.HomeNewData?.listdata?[index].totallike = String(likeCountFromServer)
        //            }
        //
        //            completion()
        //        }
    }
    
    
    func getParentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
