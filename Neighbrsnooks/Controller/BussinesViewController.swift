//
//  BussinesViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 07/03/24.
//

import UIKit
import SVProgressHUD

import AVFoundation
import AVKit
@available(iOS 16.0, *)
class BussinesViewController: BaseViewController, BussinessDataSelectionDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableviewBussiness: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var BussinessImgView : UIImageView!
    @IBOutlet weak var tfCategory: UITextField!
    
    @IBOutlet weak var tpyeCategoryLbl: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var bussinessView: UIView!
    
    private let bottomPanelView = BottomPanelView()
    var BusinessListData : BussinessListModel?
    var sourceViewController: String?
    var selectedNeighborhoodId: String?
    var businessListData: [BusinessListData] = []
    //    var listdata: [Listdatum] = []
    var business_id : String?
//    var serviceDropdownData = DropDown()
    var serviceName = [String]()
    let pickerView = UIPickerView()
    var BussinessCategoryData : BusinessCategoryModel?
    var filteredbussinessData: BussinessListModel?
    var searchWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchView.isHidden = true
        tfSearch.delegate = self
        if let selectedIndex = selectedTabIndex {
            bottomPanelView.updateTabAppearance(selectedIndex: selectedIndex)
        }
  
        tableviewBussiness.backgroundView = noDataLabel
        tableviewBussiness.allowsSelection = true
        tableviewBussiness.delegate = self
        //        tableviewBussiness.dataSource = self
        self.serviceName.append("Business category")
        self.view.backgroundColor = .white
        tfCategory.inputView = pickerView
        
        let professionLabelTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
        tpyeCategoryLbl.isUserInteractionEnabled = true
        tpyeCategoryLbl.addGestureRecognizer(professionLabelTap)
        
    }
    
    
    private func setupBottomPanel() {
        bottomPanelView.delegate = self
        bottomPanelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomPanelView)
        
        NSLayoutConstraint.activate([
            bottomPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5), // Moves it downward
            bottomPanelView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        callBussinesTypePostWebService(
        )
        SVProgressHUD.show()
        callBusinessListWebService(searchQuery: "") {
            SVProgressHUD.dismiss()
            self.tableviewBussiness.reloadData()
        }
    }
    
    @objc func professionLabelTapped() {
        showPopup(for: 1, allowMultipleSelection: false) // Single selection for profession
    }
    
    func showPopup(for labelTag: Int, allowMultipleSelection: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "BussinessSelecetCategoryVC") as? BussinessSelecetCategoryVC {
            popupVC.allowMultipleSelection = allowMultipleSelection
            popupVC.labelTag = labelTag
            popupVC.delegate = self
            
            if labelTag == 1 {
                // Profession data pass karna
                popupVC.bussinData = BussinessCategoryData?.nbdata?.compactMap { $0.businessTitle ?? "" } ?? []
            } else {
                print("Label tag does not match for profession.")
            }
            // Popup style and animation
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            
            self.present(popupVC, animated: true, completion: nil)
        }
    }
    
    
    
    // Delegate method to receive selected items
    func didSelectItems(selectedItems: [String], forLabel tag: Int) {
        let selectedItemsString = selectedItems.isEmpty ? "Select" : selectedItems.joined(separator: ", ")

        // Check if tag matches for business category
        if tag == 1 {
            tpyeCategoryLbl.text = selectedItems.first ?? "Select" // Show the first selected item
            // Retrieve the selected category ID and title
            if let categoryID = UserDefaults.standard.string(forKey: "idCategory"),
               let businessTitle = UserDefaults.standard.string(forKey: "businessTitle") {
                print("Selected category ID: \(categoryID), Title: \(businessTitle)")
                
                // You can now use the selected `categoryID` for filtering the data as needed.
                filterData(by: categoryID)
            }
        } else {
            print("Data not found for tag \(tag)")
        }
    }

    func filterData(by categoryID: String) {
        if let listdata = BusinessListData?.listdata {
            let filteredList = listdata.filter { $0.catid == categoryID }

            filteredbussinessData = BussinessListModel(
                status: BusinessListData?.status,
                message: BusinessListData?.message,
                addlineone: BusinessListData?.addlineone,
                addlinetwo: BusinessListData?.addlinetwo,
                countryName: BusinessListData?.countryName,
                stateName: BusinessListData?.stateName,
                cityName: BusinessListData?.cityName,
                pin: BusinessListData?.pin,
                verfiedMsg: BusinessListData?.verfiedMsg,
                listdata: filteredList
            )

            noDataLabel.isHidden = !filteredList.isEmpty // Agar data nahi mila toh message show karo

            self.tableviewBussiness.reloadData()
        } else {
            print("Business list data is nil")
        }
    }



    // No Data Label Create karo
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No Data Found"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.isHidden = true // Default hidden rahega
        return label
    }()




    
    
    @IBAction func btnSearch(_ : UIButton){
        
        self.searchView.isHidden = false
        
    }
    
    @IBAction func btncancelSearch(_ : UIButton){
        
        self.searchView.isHidden = true
        self.tfSearch.text = ""
        callBusinessListWebService(searchQuery: "") {
            self.tableviewBussiness.reloadData()
        }
        
    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            bussinessView.backgroundColor = .black
            tableviewBussiness.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
           

            // Light mode mein PollsView ka background red karna
            bussinessView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            tableviewBussiness.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
           
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    @IBAction func serviceBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
//        self.showDropdownData(showOn: tfCategory, DropdownName: serviceDropdownData)
//        serviceDropdownData.cellHeight = 35
//        serviceDropdownData.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Cancel the previous work item to avoid multiple API calls
        searchWorkItem?.cancel()
        
        // Create a new work item for the search
        searchWorkItem = DispatchWorkItem {
            // Call the API with the updated search text
            self.callBusinessListWebService(searchQuery: updatedText) {
                self.tableviewBussiness.reloadData()
            }
        }
        
        // Execute the work item after a delay of 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchWorkItem!)
        
        return true
    }
    
    
