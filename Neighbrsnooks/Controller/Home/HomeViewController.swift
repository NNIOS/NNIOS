//
//  HomeViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 01/03/24.
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
    
    var filteredData: HomeAllModel? = nil
    var isFromProfile: Bool?
    var isSearching = false
    var name = ""
    var secname = ""
    var Neighbourname : String! = nil
    //    var HomeData : HomeModel?
    var HomeNewData : HomeAllModel?
    var userid : String?
    var id : String?
    var imgData = [PostImage]()
    var PostListData : PostListModel?
    var PostLikeData : LikePostModel?
    let transitionManager = SideMenuTransitionManager()
    var profileData : ProfileModel?
    var uploadDoc : UploadedDocumentsModel?
    var HomeBokkayData : HomeBookayModel?
    var homeLikeData : HomeLikeWelcomeModel?
    var sideMenuVisible = false
    var selectedNeighborhoodId: String?
    var welcomeid = [Datum]()
    var PopupVerifyData : PopUpVerificationModel?
    private let bottomPanelView = BottomPanelView()
    var deletePost : DeletePostModel?
    var savedProfileData: ProfileModel?
    var savedUploadedDocuments: UploadedDocumentsModel?
    var likeListModel : LikeListModel?
    private var activityIndicator: UIActivityIndicatorView?
    var loaderView: UIView?
    var currentPage = 1  // Start with page 1
    var isLoading = false // Prevent duplicate API calls
    var isLastPage = false // To determine if all data is loaded
    var imgDataAll: [postImagesN] = [] // Define your data source array
    var isExpanded = false // Track if description is expanded or collapsed
    var sortedSections: [(type: String, items: [Any])] = []
    var dimmingLayer: UIView?
    var timer: Timer?
    var fireBaseToken : UpdateTokenModel?
    var welcomeIDList: [String] = []
    var bookay_Status:Int?
    var like_Status:Int?
    var isHomePageLoadedOnce = false
    var apiCallCount = 0
    var tableReloadCount = 0
    //    var hasRefreshedOnce = false
    var userGivenLike = Set<String>()      // createdBy userID
    var userGivenBookay = Set<String>()    // createdBy userID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewMember.showsVerticalScrollIndicator = false
        veriyfiedView.layer.shadowColor = UIColor.black.cgColor
        veriyfiedView.layer.shadowOpacity = 0.3
        veriyfiedView.layer.shadowOffset = CGSize(width: 0, height: 2)
        veriyfiedView.layer.shadowRadius = 4
        // Add view and hide initially
        self.view.addSubview(self.veriyfiedView)
        veriyfiedView.isHidden = true
        //        callUserProfileWebService{}
        self.additionalSafeAreaInsets.top = -view.safeAreaInsets.top
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshNotification), name: NSNotification.Name("RefreshHomePageNotification"), object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        prepareSortedData(homeModel: HomeNewData)
        NetworkMonitor.shared.startMonitoring()
        // commend irshad check kanre ke liye
        self.searchView.isHidden = true
        // setupBottomPanel()
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.SectorLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.lblWelcomeVeriyfied.font = UIFont(name: "Montserrat-Medium", size: 25)
        lblVeriyfied.textColor = #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        callDeviceInfoWebService()
        callHomeAllWebService{
            SVProgressHUD.dismiss()
            self.SectorLbl.text = self.HomeNewData?.myNeighborhood
            self.tableviewMember.reloadData()
        }
        // Initialize the refresh control page
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPageAction), for: .valueChanged)
        // Add the refresh control to your UITableView or UICollectionView
        tableviewMember.refreshControl = refreshControl
        // Listen for refresh notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRefreshNotification),
                                               name: NSNotification.Name("RefreshHomePageNotification"),
                                               object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let userID = UserDefaults.standard.string(forKey: "userid") {
                Messaging.messaging().token { token, error in
                    if let token = token {
                        self.callUpdateFirebaseTokenPostWebServiceDirect(userId: userID, firebaseToken: token) {
                            print("🎯 Token updated from viewDidLoad with direct URL")
                        }
                    } else if let error = error {
                        print("❌ Firebase token fetch error: \(error)")
                    }
                }
            }
        }
        
        
        
        
    }
    
    
    @objc func handleHomeRefreshNotification() {
        print("🔁 Refreshing Home after coming back")
        callHomeAllWebService {
            self.tableviewMember.reloadData()
        }
    }
    
    @objc func handleRefreshNotification() {
        print("🔄 Refresh notification received in HomeViewController")
        refreshPage()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshPage()
        NotificationCenter.default.addObserver(self, selector: #selector(checkAwaitStatus), name: Notification.Name("CheckAwaitStatus"), object: nil)
        
    }
    
    @objc func checkAwaitStatus() {
        refreshPage()
    }
    
    // Jab bhi text change hoga yeh function call hoga
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let searchText = textField.text {
            isSearching = !searchText.trimmingCharacters(in: .whitespaces).isEmpty
            filterData(with: searchText)
        }
    }
    
    
    // Jab return button press karein
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Keyboard hide karega
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchView.isHidden = true
        self.currentPage = 1
        // 👇 API call to refresh
        self.tableviewMember.setContentOffset(.zero, animated: false)
        callUserProfileWebService { [weak self] in
            self?.callHomeAllWebService {
                SVProgressHUD.dismiss()
                self?.tableviewMember.reloadData()
            }
        }
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
    
    @objc func appWillEnterForeground() {
        print("✅ App came to foreground")
        if !isSearching {
            
            callUserProfileWebService { [weak self] in
                guard let self = self else { return }
                self.callHomeAllWebService {
                    SVProgressHUD.dismiss()
                    self.tableviewMember.reloadData()
                }
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
    
    
    func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.fetchStatusFromAPI()
        }
    }
    
    func fetchStatusFromAPI() {
        // API Call
        refreshPage()
    }
    
    deinit {
        timer?.invalidate()
        NetworkMonitor.shared.stopMonitoring()
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
    
    
    func refreshPage() {
        print("✅ Refreshing page")
        
        // Scroll to top before reloading
        DispatchQueue.main.async {
            self.tableviewMember.setContentOffset(.zero, animated: false)
        }
        
        callUserProfileWebService {
            self.callHomeAllWebService {
                self.tableviewMember.reloadData()
                self.tableviewMember.refreshControl?.endRefreshing()
            }
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        hasRefreshedOnce = false
    }
    
    
    // @objc function for triggering the refresh
    @objc func refreshPageAction() {
        //        isHomePageLoadedOnce = false
        refreshPage()
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
        
        // Call APIs after animation
        self.callpopupVerificationWebService {}
        self.callHomeAllWebService {}
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
        vc.homeData = self.HomeNewData
        vc.profileData = self.profileData
        //        print(vc.profileData)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    
    @objc func handleSwipe() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func btnCreatePost(_ : UIButton){
        if !NetworkMonitor.shared.isConnected {
            // Show your own alert or prevent API call
            showAlert(message: "Internet not available. Please check your connection.")
            return
        }
        
        if profileData?.verfiedMsg == "User Verification is completed!" {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else {return}
            
            self.navigationController?.pushViewController(vc, animated: true)
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
    
    @objc func presentSideMenu() {
        guard let sideMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {return}
        sideMenuVC.modalPresentationStyle = .custom
        sideMenuVC.transitioningDelegate = transitionManager
        present(sideMenuVC, animated: true, completion: nil)
    }
    
    @IBAction func btnOpenMenu(_ : UIButton){
        
        self.searchView.isHidden = false
        self.SectorLbl.isHidden = true
        self.sideMenu.isHidden = true
        
    }
    
    @IBAction func btncancelSearch(_ : UIButton){
        refreshPage()
        self.searchView.isHidden = true
        self.tfSearch.text = ""
        self.SectorLbl.isHidden = false
        self.sideMenu.isHidden = false
    }
    
    
    
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let loggedUser = UserDefaults.standard.string(forKey: "loggeduser") ?? ""
        let dictParams: [String: Any] = [
            "userid": id,
            "loggeduser": id
        ]
        print("📤 API Call Params: \(dictParams)")
        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { (data: ProfileModel?) in
            
            if let data = data {
                print("✅ API Response received")
                print("🔍 Full ProfileModel: \(data)")
                
                self.profileData = data
                self.savedProfileData = data
                
                // Save UserDefaults
                UserDefaults.standard.set(data.emerPhone ?? "", forKey: "emer_phone")
                UserDefaults.standard.set(data.userpic ?? "", forKey: "profileImage")
                UserDefaults.standard.set(data.lastname ?? "", forKey: "lastName")
                UserDefaults.standard.set(data.neighborhood ?? "", forKey: "myNeighbhrhhod")
                UserDefaults.standard.set(data.nbdId ?? "", forKey: "Neighbhrhhod")
                UserDefaults.standard.set(data.addlineone ?? "", forKey: "addressLineOne")
                UserDefaults.standard.set(data.addlinetwo ?? "", forKey: "addressLineTwo")
                UserDefaults.standard.set(data.city ?? "", forKey: "city")
                UserDefaults.standard.set(data.state ?? "", forKey: "state")
                UserDefaults.standard.set(data.country ?? "", forKey: "country")
                UserDefaults.standard.set(data.pincode ?? "", forKey: "pincode")
                
            } else {
                print("❌ API response is nil. Either network failed or model didn't map correctly.")
            }
            
            completionClosure()
        }
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
    
    
    func showAwaitPopup(message: String) {
        let fullMessage = "\(message)"
        
        // MARK: - Customize Title
        let title = "Mismatched Documents"
        let attributedTitle = NSMutableAttributedString(string: title)
        attributedTitle.addAttribute(.font, value: UIFont(name: "Montserrat-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: title.count))
        attributedTitle.addAttribute(.foregroundColor, value: UIColor(hex: "#353535"), range: NSRange(location: 0, length: title.count))
        
        // MARK: - Customize Message
        let attributedMessage = NSMutableAttributedString(string: fullMessage)
        if let range = fullMessage.range(of: message) {
            let nsRange = NSRange(range, in: fullMessage)
            attributedMessage.addAttribute(.font, value: UIFont(name: "Montserrat-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15), range: nsRange)
            attributedMessage.addAttribute(.foregroundColor, value: UIColor(hex: "#353535"), range: nsRange)
        }
        
        // MARK: - Alert Setup
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        // MARK: - OK Button
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let missmatchStatus = self.HomeNewData?.missmatchStatus
            if missmatchStatus == "name" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let myProfileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                    myProfileVC.sourceViewController = "HomeViewController"
                    myProfileVC.Oid = self.id
                    self.navigationController?.pushViewController(myProfileVC, animated: true)
                }
            }
            
            
            //            if missmatchStatus == "name" {
            //                // ⭐️ MyProfileViewController push
            //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //                if let myProfileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
            //                    myProfileVC.sourceViewController = "HomeViewController"
            //                    self.navigationController?.pushViewController(myProfileVC, animated: true)
            //                }
            else if missmatchStatus == "address" {
                // ⭐️ RegistationAdressProofVC push (direct)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let registerVC = storyboard.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
                    // set data if needed
                    registerVC.uploadedDocuments = self.savedUploadedDocuments
                    registerVC.profileData = self.profileData
                    registerVC.sourceScreen = "home"
                    registerVC.shouldCallAPIOnAppear = true
                    self.navigationController?.pushViewController(registerVC, animated: true)
                }
            } else if missmatchStatus == "address_proof" {
                // ⭐️ NewRegistationSecondStepVC push
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let secondStepVC = storyboard.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                    // set data if needed
                    secondStepVC.uploadedDocuments = self.savedUploadedDocuments
                    secondStepVC.profileData = self.profileData
                    secondStepVC.sourceScreen = "home"
                    secondStepVC.bntNameUpdate = "Update"
                    self.navigationController?.pushViewController(secondStepVC, animated: true)
                }
            } else {
                // ⭐️ Existing flow (callUserProfileWebService...)
                self.callUserProfileWebService { [weak self] in
                    guard let self = self else { return }
                    self.callUploaddocumentWebService {
                        self.savedUploadedDocuments = self.uploadDoc
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let registerVC = storyboard.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                            registerVC.uploadedDocuments = self.savedUploadedDocuments
                            registerVC.profileData = self.profileData
                            registerVC.sourceScreen = "secondStep"
                            print("Passing Profile Data: \(self.profileData ?? nil)")
                            self.navigationController?.pushViewController(registerVC, animated: true)
                        }
                    }
                }
            }
            
        }
        
        okAction.setValue(UIColor(hex: "#008000"), forKey: "titleTextColor")
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // callUploadDocumentWebService function (already handled properly)
    func callUploaddocumentWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? ""
        ]
        
        // Calling the web service that expects Data and returns UploadedDocumentsModel
        WebService.sharedInstance.callUploadDocumnetWebService(withParams: dictParams) { uploadedDocuments in
            self.uploadDoc = uploadedDocuments // Save the fetched document data
            
            completionClosure() // Proceed after fetching data
        }
    }
    
    
    
    func callHomebookayWebService(welUserID: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let params: [String: Any] = [
            "userid": id ?? "",
            "welcomeid": "4",
            "weluserid": welUserID,
            "bokaystatus": "1"
        ]
        WebService.sharedInstance.callHomebookayWebService(withParams: params) { data in
            self.HomeBokkayData = data
            self.bookay_Status = data.bokayStatus
            completionClosure()
        }
    }
    
    func callHomeLikeWelWebService(welUserID: String,_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let params: [String: Any] = [
            "userid": id ?? "",
            "welcomeid": "4",
            "weluserid": welUserID,
            "likestatus": "1"
        ]
        WebService.sharedInstance.callHomeLikeWelWebService(withParams: params) { data in
            self.homeLikeData = data
            completionClosure()
        }
    }
    
    
    
    
    
    // MARK: - API call to post device information
    
    func callDeviceInfoWebService() {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        
        // Get device information
        let deviceInfo = getDeviceInfo()
        
        // Set up parameters for API
        let dictParams: [String: Any] = [
            "device_model": deviceInfo.deviceModel,
            "device_imei": deviceInfo.deviceIMEI,  // This will contain UUID
            "device_platform": deviceInfo.devicePlatform,
            "device_id": deviceInfo.deviceID,
            "user_id": userId
        ]
        
        // Call the Web Service
        WebService.sharedInstance.callDeviceInfo(withParams: dictParams) { data in
            // Handle the response here
            print("Device info posted successfully")
        }
    }
    
    
    func callpopupVerificationWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            
            
        ]
        WebService.sharedInstance.callpopupVerificationWebService(withParams: dictParams) { data in
            self.PopupVerifyData = data
            completionClosure()
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
            self.refreshPage()
            completionClosure()
        }
    }
    
    
    // irshad warknig api
    func callHomeAllWebService(_ completionClosure: @escaping () -> ()) {
        SVProgressHUD.show()
        self.prepareSortedData(homeModel: self.HomeNewData)  // Ensure it's using updated data
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "userid": id,
            "page": "\(currentPage)"
        ]
        
        WebService.sharedInstance.callHomeAllWebService(withParams: dictParams) { data in
            print("📥 API callback received") // Add this line to confirm entry
            print("⏳ awaitStatus: \(data.awaitStatus ?? "nil")")
            SVProgressHUD.dismiss()
            if data.status == "success" {
                if let newListData = data.listdata {
                    if self.currentPage == 1 {
                        self.HomeNewData = data
                    } else {
                        self.HomeNewData?.listdata?.append(contentsOf: newListData)
                    }
                    // Debug print
                    if let newListData = data.listdata {
                        print("📢 listdata Count: \(newListData.count)")
                        for (index, datum) in newListData.enumerated() {
                            print("🔹 Item \(index + 1):")
                            print("   🔸 Type: \(datum.type ?? "N/A")")
                            print("   🔸 hID: \(datum.hID ?? "N/A")")
                            print("   🔸 sponsorID: \(datum.sponsorID ?? "N/A")")
                            print("   🔸 Username: \(datum.username ?? "N/A")")
                            print("   🔸 Caption: \(datum.caption ?? "N/A")")
                            print("   🔸 Post Message: \(datum.postMessage ?? "N/A")")
                            print("   🔸 Total Likes: \(datum.total_like ?? 0)")
                            print("   🔸 Total Bokay: \(datum.total_bokay ?? 0)")
                            print("-------------------------")
                        }
                    } else {
                        print("❌ listdata is NIL ya EMPTY")
                    }
                    for datum in newListData {
                        print("🚀 API Response Type: \(datum.type ?? "No type available")")
                    }
                    self.isLastPage = newListData.isEmpty
                }
                if let listData = data.listdata {
                    for datum in listData {
                        if let welcomeID = datum.welcomeid, let userID = datum.hID {
                            UserDefaults.standard.set(welcomeID, forKey: "welcomeid")
                            UserDefaults.standard.set(userID, forKey: "userWelid")
                        }
                    }
                }
                
                //MARK: - ✅ Show welcome popup here
                print("Checking for popup condition...")
                
                if let verifiedStatus = data.verifiedStatus,
                   verifiedStatus == "1",
                   let popupVerifiedStatus = data.popupVerifiedStatus {
                    
                    if popupVerifiedStatus == 0 {
                        print("📣 popup_verified_status == 0: Show Custom Popup View")
                        DispatchQueue.main.async {
                            // 🔲 1. Create and add dimmed background view
                            let dimmedView = UIView(frame: self.view.bounds)
                            dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                            dimmedView.tag = 999  // So we can remove it later
                            self.view.addSubview(dimmedView)
                            dimmedView.isUserInteractionEnabled = false
                            self.lblVeriyfied.text = "You are now a verified member.\nHappy Neighbrsnooking!!!"
                            // 🔲 2. Setup popup view (centered)
                            let popupWidth: CGFloat = self.view.frame.width - 90
                            let popupHeight: CGFloat = 220
                            let x = (self.view.frame.width - popupWidth) / 2
                            let y = (self.view.frame.height - popupHeight) / 2
                            self.veriyfiedView.frame = CGRect(x: x, y: y, width: popupWidth, height: popupHeight)
                            self.veriyfiedView.layer.cornerRadius = 12
                            self.veriyfiedView.clipsToBounds = true
                            self.veriyfiedView.alpha = 0
                            self.veriyfiedView.isHidden = false
                            // 🔲 3. Show popup on top
                            self.view.bringSubviewToFront(self.veriyfiedView)
                            // 🔲 4. Animate popup appearance
                            UIView.animate(withDuration: 0.1) {
                                self.veriyfiedView.alpha = 1
                            }
                        }
                        
                    } else if popupVerifiedStatus == 1 {
                        print("🚫 popup_verified_status == 1: Hide Custom Popup View (No popup)")
                        
                        DispatchQueue.main.async {
                            // 🔲 1. Animate popup hiding
                            UIView.animate(withDuration: 0.1, animations: {
                                self.veriyfiedView.alpha = 0
                            }) { _ in
                                self.veriyfiedView.isHidden = true
                                
                                // 🔲 2. Remove dimmed background if exists
                                if let dimmedView = self.view.viewWithTag(999) {
                                    dimmedView.removeFromSuperview()
                                }
                            }
                        }
                    }
                    
                } else {
                    print("❌ Condition not matched or data missing")
                }
                
                if let awaitStatus = data.awaitStatus {
                    print("🔎 awaitStatus found: \(awaitStatus)")
                    if awaitStatus == "1" {
                        let remarks = data.missmatchRemarks ?? "No remarks available"
                        DispatchQueue.main.async {
                            self.showAwaitPopup(message: remarks)
                        }
                    }
                } else {
                    print("❌ awaitStatus not found")
                }
                
                // Ensure sorted data is updated with the latest response
                self.prepareSortedData(homeModel: self.HomeNewData)
                completionClosure()
            } else {
                self.showAlert(Message: data.message ?? "Unknown error")
            }
        }
    }
    
}

