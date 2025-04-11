//
//  BusinessSelectCategoryPopupVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 07/02/25.
//

import UIKit

protocol BusinessCategorySelectionDelegate: AnyObject {
    func didSelectCategory(id: String, title: String)
}

@available(iOS 16.0, *)
class BusinessSelectCategoryPopupVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var viewCornerRadius: UIView!
    @IBOutlet weak var tblSelectCategory: UITableView!
    var AddPCategoryData : CategoryBussinessModel?
    weak var delegate: BusinessCategorySelectionDelegate? // 🔹 Delegate property

    
    var serviceName = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCornerRadius.layer.cornerRadius = 10
        viewCornerRadius.clipsToBounds = true
        self.tblSelectCategory.dataSource = self
        self.tblSelectCategory.delegate = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent black
        self.view.isOpaque = false
        tblSelectCategory.separatorStyle = .none
        tblSelectCategory.showsVerticalScrollIndicator = false
        callCatBussinessWebService() // ✅ API Call Yahan Karein

        // Background tap gesture add karo
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
           tapGesture.cancelsTouchesInView = false
           self.view.addGestureRecognizer(tapGesture)
        
     }
    
    
    // Function to dismiss the popup
    @objc func dismissPopup(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)

        // Agar tap popup ke content view ke bahar hua hai tab dismiss karein
        if !viewCornerRadius.frame.contains(location) {
            self.dismiss(animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddPCategoryData?.nbdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessSelectCategoryTblVCell") as! BusinessSelectCategoryTblVCell
        let businessData = AddPCategoryData?.nbdata[indexPath.row]
        cell.lblSelectCaegory.text = businessData?.businessTitle  // Assign businessTitle to label
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }

    // ✅ **Step 3: Handle Selection**
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           guard let selectedCategory = AddPCategoryData?.nbdata[indexPath.row] else { return }
           delegate?.didSelectCategory(id: selectedCategory.id, title: selectedCategory.businessTitle)
           self.dismiss(animated: true) // Dismiss popup
       }
    
    func callCatBussinessWebService() {
        let dictParams: Dictionary<String, Any> = ["":""]
        
        WebService.sharedInstance.callCatBussinessWebService(withParams: dictParams) { data in
            self.AddPCategoryData = data
            UserDefaults.standard.set(self.AddPCategoryData?.nbdata.first?.id, forKey: "id")
            UserDefaults.standard.set(self.AddPCategoryData?.businessImgLimit, forKey: "imageLimit")
            
            self.serviceName.removeAll()
            for value in self.AddPCategoryData?.nbdata ?? [] {
                self.serviceName.append(value.businessTitle)
            }
            
            // ✅ Ensure UI update happens on the main thread
            DispatchQueue.main.async {
                self.tblSelectCategory.reloadData() // 🔥 FIX: Data reload karna zaroori hai
            }
        }
    }

    
}
