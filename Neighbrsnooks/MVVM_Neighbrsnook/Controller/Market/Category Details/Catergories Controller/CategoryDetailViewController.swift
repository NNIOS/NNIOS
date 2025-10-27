//
//  CategoryDetailViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 18/09/24.
//

import UIKit

@available(iOS 16.0, *)
class CategoryDetailViewController: BaseViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    
    var jCatId: Int?
    var jCatTitle: String?
    var viewModel = CategroriesDeatilsVM()
    var objCategoriesData: CategroriesDeatilsResponse?
    var objDecryptCategoriesData: DecryptCategroriesDeatilsResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        searchView.isHidden = true
    }
    
    @IBAction func BackButtionAction(_ : UIButton){ navigationController?.popViewController(animated: true) }
    @IBAction func btnSearch(_ : UIButton){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SearchAllListViewController") as? SearchAllListViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btncancelSearch(_ : UIButton){
        searchView.isHidden = true
    }
}

extension CategoryDetailViewController {
    
    func setupUI() {
        lblHeading.text = jCatTitle
        lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        searchView.isHidden = true
    }
    
    private func fetchData() {
        guard Reach().isInternet() else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
            return
        }
        categoriesFilterApi()
    }
    
    func categoriesFilterApi() {
        UtilityMethods.showIndicator()
        let request = CategroriesDeatilsRequest(cat_id: jCatId ?? 0)
        let param = ["cat_id": request.cat_id]
        print("param is :\(param)")
        viewModel.fetchCategoriesFilter(parameter: param, request: request) { [weak self] response in
            guard let self, let encryptedString = response?.data else { return }
            objCategoriesData?.data = encryptedString
            decryptCategoriesFilterApi(encryptedString: encryptedString)
        }
    }
    
    private func decryptCategoriesFilterApi(encryptedString: String) {
        viewModel.decryptCategoriesFilter(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self, let decryptedData = decryptedResponse else {
                print("❌ Failed to decrypt poll list data"); return
            }
            DispatchQueue.main.async {
                self.objDecryptCategoriesData = decryptedData
                UtilityMethods.hideIndicator()
                self.collectionViewMyEvent.reloadData()
            }
        }
    }
}

extension CategoryDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        objDecryptCategoriesData?.data.data.filter_data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItemCollectionViewCell", for: indexPath) as! MyItemCollectionViewCell
        guard let item = objDecryptCategoriesData?.data.data.filter_data[indexPath.row] else { return cell }
        cell.viewItems.layer.applyShadow(color: .gray, alpha: 0.5, x: 0, y: 0, blur: 10, spread: 0, cornerRadius: 2)
        cell.secttLbl.text = item.neighborhood_name
        cell.EventLbl.text = item.p_title
        cell.rsLbl.text = (Double(item.sale_price) ?? 0) == 0 ? "Free" : "Rs. \(formatPrice(Double(item.sale_price) ?? 0))"
        cell.lblSellDonate.text = (Double(item.sale_price) ?? 0) == 0 ? "GIVEN" : "SOLD"
        cell.lblSellDonate.isHidden = item.p_status
        cell.imgWishlist.isHidden = !item.wishlist_status
        cell.DayLbl.text = item.created_time
        ImageLoader.shared.setImage(on: cell.profileImgView, urlString: item.p_images, placeholder: "MarketDefault")
        [cell.rsLbl, cell.secttLbl].forEach { $0?.font = UIFont(name: "Montserrat-Regular", size: 12) }
        cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
        cell.DetailCallback = { [weak self] _ in
            guard let self, let vc = storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController") as? MarketDetailViewController else { return }
            vc.jMarketId = item.id
            navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionViewMyEvent.frame.width / 2 - 5, height: 155)
    }
}