//    private func showDropdownData(showOn textField: UITextField, DropdownName dropdown : DropDown) {
//        dropdown.show()
//        dropdown.anchorView = textField
//        dropdown.bottomOffset = CGPoint(x: 30, y: (dropdown.anchorView?.plainView.bounds.height)!)
//        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
//            if index != 0{
//                self.tfCategory.text = self.serviceName[index]
//            }else{
//                self.tfCategory.text = ""
//            }
//            
//            UserDefaults.standard.set(self.serviceName[index], forKey: "id")
//            if index != 0{
//                UserDefaults.standard.set(self.BussinessCategoryData?.nbdata?[index - 1].id, forKey: "idCategory")
//            }
//            dropdown.backgroundColor = UIColor.white
//            dropdown.cellHeight = 35
//            dropdown.direction = .bottom
//            dropdown.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
//            DropDown.appearance().setupCornerRadius(10)
//            dropdown.width = 200
//        }
//    }
    
    
    @IBAction func btnAddBussiness(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBussinessViewController") as? AddBussinessViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    // new code Irshad
    func callBussinesTypePostWebService() {
        let dictParams: [String: Any] = [:]
        WebService.sharedInstance.callBussinesTypePostWebService(withParams: dictParams) { data in
            self.BussinessCategoryData = data
            
            // Sirf "Select category" set karna hai, aur koi data label pe show nahi karna
            DispatchQueue.main.async {
                self.tpyeCategoryLbl.text = "Select category"
            }
            
            // Agar dropdown ya kisi aur data source ko populate karna ho toh
//            self.serviceDropdownData.dataSource = self.serviceName
        }
    }
    
    
    
    
    
}

