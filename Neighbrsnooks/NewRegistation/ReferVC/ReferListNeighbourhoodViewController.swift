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
    var isHeightCalculated = false
    
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
        
        // Initial height set karo
        self.viewHeight.constant = 200
        
        fetchNeighbourhoodList(referrerUserId: id)
    }
    
    // MARK: - API CALL
    func fetchNeighbourhoodList(referrerUserId id: String) {
        let baseURL = "https://laravelpanel.neighbrsnook.com/api/referrals/search-neighbourhood"
        let apiKey = "DEV-3a9f1d2e7b8c4d61234abcd5678ef90"
        guard let url = URL(string: "\(baseURL)?referrer_user_id=\(id)&api=\(apiKey)") else {
            print("❌ Invalid URL")
            return
        }
        
        print("📡 API URL:", url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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

                    print("✅ Total items fetched:", decoded.data.count)
                    
                    // Height update ko thoda delay karo taki table view properly render ho jaaye
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.updateViewHeight()
                    }
                }

            } catch {
                print("❌ Decoding error:", error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: - Adjust Table Height According to Data - CORRECTED
    func updateViewHeight() {
        guard !lblData.isEmpty else {
            self.viewHeight.constant = 150 // Default height agar koi data nahi hai
            return
        }
        
        let rowHeight: CGFloat = 35
        let totalRows = CGFloat(lblData.count)
        
        // Table view content height
        let tableContentHeight = totalRows * rowHeight
        
        // Header section height (lblSelectNeighHeaading + btnCross) - KAM KARO
        let headerHeight: CGFloat = 50
        
        // Additional padding (top + bottom) - KAM KARO
        let additionalPadding: CGFloat = 20
        
        // Total container height calculation
        let totalContainerHeight = headerHeight + tableContentHeight + additionalPadding
        
        // Minimum height ensure karo
        let minHeight: CGFloat = 150
        
        // Maximum height (screen ke 60% se zyada nahi honi chahiye)
        let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.6
        
        let finalHeight = max(minHeight, min(totalContainerHeight, maxHeight))
        
        // Debug information
        print("📏 HEIGHT CALCULATION:")
        print("   - Rows: \(lblData.count)")
        print("   - Row Height: \(rowHeight)")
        print("   - Table Content Height: \(tableContentHeight)")
        print("   - Header Height: \(headerHeight)")
        print("   - Additional Padding: \(additionalPadding)")
        print("   - Total Height: \(totalContainerHeight)")
        print("   - Min Height: \(minHeight)")
        print("   - Max Height: \(maxHeight)")
        print("   - Final Height: \(finalHeight)")
        
        // Apply the height
        self.viewHeight.constant = finalHeight
        
        // Scroll enable karo agar content zyada hai
        self.selectNeighbReferTblView.isScrollEnabled = tableContentHeight > 200
        
        // Smooth animation ke saath update karo
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
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
