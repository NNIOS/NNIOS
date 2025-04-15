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

@available(iOS 16.0, *)
class HomeViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblNeighbrsnook: UILabel!
    @IBOutlet weak var tableviewMember: UITableView!
    @IBOutlet weak var SectorLbl: UILabel!
    @IBOutlet weak var MemberLbl: UILabel!
    @IBOutlet weak var NMemberLbl: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var LastNameLbl: UILabel!
    @IBOutlet weak var SectorMenuLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var viewToHide: UIView!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var Lblneighbourhood: UILabel!
    @IBOutlet weak var LblBussiness: UILabel!
    @IBOutlet weak var lblDm: UILabel!
    @IBOutlet weak var LblEvent: UILabel!
    @IBOutlet weak var LblFavourite: UILabel!
    @IBOutlet weak var lblGroup: UILabel!
    @IBOutlet weak var LblPolls: UILabel!
    @IBOutlet weak var LblPost: UILabel!
    @IBOutlet weak var lblPublic: UILabel!
    @IBOutlet weak var LblShare: UILabel!
    @IBOutlet weak var LblSetting: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var sideMenu: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var LblContact: UILabel!
    @IBOutlet weak var btnHomeimg: UILabel!
    @IBOutlet weak var lblVersionNeighbrsnook: UILabel!
    
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
    var sideMenuVisible = false
    var selectedNeighborhoodId: String?
    var welcomeid = [Datum]()
    var PopupVerifyData : PopUpVerificationModel?
    private let bottomPanelView = BottomPanelView()
    var deletePost : DeletePostModel?
    var savedProfileData: ProfileModel?
    var savedUploadedDocuments: UploadedDocumentsModel?
    
    private var activityIndicator: UIActivityIndicatorView?
    var loaderView: UIView?
    var currentPage = 1  // Start with page 1
    var isLoading = false // Prevent duplicate API calls
    var isLastPage = false // To determine if all data is loaded
    var imgDataAll: [postImagesN] = [] // Define your data source array
    
    var isExpanded = false // Track if description is expanded or collapsed
    var sortedSections: [(type: String, items: [Any])] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            lblVersionNeighbrsnook.text = "V\(version) @Neighbrsnook"
        }
        
        
        prepareSortedData(homeModel: HomeNewData)
        NetworkMonitor.shared.startMonitoring()
        if let verifiedStatus = HomeNewData?.verifiedStatus,
           let popupVerifiedStatus = HomeNewData?.popupVerifiedStatus,
           verifiedStatus == "1" && popupVerifiedStatus == 0 {
            // Create an attributed title
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 22) ?? UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            let attributedTitle = NSAttributedString(string: "Welcome!", attributes: titleAttributes)
            
            // Create an attributed message
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            let attributedMessage = NSAttributedString(string: "You are now a verified member.\n Happy Neighbrsnooking!!!", attributes: messageAttributes)
            
            // Create the alert controller
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            // Set the attributed title and message using KVC (Key-Value Coding)
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                print("OK button tapped")
                self.callpopupVerificationWebService {}
            }
            
            alertController.addAction(okAction)
            
            // Present the alert
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("Conditions not met, popup not shown")
        }
        // commend irshad check kanre ke liye
        callDeviceInfoWebService()
        self.searchView.isHidden = true
        // setupBottomPanel()
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        self.tabBarController?.tabBar.tintColor = UIColor.red
        SVProgressHUD.show()
        //  self.tabBarController?.tabBar.tintColor = UIColor.green
        self.SectorLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.MemberLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.NMemberLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.SectorMenuLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        
        self.lblProfile.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.Lblneighbourhood.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.LblBussiness.font = UIFont(name: "Montserrat-Regular", size: 17)
        //        self.lblDm.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.LblEvent.font = UIFont(name: "Montserrat-Regular", size: 17)
        //        self.LblFavourite.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblGroup.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.LblPolls.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.LblPost.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblPublic.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.LblShare.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.LblSetting.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblNeighbrsnook .font = UIFont(name: "Montserrat-Regular", size: 20)
        
        //   self.LblContact.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        NSLayoutConstraint.activate([
            viewSideMenu.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0), // Top constraint
            viewSideMenu.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0), // Bottom constraint
            viewSideMenu.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0), // Leading (left) constraint
            viewSideMenu.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0) // Trailing (right) constraint
        ])
        
        
        //        setdata()
        profileImgView.layer.cornerRadius = profileImgView.frame.size.width / 2
        profileImgView.clipsToBounds = true
        closeSideMenu()
        //        self.tabBarController?.delegate = self
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //        viewToHide.addGestureRecognizer(tapGesture)
        // commend irshad check kanre ke liye
        callDeviceInfoWebService()
        
        callHomeAllWebService{
            SVProgressHUD.dismiss()
            self.SectorLbl.text = self.HomeNewData?.myNeighborhood
            self.MemberLbl.text = self.HomeNewData?.memberCount
            
            self.tableviewMember.reloadData()
            
        }
        callHomeAllWebService{
            self.tableviewMember.reloadData()
            
        }
        
        
        // Initialize the refresh control page
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPageAction), for: .valueChanged)
        
        // Add the refresh control to your UITableView or UICollectionView
        tableviewMember.refreshControl = refreshControl
        
        
        
        
        
    }
    
    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        tabBarController?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if tabBarController?.delegate === self {
            tabBarController?.delegate = nil
        }
    }
    
    // Jab bhi text change hoga yeh function call hoga
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let searchText = textField.text {
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
        viewSideMenu.isHidden = true
        viewSideMenu.isHidden = true
        self.searchView.isHidden = true
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.shouldSupportAllOrientations = false
        }
        
        
        if let verifiedStatus = HomeNewData?.verifiedStatus,
           let popupVerifiedStatus = HomeNewData?.popupVerifiedStatus,
           verifiedStatus == "1" && popupVerifiedStatus == 0 {
            // Create an attributed title
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 22) ?? UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            let attributedTitle = NSAttributedString(string: "Welcome!", attributes: titleAttributes)
            
            // Create an attributed message
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            let attributedMessage = NSAttributedString(string: "You are now a verified member.\n Happy Neighbrsnooking!!!", attributes: messageAttributes)
            
            // Create the alert controller
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            // Set the attributed title and message using KVC (Key-Value Coding)
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                print("OK button tapped")
                self.callpopupVerificationWebService {}
            }
            
            alertController.addAction(okAction)
            
            // Present the alert
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("Conditions not met, popup not shown")
        }
        
        
        //        if let selectedIndex = selectedTabIndex {
        //            bottomPanelView.updateTabAppearance(selectedIndex: selectedIndex)
        //        }
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //                viewToHide.addGestureRecognizer(tapGesture)
        
        //   self.lblHeading.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        SVProgressHUD.show()
        
        
        
        callHomeAllWebService{
            SVProgressHUD.dismiss()
            self.tableviewMember.reloadData()
            
            
        }
        
        
        
        SVProgressHUD.show()
        // commend irshad check kanre ke liye
        callUserProfileWebService{ [self] in
            
            SVProgressHUD.dismiss()
            
            
            
            self.NameLbl.text = "\(self.profileData?.firstname ?? "") \(self.profileData?.lastname ?? "")"
            
            //  self.SecLbl.text = self.profileData?.lastname
            
            let url = URL(string: (self.profileData?.userpic ?? ""))
            self.profileImgView.kf.indicatorType = .activity
            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "profile 1"))
            self.SectorMenuLbl.text = self.profileData?.neighborhood
            // self.MobileLbl.text = self.profileData?.phoneno
            
            
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTableViewTap))
        tableviewMember.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTableViewTap() {
        if !viewSideMenu.isHidden {
            viewSideMenu.isHidden = true
        }
    }
    
    
    func refreshPage() {
        // Start loading data again (Web service calls)
        callUserProfileWebService {
            // This closure will be called once the user profile data is loaded
            // This closure will be called once the post list data is loaded
            self.callHomeAllWebService {
                // After all the web service calls are completed, reload the UI
                self.tableviewMember.reloadData()
                // Stop the refresh control spinner once everything is loaded
                self.tableviewMember.refreshControl?.endRefreshing()
            }
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
    
    
    
    @objc func handleTap() {
        viewSideMenu.isHidden = true
    }
    
    func closeSideMenu()
    {
        sideMenuVisible = false
        viewSideMenu.isHidden = true
    }
    
    @IBAction func btnSliderMenu(_ sender: UIButton) {
        viewSideMenu.isHidden = false
        
        // Create an overlay view to darken the background
        let extraView = UIView(frame: CGRect(x: viewSideMenu.frame.maxX,
                                             y: 0,
                                             width: self.view.frame.width - viewSideMenu.frame.width,
                                             height: self.view.frame.height))
        
        // Apply a dark semi-transparent background color
        extraView.backgroundColor = UIColor.black.withAlphaComponent(0.3) // Adjust the alpha for darkness intensity
        extraView.tag = 100 // Assign a unique tag to identify this view later
        
        // Add a tap gesture recognizer to the extra view to close the menu
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(extraViewTapped))
        extraView.addGestureRecognizer(tapGesture)
        
        // Add the extra view as a subview
        self.view.addSubview(extraView)
    }
    
    @objc func tabBarButtonTapped() {
        viewSideMenu.isHidden = false
    }
    @objc func handleSwipe() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnHideenMenu(_ : UIButton){
        
        viewSideMenu.isHidden = true
    }
    
    @objc private func emojiTapped(sender: UIButton) {
        callPostUnLikeWebService{
            self.tableviewMember.reloadData()
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        viewSideMenu.isHidden = false
    }
    
    @IBAction func btnCreatePost(_ : UIButton){
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
    
    
    
    @IBAction func btnMenu(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnProfile(_ : UIButton){
        closeSideMenu()
        viewSideMenu.isHidden = true
        
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}
        vc.sourceViewController = "HomeViewController"
       // vc.headingTitle = vc.Oid!.isEmpty ? "My Profile" : "Profile"
        vc.headingTitle = "My Profile" // हमेशा "My Profile" सेट करें
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNeighbrood(_ : UIButton){
        
        viewSideMenu.isHidden = true
        
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeighbourhoodViewController") as? NeighbourhoodViewController else { return }
        
        // Get the neighborhood ID from `profileData` or default to an empty string
        let selectedNeighbourId = profileData?.nbdId ?? ""
        
        // Pass the neighborhood ID to the view controller
        vc.idNeighbour = selectedNeighbourId
        
        // Save the neighborhood ID to UserDefaults
        UserDefaults.standard.set(selectedNeighbourId, forKey: "neighbrhood")
        
        // Navigate to the NeighbourhoodViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnBussiness(_ : UIButton){
        closeSideMenu()
        viewSideMenu.isHidden = true
        
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BussinesViewController") as? BussinesViewController else {return}
        vc.selectedNeighborhoodId = self.selectedNeighborhoodId
        vc.sourceViewController = "Neighbourhood"
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    
    @IBAction func btnPost(_ : UIButton){
        viewSideMenu.isHidden = true
        
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MennuPostViewController") as? MennuPostViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func btnEvent(_ : UIButton){
        viewSideMenu.isHidden = true
        
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsViewController") as? EventsViewController else {return}
        vc.sourceViewController = "Menu"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnGroups(_ : UIButton){
        viewSideMenu.isHidden = true
        
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController else {return}
        vc.sourceViewController = "Menu"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPolls(_ : UIButton){
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollsViewController") as? PollsViewController else {return}
        vc.sourceViewController = "Menu"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnSettings(_ : UIButton){
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingNewViewController") as? SettingNewViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnPublic(_ : UIButton){
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublicAgencyViewController") as? PublicAgencyViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnTerms$Condition(_ sender: UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewControllerViewController") as? WebViewControllerViewController else {return}
        vc.heading = "Privacy Policy"
        vc.urlString = "http://neighbrsnook.com/privacy-policy/"
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    @IBAction func btnDm(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectMessageViewController") as? DirectMessageViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnMarket(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeMarketViewController") as? HomeMarketViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
        self.MemberLbl.isHidden = true
        self.sideMenu.isHidden = true
        
    }
    
    
    
    
    @IBAction func btnSearch(_ : UIButton) {
        
        self.searchView.isHidden = false
        self.SectorLbl.isHidden = true
        self.MemberLbl.isHidden = true
        self.sideMenu.isHidden = true
        
    }
    
    
    
    
    @IBAction func btncancelSearch(_ : UIButton){
        self.searchView.isHidden = true
        self.tfSearch.text = ""
        self.SectorLbl.isHidden = false
        self.MemberLbl.isHidden = false
        self.sideMenu.isHidden = false
    }
    
    @IBAction func btnShareApp(_ : UIButton){
        // Step 1: Show share popup
        let appName = "NeighboursNook"
        let appDescription = "NeighbrsNook is a hyperlocal social networking service . Connecting with your neighborhood today!"
        let appLink = "https://testflight.apple.com/join/1G74jNEC"
        
        let shareText = "\(appDescription) \nDownload now: \(appLink)"
        
        // Step 2: Show share popup
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // Step 3: Present the share popup
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    
    @objc func extraViewTapped() {
        // Hide the side menu
        viewSideMenu.isHidden = true
        // Remove the extra view
        if let extraView = self.view.viewWithTag(100) {
            extraView.removeFromSuperview()
        }
    }
    
    
    
    //MARK: - ----------------------------------- call api userProfile -----------------------/
    
    
    // Function to fetch user profile and handle the response
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let loggedUser = UserDefaults.standard.string(forKey: "loggeduser") ?? ""
        
        let dictParams: [String: Any] = [
            "userid": id,
            "loggeduser": id // Use loggedUser instead of id
        ]
        print(dictParams)
        
        // Call the web service
        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { (data: ProfileModel?) in
            // Check if data is nil (i.e., the API response was unsuccessful)
            guard let data = data else {
                print("Error: API response is nil")
                completionClosure()
                return
            }
            
            // Now, 'data' is a ProfileModel, and we can safely assign it
            self.profileData = data
            self.savedProfileData = data
            print("Profile Data Saved: \(String(describing: self.savedProfileData))")
            
            // Save required fields to UserDefaults
            if let emerPhone = self.profileData?.emerPhone {
                UserDefaults.standard.set(emerPhone, forKey: "emer_phone")
            }
            if let userPic = self.profileData?.userpic {
                UserDefaults.standard.set(userPic, forKey: "profileImage")
            }
            if let lastName = self.profileData?.lastname {
                UserDefaults.standard.set(lastName, forKey: "lastName")
            }
            if let neighborhood = self.profileData?.neighborhood {
                UserDefaults.standard.set(neighborhood, forKey: "myNeighbhrhhod")
            }
            
            // Save address details
            let addressLineOne = self.profileData?.addlineone ?? ""
            let addressLineTwo = self.profileData?.addlinetwo ?? ""
            let city = self.profileData?.city ?? ""
            let state = self.profileData?.state ?? ""
            let country = self.profileData?.country ?? ""
            let pincode = self.profileData?.pincode ?? ""
            
            UserDefaults.standard.set(addressLineOne, forKey: "addressLineOne")
            UserDefaults.standard.set(addressLineTwo, forKey: "addressLineTwo")
            UserDefaults.standard.set(city, forKey: "city")
            UserDefaults.standard.set(state, forKey: "state")
            UserDefaults.standard.set(country, forKey: "country")
            UserDefaults.standard.set(pincode, forKey: "pincode")
            
            // Final completion callback
            completionClosure()
        }
    }
    
    
    
    // like api call
    func callPostLikeWebService(postId : String?,emoji : String?, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        //    let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        //     let idPost = UserDefaults.standard.string(forKey: "postid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "" ,
            "postid":postId ?? "",
            "likestatus": "1",
            "emojiunicode": emoji ?? "",
        ]
        
        WebService.sharedInstance.callPostLikeWebService(withParams: dictParams) { data in
            self.PostLikeData = data
            // UserDefaults.standard.setValue(nil, forKey: "postid")
            //  UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
            //  UserDefaults.standard.set("\(self.MemberListData?.listdata.first?.id ?? 0)", forKey: "userid")
            //              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
            // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
            // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
            
            completionClosure()
        }
    }
    
    
    // unlike api call
    
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
    
    
    
    
    
    // Your function to show the popup
    func showAwaitPopup(message: String) {
        let fullMessage = "There has been a mismatch found in your address against ID/ \(message) Please provide suitable documents for processing."
        let attributedMessage = NSMutableAttributedString(string: fullMessage)
        
        if let range = fullMessage.range(of: message) {
            let nsRange = NSRange(range, in: fullMessage)
            attributedMessage.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
        }
        
        let alert = UIAlertController(title: "Missmatched Documents", message: nil, preferredStyle: .alert)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Call user profile API
            self.callUserProfileWebService { [weak self] in
                guard let self = self else { return }
                
                // Call upload documents API
                self.callUploaddocumentWebService {
                    // Save uploaded documents data
                    self.savedUploadedDocuments = self.uploadDoc
                    
                    // Navigate to the next screen
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let registerVC = storyboard.instantiateViewController(withIdentifier: "ReUploadDocumentsVC") as? ReUploadDocumentsVC {
                        // Pass data to the next controller
                        print("Passing Profile Data: \(self.savedProfileData ?? nil)")
                        registerVC.uploadedDocuments = self.savedUploadedDocuments
                        registerVC.profileData = self.savedProfileData
                        self.navigationController?.pushViewController(registerVC, animated: true)
                    }
                }
            }
        }))
        
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
    
    
    
    
    
    
    
    
    
    
    func callHomebookayWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let Welid = UserDefaults.standard.string(forKey: "welcomeid")
        let Uwelid = UserDefaults.standard.string(forKey: "userWelid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "welcomeid":Welid ?? "",
            "weluserid":Uwelid ?? "",
            "bokaystatus":"1"
            
        ]
        WebService.sharedInstance.callHomebookayWebService(withParams: dictParams) { data in
            self.HomeBokkayData = data
            // UserDefaults.standard.set(self.HomeBokkayData?.b.id, forKey: "id")
            completionClosure()
        }
    }
    
    // like api
    func callHomeLikeWelWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let Welid = UserDefaults.standard.string(forKey: "welcomeid")
        let Uwelid = UserDefaults.standard.string(forKey: "userWelid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "welcomeid":Welid ?? "",
            "weluserid":Uwelid ?? "",
            "likestatus":"1"
            
        ]
        WebService.sharedInstance.callHomeLikeWelWebService(withParams: dictParams) { data in
            //   self.HomeBokkayData = data
            // UserDefaults.standard.set(self.HomeBokkayData?.b.id, forKey: "id")
            
            completionClosure()
        }
    }
    
    
    
    // -------------------------    get Device info Irshad malik --------------------/
    func getDeviceInfo() -> (deviceModel: String, deviceIMEI: String, devicePlatform: String, deviceID: String) {
        let device = UIDevice.current
        
        // Operating system name (e.g., "iOS")
        let systemName = device.systemName
        
        // Unique device identifier (UUID)
        let uuid = device.identifierForVendor?.uuidString ?? "N/A"
        
        // Get specific model name
        let modelName = getDeviceModelName()
        
        return (deviceModel: modelName, deviceIMEI: uuid, devicePlatform: systemName, deviceID: uuid)
    }
    
    // Helper function to get the specific model name using hardware identifier
    func getDeviceModelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0)
            }
        }
        
        // Mapping of model codes to specific iPhone models (only some examples shown here)
        let modelMap: [String: String] = [
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone13,3": "iPhone 12 Pro",
            // Add more models here as needed
        ]
        
        if let modelName = modelMap[modelCode ?? ""] {
            return modelName
        } else {
            return modelCode ?? "Unknown iPhone"
        }
    }
    
    // API call to post device information
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
            completionClosure()
        }
    }
    
    
    
    
    // irshad warknig api
    // call home all api
    func callHomeAllWebService(_ completionClosure: @escaping () -> ()) {
        self.prepareSortedData(homeModel: self.HomeNewData)  // Ensure it's using updated data
        guard !isLoading, !isLastPage else { return }
        isLoading = true
        
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "userid": id,
            "page": "\(currentPage)"
        ]
        
        showLoader()
        WebService.sharedInstance.callHomeAllWebService(withParams: dictParams) { data in
            self.hideLoader()
            self.isLoading = false
            
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
                            print("   🔸 Total Likes: \(datum.totalLike ?? 0)")
                            print("   🔸 Total Bokay: \(datum.totalBokay ?? 0)")
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
                
                if let awaitStatus = data.awaitStatus, awaitStatus == "1" {
                    let remarks = data.missmatchRemarks ?? "No remarks available"
                    self.showAwaitPopup(message: remarks)
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
    
    func filterData(with searchText: String) {
        print("🔍 Searching for: \(searchText)")  // Debug log
        
        guard !searchText.isEmpty else {
            filteredData = HomeNewData  // Search clear hone par pura data show karein
            isSearching = false
            tableviewMember.reloadData()
            return
        }
        
        isSearching = true
        let normalizedSearchText = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        
        filteredData = HomeAllModel(
            status: HomeNewData?.status,
            message: HomeNewData?.message,
            announcement: HomeNewData?.announcement,
            myNeighborhoodID: HomeNewData?.myNeighborhoodID,
            myNeighborhood: HomeNewData?.myNeighborhood,
            verfiedMsg: HomeNewData?.verfiedMsg,
            missmatchRemarks: HomeNewData?.missmatchRemarks,
            awaitStatus: HomeNewData?.awaitStatus,
            memberCount: HomeNewData?.memberCount,
            verifiedStatus: HomeNewData?.verifiedStatus,
            popupVerifiedStatus: HomeNewData?.popupVerifiedStatus ?? 0,
            listdata: HomeNewData?.listdata?.filter { datum in
                let normalizedUsername = datum.username?.lowercased() ?? ""
                let normalizedPostMessage = datum.postMessage?.lowercased() ?? ""
                let normalizedCompany = datum.company?.lowercased() ?? ""
                let normalizedEventName = datum.eventName?.lowercased() ?? ""
                
                return normalizedUsername.contains(normalizedSearchText) ||
                normalizedPostMessage.contains(normalizedSearchText) ||
                normalizedCompany.contains(normalizedSearchText) ||
                normalizedEventName.contains(normalizedSearchText)
            }
        )
        
        print("🔎 Filtered items count: \(filteredData?.listdata?.count ?? 0)")
        tableviewMember.reloadData()
    }
    
    
    // warking code hai ye tabke view ko theek karne ke liye
    
    func prepareSortedData(homeModel: HomeAllModel?) {
        guard let homeModel = homeModel else {
            print("❌ homeModel is NIL")
            return
        }
        guard let data = homeModel.listdata, !data.isEmpty else {
            print("❌ listdata is NIL or EMPTY")
            return
        }
        print("✅ listdata found, Count: \(data.count)")
        sortedSections.removeAll()
        // Add Announcement section first
        if let announcement = homeModel.announcement, !announcement.isEmpty {
            sortedSections.append(("Announcement", announcement))
            print("🟢 Added Announcement Section")
        }
        // **Maintain Exact API Order**
        for item in data {
            let type = item.type ?? "" // ✅ Optional handling
            sortedSections.append((type, [item])) // ✅ Correct tuple format
            print("✅ Section Added: \(type) - Count: 1 (Individual Item)")
        }
        
        print("🔢 Total Sections: \(sortedSections.count)")
        //        print("🟡 Final Sorted Sections: \(sortedSections)")
    }
    
    // Filtered data ko fetch karna
    func getFilteredData(for type: String, at index: Int) -> HomeNewData? {
        let dataSource = isSearching ? filteredData : HomeNewData
        let filteredList = dataSource?.listdata?.filter { $0.type == type } ?? []
        return index < filteredList.count ? filteredList[index] : nil
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
                //      guard var postData = dataSource?.listdata?.filter({ $0.type == "Post" })[indexPath.row] else { return cell }
                cell.lblLikeCount.text = postData.totallike
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
                cell.delegateM = self
                cell.favouriteButtonCallback = { [weak self] in
                    guard let self = self else { return }
                    // Make a mutable copy of the postData
                    var mutablePostData = postData
                    guard let postId = mutablePostData.postid, !postId.isEmpty else { return }
                    if mutablePostData.favouritstatus == 1 {
                        // Unfavourite Action
                        self.callFavouriteRemoveBussinessWebService(postId: postId) { message in
                            mutablePostData.favouritstatus = 0 // Update status
                            cell.updateFavouriteButton(isFavourite: false) // Update button icon
                            self.showAlert(message: message) // Show alert
                        }
                    } else {
                        // Favourite Action
                        self.callFavouriteBussinessWebService(postId: postId) { message in
                            mutablePostData.favouritstatus = 1 // Update status
                            cell.updateFavouriteButton(isFavourite: true) // Update button icon
                            self.showAlert(message: message) // Show alert
                        }
                    }
                }
                
                
                
 
                
                cell.likeUnLikeTab = { [weak self] in
                    guard let self = self else { return }

                    var mutablePostData = postData
                    guard let postId = mutablePostData.postid, !postId.isEmpty else { return }

                    // Like with Emoji
                    if let emoji = cell.selectedEmoji {
                        self.callPostLikeWebService(postId: postId, emoji: emoji) {
                            mutablePostData.favouritstatus = 1
                             print("✅ Liked with emoji \(emoji)")
                        }
                    } else {
                        // Normal Like / Unlike toggle
                        if cell.isLikedByUser {
                            self.callPostLikeWebService(postId: postId, emoji: "") {
                                mutablePostData.favouritstatus = 1
                                cell.updateFavouriteButton(isFavourite: true)
                                print("✅ Liked without emoji")
                            }
                        } else {
                            self.callPostUnLikeWebService {
                                mutablePostData.favouritstatus = 0
                                 print("❌ Unliked")
                            }
                        }
                    }
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
                        if profileData?.verfiedMsg == "User Verification is completed!" {
                            guard let homeData = self.HomeNewData?.listdata, indexPath.row < homeData.count else { return }
                            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDotViewController") as? PostDotViewController else { return }
                            vc.business_id = postID // postID pass karo
                            print("✅ Passing Post ID to PostDotViewController: \(postID ?? "No Post ID")")
                            vc.poststs = homeData[indexPath.row].favouritstatus // Make sure 'favouritstatus' is an Int
                            // Configure PostDotViewController appearance and presentation
                            //                            vc.height = 270
                            vc.topCornerRadius = 10.0
                            vc.presentDuration = 0.2
                            vc.dismissDuration = 0.2
                            let selectedPostData = homeData[indexPath.row] // ✅ Correct row ka data lo
                            vc.poststs = selectedPostData.favouritstatus // Make sure 'favouritstatus' is an Int
                            // ✅ Yahan `createdby` pass kar rahe hain
                            vc.createdBy = createdByUser // ✅ Yahan bhi wahi variable use kiya
                            print("✅ Passing CreatedBy to PostDotViewController: \(createdByUser ?? "nil")")
                            vc.view.backgroundColor = .white
                            // Modify the callback to accept an 'Int' instead of 'Range<Int>' (if required)
                            vc.callback = { status in
                                // Handle the status (status should be an Int, not Range<Int>)
                                print("Callback received with status: \(status)")
                            }
                            
                            
                            //  MARK: - Configure navigateToReportCallback to pass data and navigate to ReportPostViewController
                            vc.navigateToReportCallback = { [weak self] in
                                guard let self = self else { return }
                                if let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportPostViewController") as? ReportPostViewController {
                                    let selectedPost = homeData[indexPath.row]
                                    // Basic post data
                                    reportVC.UserName = selectedPost.username ?? ""
                                    reportVC.sectorName = selectedPost.neighborhood ?? ""
                                    reportVC.MonthName = selectedPost.createdOn ?? ""
                                    reportVC.GeneralName = selectedPost.postType ?? ""
                                    reportVC.DescriptionlName = selectedPost.postMessage ?? ""
                                    reportVC.CommentName = selectedPost.totcomment ?? ""
                                    reportVC.likeName = selectedPost.totallike ?? ""
                                    reportVC.postid = postID ?? ""
                                    
                                    // Pass the complete media array (both images and videos)
                                    reportVC.mediaDatas = selectedPost.postImagesN?.filter {
                                        !($0.img?.isEmpty ?? true) || !($0.video?.isEmpty ?? true)
                                    } ?? []
                                    
                                    print("📊 Passing Media Data:")
                                    reportVC.mediaDatas.forEach { media in
                                        if let img = media.img, !img.isEmpty {
                                            print("🖼 Image: \(img)")
                                        }
                                        if let video = media.video, !video.isEmpty {
                                            print("🎥 Video: \(video)")
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
            //            let WlcmData = dataSource?.listdata?.filter { $0.type == "Welcome" }[indexPath.row]
            if let wlcmData = item as? HomeNewData {
                print("Welcome Data: \(wlcmData)")
                // Configure the cell using pollData
                cell.lblWelcmMsg.text = wlcmData.welcomeMsg
                //
                cell.lblName.text = wlcmData.username
                cell.lblName.text = "Let's welcome \(wlcmData.username ?? "")"
                cell.lblWelcmCount.text = "\(wlcmData.totalLike ?? 0)"
                cell.lblBookaCount.text = "\(wlcmData.totalBokay ?? 0)"
                
                cell.bookayCallback = { [self] value in
                    
                    
                    callHomebookayWebService{}
                    callHomeAllWebService{}
                    
                }
                
                cell.WelLikeCallback = { [self] value in
                    
                    
                    callHomeLikeWelWebService{}
                    callHomeAllWebService{}
                    
                }
                
                cell.lblWelcmMsg.font = UIFont(name: "Montserrat-Regular", size: 16)
                cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 16)
                
                cell.lblWelcmCount.font = UIFont(name: "Montserrat-Regular", size: 13)
                cell.lblBookaCount.font = UIFont(name: "Montserrat-Regular", size: 13)
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
                cell.lblAction.text = sponsorData.action
                cell.lblAction.text = sponsorData.companylink
                
                cell.SponsCallback = { [weak self] value in
                    if let urlString = sponsorData.companylink, let url = URL(string: urlString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Optionally handle invalid URL here
                        print("Invalid URL")
                    }
                }
                
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
                cell.ProfileImgView.kf.setImage(with:urlBan ,placeholder: UIImage(named: "EventImage"))
                print(eventData.eventid)
                cell.userId = eventData.createdby // 🟢 Assign userId
                cell.delegate = self  // 🟢 Assign Delegate
                
                
                // MARK: - Call for button push toh eventDitails
                cell.eventCallAction = { [weak self] value in
                    guard let self = self else { return }
                    guard let postListData = self.HomeNewData?.listdata, indexPath.row < postListData.count else { return }
                    
                    // Safely unwrap PostDotViewController
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController") as? EventsDetailViewController else { return }
                    vc.eventid = eventData.eventid ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                
                
                //MARK: -             EventThreeDotViewController
                cell.DotCallback = { [weak self] value in
                    guard let self = self else { return }
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
                cell.lblSector.text = pollData.createdOn
                cell.lblTime.text = pollData.createdOn
                cell.lblAddress.text = pollData.pollQuestion
                
                cell.lblstartdate.text = pollData.pollStartDate
                cell.lblEnddate.text = pollData.pollEndDate
                cell.lblVote.text = pollData.totalvote
                cell.userId = pollData.createdby
                cell.delegate = self
                
                cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblTime.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblAddress.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblstartdate.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblEnddate.font = UIFont(name: "Montserrat-Regular", size: 14)
                cell.lblVote.font = UIFont(name: "Montserrat-Regular", size: 14)
                
                if pollData.isvoted == "0" {
                    cell.VoteBtn.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0, blue: 0, alpha: 1)
                    cell.VoteBtn.setTitle("Vote", for: .normal)
                } else {
                    cell.VoteBtn.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1) //
                    cell.VoteBtn.setTitle("Voted", for: .normal)
                }
                cell.DetailsCallback = { [weak self] value in
                    guard let strongSelf = self else { return }
                    
                    if strongSelf.profileData?.verfiedMsg == "User Verification is completed!" {
                        let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "PollsDetailViewController") as! PollsDetailViewController
                        vc.pollid = pollData.pollid ?? ""
                        vc.id = pollData.hID ?? ""
                        strongSelf.navigationController?.pushViewController(vc, animated: true)
                    } else {
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
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
                
                
                
                cell.DotCallback = { [self] value in
                    if profileData?.verfiedMsg == "User Verification is completed!" {
                        
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
                //
                
                cell.userId = businessData.createdby
                cell.delegate = self
                
                let urlBan = URL(string: (businessData.userpic ?? ""))
                cell.profileImgView.kf.indicatorType = .activity
                cell.profileImgView.kf.setImage(with:urlBan ,placeholder: UIImage(named: "defaultImage"))
                
                cell.lblUserName.font = UIFont(name: "Montserrat-Regular", size: 16)
                cell.lblSector.font = UIFont(name: "Montserrat-Regular", size: 13)
                
                cell.lblProduct.font = UIFont(name: "Montserrat-SemiBold", size: 15)
                cell.lblHealth.font = UIFont(name: "Montserrat-Regular", size: 13)
                
                cell.DetailsCallback = { [self] value in
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
                    if profileData?.verfiedMsg == "User Verification is completed!" {
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDotViewController") as? BusinessDotViewController else {return}
                        // vc.business_id = business_id
                        //   vc.business_id = postListData[indexPath.row].postid
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
                cell.lblPrivate.text = groupsData.groupType
                cell.lblSec.text = groupsData.neighborhood
                cell.lblTime.text = groupsData.createdOn
                
                cell.userId = groupsData.createdby
                cell.delegate = self
                
                cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 16)
                cell.lblGroupName.font = UIFont(name: "Montserrat-Regular", size: 13)
                
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
                    if HomeNewData?.verfiedMsg == "User Verification is completed!" {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController")as! GroupsViewController
                        // vc.groupid = GroupListData?.listdata![IndexPath.row].groupid
                        
                        //     vc.selectedNeighborhoodId = GroupsData?.bID ?? ""
                        //            vc.userid = GroupListData?.listdata![indexPath.row].userid ?? ""
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
                
                
                
                //            GroupThreeDotViewController
                
                cell.DotCallback = { [weak self] value in
                    guard let self = self else { return }
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
            
            // Profile verification check karo
            if self.profileData?.verfiedMsg == "User Verification is completed!" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let postDetailsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailsViewController") as? PostDetailsViewController {
                    //                    let navController = UINavigationController(rootViewController: postDetailsVC)
                    //                       navController.hidesBottomBarWhenPushed = false
                    //                       self.present(navController, animated: true)
                    
                    // ✅ Correct way to fetch post data
                    let sectionData = sortedSections[indexPath.section]
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
    
    
    
    
    
    // Set cell height to 0 when there's no data
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //
    //        switch indexPath.section {
    //        case 0:  // Announcement Section
    //            if let announcement = HomeNewData?.announcement, !announcement.isEmpty {
    //                return UITableView.automaticDimension // Regular height if data is available
    //            } else {
    //                return 0 // Height 0 when there's no announcement
    //            }
    //
    //
    //
    //        default:
    //            return UITableView.automaticDimension // Default height for other sections
    //        }
    //    }
    
    
    
    
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as! PostViewShowImgVideosDataVC
            
            // ✅ Saara data pass karo
            destinationVC.imgDataAll = allImages
            destinationVC.UserName = username
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    
    
    
    func didTapProfile(for userId: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        vc.Oid = userId
        print(userId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
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
        
        // Detect scrolling to the bottom for next page
        if offsetY > contentHeight - scrollViewHeight - 100 {
            currentPage += 1
            callHomeAllWebService {
                DispatchQueue.main.async {
                    self.tableviewMember.reloadData()
                }
            }
        }
        
        // Detect scrolling to the top for previous page
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
}

@available(iOS 16.0, *)
extension HomeViewController: EventHomeTableViewCellDelegate,ProfileTapDelegate {
    func didTapProfile(userId: String) {
        print("🔵 Profile Tapped for UserID: \(userId)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
            profileVC.Oid = userId  // 🟢 Pass UserID
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}




