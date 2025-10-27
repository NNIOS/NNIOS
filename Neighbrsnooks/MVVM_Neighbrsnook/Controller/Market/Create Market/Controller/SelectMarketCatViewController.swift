//
//  SelectMarketCatViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 12/02/25.
//



import UIKit

protocol MarketDataSelectionDelegate: AnyObject {
    func didSelectItems(selectedItems: [String], forLabel tag: Int)
}
@available(iOS 16.0, *)
class SelectMarketCatViewController: UIViewController {
    @IBOutlet weak var selectPostTblView: UITableView!
    @IBOutlet weak var lblPostTypeheading: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    
    var allowMultipleSelection: Bool = true
    var selectedItems: [String] = []
    weak var delegate: MarketDataSelectionDelegate?
    var MarketCatDataNew: MarketCatModel?
    var viewModel = SelectMarketCategoriesViewModel()
    var objSelectMarketCategoriesData:SelectMarketCategoriesResponse?
    var decryptSelectCategories:DecryptedSelctedMarketCatResponse?
    
    var labelTag: Int = 0
    var callback: ((_ catId: Int, _ catName: String) -> Void)?
    var selectedCategoryId: Int?
    var selectedCategoryTitleName: String?
    var token:String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        token = UserDefaults.standard.string(forKey: "authToken")
        selectMarketCategoriesApi()
        selectPostTblView.dataSource = self
        selectPostTblView.delegate = self
        mainView.layer.cornerRadius = 10
        crossButton.layer.cornerRadius = crossButton.height / 2
        lblPostTypeheading.textColor = #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        self.lblPostTypeheading.font  = UIFont(name: "Montserrat-Medium", size: 19)
        selectPostTblView.alwaysBounceVertical = false
        if let headingLabel = lblPostTypeheading {
            switch labelTag {
            case 1:
                headingLabel.text = "Select post type"
            case 3:
                headingLabel.text = "Categories"
            default:
                headingLabel.text = "Select Items"
            }
        } else {
            print("headingLabel is nil")
        }
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.isOpaque = false
    }
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionOk(_ sender: Any) {
        if let selectedId = selectedCategoryId,let selectedCatName = selectedCategoryTitleName {
            callback!(selectedId, selectedCatName)
            print("Sending callback with ID: \(selectedId)")
        } else {
            print("No category selected for callback")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func selectMarketCategoriesApi() {
        UtilityMethods.showIndicator()
        let requet = SelectMarketCategories_Request(decrypt: token ?? "")
        let  param: [String: String] = [
            "decrypt": requet.decrypt
        ]
        print("Param is:\(param)")
        let viewModel = SelectMarketCategoriesViewModel()
        viewModel.selectMarketCategories(parameter: param, request: requet) { response in
            DispatchQueue.main.async {
                self.selectPostTblView.reloadData()
                if let encryptedData = response?.data {
                    UtilityMethods.hideIndicator()
                    self.objSelectMarketCategoriesData?.data = encryptedData
                    self.decryptselectMarketCategoriesApi(encryptedString: encryptedData)
                }
            }
        }
    }
    
    private func decryptselectMarketCategoriesApi(encryptedString: String) {
        viewModel = SelectMarketCategoriesViewModel()
        viewModel.decryptselectMarketCategoriesApi(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    if self.decryptSelectCategories == nil {
                        self.decryptSelectCategories = decryptedData
                        print("Decrypted Data is :\(decryptedData)")
                    }
                    self.selectPostTblView.reloadData()
                }
            } else {
                print("❌ Failed to decrypt poll list data")
            }
        }
    }
    
}

@available(iOS 16.0, *)
extension SelectMarketCatViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Return count is: \(decryptSelectCategories?.data.categories.count ?? 0)")
        return decryptSelectCategories?.data.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPostTableViewCell", for: indexPath) as! SelectPostTableViewCell
        let data = decryptSelectCategories?.data.categories[indexPath.row]
        cell.selectPostLbl?.text = data?.name
        cell.selectPostLbl?.font = UIFont(name: "Montserrat-Regular", size: 17)
        cell.selectPostLbl?.textColor = #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        self.selectPostTblView.separatorStyle = .none
        self.selectPostTblView.showsVerticalScrollIndicator = false
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = decryptSelectCategories?.data.categories[indexPath.row] else {
            print("Data is missing at index \(indexPath.row)")
            return
        }
        
        let id = data.id
        let title = data.name
        
        print("Selected ID: \(id), Title: \(title)")
        
        selectedCategoryId = id
        selectedCategoryTitleName = title

        if allowMultipleSelection {
            if !selectedItems.contains(title) {
                selectedItems.append(title)
            }
        } else {
            selectedItems = [title]
        }

        callback?(id, title)
        print("Sending callback with ID: \(id)")

        self.dismiss(animated: true, completion: nil)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
