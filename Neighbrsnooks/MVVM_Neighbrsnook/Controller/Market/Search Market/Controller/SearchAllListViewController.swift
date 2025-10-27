//
//  SearchAllListViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 23/09/24.
//

import UIKit
@available(iOS 16.0, *)
class SearchAllListViewController: BaseViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    
    private var searchTimer: Timer?
    var viewModel = SearchMarketVM()
    var objSearchData:SearchMarketResponse?
    var objDecryptSearchMarket:DecryptSearchMarketResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchView.isHidden = false
    }
    
    @IBAction func BackButtionAction(_ : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch(_ : UIButton) {
        self.searchView.isHidden = false
    }
    
    @IBAction func btncancelSearch(_ : UIButton) {
        self.searchView.isHidden = true
        self.tfSearch.text = ""
    }
}

extension SearchAllListViewController {
    
    func setupUI() {
        tfSearch.delegate = self
        collectionViewMyEvent.tag = 1
        self.searchView.isHidden = false
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
    }
    
    func callSearchMarketApi() {
        let text = (tfSearch.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let request = SearchMarketRequest(search_query: text)
        let param: [String: Any] = [
            "search_query": request.search_query
        ]
        print("🔍 Sending Search Params:", param)
        viewModel.fetchSearchMarket(parameter: param, request: request) { [weak self] searchProductResponse in
            guard let self = self else { return }
            if let searchData = searchProductResponse {
                let encryptedString = searchData.data
                self.objSearchData?.data = encryptedString
                print("Encrypted Search Market Data is: \(encryptedString)")
                DispatchQueue.main.async {
                    self.decryptSearchMarketApi(encryptedString: encryptedString)
                }
            }
        }
    }
    
    private func decryptSearchMarketApi(encryptedString: String) {
        viewModel.decryptSearchMArket(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.objDecryptSearchMarket = decryptedData
                    self.collectionViewMyEvent.reloadData()
                    print("Decrypted Search Market Data is: \(decryptedData)")
                }
            } else {
                print("❌ Failed to decrypt market data")
            }
        }
    }
}

extension SearchAllListViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objDecryptSearchMarket?.data.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItemCollectionViewCell", for: indexPath) as! MyItemCollectionViewCell
        let item = objDecryptSearchMarket?.data.data[indexPath.row]
        cell.viewItems.layer.applyShadow(color: .gray,  alpha: 0.5,x: 0, y: 0, blur: 10, spread: 0, cornerRadius: 2)
        cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
        cell.EventLbl.text = item?.p_title
        cell.EventLbl.numberOfLines = 1
        cell.rsLbl.text = "Rs." + (item?.sale_price ?? "")
        cell.DayLbl.text = item?.created_time
//        if let price = Double(item?.sale_price ?? "0") {
//            if price == 0 {
//                cell.rsLbl.text = "Free"
//                cell.lblSellDonate.text = "GIVEN"
//            } else {
//                cell.rsLbl.text = "Rs. \(Int(price))"
//                cell.lblSellDonate.text = "SOLD"
//            }
//        } else {
//            cell.rsLbl.text = "Rs. 0"
//        }
        ImageLoader.shared.setImage(on: cell.profileImgView, urlString: item?.p_images ?? "", placeholder: "MarketDefault")
        cell.DetailCallback = { [self] _ in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController") as? MarketDetailViewController {
                vc.jMarketId = item?.id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionViewMyEvent.frame.width / 2 - 5
        let height = CGFloat(145)
        return CGSize(width: width, height: height)
    }
}

extension SearchAllListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.tfSearch.text = updatedText
            self?.callSearchMarketApi()
        }
        return true
    }
}
