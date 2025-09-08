//
//  PollsViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 08/04/24.
//
 
import UIKit
import SVProgressHUD
@available(iOS 16.0, *)
class PollsViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var PollsView: UIView!
    
    var PollsData : PollsModel?
    // var HomeData : HomeModel?
    var filteredPollsData: PollsModel? // Holds filtered poll data for search results
    var searchWorkItem: DispatchWorkItem?
    var business_id : String?
    var selectedNeighborhoodId: String?
    var sourceViewController: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
        self.searchView.isHidden = true
        tfSearch.delegate = self
        self.tableviewMembers.reloadData()
        view.backgroundColor = .white
        NetworkMonitor.shared.startMonitoring()
        view.backgroundColor = UIColor.systemBackground  // Adapt to light/dark mode
        tableviewMembers.showsVerticalScrollIndicator = false
        NetworkMonitor.shared.startMonitoring()
        updateColorsForTheme() // Apply colors based on theme
        PollsView.backgroundColor = UIColor.systemBackground
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshPageData), for: .valueChanged)
        tableviewMembers.refreshControl = refreshControl
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.searchView.isHidden = true
        SVProgressHUD.show()
        updateColorsForTheme()
        //   callHomeWebService()
        callPollsListWebService(searchQuery: "") {
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
        }
    }
    
    func updateColorsForTheme() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        view.backgroundColor = UIColor.systemBackground
        //  lblHeading.textColor = UIColor.label
        searchView.backgroundColor = isDarkMode ? UIColor.darkGray : UIColor.white
        tfSearch.textColor = UIColor.label
        tfSearch.backgroundColor = UIColor.secondarySystemBackground
        
        
        
        // Reload table view to apply colors
        tableviewMembers.reloadData()
    }
    
    @objc func refreshPageData() {
        // Call all web services you want to refresh
        callPollsListWebService(searchQuery: "") {
            self.tableviewMembers.reloadData()
            self.tableviewMembers.refreshControl?.endRefreshing()
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColorsForTheme()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            
            PollsView.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            
            
            // Light mode mein PollsView ka background red karna
            PollsView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            tableviewMembers.separatorStyle = .none
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSearch(_ : UIButton){
        
        self.searchView.isHidden = false
        
    }
    
    @IBAction func btncancelSearch(_ : UIButton){
        
        self.searchView.isHidden = true
        self.tfSearch.text = ""
        callPollsListWebService(searchQuery: "") {
            self.tableviewMembers.reloadData()
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
            self.callPollsListWebService(searchQuery: updatedText) {
                self.tableviewMembers.reloadData()
            }
        }
        
        // Execute the work item after a delay of 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchWorkItem!)
        
        return true
    }
    
    @IBAction func btnCreatePoll(_ : UIButton){
        
        //    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePollViewController") as? CreatePollViewController else {return}
        //
        //    self.navigationController?.pushViewController(vc, animated: true)
        
        if !NetworkMonitor.shared.isConnected {
            // Show your own alert or prevent API call
            showAlert(message: "Internet not available. Please check your connection.")
            return
        }
        
        if PollsData?.verfiedMsg == "User Verification is completed!" {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePollViewController") as? CreatePollViewController else {return}
            
            self.navigationController?.pushViewController(vc, animated: true)
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

@available(iOS 16.0, *)
extension PollsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Use filteredPollsData to determine the number of rows
        return filteredPollsData?.nbdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PollsTableViewCell", for: indexPath) as! PollsTableViewCell
        
        // Get poll data from filteredPollsData, not PollsData
        guard let pollData = filteredPollsData?.nbdata[indexPath.row] else { return cell }
        
        cell.lblCreaterName.text = pollData.createdBy
        cell.lblSec.text = pollData.neighborhood
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.lblTime.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.lblCreaterName.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        cell.lblCreaterName.textColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 0.8)
        var startDate = pollData.pollQues
        if !startDate.contains("?") {
            startDate += " ?"
        }
        cell.lblPolls.text =  startDate
        cell.lblStartDate.text = pollData.startDate
        cell.lblEndDate.text = pollData.endDate
        cell.lblFavorite.text = (pollData.totalvote == "0") ? "" : (pollData.totalvote)
        // cell.lblTime.text = pollData.createdDate
        cell.lblTime.text = ", \(pollData.createdDate)"
        // cell.lblTime.textColor = UIColor.secondaryLabel
        
        // cell.backgroundColor = UIColor.systemBackground
        cell.BgView.backgroundColor = UIColor.systemBackground // Ensures dynamic theme adaptation
        
        
        if traitCollection.userInterfaceStyle == .dark {
            cell.backgroundColor = UIColor.systemBackground  // Dark mode background
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1) // Light mode background
        }
        
        
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
        
        cell.lblCreaterName.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblPolls.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblStartDate.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblEndDate.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblFavorite.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblStart.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblEnd.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblTime.font = UIFont(name: "Montserrat-Regular", size: 13)
        
        let url = URL(string: pollData.userpic ?? "")
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
        
        //        cell.DetailsCallback = { [weak self] value in
        //            guard let strongSelf = self else { return }
        //            let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "PollsDetailViewController") as! PollsDetailViewController
        //            vc.pollid = pollData.pID ?? ""
        //            strongSelf.navigationController?.pushViewController(vc, animated: true)
        //        }
        
        cell.DetailsCallback = { [weak self] value in
            guard let self = self else { return }
            if !NetworkMonitor.shared.isConnected {
                // Show your own alert or prevent API call
                showAlert(message: "Internet not available. Please check your connection.")
                return
            }
            
            // Check if verification is completed
            //                if PollsData?.verfiedMsg == "User Verification is completed!" {
            //                    // Verification is completed
            //                    let index = indexPath.row
            //                    if let group = filteredPollsData?.nbdata[index] {
            //                        if group.ispollrunning == "2" {
            //                            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            //
            //                            // Customizing the message font and size
            //                            let messageText = "Polling is closed."
            //                            if let customFont = UIFont(name: "Montserrat-Regular", size: 17) {
            //                                let attributedMessage = NSAttributedString(string: messageText, attributes: [
            //                                    .font: customFont,
            //                                    .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            //                                ])
            //                                alertController.setValue(attributedMessage, forKey: "attributedMessage")
            //                            }
            //
            //                            // Adding an "OK" button to close the popup
            //                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            //                                alertController.dismiss(animated: true, completion: nil)
            //                            }
            //                            alertController.addAction(okAction)
            //
            //                            // Present the alert
            //                            self.present(alertController, animated: true, completion: nil)
            //
            //                        }
            //                        else {
            //                            // Navigate to PollsDetailViewController
            //                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollsDetailViewController") as! PollsDetailViewController
            //                            vc.pollid = group.pID ?? ""
            //                            self.navigationController?.pushViewController(vc, animated: true)
            //                        }
            //                    }
            //                }
            if PollsData?.verfiedMsg == "User Verification is completed!" {
                guard let userID = UserDefaults.standard.string(forKey: "userid") else { return }
                let index = indexPath.row
                guard let group = filteredPollsData?.nbdata[index] else { return }
                
                if userID == pollData.userid {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollsDetailViewController") as! PollsDetailViewController
                    vc.pollid = group.pID
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if pollData.ispollrunning == "2" {
                    let alert = UIAlertController(title: nil, message: "Polling is closed", preferredStyle: .alert)
                    let attributedMessage = NSAttributedString(
                        string: "Polling is closed",
                        attributes: [
                            .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                        ])
                    alert.setValue(attributedMessage, forKey: "attributedMessage")
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollsDetailViewController") as! PollsDetailViewController
                    vc.pollid = group.pID
                    self.navigationController?.pushViewController(vc, animated: true)
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
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        cell.ProfileCallback = { [weak self] value in
            guard let self = self else { return }
            if !NetworkMonitor.shared.isConnected {
                // Show your own alert or prevent API call
                showAlert(message: "Internet not available. Please check your connection.")
                return
            }
            
            // Check if verification is completed
            if PollsData?.verfiedMsg == "User Verification is completed!" {
                // Verification is completed
                let index = indexPath.row
                if let group = filteredPollsData?.nbdata[index] {
                    if group.ispollrunning == "2" {
                        //
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        
                        // Customizing the message font and size
                        let messageText = "Polling is closed."
                        if let customFont = UIFont(name: "Montserrat-Regular", size: 17) {
                            let attributedMessage = NSAttributedString(string: messageText, attributes: [
                                .font: customFont,
                                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                            ])
                            alertController.setValue(attributedMessage, forKey: "attributedMessage")
                        }
                        
                        // Adding an "OK" button to close the popup
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            alertController.dismiss(animated: true, completion: nil)
                        }
                        alertController.addAction(okAction)
                        
                        // Present the alert
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
                    }
                    else {
                        // Navigate to PollsDetailViewController
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                        //                            vc.Oid = group.userid ?? ""
                        let id = UserDefaults.standard.string(forKey: "userid")
                        if id == group.userid {
                            vc.Oid = group.userid
                            vc.sourceViewController = "MyProfile"
                        } else {
                            vc.Oid = group.userid
                            vc.sourceViewController = "OtherProfile"
                            
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                // Show verification alert
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
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollDotViewController") as? PollDotViewController else {return}
            // vc.business_id = business_id
            vc.business_id = filteredPollsData?.nbdata[indexPath.row].pID ?? ""
            vc.height = 150
            vc.topCornerRadius = 10.0
            vc.presentDuration = 0.5
            vc.dismissDuration = 0.5
            vc.isComingFromMenuPollVC = true
            vc.createdBy = filteredPollsData?.nbdata[indexPath.row].userid ?? ""
            vc.view.backgroundColor = .white
            vc.onUpdateForBlock = { [weak self] in
                self?.callPollsListWebService(searchQuery: "") {
                    self?.tableviewMembers.reloadData()
                }
            }
            
            
            
            
            vc.callback = { range in
                
            }
            self.present(vc, animated: true, completion: nil)
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func callPollsListWebService(searchQuery: String, _ completionClosure: @escaping () -> ()) {
        
        
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let neighborhoodId = selectedNeighborhoodId ?? idNeighbour // Use default if selectedNeighborhoodId is nil
        
        //        let dictParams: [String: Any] = [
        //            "userid": id ?? "",
        //            "neighbrhood": neighborhoodId ?? "", // Use the resolved neighborhoodId
        //            "searchQuery": searchQuery
        //        ]
        var dictParams: [String: Any] = [:]
        
        if sourceViewController == "MyProfile" {
            dictParams = [
                "userid": id ?? "",
                "polluserlist":id ?? "",
                "searchQuery": searchQuery
            ]
        } else if sourceViewController == "OtherProfile" {
            dictParams = [
                "userid": business_id ?? "",
                "polluserlist":business_id ?? "",
                "searchQuery": searchQuery
            ]
        }
        else if sourceViewController == "Neighbourhood" {
            dictParams = [
                "userid": id ?? "",
                "neighbrhood": neighborhoodId ?? "", // Use the resolved neighborhoodId
                "searchQuery": searchQuery
            ]
        }
        else if sourceViewController == "Menu" {
            dictParams = [
                "userid": id ?? "",
                "searchQuery": searchQuery
            ]
        }
        print("Param is :\(dictParams)")
        
        WebService.sharedInstance.callPollsListWebService(withParams: dictParams) { data in
            self.PollsData = data
            
            // Filter the PollsData based on search query
            if searchQuery.isEmpty {
                self.filteredPollsData = self.PollsData // No filtering if search is empty
            } else {
                self.filteredPollsData = PollsModel(
                    status: data.status,
                    message: data.message,
                    verfiedMsg: data.verfiedMsg,
                    nbdata: data.nbdata.filter { $0.pollQues.lowercased().contains(searchQuery.lowercased()) }
                )
            }
            
            // Reload the table view after filtering the data
            completionClosure()
            self.tableviewMembers.reloadData()
        }
    }
    
}
