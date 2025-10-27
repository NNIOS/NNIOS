//
//  GroupsViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 07/03/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class GroupsViewController: BaseViewController, ConfirmDelegate,UITextFieldDelegate  {
    func tapConfirm() {
        //   callGroupListWebService{}
    }
    
    
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var GroupLbl: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnOwner: UIButton!
    @IBOutlet weak var btnPrivate: UIButton!
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnJoined: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var groupsView: UIView!
    
    var GroupListData : GropsListModel?
    var JoinListData : JoinGroupModel?
    var filteredGroupData: GropsListModel?
    var searchWorkItem: DispatchWorkItem?
    var groupid : String?
    var groupName : String?
    var userName : String?
    var refreshTimer: Timer?
    //  var groupid : String?
    var userid : String?
    // var refreshTimer: Timer?
    var isTimerStopped = false  // Default false, mtlb API har 5 sec me hit hogi
    var selectedFilter: String?
    
    
    
    var selectedNeighborhoodId: String? // Property to receive the selected ID
    //  var imgData = self().GroupListData
    // let blurEffectTransitioningDelegate = BlurEffectTransitioningDelegate()
    var sourceViewController: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchView.isHidden = true
        tfSearch.delegate = self
        self.tableviewMembers.showsVerticalScrollIndicator = false
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        fetchGroupListData()
        // updateColorsForTheme()
        NetworkMonitor.shared.startMonitoring()
        
        if sourceViewController == "MyProfile" {
            stackView.isHidden = true
            stackViewHeightConstraint.constant = 0  // Completely collapse stackView
            tableViewTopConstraint.constant = 0     // Move tableView to the top
        } else {
            stackView.isHidden = false
            stackViewHeightConstraint.constant = 35  // Set stackView's original height (adjust as needed)
            tableViewTopConstraint.constant = 10     // Keep tableView in its normal position
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPageData), for: .valueChanged)
        tableviewMembers.refreshControl = refreshControl
        
    }
    //  5C5C5C, D9D9D9
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
//        SVProgressHUD.show()
        
        if sourceViewController == "MyProfile" {
            stackView.isHidden = true
            stackViewHeightConstraint.constant = 0  // Completely collapse stackView
            tableViewTopConstraint.constant = 0     // Move tableView to the top
        } else {
            stackView.isHidden = false
            stackViewHeightConstraint.constant = 35  // Set stackView's original height (adjust as needed)
            tableViewTopConstraint.constant = 10     // Keep tableView in its normal position
        }
        
        
        
        // Reset all buttons to default color & title
        let allButtons = [btnAll, btnOwner, btnPrivate, btnPublic, btnJoined]
        for button in allButtons {
            button?.backgroundColor =  #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1) // Default  // Default color
            
            button?.setTitleColor(#colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1), for: .normal) // Default text color (Black)
            btnAll.setTitleColor(.white, for: .normal) // Change text color
            btnAll.backgroundColor =  #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1) // Default color   //008000  // Highlighted color
        }
        fetchGroupListData()
        refreshPageData()
        
        // Start timer to call API every 5 seconds
                refreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    if !self.isTimerStopped {  // Jab tak timer band nahi hai tabhi API call hogi
                        self.callGroupListWebService(searchQuery: "") {
        
                            self.tableviewMembers.reloadData()
                        }
                    }
                }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    @objc func refreshPageData() {
        // Call all web services you want to refresh
        callGroupListWebService(searchQuery: "") {
            self.tableviewMembers.reloadData()
            self.tableviewMembers.refreshControl?.endRefreshing()
        }
    }
    
    
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            
            groupsView.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            
            
            // Light mode mein PollsView ka background red karna
            groupsView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            tableviewMembers.separatorStyle = .none
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    func filterOwnerGroups() {
        guard let allGroups = GroupListData else { return }
        
        callGroupListWebService(searchQuery: "") {
            self.filteredGroupData = GropsListModel(
                status: allGroups.status,
                message: allGroups.message,
                verfied_msg: allGroups.verfied_msg,
                listdata: allGroups.listdata?.filter { $0.getjoin == "owner" }
            )
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
        }
    }
    
    @objc func refreshData() {
        fetchGroupListData()
    }
    
    
    func fetchGroupListData() {
        callGroupListWebService(searchQuery: "") {
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
        }
    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSearch(_ : UIButton){
        
        self.searchView.isHidden = false
        self.GroupLbl.isHidden = true
        
    }
    
    @IBAction func btncancelSearch(_ : UIButton){
        
        self.searchView.isHidden = true
        self.GroupLbl.isHidden = false
        self.tfSearch.text = ""
        callGroupListWebService(searchQuery: "") {
            self.tableviewMembers.reloadData()
        }
    }
    
    @IBAction func filterGroups(_ sender: UIButton) {
        
        // Stop the timer when any button is pressed
        refreshTimer?.invalidate()
        refreshTimer = nil
        isTimerStopped = true  // Timer band kar diya
        
        guard let allGroups = GroupListData else { return } // Ensure data is available
        
        // Reset all buttons to default color & title
        let allButtons = [btnAll, btnOwner, btnPrivate, btnPublic, btnJoined]
        for button in allButtons {
            button?.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1) // Default
            button?.setTitleColor(#colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1), for: .normal) // Default text color
        }
        
        switch sender {
        case btnAll:
            callGroupListWebService(searchQuery: "") {
                self.filteredGroupData = allGroups
                SVProgressHUD.dismiss()
                self.tableviewMembers.reloadData()
            }
            
        case btnOwner:
            callGroupListWebService(searchQuery: "") {
                self.filteredGroupData = GropsListModel(
                    status: allGroups.status,
                    message: allGroups.message,
                    verfied_msg: allGroups.verfied_msg,
                    listdata: allGroups.listdata?.filter { $0.getjoin == "owner" }
                )
                SVProgressHUD.dismiss()
                self.tableviewMembers.reloadData()
            }
            
        case btnPrivate:
            callGroupListWebService(searchQuery: "") {
                self.filteredGroupData = GropsListModel(
                    status: allGroups.status,
                    message: allGroups.message,
                    verfied_msg: allGroups.verfied_msg,
                    listdata: allGroups.listdata?.filter { $0.group_type == "Private" }
                )
                SVProgressHUD.dismiss()
                self.tableviewMembers.reloadData()
            }
            
        case btnPublic:
            callGroupListWebService(searchQuery: "") {
                self.filteredGroupData = GropsListModel(
                    status: allGroups.status,
                    message: allGroups.message,
                    verfied_msg: allGroups.verfied_msg,
                    listdata: allGroups.listdata?.filter { $0.group_type == "Public" }
                )
                SVProgressHUD.dismiss()
                self.tableviewMembers.reloadData()
            }
            
        case btnJoined:
            callGroupListWebService(searchQuery: "") {
                self.filteredGroupData = GropsListModel(
                    status: allGroups.status,
                    message: allGroups.message,
                    verfied_msg: allGroups.verfied_msg,
                    listdata: allGroups.listdata?.filter { $0.getjoin == "joined" }
                )
                SVProgressHUD.dismiss()
                self.tableviewMembers.reloadData()
            }
            
        default:
            break
        }
        
        // Change the selected button's color & title
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1) // Highlighted color
        sender.setTitleColor(.white, for: .normal) // Change text color
        
        tableviewMembers.reloadData()
    }
    
    
    
    
    
    
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        let currentText = textField.text ?? ""
    //        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
    //
    //        // Cancel the previous work item to avoid multiple API calls
    //        searchWorkItem?.cancel()
    //
    //        // Create a new work item for the search
    //        searchWorkItem = DispatchWorkItem {
    //            // Call the API with the updated search text
    //            self.callGroupListWebService(searchQuery: updatedText) {
    //                self.tableviewMembers.reloadData()
    //            }
    //        }
    //
    //        // Execute the work item after a delay of 0.5 seconds
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchWorkItem!)
    //
    //        return true
    //    }
    
    @IBAction func btnCreateGroup(_ : UIButton){
        
        if !NetworkMonitor.shared.isConnected {
            showAlert(message: "No internet connection. Please check your network settings.")
            return
        }
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as? CreateGroupViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if GroupListData?.verfied_msg == "User Verification is completed!" {
//            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as? CreateGroupViewController else { return }
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
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
    
    @IBAction func JoinBtn(_ sender: UIButton){
        
        
        callJoinGroupWebService{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController")as! GroupsViewController
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performLocalSearch), object: nil)
        perform(#selector(performLocalSearch), with: nil, afterDelay: 0.3)
        
        return true
    }
    
    // MARK: - Local Search
    @objc func performLocalSearch() {
        let query = tfSearch.text ?? ""
        filterSearchResults(query)
    }
    
    // MARK: - Filter Logic
    func filterSearchResults(_ query: String) {
        guard let fullList = GroupListData?.listdata else { return }
        
        if query.isEmpty {
            filteredGroupData?.listdata = fullList
        } else {
            filteredGroupData?.listdata = fullList.filter {
                ($0.groupname?.lowercased().contains(query.lowercased()) ?? false) ||
                ($0.username?.lowercased().contains(query.lowercased()) ?? false) ||
                ($0.description?.lowercased().contains(query.lowercased()) ?? false) ||
                ($0.group_type?.lowercased().contains(query.lowercased()) ?? false)
            }
        }
        
        DispatchQueue.main.async {
            self.tableviewMembers.reloadData()
            
            // ✅ If no data found
            if self.filteredGroupData?.listdata?.isEmpty ?? true {
                let noDataLabel = UILabel()
                noDataLabel.text = "Data not found"
                noDataLabel.textAlignment = .center
                noDataLabel.font = UIFont.systemFont(ofSize: 16)
                noDataLabel.textColor = .gray
                self.tableviewMembers.backgroundView = noDataLabel
            } else {
                self.tableviewMembers.backgroundView = nil
            }
        }
    }
    
    
    
    
    
    
    func callGroupListWebService(searchQuery: String, _ completionClosure: @escaping () -> ()) {
        
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let neighborhoodId = selectedNeighborhoodId ?? idNeighbour
        //                var dictParams: [String: Any] = [:]
        //                if sourceViewController == "Menu" {
        //                    dictParams = [
        //                        "userid": id ?? "",
        //                    ]
        //                }
        //                else  if sourceViewController == "MyProfile" {
        //                    dictParams = [
        //                        "userid": id ?? "",
        //                        "groupuserlist": id ?? ""
        //                    ]
        //                }
        //                else  if sourceViewController == "Neighbourhood" {
        //                    dictParams = [
        //                        "userid": id ?? "",
        //                        "neighbrhood": idNeighbour ?? ""
        //                    ]
        //                }
        //                else  if sourceViewController == "HomeViewController"{ //HomeViewController
        //                    dictParams = [
        //                        "userid": userid ?? "",
        //                    ]
        //                } else if sourceViewController == "OtherProfile"{
        //                    dictParams = [
        //                        "userid": userid ?? "",
        //                        "groupuserlist": userid ?? ""
        //                    ]
        //                }
        var dictParams: [String: Any] = [:]
        if sourceViewController == "Menu" {
            dictParams = [
                "userid": id ?? "",
            ]
        }
        else  if sourceViewController == "MyProfile" {
            dictParams = [
                "userid": id ?? "",
                "groupuserlist": id ?? ""
            ]
        }
        else  if sourceViewController == "Neighbourhood" {
            dictParams = [
                "userid": id ?? "",
                "neighbrhood": idNeighbour ?? ""
            ]
        }
        else  if sourceViewController == "HomeViewController"{ //HomeViewController
            dictParams = [
                "userid": userid ?? "",
            ]
        } else if sourceViewController == "OtherProfile"{
            dictParams = [
                "userid": userid ?? "",
                "groupuserlist": userid ?? ""
            ]
        }
        else {
            dictParams = [
                "userid": id ?? ""
            ]
        }
        
        
        
        print("Param is :\(dictParams)")
        
//        WebService.sharedInstance.callGroupListWebService(withParams: dictParams) { data in
//            self.GroupListData = data
//            
//            // Filter the GroupListData based on the search query
//            if searchQuery.isEmpty {
//                self.filteredGroupData = self.GroupListData // No filtering if search is empty
//            } else {
//                self.filteredGroupData = GropsListModel(
//                    status: data.status,
//                    message: data.message,
//                    verfied_msg: data.verfied_msg, // Corrected property name
//                    listdata: data.listdata?.filter {
//                        $0.groupname?.lowercased().contains(searchQuery.lowercased()) ?? false // Safely unwrap optional
//                    }
//                )
//            }
//            
//            // Reload the table view after filtering the data
//            completionClosure()
//            self.tableviewMembers.reloadData()
//        }
    }
    
    
    func callJoinGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "groupid": groupid ?? "",
            "groupname": groupName ?? "",
            "username": userName ?? ""
        ]
        
        print("Param is : \(dictParams)")
        
//        WebService.sharedInstance.callJoinGroupWebService(withParams: dictParams) { data in
//            self.JoinListData = data
//            
//            if self.JoinListData?.status == "success" {
//                self.callGroupListWebService(searchQuery: "") {
//                    self.tableviewMembers.reloadData()
//                    self.tableviewMembers.refreshControl?.endRefreshing()
//                }
//                completionClosure()
//            } else {
//                self.showAlert(Message: self.JoinListData?.message ?? "")
//            }
//        }
    }

}

