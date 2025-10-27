import UIKit
import SVProgressHUD

@available(iOS 16.0, *)

class HomeMarketViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var lblMyItem: UILabel!
    @IBOutlet weak var LblPopCat: UILabel!
    @IBOutlet weak var lblAllListing: UILabel!
    @IBOutlet weak var LblWishList: UILabel!
    @IBOutlet weak var LblLatest: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    @IBOutlet weak var LatestCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewcategory: UICollectionView!
    @IBOutlet weak var LatestCollectionViewListing: UICollectionView!
    @IBOutlet weak var LatestCollectionViewWishList: UICollectionView!
    
    @IBOutlet weak var allListingCVHeightConst: NSLayoutConstraint!
    @IBOutlet weak var collectionViewCategoryTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnMyItems: UIButton!
    @IBOutlet weak var btnWishList: UIButton!
    @IBOutlet weak var btnLatestViewAll: UIButton!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var collectionViewSearch: UICollectionView!
    @IBOutlet weak var searchCollView: UIView!
    @IBOutlet weak var lblLatestTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblPopularTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var MarketFullView: UIView!
    @IBOutlet weak var btnAllListViewAll: UIButton!
    @IBOutlet weak var LatestCollectionViewWishListHeightConst: NSLayoutConstraint!
    
    
    var MarketCatData : MarketCatModel?
    var MarketWallData : MarketWallModel?
    var ProductListData : TodaProductListModel?
    var categories = [MarketWallModel]()
    var AllListMarketData : AlllistMarketModel?
    var idD = ""
    var thisWidth:CGFloat = 0
    var profileData : ProfileModel?
    var sourceViewController: String?
    var Newid: String?
    var Oid: String?
    var timer: Timer?
    
    
    let myItemViewModel = MyItemListViewModel()
    var objAuthProductList:MyItemListResponse?
    var objDecryptedAuthProduct:DecryptMyItemListResponse?
    
    let latestProductViewModel = LatestProductViewModel()
    var objLatestList:LatestProductListResponse?
    var objDecryptLatestProduct:DecryptLatestListResponse?
    
    let popularViewModel = CategoryListViewModel()
    var objPopularCategoryData:PopularCategoryResponse?
    var objDecryptPopularCartegory:DecryptPopularCategoryResponse?
    
    var allProductListViewModel = AllProductListViewModel()
    var objAllProductListData:AllProductListResponse?
    var objDecryptAllProduct:DecryptAllProductListResponse?
    
    var wishListViewModel = WishListViewModel()
    var objWishListData:WishListResponse?
    var decryptWishList:DecryptWishlistResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        collectionViewMyEvent.reloadData()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.lblMyItem.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.LblPopCat.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.lblAllListing.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.LblWishList.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.LblLatest.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        collectionViewMyEvent.tag = 1
        LatestCollectionView.tag = 2
        collectionViewcategory.tag = 3
        LatestCollectionViewListing.tag = 4
        LatestCollectionViewWishList.tag = 5
        if Reach().isInternet() {
            callAuthProductListApi()
            callLatestProductListApi()
            callpopularCategoryApi()
            callAllProductListApi()
            callwishListApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reach().isInternet() {
            callAuthProductListApi()
            callLatestProductListApi()
            callpopularCategoryApi()
            callAllProductListApi()
            callwishListApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchAllListViewController") as? SearchAllListViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddMarket(_ : UIButton) {
        if Reach().isInternet() {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMarketViewController") as? CreateMarketViewController else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @IBAction func btnMyitemViewAll(_ : UIButton){
        let id = UserDefaults.standard.string(forKey: "userId") ?? ""
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyitemsMarketViewController") as? MyitemsMarketViewController else {return}
        vc.jMarketId = Int(id)
        vc.sourceViewController = "MyProfile"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLatestViewAll(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "latestListMarketViewController") as? latestListMarketViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAllLatestViewAll(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllListMarketViewController") as? AllListMarketViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnWishListViewAll(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishListmarketViewController") as? WishListmarketViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCategoryViewAll(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllCategoryilViewController") as? AllCategoryilViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeMarketViewController {
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
                    self.LatestCollectionView.reloadData()
                }
            } else {
                print("❌ Failed to decrypt poll list data")
            }
        }
    }
    
    func callpopularCategoryApi() {
        popularViewModel.fetchCategoryListData() { [weak self] latestProductListResponse in
            guard let self = self else { return }
            if let latestProduct = latestProductListResponse {
                let encryptedString = latestProduct.data
                self.objPopularCategoryData?.data = encryptedString
                DispatchQueue.main.async {
                    self.decryptPopularCategoryApi(encryptedString: encryptedString)
                }
            }
        }
    }
    
    func decryptPopularCategoryApi(encryptedString: String) {
        popularViewModel.decryptCategoryListData(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.objDecryptPopularCartegory = decryptedData
                    self.collectionViewcategory.reloadData()
                }
            } else {
                print("❌ Failed to decrypt poll list data")
            }
        }
    }
    
    func callAllProductListApi() {
        allProductListViewModel.fetchAllProductListData() { [weak self] latestProductListResponse in
            guard let self = self else { return }
            if let latestProduct = latestProductListResponse {
                let encryptedString = latestProduct.data
                self.objAllProductListData?.data = encryptedString
                print("Encrypted All product List Data is: \(encryptedString)")
                DispatchQueue.main.async {
                    self.decryptAllProductListApi(encryptedString: encryptedString)
                }
            }
        }
    }
    
    func decryptAllProductListApi(encryptedString: String)  {
        allProductListViewModel.decryptAllProductListData(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.objDecryptAllProduct = decryptedData
                    self.LatestCollectionViewListing.reloadData()
                    print("Decrypted All Product List Data is: \(decryptedData)")
                }
            } else {
                print("❌ Failed to decrypt poll list data")
            }
        }
    }
    
    func callwishListApi() {
        wishListViewModel.fetchWishListData() { [weak self] wishListResponse in
            guard let self = self else { return }
            if let wishListProduct = wishListResponse {
                let encryptedString = wishListProduct.data
                self.objWishListData?.data = encryptedString
                print("Encrypted WishList Data is :\(encryptedString)")
                DispatchQueue.main.async {
                    self.decryptWishListApi(encryptedString: encryptedString)
                }
            }
        }
    }
    
    func decryptWishListApi(encryptedString: String) {
        wishListViewModel.decryptWishListData(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.decryptWishList = decryptedData
                    self.LatestCollectionViewWishList.reloadData()
                    print("Decrypted WishList Data is: \(decryptedData)")
                }
            } else {
                print("❌ Failed to decrypt poll list data")
            }
        }
    }
}


