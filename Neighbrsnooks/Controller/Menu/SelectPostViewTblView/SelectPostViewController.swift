//
//  SelectPostViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 28/10/24.
//

import UIKit

protocol PostDataSelectionDelegate: AnyObject {
    func didSelectItems(selectedItems: [String], forLabel tag: Int)
}

@available(iOS 16.0, *)
class SelectPostViewController: UIViewController {
    var CategoryPostData : CategoryPostModel?
    @IBOutlet weak var selectPostTblView: UITableView!
    @IBOutlet weak var lblPostTypeheading: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    
    var allowMultipleSelection: Bool = true
    var postData: [String] = []
    var selectedItems: [String] = []
    weak var delegate: PostDataSelectionDelegate?
    var labelTag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAndSetData()
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
        delegate?.didSelectItems(selectedItems: selectedItems, forLabel: labelTag)
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchAndSetData() {
        WebService.sharedInstance.callCategoryPostWebService(withParams: [:]) { [weak self] categories in
            guard let self = self else { return }
            self.CategoryPostData = categories
            self.postData = categories.nbdata.compactMap { $0.postTitle }
            DispatchQueue.main.async {
                self.selectPostTblView.reloadData()
            }
        }
    }
    
    
    
}

@available(iOS 16.0, *)
extension SelectPostViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPostTableViewCell", for: indexPath) as! SelectPostTableViewCell
        let currentItem = postData[indexPath.row]
        self.selectPostTblView.separatorStyle = .none
        cell.selectPostLbl?.text = currentItem
        cell.isChecked = selectedItems.contains(currentItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Select item logic
        let selectedItem = postData[indexPath.row]
        selectedItems = [selectedItem] // Single selection
        
        // Save `id` and `idCategory` to UserDefaults
        UserDefaults.standard.set(selectedItem, forKey: "id")
        if let categoryID = CategoryPostData?.nbdata[indexPath.row].id {
            UserDefaults.standard.set(categoryID, forKey: "idCategory")
        }
        
        // Notify delegate and dismiss
        delegate?.didSelectItems(selectedItems: selectedItems, forLabel: labelTag)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        35
    }
    
}