@available(iOS 16.0, *)
extension BussinesViewController: UITableViewDataSource, UITableViewDelegate, BussinessTableViewCellDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = filteredbussinessData?.listdata.count ?? 0
        noDataLabel.isHidden = count > 0 // Agar data hai toh label hide kar do, warna show kar do
        return count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BussinessTableViewCell", for: indexPath) as! BussinessTableViewCell
        
        // Ensure filteredbussinessData?.listdata has enough elements to access
        guard let businessList = filteredbussinessData?.listdata, indexPath.row < businessList.count else {
            return cell // If index is out of range, return empty cell
        }
        
        cell.delegate = self // Delegate set karna
        
        let businessData = businessList[indexPath.row]
        
        // Configure cell data
        cell.configureCell(with: businessData.image ?? [])
        
        cell.lblUserName.text = businessData.username
        cell.lblSector.text = businessData.neighborhood
        cell.lblProduct.text = businessData.name
        cell.lblHealth.text = businessData.category
        if let rating = businessData.rating, rating != "0.0", !rating.isEmpty {
            cell.lblRating.text = rating
        } else {
            cell.lblRating.text = "--"
        }

        
        let url = URL(string: (businessData.userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "NewBusiness"))
        
        // DetailsCallback
        cell.DetailsCallback = { [weak self] value in
            guard let self = self else { return }
            if BusinessListData?.verfiedMsg == "User Verification is completed!" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as! BusinessDetailsViewController
                vc.business_id = businessData.id
                self.navigationController?.pushViewController(vc, animated: true)
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
        
        // DotCallback
        cell.DotCallback = { [weak self] value in
            guard let self = self else { return }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDotViewController") as! BusinessDotViewController
            vc.business_id = businessData.id
            vc.userID = businessData.userid
            vc.height = 200
            vc.topCornerRadius = 10.0
            vc.presentDuration = 0.5
            vc.dismissDuration = 0.5
            vc.view.backgroundColor = .white
            vc.navigateTobussinessCallback = {
                if let messageVC = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as? MessageViewController {
                    messageVC.otherid = businessData.userid
                    messageVC.userName = businessData.username
                    messageVC.senderUserpic = businessData.userpic ?? ""
                    self.navigationController?.pushViewController(messageVC, animated: true)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        // Pass business data to cell
        cell.businessData = businessData
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Select the business data for the selected row
        if let selectedBusiness = BusinessListData?.listdata[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as! BusinessDetailsViewController
            
            // Pass business ID to the next view controller
            destinationVC.business_id = selectedBusiness.id
            
            // Navigate to the next view controller
            self.navigationController?.pushViewController(destinationVC, animated: true)
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
    
    
    func callBusinessListWebService(searchQuery: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let neighborhoodId = selectedNeighborhoodId ?? idNeighbour // Use default if selectedNeighborhoodId is nil
        
        var dictParams: [String: Any] = [:]
        
        // Determine parameters based on sourceViewController
        if sourceViewController == "MyProfile" {
            dictParams = [
                "userid": id ?? "",
                "businessuserlist": id ?? ""
            ]
        } else if sourceViewController == "Neighbourhood" {
            dictParams = [
                "userid": id ?? "",
                "neighbrhood": neighborhoodId ?? ""
            ]
        }
        
        WebService.sharedInstance.callBusinessListWebService(withParams: dictParams) { data in
            self.BusinessListData = data // Save the original data
            
            // Filter the BusinessListData based on the search query
            if searchQuery.isEmpty {
                self.filteredbussinessData = self.BusinessListData // No filtering if search is empty
            } else {
                // Filter only the `listdata` array
                let filteredListdata = data.listdata.filter {
                    $0.name?.lowercased().contains(searchQuery.lowercased()) ?? false
                }
                
                // Create a new `BussinessListModel` with the filtered listdata
                self.filteredbussinessData = BussinessListModel(
                    status: data.status,
                    message: data.message,
                    addlineone: data.addlineone,
                    addlinetwo: data.addlinetwo,
                    countryName: data.countryName,
                    stateName: data.stateName,
                    cityName: data.cityName,
                    pin: data.pin,
                    verfiedMsg: data.verfiedMsg,
                    listdata: filteredListdata
                )
            }
            // Reload the table view after filtering the data
            completionClosure()
            self.tableviewBussiness.reloadData()
        }
    }
    
}

@available(iOS 16.0, *)
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