extension HomeMarketViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        func handleVisibility(count: Int, label: UIView?, button: UIView?, constraint: NSLayoutConstraint? = nil) {
            let shouldHide = (count == 0)
            label?.isHidden = shouldHide
            button?.isHidden = shouldHide
            if let constraint = constraint {
                UIView.animate(withDuration: 0.0) {
                    constraint.constant = shouldHide ? -200 : 15
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        if collectionView == collectionViewMyEvent {
            let count = objDecryptedAuthProduct?.data.data.Auth_Products.count ?? 0
            handleVisibility(count: count, label: lblMyItem, button: btnMyItems, constraint: lblLatestTopConstraint)
            return count
        } else if collectionView == LatestCollectionView {
            let count = objDecryptLatestProduct?.data.data.today_list.count ?? 0
            handleVisibility(count: count, label: LblLatest, button: btnLatestViewAll, constraint: lblPopularTopConstraint)
            return count
        } else if collectionView == collectionViewcategory {
            return objDecryptPopularCartegory?.data.categories.count ?? 0
        } else if collectionView == LatestCollectionViewListing {
            let count = objDecryptAllProduct?.data.data.all_products_list.data.count ?? 0
            handleVisibility(count: count, label: lblAllListing, button: btnAllListViewAll)
            return count
        } else {
            let count = decryptWishList?.data.data.Auth_Wishlist.count ?? 0
            let shouldHide = (count == 0)
            LatestCollectionViewWishListHeightConst.constant = shouldHide ? 0 : 175
            LblWishList.isHidden = shouldHide
            btnWishList.isHidden = shouldHide
            return count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMyEvent {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItemCollectionViewCell", for: indexPath) as! MyItemCollectionViewCell
            let item = objDecryptedAuthProduct?.data.data.Auth_Products[indexPath.row]
            cell.viewItems.layer.applyShadow(color: .gray,  alpha: 0.5,x: 0, y: 0, blur: 10, spread: 0, cornerRadius: 2)
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.secttLbl.text = item?.neighborhood_name
            cell.EventLbl.text = item?.p_title
            cell.DayLbl.text = item?.created_time
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
            cell.lblSellDonate.isHidden = item?.p_status ?? true
            cell.imgWishlist.isHidden = true
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: item?.p_images ?? "", placeholder: "MarketDefault")
            cell.DetailCallback = { [self] _ in
                let vc = storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController") as! MarketDetailViewController
                vc.jMarketId = item?.id ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else if collectionView == LatestCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestListingCollectionViewCell", for: indexPath) as! LatestListingCollectionViewCell
            let item = objDecryptLatestProduct?.data.data.today_list[indexPath.row]
            cell.secttLbl.text =  item?.neighborhood_name
            cell.viewItems.layer.applyShadow(color: .gray,  alpha: 0.5,x: 0, y: 0, blur: 10, spread: 0, cornerRadius: 2)
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
            
            cell.lblSellDonate.isHidden = item?.p_status ?? true
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: item?.p_images ?? "", placeholder: "MarketDefault")
            cell.DayLbl.text = item?.created_time
            cell.imgWishlist.isHidden = !(item?.wishlist_status ?? false)
            cell.DetailCallback = { [self] value in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
                vc.jMarketId = item?.id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else if collectionView == collectionViewcategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            let item = objDecryptPopularCartegory?.data.categories[indexPath.row]
            cell.viewItems.layer.applyShadow(color: .gray,  alpha: 0.5,x: 0, y: 0, blur: 10, spread: 0, cornerRadius: 2)
            cell.EventLbl.font = UIFont(name: "Montserrat-SemiBold", size: 13)
            cell.EventLbl.text = item?.name
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: item?.image ?? "", placeholder: "MarketDefault")
            cell.DetailCallback = { [self] value in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailViewController")as! CategoryDetailViewController
                vc.jCatId = item?.id ?? 0
                vc.jCatTitle = item?.name
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else if collectionView == LatestCollectionViewListing {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllListingCollectionViewCell", for: indexPath) as! AllListingCollectionViewCell
            let item = objDecryptAllProduct?.data.data.all_products_list.data[indexPath.row]
            cell.viewItems.layer.applyShadow(color: .gray,  alpha: 0.5,x: 0, y: 0, blur: 10, spread: 0, cornerRadius: 2)
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
            cell.EventLbl.text = item?.p_title
            cell.secttLbl.text = item?.neighborhood_name
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
            cell.lblSellDonate.isHidden = item?.p_status ?? true
            cell.imgWishlist.isHidden = !(item?.wishlist_status ?? false)
            cell.DayLbl.text = item?.created_time
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: item?.p_images ?? "", placeholder: "MarketDefault")
            cell.DetailCallback = { [self] value in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
                vc.jMarketId = item?.id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else  if collectionView == LatestCollectionViewWishList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishListCollectionViewCell", for: indexPath) as! WishListCollectionViewCell
            let item = decryptWishList?.data.data.Auth_Wishlist[indexPath.row]
            cell.viewItems.layer.applyShadow(color: .gray,  alpha: 0.5,x: 0, y: 0, blur: 10, spread: 0, cornerRadius: 2)
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
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
            cell.lblSellDonate.isHidden = item?.p_status ?? true
            cell.secttLbl.text = item?.neighborhood_name
            cell.DayLbl.text = item?.created_time
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: item?.p_images ?? "", placeholder: "MarketDefault")
            cell.DetailCallback = { [self] value in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
                vc.jMarketId = item?.id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1:
            return CGSize(width: collectionView.frame.width / 2, height: 175)
        case 2:
            return CGSize(width: collectionView.frame.width / 2, height: 175)
        case 3:
            return CGSize(width: collectionView.frame.width / 4, height: 100)
        case 4:
            return CGSize(width: collectionView.frame.width / 2, height: 175)
        case 5:
            return CGSize(width: collectionView.frame.width / 2, height: 175)
        default:
            return CGSize(width: collectionView.frame.width / 2, height: 175)
        }
    }
}
