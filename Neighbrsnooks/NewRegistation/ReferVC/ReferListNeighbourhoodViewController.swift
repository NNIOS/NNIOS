//
//  ReferListNeighbourhoodViewController.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 13/10/25.
//


import UIKit

protocol ReferListNeighbourhoodDelegate: AnyObject {
    func didSelectNeighbourhood(name: String, id: String)
}


class ReferListNeighbourhoodViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var viewDataList: UIView!
    @IBOutlet weak var selectNeighbReferTblView: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSelectNeighHeaading: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    
    // MARK: - Variables
    var selectedItems: [String] = []
    var neighListData: ReferListNeighbourhoodModel?
    var lblData: [String] = []
    weak var delegate: ReferListNeighbourhoodDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectNeighbReferTblView.delegate = self
        selectNeighbReferTblView.dataSource = self
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.isOpaque = false
        
        viewDataList.layer.cornerRadius = 12
        btnCross.layer.cornerRadius = 12
        lblSelectNeighHeaading.font = UIFont(name: "Montserrat-Regular", size: 20)
        
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        print("User ID:", id)
        
        // ✅ Direct API call
        fetchNeighbourhoodList(referrerUserId: id)
    }
    
    // MARK: - API CALL
    func fetchNeighbourhoodList(referrerUserId id: String) {
        // ✅ Replace with your actual base URL
        let baseURL = "https://dev.neighbrsnook.com/admin/api/referrals/search-neighbourhood"
        
        // ✅ Add your query parameters
        let apiKey = "DEV-3a9f1d2e7b8c4d61234abcd5678ef90" // same as Postman
        guard let url = URL(string: "\(baseURL)?referrer_user_id=\(id)&api=\(apiKey)") else {
            print("❌ Invalid URL")
            return
        }
        
        print("📡 API URL:", url.absoluteString)
        
        // ✅ Create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // ✅ Call API
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(ReferListNeighbourhoodModel.self, from: data)
                DispatchQueue.main.async {
                    self.neighListData = decoded
                    self.lblData = decoded.data.map { $0.name }
                    self.selectNeighbReferTblView.reloadData()
//                    self.updateViewHeight()
                }
            } catch {
                print("❌ Decoding error:", error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: - Adjust View Height Dynamically
//    func updateViewHeight() {
//        self.selectNeighbReferTblView.layoutIfNeeded()
//        let contentHeight = self.selectNeighbReferTblView.contentSize.height
//        let maxHeight: CGFloat = 500
//        
//        viewHeight.constant = min(contentHeight, maxHeight)
//        selectNeighbReferTblView.isScrollEnabled = contentHeight > maxHeight
//        self.view.layoutIfNeeded()
//    }

    
    // MARK: - Cross Button
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - TableView Delegate & DataSource
extension ReferListNeighbourhoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lblData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferListNeighbourhoodTableViewCell", for: indexPath) as! ReferListNeighbourhoodTableViewCell
        let currentItem = lblData[indexPath.row]
        cell.selectListDataLbl.text = currentItem
        cell.isChecked = selectedItems.contains(currentItem)
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedData = neighListData?.data[indexPath.row] else { return }
        selectedItems = [selectedData.name]
        selectNeighbReferTblView.reloadData()
        delegate?.didSelectNeighbourhood(name: selectedData.name, id: selectedData.id)
        dismiss(animated: true, completion: nil)
    }




    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