@available(iOS 16.0, *)
extension GroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredGroupData?.listdata?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
        
        cell.lblName.text = filteredGroupData?.listdata?[indexPath.row].username
        cell.lblGroupName.text = filteredGroupData?.listdata?[indexPath.row].groupname
        cell.lblPrivate.text = filteredGroupData?.listdata?[indexPath.row].group_type
        cell.lblSec.text = filteredGroupData?.listdata?[indexPath.row].neighbrhood
        cell.lblPendingCount.text = filteredGroupData?.listdata?[indexPath.row].pendingRequestCount
        if let memberCount = GroupListData?.listdata?[indexPath.row].membercount {
            cell.lblMember.text = "\(memberCount)"
        } else {
            cell.lblMember.text = "N/A" // Or some default value
        }
        
        cell.lblOwner.text = filteredGroupData?.listdata?[indexPath.row].getjoin
        
        cell.lblName.font  = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblGroupName.font  = UIFont(name: "Montserrat-Regular", size: 14)
        cell.lblPrivate.font  = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblSec.font  = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblMemberText.font = UIFont(name: "Montserrat-Regular", size: 10)
        cell.lblOwner.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        
        if filteredGroupData?.listdata![indexPath.row].getjoin == "owner" {
            cell.viewOwner.isHidden = false  // Ensure viewOwner is visible
            cell.viewOwner.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
            cell.btnExit.isHidden = true
            cell.btnJoin.isHidden = true
            cell.lblOwner.text = "Owner"
            cell.btnDetails.isHidden = false
            cell.btnDetails2.isHidden = false
            
            // Check the value of pendingRequestCount
            if filteredGroupData?.listdata![indexPath.row].pendingRequestCount == "0" {
                cell.btnReqPending.isHidden = true
                cell.viewPendingCount.isHidden = true
            } else {
                cell.btnReqPending.isHidden = false
                cell.viewPendingCount.isHidden = false
            }
        }
        
        else if filteredGroupData?.listdata![indexPath.row].getjoin == "joined" {
            
            cell.viewOwner.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
            cell.viewOwner.isHidden = true
            cell.btnExit.isHidden = false
            cell.btnJoin.isHidden = true
            cell.btnReqPending.isHidden = true
            cell.viewPendingCount.isHidden = true
            cell.btnDetails.isHidden = false
            cell.btnDetails2.isHidden = false
            
        }
        
        else if filteredGroupData?.listdata![indexPath.row].getjoin == "pending" {
            
            cell.viewOwner.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0, blue: 0.5019607843, alpha: 1)
            cell.btnJoin.isHidden = true
            cell.btnExit.isHidden = true
            cell.btnReqPending.isHidden = true
            cell.viewPendingCount.isHidden = true
            cell.btnDetails.isHidden = true
            cell.btnDetails2.isHidden = true
            cell.viewOwner.isHidden = false
            cell.lblOwner.text =  "Approval Pending"
            
        }
        
        else if filteredGroupData?.listdata![indexPath.row].getjoin == "join" {
            
            
            cell.btnExit.isHidden = true
            cell.btnJoin.isHidden = false
            cell.btnReqPending.isHidden = true
            cell.viewPendingCount.isHidden = true
            cell.btnDetails.isHidden = false
            cell.btnDetails2.isHidden = false
        }
        
        else if filteredGroupData?.listdata![indexPath.row].getjoin == "Public" {
            
            
            cell.btnExit.isHidden = true
            cell.btnJoin.isHidden = false
            cell.btnReqPending.isHidden = true
            cell.viewPendingCount.isHidden = true
            cell.btnDetails.isHidden = false
            cell.btnDetails2.isHidden = false
        }
        
        else if filteredGroupData?.listdata![indexPath.row].pendingRequestCount == "0" {
            
            
            cell.btnReqPending.isHidden = true
            cell.viewOwner.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0, blue: 0.5019607843, alpha: 1)
            cell.viewOwner.isHidden = false
            cell.lblOwner.text =  "Approval Pending"
        }
        
        
        
        
        
        let url = URL(string: (filteredGroupData?.listdata?[indexPath.row].image ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupImg"))
        
        cell.ExitCallback = { [self] value in
            
            
            
            let vc = storyboard?.instantiateViewController(withIdentifier:"ExitPopupViewController")as! ExitPopupViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            vc.groupid = filteredGroupData?.listdata![indexPath.row].groupid ?? ""
            vc.userid = filteredGroupData?.listdata![indexPath.row].userid ?? ""
            
            vc.onUpdateForGroup = { [weak self] in
                self?.fetchGroupListData()
            }
            
            self.present(vc , animated: true)
            
        }
        
        cell.JoinCallback = { [weak self] value in
            guard let self = self else { return }

            // Check if verification is completed
            if GroupListData?.verfied_msg == "User Verification is completed!" {
                // Fetch required data
                self.groupid = filteredGroupData?.listdata![indexPath.row].groupid ?? ""
                self.groupName = filteredGroupData?.listdata![indexPath.row].groupname ?? ""
                self.userName = filteredGroupData?.listdata![indexPath.row].username ?? ""

                // Call the API
                
                self.callJoinGroupWebService {
                    // Show the popup after API success
                    if self.filteredGroupData?.listdata?[indexPath.row].group_type == "Private" {
                        let message = "Group joining request sent."
                        let messageAttributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: 18),
                            .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1) // Hex Color Literal
                        ]
                        let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
                        
                        // Show popup message
                        let alert = UIAlertController(
                            title: "",
                            message: nil,
                            preferredStyle: .alert
                        )
                        alert.setValue(attributedMessage, forKey: "attributedMessage") // Set formatted message
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                        self.callGroupListWebService(searchQuery: "") {
                            SVProgressHUD.dismiss()
                            self.tableviewMembers.reloadData()
                        }
                    }
                    else {
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsViewController") as? GroupDetailsViewController else {return}
                        vc.groupid = self.filteredGroupData?.listdata![indexPath.row].groupid ?? ""
                        vc.userid = self.filteredGroupData?.listdata![indexPath.row].userid ?? ""
                       
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
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
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        
        
        
        //  "It's private group please send request to join."
        cell.DetailsCallback = { [self] value in
                      let index = indexPath.row
                      if let group = filteredGroupData?.listdata?[index] {
                          
                          if group.group_type == "Private" && group.getjoin == "join" {
                              // Customize the message with larger font
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
                                  string: "It's private group please send request to join.",
                                  attributes: messageAttributes
                              )

                              // Set the title and message of the alert
                              alert.setValue(attributedTitle, forKey: "attributedTitle")
                              alert.setValue(attributedMessage, forKey: "attributedMessage")

                              // Single OK action with custom color
                              let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                                  alert.dismiss(animated: true, completion: nil)
                              })
                              okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
                              alert.addAction(okAction)

                              // Present the alert
                              self.present(alert, animated: true, completion: nil)

                          }
                       else {
                              if GroupListData?.verfied_msg == "User Verification is completed!" {
                              let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsViewController") as! GroupDetailsViewController
                              vc.groupid = group.groupid ?? ""
                              vc.userid = group.userid ?? ""
                              self.navigationController?.pushViewController(vc, animated: true)
                              }
                              else {
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
                  }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    func showBottomPopup(message: String) {
        let popupView = UIView()
        popupView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popupView.layer.cornerRadius = 10
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the message label
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the popup
        popupView.addSubview(messageLabel)
        
        // Add the popup to the view
        self.view.addSubview(popupView)
        
        // Set up constraints for the popup view
        NSLayoutConstraint.activate([
            popupView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            popupView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            popupView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            popupView.heightAnchor.constraint(equalToConstant: 50),
            
            messageLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -10),
            messageLabel.centerYAnchor.constraint(equalTo: popupView.centerYAnchor)
        ])
        
        // Animate the popup's disappearance after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.5, animations: {
                popupView.alpha = 0
            }) { _ in
                popupView.removeFromSuperview()
            }
        }
    }
}