@available(iOS 16.0, *)
extension HomeViewController: UITableViewDataSource, UITableViewDelegate, HomeTableViewCellDelegate, MemberTableViewCellDelegate, MemberCellDelegate {
    
    func updateSortedSections() {
        let sourceData = isSearching ? filteredData : HomeNewData
        prepareSortedData(homeModel: sourceData)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData(with: searchText)
    }
    
    func filterData(with searchText: String) {
        print("🔍 Searching for: \(searchText)")
        guard let originalData = HomeNewData else {
            print("❌ No original data to search")
            return
        }
        print("🧾 Original data count: \(originalData.listdata?.count ?? 0)")
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedSearchText.isEmpty {
            print("✅ Empty search: show full data")
            filteredData = originalData
            isSearching = false
            prepareSortedData(homeModel: originalData)
            DispatchQueue.main.async {
                self.tableviewMember.reloadData()
            }
            return
        }
        isSearching = true
        let normalizedSearchText = trimmedSearchText.lowercased()
        let filteredList = originalData.listdata?.filter { datum in
            let username = (datum.username ?? "").lowercased()
            let postMessage = (datum.postMessage ?? "").lowercased()
            let company = (datum.company ?? "").lowercased()
            let eventName = (datum.eventName ?? "").lowercased()
            return username.contains(normalizedSearchText) ||
            postMessage.contains(normalizedSearchText) ||
            company.contains(normalizedSearchText) ||
            eventName.contains(normalizedSearchText)
        } ?? []
        print("🔎 Filtered items count: \(filteredList.count)")
        // Final filtered model
        filteredData = HomeAllModel(
            status: originalData.status,
            message: originalData.message,
            announcement: originalData.announcement,
            myNeighborhoodID: originalData.myNeighborhoodID,
            myNeighborhood: originalData.myNeighborhood,
            verfiedMsg: originalData.verfiedMsg,
            missmatchRemarks: originalData.missmatchRemarks,
            awaitStatus: originalData.awaitStatus,
            memberCount: originalData.memberCount,
            verifiedStatus: originalData.verifiedStatus,
            popupVerifiedStatus: originalData.popupVerifiedStatus,
            missmatchStatus: originalData.missmatchStatus,
            listdata: filteredList
        )
        prepareSortedData(homeModel: filteredData)
        DispatchQueue.main.async {
            self.tableviewMember.reloadData()
        }
    }
    
    
    // Filtered data ko fetch karna
    func getFilteredData(for type: String, at index: Int) -> HomeNewData? {
        let dataSource = isSearching ? filteredData : HomeNewData
        let filteredList = dataSource?.listdata?.filter { $0.type == type } ?? []
        return index < filteredList.count ? filteredList[index] : nil
    }
    
