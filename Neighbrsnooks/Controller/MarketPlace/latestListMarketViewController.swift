//
//  latestListMarketViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/09/24.
//

import UIKit
@available(iOS 16.0, *)
class latestListMarketViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    var LatestListData : LatestListModel?
    
    let latestProductViewModel = LatestProductViewModel()
    var objLatestList:LatestProductListResponse?
    var objDecryptLatestProduct:DecryptLatestListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if Reach().isInternet() {
            callLatestProductListApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    func setupUI() {
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        collectionViewMyEvent.reloadData()
        collectionViewMyEvent.tag = 1
        lblHeading.text = "Latest Listing"
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
    }
    
    func callLatestProductListApi() {
        latestProductViewModel.fetchLatestProducttData() { [weak self] latestProductListResponse in
            guard let self = self else { return }
            if let latestProduct = latestProductListResponse {
                let encryptedString = latestProduct.data
                self.objLatestList?.data = encryptedString
                DispatchQueue.main.async {
                    self.decryptLatestroductListApi(encryptedString: encryptedString)
                }
            }
        }
    }
    
    private func decryptLatestroductListApi(encryptedString: String) {
        latestProductViewModel.decryptLatestProductData(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.objDecryptLatestProduct = decryptedData
                    self.collectionViewMyEvent.reloadData()
                }
            } else {
                print("❌ Failed to decrypt poll list data")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reach().isInternet() {
            callLatestProductListApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateMarketAction(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMarketViewController") as? CreateMarketViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
        print("Abdul Aleem Usmani")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objDecryptLatestProduct?.data.data.today_list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItemCollectionViewCell", for: indexPath) as! MyItemCollectionViewCell
        let item = objDecryptLatestProduct?.data.data.today_list[indexPath.row]
        cell.viewItems.layer.shadowColor = UIColor.gray.cgColor
        cell.viewItems.layer.shadowOpacity = 0.5
        cell.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewItems.layer.shadowRadius = 5
        cell.viewItems.layer.masksToBounds = false
        cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
        cell.EventLbl.text = item?.p_title
        cell.EventLbl.numberOfLines = 1
        if let priceString = item?.sale_price,
           let priceDouble = Double(priceString) {
            if priceDouble == 0 {
                cell.rsLbl.text = "Free"
                cell.lblSellDonate.text = "GIVEN"
            } else {
                cell.rsLbl.text = "Rs. \(formatPrice(priceDouble))"
                cell.lblSellDonate.text = "SOLD"
            }
        } else {
            cell.rsLbl.text = "Rs. 0"
        }
        
        if item?.p_status == false {
            cell.lblSellDonate.isHidden = false
        } else {
            cell.lblSellDonate.isHidden = true
        }
        
        cell.DayLbl.text = item?.created_time
        ImageLoader.shared.setImage(on: cell.profileImgView, urlString: item?.p_images ?? "", placeholder: "MarketDefault")
        cell.secttLbl.text = item?.neighborhood_name
        cell.DetailCallback = { [self] value in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
            vc.jMarketId = item?.id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionViewMyEvent.frame.width / 2 - 5
        let height = CGFloat(152)
        return CGSize(width: width , height: height)
    }
}
