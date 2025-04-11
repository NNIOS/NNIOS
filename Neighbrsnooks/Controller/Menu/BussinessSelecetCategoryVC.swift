//
//  BussinessSelecetCategoryVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 16/11/24.
//

import UIKit

protocol BussinessDataSelectionDelegate: AnyObject {
    func didSelectItems(selectedItems: [String], forLabel tag: Int)
}

@available(iOS 16.0, *)
class BussinessSelecetCategoryVC: UIViewController {
    
    var BussinessCategoryData : BusinessCategoryModel?
    @IBOutlet weak var selectBussinessTblView: UITableView!
    @IBOutlet weak var lblBussinessTypeheading: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    
    @IBOutlet weak var crossButton: UIButton!
    
    var allowMultipleSelection: Bool = true
    var bussinData: [String] = []
    var selectedItems: [String] = []
    weak var delegate: BussinessDataSelectionDelegate?
    var labelTag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectBussinessTblView.dataSource = self
        selectBussinessTblView.delegate = self
        mainView.layer.cornerRadius = 10
        crossButton.layer.cornerRadius = crossButton.height/2
        fetchAndSetData()
        self.lblBussinessTypeheading.font  = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblBussinessTypeheading.tintColor = .darkGray
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent black
        self.view.isOpaque = false

        updateHeadingLabel()
        
    }
    
    func updateHeadingLabel() {
        if let headingLabel = lblBussinessTypeheading {
            switch labelTag {
            case 1:
                headingLabel.text = "Business categories"
            default:
                headingLabel.text = "Select Items"
            }
        } else {
            print("lblBussinessTypeheading is nil. Check IBOutlet connection.")
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
        let parameters: [String: Any] = [:] // Yaha parameters set karein agar zarurat ho

        // API call
        WebService.sharedInstance.callBussinesTypePostWebService(withParams: parameters) { [weak self] categories in
            self?.BussinessCategoryData = categories
            DispatchQueue.main.async {
                self?.selectBussinessTblView.reloadData()
            }
             
            
        }
    }

     
}

@available(iOS 16.0, *)
extension BussinessSelecetCategoryVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bussinData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BussinessSelecetCategoryVCTblViewCell", for: indexPath) as! BussinessSelecetCategoryVCTblViewCell
        let currentItem = bussinData[indexPath.row]
        self.selectBussinessTblView.separatorStyle = .none
        cell.selectBussinessLbl?.text = currentItem
        cell.isChecked = selectedItems.contains(currentItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = bussinData[indexPath.row]

        // Single selection: Clear previous selections and add the new one
        selectedItems = [selectedItem]

        // Ensure CategoryPostData is available
        if let categoryData = self.BussinessCategoryData {
            print("CategoryPostData available with \(categoryData.nbdata?.count ?? 0) items.")

            // Check index bounds for nbdata
            if indexPath.row < categoryData.nbdata?.count ?? 0 {
                let categoryID = categoryData.nbdata?[indexPath.row].id // Access using the same index
                let businessTitle = categoryData.nbdata?[indexPath.row].businessTitle // Get the businessTitle

                // Store both 'id' and 'businessTitle' in UserDefaults
                UserDefaults.standard.set(categoryID, forKey: "idCategory")
                UserDefaults.standard.set(businessTitle, forKey: "businessTitle")

                // Print to verify
                print("idCategory set in UserDefaults: \(categoryID ?? "nil")")
                print("businessTitle set in UserDefaults: \(businessTitle ?? "nil")")
            } else {
                print("Index out of bounds, cannot set idCategory and businessTitle.")
            }
        } else {
            print("CategoryPostData is nil in didSelectRowAt.")
        }

        // Reload table view to reflect the selection change
        tableView.reloadData()

        // Notify the delegate of the selected item
        delegate?.didSelectItems(selectedItems: selectedItems, forLabel: labelTag)

        // Dismiss the view controller immediately after selection
        self.dismiss(animated: true, completion: nil)
    }



    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 40 // Yahan apni required height daal sakte ho
      }
      
    
    
}