    func prepareSortedData(homeModel: HomeAllModel?) {
        guard let homeModel = homeModel else {
            print("❌ homeModel is NIL")
            sortedSections.removeAll()
            tableviewMember.backgroundView = noDataLabel
            tableviewMember.reloadData()
            return
        }
        
        guard let data = homeModel.listdata else {
            print("❌ listdata is NIL")
            sortedSections.removeAll()
            tableviewMember.backgroundView = noDataLabel
            tableviewMember.reloadData()
            return
        }
        
        if data.isEmpty {
            print("⚠️ No matching data")
            sortedSections.removeAll()
            tableviewMember.backgroundView = noDataLabel
            // ❌ return hata do yahan se
        } else {
            tableviewMember.backgroundView = nil
        }
        
        
        print("✅ listdata found, Count: \(data.count)")
        sortedSections.removeAll()
        
        if let announcement = homeModel.announcement, !announcement.isEmpty {
            sortedSections.append(("Announcement", announcement))
            print("🟢 Added Announcement Section")
        }
        
        for item in data {
            let type = item.type ?? ""
            sortedSections.append((type, [item]))
        }
        tableviewMember.backgroundView = nil  // Clear "Data not found"
        tableviewMember.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("🔢 Total Sections: \(sortedSections.count)")
        return sortedSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = sortedSections[section]
        print("📌 Section \(section) - \(sectionData.0): Rows Count = \(sectionData.1.count)")
        
        if section == 0, sectionData.0 == "Announcement" {
            if sectionData.1.isEmpty {
                return sortedSections.count > 1 ? sortedSections[1].1.count : 0
            }
            return sectionData.1.count
        }
        return sectionData.1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = sortedSections[indexPath.section]
        let item = sectionData.1[indexPath.row]
        print("🟢 CellForRowAt: Section = \(sectionData.0), Row = \(indexPath.row)")
        
        // Announcement Section (Section 0)
        if indexPath.section == 0, sectionData.0 == "Announcement" {
            if let announcement = item as? Announcement {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell", for: indexPath) as! AnnouncementTableViewCell
                print("Configuring Announcement Cell")
                cell.lblTitle.text = announcement.title
                cell.lblMessage.text = announcement.msg
                
                if traitCollection.userInterfaceStyle == .dark {
                    // separator.backgroundColor =  #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
                    cell.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
                } else {
                    //  separator.isHidden = true
                    cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
                }
                
                return cell
            }
        }
        // For other sections, based on the Type
        switch sectionData.0 {
        case "Post":
            print("🟢 Calling Post Cell")
            let dataSource = isSearching ? filteredData : HomeNewData
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
            cell.delegate = self
            cell.delegateCell = self // Delegate assign karo
            if let postData = item as? HomeNewData {
                print("Post Data: \(postData)")
                cell.delegateLikeUnlikeCell = self
                cell.postId = postData.postid ?? ""
                //guard var postData = dataSource?.listdata?.filter({ $0.type == "Post" })[indexPath.row] else { return cell }
                cell.lblLikeCount.text = postData.totallike
                
                cell.likeCount = Int(postData.totallike ?? "0") ?? 0
                cell.isLikedByUser = postData.isLiked ?? false
                cell.selectedEmoji = postData.emojiunicode
                //                cell.setupLikeUI()
                
                cell.configureLikeButton(
                    likestatus: postData.postlike ?? "0", // ✅ This is correct
                    totalLike: Int(postData.totallike ?? "0") ?? 0,
                    selectedEmoji: postData.emojiunicode
                )

                
                cell.lblCommentCount.text = postData.totcomment
                cell.lblName.text = postData.username
                cell.lblGeneral.text = postData.postType ?? "N/A"
                cell.lblDescription.text = postData.postMessage ?? "N/A"
                cell.lblSec.text = postData.neighborhood
                cell.lblMonth.text = postData.createdOn
                let url = URL(string: (postData.userpic ?? ""))
                cell.profileImgView.kf.indicatorType = .activity
                cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: ""))
                cell.imgDataAll = postData.postImagesN ?? []
                cell.configureDescription(with: postData.postMessage ?? "N/A")
                cell.addTapGestureToLabel()
                // Update button icon based on favouritstatus
                cell.updateFavouriteButton(isFavourite: postData.favouritstatus == 1)
                // Handle Favourite Button Tap
                cell.userId = postData.createdby // Assign user ID
                print(postData.createdby)
                cell.showAlertCallback = { [weak self] message in
                    guard let self = self else { return }
                    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
                
                cell.delegateM = self
                if traitCollection.userInterfaceStyle == .dark {
                    cell.backgroundColor =  #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1) // Dark mode background
                } else {
                    cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1) // Light mode background
                }
                
                let imageExists = postData.postImagesN?[indexPath.row].img != nil
                let videoExists = postData.postImagesN?[indexPath.row].video != nil
                
                if imageExists || videoExists {
                    cell.collectionViewBanner.isHidden = false
                    cell.collectionViewBannerHeight.constant = 523
                } else {
                    cell.collectionViewBanner.isHidden = true
                    cell.collectionViewBannerHeight.constant = 0
                }
                
                cell.favouriteButtonCallback = { [weak self] in
                    guard let self = self else { return }
                    // Check verification status
                    if !NetworkMonitor.shared.isConnected {
                        // Show your own alert or prevent API call
                        showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    guard self.HomeNewData?.verfiedMsg == "User Verification is completed!" else {
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
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    var mutablePostData = postData
                    guard let postId = mutablePostData.postid, !postId.isEmpty else { return }
                    
//                    if mutablePostData.favouritstatus == 1 {
//                        // Unfavourite
//                        self.callFavouriteRemoveBussinessWebService(postId: postId) { message in
//                            mutablePostData.favouritstatus = 0
//                            self.HomeNewData?.listdata?[indexPath.row].favouritstatus = 0
//                            cell.updateFavouriteButton(isFavourite: false)
//                            self.callUserProfileWebService {
//                                self.callHomeAllWebService {
//                                 }
//                            }
//                            //                            self.showAutoDismissAlert(message: message)
//                        }
//                    } else {
//                        // Favourite
//                        self.callFavouriteBussinessWebService(postId: postId) { message in
//                            mutablePostData.favouritstatus = 1
//                            self.HomeNewData?.listdata?[indexPath.row].favouritstatus = 1 // or 0
//                            cell.updateFavouriteButton(isFavourite: true)
//                            self.callUserProfileWebService {
//                                self.callHomeAllWebService {
//                                 }
//                            }
//                            //                            self.showAutoDismissAlert(message: message)
//                        }
//                    }
                    
                    
                    cell.favouriteButtonCallback = { [weak self] in
                        guard let self = self else { return }
                        // ... Check verification and API call logic ...
                        if mutablePostData.favouritstatus == 1 {
                            // Unfavourite flow
                            self.callFavouriteRemoveBussinessWebService(postId: postId) { message in
                                mutablePostData.favouritstatus = 0
                                self.HomeNewData?.listdata?[indexPath.row].favouritstatus = 0
                                cell.updateFavouriteButton(isFavourite: false)
                                self.callHomeAllWebService{}
                            }
                        } else {
                            // Favourite flow
                            self.callFavouriteBussinessWebService(postId: postId) { message in
                                mutablePostData.favouritstatus = 1
                                self.HomeNewData?.listdata?[indexPath.row].favouritstatus = 1
                                cell.updateFavouriteButton(isFavourite: true)
                                self.callHomeAllWebService{}
                            }
                        }
                    }


                }
                
                
                cell.shareAppCallback = { [weak self] in
                    guard let self = self else { return }
                    
                    if !NetworkMonitor.shared.isConnected {
                        self.showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    
                    // ✅ Check verification
                    guard profileData?.verfiedMsg == "User Verification is completed!" else {
                        let alert = UIAlertController(
                            title: "",
                            message: "You have limited access till verification is complete.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    
                    // ✅ Post details
                    let postMessage = postData.postMessage ?? "No message"
                    let weather = postData.postType ?? "Weather info not available"
                    let neighborhood = postData.neighborhood ?? "Unknown Neighborhood"
                    let imageURLString = postData.postImagesN?.first?.img ?? ""
                    
                    // ✅ Links
                    let appStoreLink = "https://apps.apple.com/in/app/neighbrsnook/id6746369263"
                    let playStoreLink = "https://play.google.com/store/apps/details?id=com.app_neighbrsnook"
                    let companyLink = "https://neighbrsnook.com/"
                    
                    // ✅ Share text (ORDER: Post → Weather → Neighborhood → Links)
                    let shareText = """
                    \(postMessage)
                    Weather: \(weather)
                    Neighborhood: \(neighborhood)
                    
                    iPhone: \(appStoreLink)
                    Android: \(playStoreLink)
                    Website: \(companyLink)
                    """
                    
                    var shareItems: [Any] = [shareText]
                    
                    // ✅ Add image if available
                    if let imageURL = URL(string: imageURLString), !imageURLString.isEmpty {
                        if let imageData = try? Data(contentsOf: imageURL),
                           let image = UIImage(data: imageData) {
                            shareItems.append(image)
                        } else {
                            shareItems.append(imageURL)
                        }
                    }
                    
                    // ✅ Present Share Sheet
                    let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                    self.present(activityVC, animated: true)
                }
                
                
                
                
                
                
                
                cell.FullImgCallback = { [self] value in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostEnlargeImageViewController")as! PostEnlargeImageViewController
                    vc.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
                    vc.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
                    //  vc.UserimgData = (PostListData?.listdata?[indexPath.row].userpic ?? [])
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.postid = postData.postid
                if let postData = item as? HomeNewData {
                    cell.userId = postData.createdby
                    print("✅ PostData CreatedBy: \(postData.createdby ?? "nil")")
                    let createdByUser = postData.createdby
                    cell.DotCallback = { [weak self] postID in
                        guard let self = self else { return }
                        if !NetworkMonitor.shared.isConnected {
                            // Show your own alert or prevent API call
                            showAlert(message: "Internet not available. Please check your connection.")
                            return
                        }
                        
                        if profileData?.verfiedMsg == "User Verification is completed!" {
                            guard let homeData = self.HomeNewData?.listdata, indexPath.row < homeData.count else { return }
                            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDotViewController") as? PostDotViewController else { return }
                            let selectedPost = homeData[indexPath.row]
                            
                            vc.business_id = postID // postID pass karo
                            
                            print("✅ Passing Post ID to PostDotViewController: \(postID ?? "No Post ID")")
                            //                            vc.poststs = homeData[indexPath.row].favouritstatus // Make sure 'favouritstatus' is an Int
                            
                            
                            
                            // Configure PostDotViewController appearance and presentation
                            //                            vc.height = 270
                            vc.topCornerRadius = 10.0
                            vc.presentDuration = 0.2
                            vc.dismissDuration = 0.2
                            let selectedPostData = homeData[indexPath.row] // ✅ Correct row ka data lo
                            vc.poststs = selectedPost.favouritstatus
                            
                            
                            
                            
                            
                            vc.callbackf = { [weak self] status in
                                guard let self = self else { return }
                                print("Callback received with status: \(status)")
                                
                                guard let postId = selectedPost.postid else { return }
                                
                                if status == 1 {
                                    // Favourite selected
                                    self.callFavouriteBussinessWebService(postId: postId) { message in
                                        self.HomeNewData?.listdata?[indexPath.row].favouritstatus = 1
                                        self.tableviewMember.reloadRows(at: [indexPath], with: .none) // ✅ UI Refresh
                                        self.callUserProfileWebService {
                                            self.callHomeAllWebService {
                                                // Completion block (agar kuch karna ho)
                                            }
                                        }
                                        //                                        self.showAutoDismissAlert(message: message)
                                    }
                                } else if status == 0 {
                                    // Unfavourite selected
                                    self.callFavouriteRemoveBussinessWebService(postId: postId) { message in
                                        self.HomeNewData?.listdata?[indexPath.row].favouritstatus = 0
                                        self.tableviewMember.reloadRows(at: [indexPath], with: .none) // ✅ UI Refresh
                                        self.callUserProfileWebService {
                                            self.callHomeAllWebService {
                                                // Completion block (agar kuch karna ho)
                                            }
                                        }
                                        //                                        self.showAutoDismissAlert(message: message)
                                    }
                                }
                            }
                            
                            
                            vc.createdBy = createdByUser
                            print("✅ Passing CreatedBy to PostDotViewController: \(createdByUser ?? "nil")")
                            vc.view.backgroundColor = .white
                            // Modify the callback to accept an 'Int' instead of 'Range<Int>' (if required)
                            vc.onUpdateForBlock = { [weak self] in
                                self?.refreshPage()
                            }
                            
                            
                            vc.onUpdateForFav = { [weak self] in
                                self?.callUserProfileWebService {
                                    self?.callHomeAllWebService {
                                        // Completion block (agar kuch karna ho)
                                    }
                                }
                            }
                            
                            
                            vc.callback = { status in
                                // Handle the status (status should be an Int, not Range<Int>)
                                print("Callback received with status: \(status)")
                            }
                            
                            //  MARK: - Configure navigateToReportCallback to pass data and navigate to ReportPostViewController
                            vc.navigateToReportCallback = { [weak self] in
                                guard let self = self else { return }
                                if let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportPostViewController") as? ReportPostViewController {
                                    // ✅ Basic details
                                    reportVC.UserName = postData.username ?? ""
                                    reportVC.sectorName = postData.neighborhood ?? ""
                                    reportVC.MonthName = postData.createdOn ?? ""
                                    reportVC.GeneralName = postData.postType ?? ""
                                    reportVC.DescriptionlName = postData.postMessage ?? ""
                                    reportVC.CommentName = postData.totcomment ?? ""
                                    reportVC.likeName = postData.totallike ?? ""
                                    reportVC.postid = postID ?? ""
                                    
                                    // ✅ 1. Pass postImagesN as-is (if used elsewhere)
                                    reportVC.mediaDatas = postData.postImagesN ?? []
                                    
                                    // ✅ 2. Convert to [PostImage] for main `mediaData` usage
                                    let convertedMedia: [PostImage] = postData.postImagesN?.map {
                                        PostImage(img: $0.img, video: $0.video)
                                    } ?? []
                                    reportVC.mediaData = convertedMedia
                                    
                                    print("✅ Passing to ReportPostViewController:")
                                    convertedMedia.forEach { media in
                                        if let img = media.img, !img.isEmpty {
                                            print("🖼 Image: \(img)")
                                        }
                                        if let vid = media.video, !vid.isEmpty {
                                            print("🎥 Video: \(vid)")
                                        }
                                    }
                                    
                                    self.dismiss(animated: true) {
                                        self.navigationController?.pushViewController(reportVC, animated: true)
                                    }
                                }
                            }
                            
                            
                            
                            
                            
                            vc.navigateToDeleteCallback = { [weak self] in
                                guard let self = self else { return }
                                
                                // Fetching postId and userId
                                guard let postId = homeData[indexPath.row].postid,
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
                                            self.callHomeAllWebService{
                                                self.tableviewMember.reloadData()
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
                        else {
                            // Show alert if verification is not complete
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
                }
                
            }
            return cell
            
        case "Welcome":
            print("🟢 Calling Welcome Cell")
            
            let dataSource = isSearching ? filteredData : HomeNewData
            let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeTableViewCell", for: indexPath) as! WelcomeTableViewCell
            if let wlcmData = item as? HomeNewData {
                print("Welcome Data: \(wlcmData)")
                let createdBy = wlcmData.createdby ?? ""
                cell.lblWelcmMsg.text = (wlcmData.welcomeMsg ?? "") + "."
                cell.lblName.text = "Let's welcome \(wlcmData.username ?? "")!"
                cell.btnLike?.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 17)
                cell.btnFlower?.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 17)
                cell.btnLike.setTitle("\(wlcmData.total_like ?? 0)", for: .normal)
                cell.btnFlower.setTitle("\(wlcmData.total_bokay ?? 0)", for: .normal)
                cell.selectionStyle = .none
                cell.likeStatus = Int(wlcmData.like_status ?? "0") ?? 0
                cell.bokayStatus = Int(wlcmData.user_bokay ?? "0") ?? 0
                cell.welUserID = wlcmData.createdby ?? ""
                print(wlcmData.like_status)
                print(wlcmData.user_bokay)
                cell.onLikeTapped = { [weak self] welUserID in
                    guard let self = self else { return }
                    // 1. Network check
                    if !NetworkMonitor.shared.isConnected {
                        self.showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    // 2. Verification check
                    guard self.HomeNewData?.verfiedMsg == "User Verification is completed!" else {
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
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    // Action not allowed if already bokayed
                    if cell.bokayStatus == 1 {
                        print("❌ Already Bokayed. Like is not allowed.")
                        return
                    }
                    
                    // Like action UI/logic
                    let currentLikeCount = Int(cell.btnLike.title(for: .normal) ?? "0") ?? 0
                    cell.btnLike.setTitle("\(currentLikeCount + 1)", for: .normal)
                    cell.likeStatus = 1
                    
                    self.callHomeLikeWelWebService(welUserID: welUserID) {
                        // Optionally reload UI if needed
                    }
                }
                
                
                cell.onBokayTapped = { [weak self] welUserID in
                    guard let self = self else { return }
                    
                    // 1. Network check
                    if !NetworkMonitor.shared.isConnected {
                        self.showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    // 2. Verification check
                    guard self.HomeNewData?.verfiedMsg == "User Verification is completed!" else {
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
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    // Action not allowed if already liked
                    if cell.likeStatus == 1 {
                        print("❌ Already Liked. Bokay is not allowed.")
                        return
                    }
                    
                    // Bokay action UI/logic
                    let currentBokayCount = Int(cell.btnFlower.title(for: .normal) ?? "0") ?? 0
                    cell.btnFlower.setTitle("\(currentBokayCount + 1)", for: .normal)
                    cell.bokayStatus = 1
                    
                    self.callHomebookayWebService(welUserID: welUserID) {
                        // Optionally reload UI if needed
                    }
                }
                
                
                
                
            }
            return cell
            
        case "Sponsor":
            print("🟢 Calling Sponsor Cell")
            let dataSource = isSearching ? filteredData : HomeNewData
            let cell = tableView.dequeueReusableCell(withIdentifier: "SponsorTableViewCell", for: indexPath) as! SponsorTableViewCell
            //            let businessData = dataSource?.listdata?.filter { $0.type == "Sponsor" }[indexPath.row]
            if let sponsorData = item as? HomeNewData {
                print("Sponsor Data: \(sponsorData)")
                // Configure the cell using businessData
                cell.lblCompany.text = sponsorData.company
                cell.lblSponsor.text = sponsorData.type
                
                cell.lblAction.text = "Action"
                cell.actionTappedCallback = { [weak self] in
                    if let urlString = sponsorData.companylink, let url = URL(string: urlString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("Invalid URL")
                    }
                }
                
                // cell.lblAction.text = sponsorData.companylink
                let url = URL(string: (sponsorData.companylogo ?? ""))
                cell.LogoImg.kf.indicatorType = .activity
                cell.LogoImg.kf.setImage(with: url, placeholder: UIImage(named: "NewBusiness"))
                
                let urlBan = URL(string: (sponsorData.bannerimage ?? ""))
                cell.BannerImgView.kf.indicatorType = .activity
                cell.BannerImgView.kf.setImage(with:urlBan ,placeholder: UIImage(named: "defaultImage"))
                
            }
            return cell
            
        case "Event":
            print("🟢 Calling Event Cell")
            
            let dataSource = isSearching ? filteredData : HomeNewData
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventHomeTableViewCell", for: indexPath) as! EventHomeTableViewCell
            //            let eventData = dataSource?.listdata?.filter { $0.type == "Event" }[indexPath.row]
            if let eventData = item as? HomeNewData {
                print("Event Data: \(eventData)")
                // Configure the cell using businessData
                cell.lblName.text = eventData.username
                cell.lblCreateOn.text = eventData.createdOn
                cell.lblSector.text = eventData.neighborhood
                cell.lblEventTitle.text = eventData.eventName
                cell.lblStartDate.text = eventData.eventStartDate
                cell.lblEndDate.text = eventData.eventEndDate
                //                cell.lblCreateOn.font = UIFont(name: "Montserrat-Regular", size: 12)
                //                cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 12)
                //                cell.lblEventTitle.font = UIFont(name: "Montserrat-Regular", size: 14)
                //                cell.lblStartDate.font = UIFont(name: "Montserrat-Regular", size: 14)
                //                cell.lblEndDate.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblCreateOn.font = UIFont(name: "Montserrat-Regular", size: 12)
                cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 12)
                cell.lblEventTitle.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblStartDate.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblStartDate.font = UIFont(name: "Montserrat-Regular", size: 14) // lblEndEvent
                cell.lblStartEvent.font = UIFont(name: "Montserrat-SemiBold", size: 14) // lblEndEvent
                cell.lblEndEvent.font = UIFont(name: "Montserrat-SemiBold", size: 14) // lblEndEvent
                cell.lblEndDate.font = UIFont(name: "Montserrat-Regular", size: 14)
                let url = URL(string: (eventData.eventCoverImage ?? ""))
                cell.BannerImgView.kf.indicatorType = .activity
                cell.BannerImgView.kf.setImage(with:url ,placeholder: UIImage(named: "EventImage"))
                let urlBan = URL(string: (eventData.userpic ?? ""))
                cell.ProfileImgView.kf.indicatorType = .activity
                cell.ProfileImgView.kf.setImage(with:urlBan ,placeholder: UIImage(named: "EventImage"))
                print(eventData.eventid)
                cell.userId = eventData.createdby // 🟢 Assign userId
                cell.delegate = self  // 🟢 Assign Delegate
                if traitCollection.userInterfaceStyle == .dark {
                    cell.backgroundColor =  #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1) // mode background
                } else {
                    cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1) // Light mode background
                }
                
                // MARK: - Call for button push toh eventDitails
                cell.eventCallAction = { [weak self] value in
                    guard let self = self else { return }
                    guard let postListData = self.HomeNewData?.listdata, indexPath.row < postListData.count else { return }
                    if !NetworkMonitor.shared.isConnected {
                        // Show your own alert or prevent API call
                        showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    if HomeNewData?.verfiedMsg == "User Verification is completed!" {
                        // Safely unwrap PostDotViewController
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController") as? EventsDetailViewController else { return }
                        vc.createdBy = eventData.createdby ?? ""
                        vc.eventid = eventData.eventid ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
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
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                //MARK: -             EventThreeDotViewController
                cell.DotCallback = { [weak self] value in
                    guard let self = self else { return }
                    if !NetworkMonitor.shared.isConnected {
                        // Show your own alert or prevent API call
                        showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    
                    if profileData?.verfiedMsg == "User Verification is completed!" {
                        // Ensure PostListData and listdata are non-nil and indexPath.row is valid
                        guard let postListData = self.HomeNewData?.listdata, indexPath.row < postListData.count else { return }
                        
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
                    else {
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
                
            }
            
            
            return cell
            
        case "Poll":
            print("🟢 Calling Poll Cell")
            
            let dataSource = isSearching ? filteredData : HomeNewData
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollHomeTableViewCell", for: indexPath) as! PollHomeTableViewCell
            //            let pollData = dataSource?.listdata?.filter { $0.type == "Poll" }[indexPath.row]
            if let pollData = item as? HomeNewData {
                print("Poll Data: \(pollData)")
                // Configure the cell using businessData
                cell.lblName.text = pollData.username
                cell.lblSector.text = pollData.neighborhood
                cell.lblTime.text = pollData.createdOn
                cell.lblAddress.text = pollData.pollQuestion
                cell.lblstartdate.text = pollData.pollStartDate
                cell.lblEnddate.text = pollData.pollEndDate
                cell.lblVote.text = (pollData.totalvote == "0") ? "" : (pollData.totalvote ?? "")
                cell.userId = pollData.createdby
                cell.delegate = self
                cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 12)
                cell.lblTime.font = UIFont(name: "Montserrat-Regular", size: 12)
                cell.lblAddress.font = UIFont(name: "Montserrat-Regular", size: 16)
                cell.lblstartdate.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblEnddate.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblVote.font = UIFont(name: "Montserrat-Regular", size: 14)
                
                if pollData.isvoted == "1" {
                    cell.VoteBtn.setTitle("Voted", for: .normal)
                    cell.VoteBtn.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
                }
                if pollData.isvoted == "0" {
                    cell.VoteBtn.setTitle("Vote", for: .normal)
                    cell.VoteBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                }
                
                if pollData.ispollrunning == "0" {
                    cell.VoteBtn.backgroundColor =  #colorLiteral(red: 0.8549019608, green: 0, blue: 0, alpha: 1)
                    cell.VoteBtn.setTitle("Vote", for: .normal)
                }
                
                if pollData.ispollrunning == "2" {
                    cell.VoteBtn.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
                    cell.VoteBtn.setTitle("Closed", for: .normal)
                }
                
                cell.DetailsCallback = { [weak self] value in
                    guard let strongSelf = self else { return }
                    if !NetworkMonitor.shared.isConnected {
                        strongSelf.showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    if strongSelf.profileData?.verfiedMsg == "User Verification is completed!" {
                        guard let userID = UserDefaults.standard.string(forKey: "userid") else { return }
                        
                        if userID == pollData.createdby { // Creator can navigate even if poll is closed
                            if pollData.ispollrunning == "2" || pollData.ispollrunning == "1" {
                                let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "PollsDetailViewController") as! PollsDetailViewController
                                vc.pollid = pollData.pollid ?? ""
                                vc.id = pollData.hID ?? ""
                                strongSelf.navigationController?.pushViewController(vc, animated: true)
                            }
                        } else {
                            if pollData.ispollrunning == "2" {
                                let messageText = "Voting is closed."
                                let alert = UIAlertController(title: "", message: messageText, preferredStyle: .alert)
                                let messageAttributes: [NSAttributedString.Key: Any] = [
                                    .font: UIFont(name: "Montserrat-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15),
                                    .foregroundColor: UIColor.darkGray
                                ]
                                let attributedMessage = NSAttributedString(string: messageText, attributes: messageAttributes)
                                alert.setValue(attributedMessage, forKey: "attributedMessage")
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
                                alert.addAction(okAction)
                                self?.present(alert, animated: true, completion: nil)
                            } else {
                                let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "PollsDetailViewController") as! PollsDetailViewController
                                vc.pollid = pollData.pollid ?? ""
                                vc.id = pollData.hID ?? ""
                                strongSelf.navigationController?.pushViewController(vc, animated: true)
                            }
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
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
                cell.DotCallback = { [self] value in
                    
                    if !NetworkMonitor.shared.isConnected {
                        // Show your own alert or prevent API call
                        showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    
                    
                    if profileData?.verfiedMsg == "User Verification is completed!" {
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollDotViewController") as? PollDotViewController else {return}
                        vc.business_id = pollData.pollid ?? ""
                        vc.height = 180
                        vc.topCornerRadius = 10.0
                        vc.presentDuration = 0.5
                        vc.dismissDuration = 0.5
                        //                        vc.createdBy = cell.userId
                        vc.createdBy = pollData.createdby // abdul
                        vc.view.backgroundColor = .white
                        print("Sending poll cfready by ID is : \(cell.userId ?? "")")
                        
                        vc.onUpdateForBlock = { [weak self] in
                            self?.refreshPage()
                        }
                        vc.onUpdateForFav = { [weak self] in
                            self?.refreshPage()
                        }
                        
                        vc.callback = { range in
                        }
                        
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                    else {
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
                let url = URL(string: (pollData.userpic ?? ""))
                cell.ProfileImgView.kf.indicatorType = .activity
                cell.ProfileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
                
            }
            return cell
            
        case "Business":
            print("🟢 Calling Business Cell")
            
            let dataSource = isSearching ? filteredData : HomeNewData
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBusinessTableViewCell", for: indexPath) as! HomeBusinessTableViewCell
            //            let businessData = dataSource?.listdata?.filter { $0.type == "Business" }[indexPath.row]
            if let businessData = item as? HomeNewData {
                print("Business Data: \(businessData)")
                // Configure the cell using businessData
                cell.lblUserName.text = businessData.username
                cell.lblSector.text = businessData.neighborhood
                cell.lblProduct.text = businessData.businessName
                cell.lblHealth.text = businessData.category
                cell.BusimgData = businessData.businessImage ?? []
                cell.delegateH = self
                cell.delegate = self
                cell.userId = businessData.createdby
                cell.delegate = self
                cell.businessID = businessData.bID // Jo bhi aapka model ka business id ho
                cell.businessDelegate = self
                if traitCollection.userInterfaceStyle == .dark {
                    // separator.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
                    cell.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
                } else {
                    //  separator.isHidden = true
                    cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
                }
                let urlBan = URL(string: (businessData.userpic ?? ""))
                cell.profileImgView.kf.indicatorType = .activity
                cell.profileImgView.kf.setImage(with:urlBan ,placeholder: UIImage(named: "defaultImage"))
                cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 12)
                cell.lblProduct.font = UIFont(name: "Montserrat-SemiBold", size: 15)
                cell.lblHealth.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.DetailsCallback = { [self] value in
                    
                    if !NetworkMonitor.shared.isConnected {
                        // Show your own alert or prevent API call
                        showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    
                    
                    if HomeNewData?.verfiedMsg == "User Verification is completed!" {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDetailsViewController")as! BusinessDetailsViewController
                        // vc.groupid = GroupListData?.listdata![IndexPath.row].groupid
                        vc.business_id = businessData.bID ?? ""
                        //            vc.userid = GroupListData?.listdata![indexPath.row].userid ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
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
                
                
                cell.DotCallback = { [self] value in
                    
                    if !NetworkMonitor.shared.isConnected {
                        // Show your own alert or prevent API call
                        showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    
                    
                    if profileData?.verfiedMsg == "User Verification is completed!" {
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDotViewController") as? BusinessDotViewController else {return}
                        vc.business_id = businessData.bID ?? ""
                        vc.height = 180
                        vc.topCornerRadius = 10.0
                        vc.presentDuration = 0.5
                        vc.dismissDuration = 0.5
                        vc.createdBy = businessData.createdby
                        //                        vc.view.backgroundColor = .white
                        //                        vc.onUpdateForBlock = { [weak self] in
                        //                            self?.refreshPage()
                        //                        }
                        
                        vc.dismissDuration = 0.5
                        vc.createdBy = businessData.createdby
                        vc.userID = businessData.createdby
                        vc.view.backgroundColor = .white
                        
                        vc.onUpdateForBlock = { [weak self] in
                            self?.refreshPage()
                        }
                        
                        
                        vc.callback = { range in
                        }
                        
                        vc.onUpdateForFav = { [weak self] in
                            self?.refreshPage()
                        }
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
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
            }
            return cell
            
            
        case "Group":
            print("🟢 Calling Group Cell")
            let dataSource = isSearching ? filteredData : HomeNewData
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            //           let GroupsData = dataSource?.listdata?.filter { $0.type == "Group" }[indexPath.row]
            if let groupsData = item as? HomeNewData {
                print("Group Data: \(groupsData)")
                // Configure the cell using businessData
                cell.lblName.text = groupsData.username
                cell.lblGroupName.text = groupsData.groupName
                cell.lblPrivate.text = "\(groupsData.groupType ?? "") Group"
                cell.lblSec.text = groupsData.neighborhood
                cell.lblTime.text = groupsData.createdOn
                cell.userId = groupsData.createdby
                cell.delegate = self
                // Use the custom dark green in dark mode, otherwise default gray
                if traitCollection.userInterfaceStyle == .dark {
                    // separator.backgroundColor =  #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
                    cell.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
                } else {
                    //  separator.isHidden = true
                    cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
                }
                cell.lblGroupName.font = UIFont(name: "Montserrat-Regular", size: 16)
                cell.lblPrivate.font = UIFont(name: "Montserrat-Regular", size: 15)
                cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.lblTime.font = UIFont(name: "Montserrat-Regular", size: 13)
                
                let url = URL(string: (groupsData.userpic ?? ""))
                cell.UserImgView.kf.indicatorType = .activity
                cell.UserImgView.kf.setImage(with: url, placeholder: UIImage(named: "NewBusiness"))
                
                if let groupImage = groupsData.groupImage, !groupImage.isEmpty {
                    let url = URL(string: groupImage)
                    cell.profileImgView.kf.indicatorType = .activity
                    cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "groupImg"))
                } else {
                    cell.profileImgView.image = UIImage(named: "groupImg") // Set default image
                }
                
                cell.DetailsCallback = { [self] value in
                    if !NetworkMonitor.shared.isConnected {
                        // Show your own alert or prevent API call
                        showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    if HomeNewData?.verfiedMsg == "User Verification is completed!" {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController")as! GroupsViewController
                        // vc.groupid = GroupListData?.listdata![IndexPath.row].groupid
                        //     vc.selectedNeighborhoodId = GroupsData?.bID ?? ""
                        //            vc.userid = GroupListData?.listdata![indexPath.row].userid ?? ""
                        vc.groupid = groupsData.createdby ?? ""
                        vc.sourceViewController = "Menu"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        
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
                
                
                
                //MARK: -   GroupThreeDotViewController
                
                cell.DotCallback = { [weak self] value in
                    guard let self = self else { return }
                    if !NetworkMonitor.shared.isConnected {
                        // Show your own alert or prevent API call
                        showAlert(message: "Internet not available. Please check your connection.")
                        return
                    }
                    
                    
                    if profileData?.verfiedMsg == "User Verification is completed!" {
                        // Ensure PostListData and listdata are non-nil and indexPath.row is valid
                        guard let postListData = self.HomeNewData?.listdata, indexPath.row < postListData.count else { return }
                        // Safely unwrap PostDotViewController
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupThreeDotViewController") as? GroupThreeDotViewController else { return }
                        // Set properties for PostDotViewController
                        vc.business_id = groupsData.groupid
                        vc.poststs = postListData[indexPath.row].favouritstatus // Make sure 'favouritstatus' is an Int
                        print(groupsData.groupid)
                        // Configure PostDotViewController appearance and presentation
                        //                        vc.height = 180
                        //                        vc.createdby = groupsData.createdby
                        //                        vc.topCornerRadius = 10.0
                        //                        vc.presentDuration = 0.2
                        //                        vc.dismissDuration = 0.2
                        //                        vc.view.backgroundColor = .white
                        //                        vc.onUpdateForBlock = { [weak self] in
                        //                            self?.refreshPage()
                        //                        }
                        
                        vc.height = 180
                        vc.createdby = groupsData.createdby
                        vc.topCornerRadius = 10.0
                        vc.presentDuration = 0.2
                        vc.dismissDuration = 0.2
                        vc.view.backgroundColor = .white
                        vc.onUpdateForBlock = { [weak self] in
                            self?.refreshPage()
                        }
                        vc.isComingFromMenuBussinessVC = false
                        vc.onUpdateForFav = { [weak self] in
                            self?.refreshPage()
                        }
                        
                        vc.callback = { status in
                            // Handle the status (status should be an Int, not Range<Int>)
                            print("Callback received with status: \(status)")
                        }
                        // Present PostDotViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else {
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
                
            }
            return cell
        default:
            return UITableViewCell()
            
        }
    }
    
    // MARK: - MemberTableViewCellDelegate
    func didTapCommentsButton(cell: MemberTableViewCell) {
        DispatchQueue.main.async { [self] in
            // Cell ke indexPath ko fetch karo
            guard let indexPath = self.tableviewMember.indexPath(for: cell) else {
                print("❌ Error: Unable to fetch indexPath for cell.")
                return
            }
            
            print("✅ IndexPath found: \(indexPath.section) - \(indexPath.row)")
            
            if !NetworkMonitor.shared.isConnected {
                // Show your own alert or prevent API call
                showAlert(message: "Internet not available. Please check your connection.")
                return
            }
            
            
            // Profile verification check karo
            if self.profileData?.verfiedMsg == "User Verification is completed!" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let postDetailsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailsNewViewController") as? PostDetailsNewViewController {
                    
                    ////                    // ✅ Correct way to fetch post data
                    let sectionData = sortedSections[indexPath.section]
                    //                    if let postData = sectionData.1[indexPath.row] as? HomeNewData {
                    //                        postDetailsVC.postid = postData.postid ?? ""
                    
                    if let postData = sectionData.1[indexPath.row] as? HomeNewData {
                        postDetailsVC.postid = postData.postid ?? ""
                        print("✅ Post ID: \(postData.postid ?? "No Post ID")")
                        
                    } else {
                        print("❌ Post Data Not Found")
                        postDetailsVC.postid = ""
                    }
                    self.navigationController?.pushViewController(postDetailsVC, animated: true)
                }
            } else {
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
    
    func didSelectItem(with postImage: postImagesN, username: String, allImages: [postImagesN]) {
        if let videoUrl = postImage.video, let url = URL(string: videoUrl) {
            let player = AVPlayer(url: url)
            player.isMuted = true // ✅ By default video mute rahega
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.pause()
            }
        } else {
            
            if !NetworkMonitor.shared.isConnected {
                // Show your own alert or prevent API call
                showAlert(message: "Internet not available. Please check your connection.")
                return
            }
            
            
            if HomeNewData?.verfiedMsg == "User Verification is completed!" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as! PostViewShowImgVideosDataVC
                // ✅ Saara data pass karo
                destinationVC.imgDataAll = allImages
                destinationVC.UserName = username
                self.navigationController?.pushViewController(destinationVC, animated: true)
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
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func didTapProfile(for userId: String) {
        if HomeNewData?.verfiedMsg == "User Verification is completed!" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            let loginUserId = UserDefaults.standard.string(forKey: "userid") ?? ""
            // Always pass selected userId
            vc.Oid = userId // Profile to show
            // Mark source
            vc.sourceViewController = (loginUserId == userId) ? "MyProfile" : "OtherProfile"
            // For matching later
            UserDefaults.standard.set(userId, forKey: "idOther")
            navigationController?.pushViewController(vc, animated: true)
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
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        print("🔠 Current Text: \(currentText)")
        print("➕ New Input: \(string)")
        print("🔍 Updated Text: \(updatedText)")
        filterData(with: updatedText)
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Remove emoji selection view when user starts scrolling
        removeEmojiSelectionView()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Continuously check and remove emoji selection view
        removeEmojiSelectionView()
        scrollViewDidPaginationScroll(scrollView)
    }
    
    func scrollViewDidPaginationScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        // Prevent multiple calls when already loading or no more pages
        guard !isLoading, !isLastPage else { return }
        
        // Detect scrolling to the bottom for next page
        if offsetY > contentHeight - scrollViewHeight - 100 {
            currentPage += 1
            callHomeAllWebService {
                DispatchQueue.main.async {
                    self.tableviewMember.reloadData()
                }
            }
        }
        
        // Detect scrolling to the top for previous page (optional)
        if offsetY < 0 && currentPage > 1 {
            currentPage -= 1
            callHomeAllWebService {
                DispatchQueue.main.async {
                    self.tableviewMember.reloadData()
                }
            }
        }
    }
    
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
    
    
    // MARK: - Call api firebaseToken dev.
    func callUpdateFirebaseTokenPostWebServiceDirect(userId: String, firebaseToken: String, _ completion: @escaping () -> ()) {
        
        // 🔗 Step 1: Create the full URL directly
        guard let url = URL(string: "https://dev.neighbrsnook.com/admin/api/update-token") else {
            print("❌ Invalid URL")  
            return
        }
        
        // 📦 Step 2: Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 🧾 Step 3: Prepare the parameters
        let params: [String: Any] = [
            "userid": userId,
            "firebase_token": firebaseToken
        ]
        
        // ✅ Step 4: Encode parameters to JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        } catch {
            print("❌ JSON encode error: \(error)")
            return
        }
        
        // 🚀 Step 5: Call the API
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ API error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Response Code: \(httpResponse.statusCode)")
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response: \(responseString)")
                }
            }
            
            // Callback
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
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
        
        if HomeNewData?.verfiedMsg == "User Verification is completed!"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let profileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                profileVC.Oid = userId
                profileVC.headingTitle = userId
                profileVC.isFromMessage = true
                if id == userId {
                    profileVC.sourceViewController = "MyProfile"
                    profileVC.Newid = userId
                } else {
                    profileVC.sourceViewController = "OtherProfile"
                    profileVC.Oid = userId
                    
                }
                
                
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
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
        
        
        if HomeNewData?.verfiedMsg == "User Verification is completed!" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as! BusinessDetailsViewController
            vc.business_id = businessID
            navigationController?.pushViewController(vc, animated: true)
        } else {
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



extension HomeAllModel {
    func copy(with listdata: [HomeNewData]?) -> HomeAllModel {
        return HomeAllModel(
            status: self.status,
            message: self.message,
            announcement: self.announcement,
            myNeighborhoodID: self.myNeighborhoodID,
            myNeighborhood: self.myNeighborhood,
            verfiedMsg: self.verfiedMsg,
            missmatchRemarks: self.missmatchRemarks,
            awaitStatus: self.awaitStatus,
            memberCount: self.memberCount,
            verifiedStatus: self.verifiedStatus,
            popupVerifiedStatus: self.popupVerifiedStatus,
            missmatchStatus: self.missmatchStatus,
            listdata: listdata
        )
    }
}

//MARK: - like unlike

extension HomeViewController: MemberTableViewLikeUnlikeCellDelegate {
    
    func didTapLike(postId: String, isLiked: Bool, emoji: String?) {
        if isLiked {
            callPostLikeWebService(postId: postId, emoji: emoji) { success in
                if success {
                    print("✅ Liked Post ID: \(postId)")
                    if let index = self.HomeNewData?.listdata?.firstIndex(where: { $0.postid == postId }) {
                        self.HomeNewData?.listdata?[index].postlike = "1"
                        self.HomeNewData?.listdata?[index].userEmoji = emoji
                        let currentLike = Int(self.HomeNewData?.listdata?[index].totallike ?? "0") ?? 0
                        self.HomeNewData?.listdata?[index].totallike = "\(currentLike + 1)"
                    }
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
                    if let index = self.HomeNewData?.listdata?.firstIndex(where: { $0.postid == postId }) {
                        self.HomeNewData?.listdata?[index].postlike = "0"
                        self.HomeNewData?.listdata?[index].userEmoji = nil
                        let currentLike = Int(self.HomeNewData?.listdata?[index].totallike ?? "0") ?? 1
                        self.HomeNewData?.listdata?[index].totallike = "\(max(0, currentLike - 1))"
                    }
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
        
        WebService.sharedInstance.callPostLikeWebService(withParams: params) { data in
            let success = (Int(data.status ?? "0") == 1)
            completion(success)
        }
        
    }
    
    func callPostUnLikeWebService(postId: String, completion: @escaping (Bool) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        let params: [String: Any] = [
            "userid": userId,
            "postid": postId,
            "likestatus": "0",
            "emojiunicode": ""
        ]
        
        WebService.sharedInstance.callPostUnLikeWebService(withParams: params) { data in
            let success = (Int(data.status ?? "0") == 1)
            completion(success)
        }
    }
    
    
    func callPostLikelistWebService(postId: String, completion: @escaping () -> Void) {
        let params: [String: Any] = [
            "postid": postId
        ]
        
        WebService.sharedInstance.callLikeListPostWebService(withParams: params) { data in
            // ✅ Replace dictionary subscript with property access
            if let likeCountFromServer = data.totalEmojis,
               let index = self.HomeNewData?.listdata?.firstIndex(where: { $0.postid == postId }) {
                self.HomeNewData?.listdata?[index].totallike = String(likeCountFromServer)
            }
            
            completion()
        }
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
