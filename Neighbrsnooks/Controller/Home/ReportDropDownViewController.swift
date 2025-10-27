//
//  ReportDropDownViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 29/10/24.
//

import UIKit

protocol PopupSelectionReportDelegate: AnyObject {
    func didSelectItems(selectedItems: [String], forLabel tag: Int)
}
@available(iOS 16.0, *)
class ReportDropDownViewController: UIViewController {

    var CategoryPostData : CategoryPostModel?
    
    @IBOutlet weak var selectPostTblView: UITableView!
    
    @IBOutlet weak var lblPostTypeheading: UILabel!
    @IBOutlet weak var mainView: UIView!
   
    
    
    @IBOutlet weak var crossButton: UIButton!
    
    var allowMultipleSelection: Bool = true
    var postData: [String] = []
    var selectedItems: [String] = []
    weak var delegate: PopupSelectionReportDelegate?
    var labelTag: Int = 0
    var ReportCatData : ReportCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectPostTblView.dataSource = self
        selectPostTblView.delegate = self
        mainView.layer.cornerRadius = 10
        crossButton.layer.cornerRadius = crossButton.height/2
        fetchAndSetData()
        self.lblPostTypeheading.font  = UIFont(name: "Montserrat-Regular", size: 20)
        self.lblPostTypeheading.tintColor = .darkGray
        
        if let headingLabel = lblPostTypeheading {
            switch labelTag {
            case 1:
                headingLabel.text = "Choose report category"
            default:
                headingLabel.text = "Choose report category"
            }
        } else {
            print("headingLabel is nil")
        }
        
    }
    
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionOk(_ sender: Any) {
        delegate?.didSelectItems(selectedItems: selectedItems, forLabel: labelTag)
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchAndSetData() {
        // Define parameters if necessary
        let parameters: [String: Any] = [:] // Populate this dictionary with your required parameters

        // Fetch your data
//        WebService.sharedInstance.callReportPostWebService(withParams: parameters) { [weak self] categories in
//            self?.ReportCatData = categories
//            self?.postData = (categories.listdata?.compactMap { $0.name })! // Assuming 'postTitle' is the text you want to show
//            DispatchQueue.main.async {
//                self?.selectPostTblView.reloadData()
//            }
//        }
    }

    
     
}

@available(iOS 16.0, *)
extension ReportDropDownViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDropDownTableViewCell", for: indexPath) as! ReportDropDownTableViewCell
        let currentItem = postData[indexPath.row]
        self.selectPostTblView.separatorStyle = .none
        cell.selectPostLbl?.text = currentItem
        cell.isChecked = selectedItems.contains(currentItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = postData[indexPath.row]
        
        // Single selection: Clear previous selections and add the new one
        selectedItems = [selectedItem]
        
        // Store 'id' in UserDefaults
        UserDefaults.standard.set(selectedItem, forKey: "id")
        
        // Ensure CategoryPostData is available
        if let categoryData = self.ReportCatData {
            print("CategoryPostData available with \(ReportCatData?.listdata?.count) items.")
            
            // Check index bounds for nbdata
            if indexPath.row < (ReportCatData?.listdata!.count)! {
                let categoryID = ReportCatData?.listdata![indexPath.row].name // Access using the same index
                UserDefaults.standard.set(categoryID, forKey: "idCategory")
                print("idCategory set in UserDefaults: \(categoryID)")
            } else {
                print("Index out of bounds, cannot set idCategory.")
            }
            
        } else {
            print("CategoryPostData is nil in didSelectRowAt.")
        }
        
        // Reload table view to reflect the selection change
        tableView.reloadData()
        
        // Notify the delegate of the selected item
        delegate?.didSelectItems(selectedItems: selectedItems, forLabel: labelTag)
        
        // Automatically dismiss the view controller on selection
        self.dismiss(animated: true, completion: nil)
    }


    
    
}
