import UIKit
@available(iOS 16.0, *)
class MyitemsMarketViewController: BaseViewController {
    
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    
    var Newid: String?
    var sourceViewController: String?
    var MyitemsData: MyeventsMarketmodel?
    var MySearchitemsData: SearchItemModel?
    var AllListMarketData: AlllistMarketModel?
    
    
    var jMarketId:Int?
    let myItemViewModel = MyItemListViewModel()
    var objAuthProductList:MyItemListResponse?
    var objDecryptedAuthProduct:DecryptMyItemListResponse?
    
    var viewModel = SearchMarketVM()
    var objSearchData:SearchMarketResponse?
    var objDecryptSearchMarket:DecryptSearchMarketResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        collectionViewMyEvent.reloadData()
        collectionViewMyEvent.tag = 1
        lblHeading.text = "My Items"
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.searchView.isHidden = true
        tfSearch.delegate = self
        callAuthProductListApi()
    }
    
    func callAuthProductListApi() {
        myItemViewModel.fetchAuthProductData() { [weak self] authProductListResponse in
            guard let self = self else { return }
            if let authProduct = authProductListResponse {
                let encryptedString = authProduct.data
                self.objAuthProductList?.data = encryptedString
                DispatchQueue.main.async {
                    self.decryptAuthProductListApi(encryptedString: encryptedString)
                }
            }
        }
    }
    
    private func decryptAuthProductListApi(encryptedString: String) {
        myItemViewModel.decryptAuthProductData(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.objDecryptedAuthProduct = decryptedData
                    self.collectionViewMyEvent.reloadData()
                }
            } else {
                print("❌ Failed to decrypt poll list data")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchView.isHidden = true
    }
    
    @IBAction func btnSearch(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchAllListViewController") as? SearchAllListViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btncancelSearch(_ : UIButton){
        self.searchView.isHidden = true
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateBtnAction(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMarketViewController") as? CreateMarketViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
        print("Abdul Aleem Usmani")
    }
}

extension MyitemsMarketViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sourceViewController == "OtherProfile" {
            return MyitemsData?.myProductList?.count ?? 0
        } else if sourceViewController == "MyProfile" {
            return objDecryptedAuthProduct?.data.data.Auth_Products.count ?? 0
        } else {
            return AllListMarketData?.producthomelist?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItemCollectionViewCell", for: indexPath) as! MyItemCollectionViewCell
        let item = objDecryptedAuthProduct?.data.data.Auth_Products[indexPath.row]
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

extension MyitemsMarketViewController {
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

extension MyitemsMarketViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !updatedText.isEmpty {
                self.tfSearch.text = updatedText
                self.callSearchMarketApi()
            }
        }
        return true
    }
}
