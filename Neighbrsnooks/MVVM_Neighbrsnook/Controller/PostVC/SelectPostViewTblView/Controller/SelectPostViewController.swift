//
//  SelectPostViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 28/10/24.
//

import UIKit
protocol PostDataSelectionDelegate: AnyObject {
    func didSelectItems(selectedTitle: String, selectedId: String, forLabel tag: Int)
}



@available(iOS 16.0, *)
class SelectPostViewController: UIViewController {
   
    @IBOutlet weak var selectPostTblView: UITableView!
    @IBOutlet weak var lblPostTypeheading: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    
    var allowMultipleSelection: Bool = true
    var postData: [PostTypeItem] = []
    var selectedItems: [String] = []
    weak var delegate: PostDataSelectionDelegate?
    var labelTag: Int = 0
    var postTypeData : PostTypeResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
     
        getAndDecryptPostTypeData()
        selectPostTblView.showsVerticalScrollIndicator = false
        // Set transparent background
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent black
        self.view.isOpaque = false
     }
    
    
    
    private func setupUI() {
        selectPostTblView.dataSource = self
        selectPostTblView.delegate = self
        mainView.layer.cornerRadius = 10
        selectPostTblView.layer.cornerRadius = 10
        crossButton.layer.cornerRadius = crossButton.frame.height / 2
        lblPostTypeheading.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblPostTypeheading.tintColor = .darkGray
        lblPostTypeheading.text = labelTag == 1 ? "Select post type" : "Select Items"
    }
        
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionOk(_ sender: Any) {
        guard let selectedTitle = selectedItems.first,
              let selectedItem = postData.first(where: { $0.title == selectedTitle }) else {
            // No selection, show alert or just return
            showAlert(message: "Please select an item")
            return
        }
        
        // Send both title and id
        delegate?.didSelectItems(
            selectedTitle: selectedItem.title,
            selectedId: "\(selectedItem.id)",
            forLabel: labelTag
        )
        
        self.dismiss(animated: true, completion: nil)
    }

    

    func getAndDecryptPostTypeData() {
        UtilityMethods.showIndicator()
        
        PostTypeV_M().get_PostType { [weak self] encryptedResponse in
            DispatchQueue.main.async {
                UtilityMethods.hideIndicator()
                
                guard let self = self, let encryptedData = encryptedResponse?.data else {
                    print("❌ Failed to fetch encrypted PostType data")
                    return
                }

                decryptPostTypeV_M(encryptedString: encryptedData) { decryptedResult in
                    DispatchQueue.main.async {
                        if let result = decryptedResult {
                            print("✅ Decrypted data: \(result)")
                            
                            // Populate table data
                            self.postData = result.data.types
                            self.selectPostTblView.reloadData()
                            
                        } else {
                            print("❌ Decryption failed or returned nil")
                        }
                    }
                }
            }
        }
    }





    
    
}

@available(iOS 16.0, *)
extension SelectPostViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPostTableViewCell", for: indexPath) as! SelectPostTableViewCell
        
        let currentItem = postData[indexPath.row]
        cell.selectPostLbl?.text = currentItem.title
        cell.isChecked = selectedItems.contains(currentItem.title)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = postData[indexPath.row]

        // Send both title and id to delegate
        delegate?.didSelectItems(
            selectedTitle: selectedItem.title,
            selectedId: "\(selectedItem.id)",
            forLabel: labelTag
        )

        self.dismiss(animated: true)
    }



    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
