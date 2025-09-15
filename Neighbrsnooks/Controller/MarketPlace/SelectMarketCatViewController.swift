////
////  SelectMarketCatViewController.swift
////  NeighbrsNook Latest Latest
////
////  Created by Mac on 12/02/25.
////
//
//import UIKit
//
//protocol MarketDataSelectionDelegate: AnyObject {
//    func didSelectItems(selectedItems: [String], forLabel tag: Int)
//}
//@available(iOS 16.0, *)
//class SelectMarketCatViewController: UIViewController {
//    @IBOutlet weak var selectPostTblView: UITableView!
//    @IBOutlet weak var lblPostTypeheading: UILabel!
//    @IBOutlet weak var mainView: UIView!
//    @IBOutlet weak var crossButton: UIButton!
//    
//    var allowMultipleSelection: Bool = true
//    var selectedItems: [String] = []
//    weak var delegate: MarketDataSelectionDelegate?
//    var MarketCatDataNew: MarketCatModel?
//    
//    var labelTag: Int = 0
//    var callback: ((_ catId: Int, _ catName: String) -> Void)?
//    var selectedCategoryId: Int?
//    var selectedCategoryTitleName: String?
//    
//    override func viewDidLoad() {
//            
//            super.viewDidLoad()
//            selectPostTblView.dataSource = self
//            selectPostTblView.delegate = self
//            mainView.layer.cornerRadius = 10
//            crossButton.layer.cornerRadius = crossButton.height / 2
//            callMarketCategoriesWebService()
//            self.lblPostTypeheading.font  = UIFont(name: "Montserrat-Regular", size: 16)
//            self.lblPostTypeheading.tintColor = .darkGray
//        
//        
//        
//            
//            if let headingLabel = lblPostTypeheading {
//                switch labelTag {
//                case 1:
//                    headingLabel.text = "Select post type"
//                case 3:
//                    headingLabel.text = "Categories"
//                default:
//                    headingLabel.text = "Select Items"
//                }
//            } else {
//                print("headingLabel is nil")
//            }
//            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            self.view.isOpaque = false
//        }
//    
//    @IBAction func actionCross(_ sender: Any) {
//        self.dismiss(animated: true,completion: nil)
//    }
//    
//    @IBAction func actionOk(_ sender: Any) {
//        if let selectedId = selectedCategoryId,let selectedCatName = selectedCategoryTitleName {
//            callback!(selectedId, selectedCatName)
//            print("Sending callback with ID: \(selectedId)")
//        } else {
//            print("No category selected for callback")
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    @objc func callMarketCategoriesWebService() {
//        let url = "https://neighbrsnook.com/admin/api/category"
//        let dictParams: Dictionary<String, Any> = ["":""]
//        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
//        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            switch statusCode {
//            case .SUCCESS ,.CREATED:
//                do {
//                    let data = try JSONDecoder().decode(MarketCatModel.self, from: result!)
//                    self.MarketCatDataNew = data
//                    print("Data is :\(data)")
//                    DispatchQueue.main.async {
//                        self.selectPostTblView.reloadData()
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
//                do {
//                    let data = try JSONDecoder().decode(MarketCatModel.self, from: result!)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .UNAUTHORIZED:
//                print(error?.localizedDescription ?? "")
//            default:
//                break
//            }
//        }
//    }
//    
//}
//
//@available(iOS 16.0, *)
//extension SelectMarketCatViewController: UITableViewDataSource, UITableViewDelegate{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Return count is: \(MarketCatDataNew?.category?.count ?? 0)")
//        return MarketCatDataNew?.category?.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPostTableViewCell", for: indexPath) as! SelectPostTableViewCell
//        let data = MarketCatDataNew?.category?[indexPath.row]
//        cell.selectPostLbl?.text = data?.catTitle
//        self.selectPostTblView.separatorStyle = .none
//        self.selectPostTblView.showsVerticalScrollIndicator = false
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            guard let data = MarketCatDataNew?.category?[indexPath.row],
//                  let id = data.id,
//                  let title = data.catTitle else {
//                print("Data is missing at index \(indexPath.row)")
//                return
//            }
//
//            print("Selected ID: \(id), Title: \(title)")
//            selectedCategoryId = id
//            selectedCategoryTitleName = title
//
//            if allowMultipleSelection {
//                if !selectedItems.contains(title) {
//                    selectedItems.append(title)
//                }
//            } else {
//                selectedItems = [title]
//            }
//
//            if let selectedId = selectedCategoryId, let selectedCatName = selectedCategoryTitleName {
//                callback?(selectedId, selectedCatName)
//                print("Sending callback with ID: \(selectedId)")
//            } else {
//                print("No category selected for callback")
//            }
//
//            self.dismiss(animated: true, completion: nil)
//        }
//}



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
    
    var labelTag: Int = 0
    var callback: ((_ catId: Int, _ catName: String) -> Void)?
    var selectedCategoryId: Int?
    var selectedCategoryTitleName: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        selectPostTblView.dataSource = self
        selectPostTblView.delegate = self
        mainView.layer.cornerRadius = 10
        crossButton.layer.cornerRadius = crossButton.height / 2
        callMarketCategoriesWebService()
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
    
    @objc func callMarketCategoriesWebService() { //dev.
        let url = "https://neighbrsnook.com/admin/api/category"
        let dictParams: Dictionary<String, Any> = ["":""]
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                do {
                    let data = try JSONDecoder().decode(MarketCatModel.self, from: result!)
                    self.MarketCatDataNew = data
                    print("Data is :\(data)")
                    DispatchQueue.main.async {
                        self.selectPostTblView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(MarketCatModel.self, from: result!)
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription ?? "")
            default:
                break
            }
        }
    }
    
}

@available(iOS 16.0, *)
extension SelectMarketCatViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Return count is: \(MarketCatDataNew?.category?.count ?? 0)")
        return MarketCatDataNew?.category?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPostTableViewCell", for: indexPath) as! SelectPostTableViewCell
        let data = MarketCatDataNew?.category?[indexPath.row]
        cell.selectPostLbl?.text = data?.catTitle
        cell.selectPostLbl?.font = UIFont(name: "Montserrat-Regular", size: 17)
        cell.selectPostLbl?.textColor = #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        self.selectPostTblView.separatorStyle = .none
        self.selectPostTblView.showsVerticalScrollIndicator = false
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = MarketCatDataNew?.category?[indexPath.row],
              let id = data.id,
              let title = data.catTitle else {
            print("Data is missing at index \(indexPath.row)")
            return
        }
        
        

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

        if let selectedId = selectedCategoryId, let selectedCatName = selectedCategoryTitleName {
            callback?(selectedId, selectedCatName)
            print("Sending callback with ID: \(selectedId)")
        } else {
            print("No category selected for callback")
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
