//
//  MarketDetailViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/09/24.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import SVProgressHUD

@available(iOS 16.0, *)
class MarketDetailViewController: BaseViewController, ConfirmDeletemarket {
    func tapConfirm() {
        
    }
    
    @IBOutlet weak var simillarCollectionViewHightConst: NSLayoutConstraint!
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    @IBOutlet weak var SimilarCollectionView: UICollectionView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var UserLbl: UILabel!
    @IBOutlet weak var rsLbl: UILabel!
    @IBOutlet weak var DescLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var CreatorLbl: UILabel!
    @IBOutlet weak var secLbl: UILabel!
    @IBOutlet weak var SimilarProductLbl: UILabel!
    @IBOutlet weak var LblCat: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var LblCount: UILabel!
    
    @IBOutlet weak var AddWishList: UIButton!
    @IBOutlet weak var RemoveWishList : UIButton!
    @IBOutlet weak var btnChat : UIButton!
    @IBOutlet weak var btnDel : UIButton!
    @IBOutlet weak var btnEdit : UIButton!
    
    @IBOutlet weak var SoldImgView : UIImageView!
    @IBOutlet weak var MarketFullView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var lblSellDonate: CustomLabelHeadingUseranme!
    
    var MarketWDetailData : ProductResponse?
    var MarketWDeleteData : DelMarketProductModel?
    var WishlistdataData : WishListModel?
    var WishlistdeleteData : WishListRemoveModel?
    // var imgDataM = [ProductImage]()
    var ProductDataM = [ProductDetail]()
    var thisWidth:CGFloat = 0
    var idD = ""
    var id = ""
    //  var productImages: [ProductImage] = []
    //  var productImages: [PImage] = []
    var productImages: [ProductImage] = []
    private var defaultTextColor: UIColor?
    //   var MarketWDetailData : ProductResponse?
    var isFromChatList: Bool = false
    var objChatRead: ChatReadModel?
    var productUserID = ""
    var loadingAlert: UIAlertController?
    
    var jMarketId: Int = 0
    var jProductUserId:Int?
    var ViewModel = MarketDetailsVM()
    var objMarketDetails:MarketDetailsResponse?
    var decryptMarketDeatils:DecryptMarketDetailsResponse?
    
    var wishListViewModel = MarketWishlistVM()
    var objWishListData: MarketWishlistResponse?
    
    var marketDeleteVM = MarketDeleteVM()
    var objMarketDelete: MarketDeleteResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reach().isInternet() {
            marketDetailsApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reach().isInternet() {
            marketDetailsApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    func updateUI() {
        self.UserLbl.numberOfLines = 0
        self.UserLbl.text = self.MarketWDetailData?.productdetail?.first?.pDescription
        if let priceString = MarketWDetailData?.productdetail?.first?.salePrice,
           let price = Double(priceString) {
            rsLbl.text = "Rs. \(Int(price))"
            if price == 0.0 {
                rsLbl.text = "Free"
                lblSellDonate.text = "Given"
            } else {
                lblSellDonate.text = "SOLD"
            }
        } else {
            rsLbl.text = "Rs. 0"
        }
        
        if MarketWDetailData?.productdetail?.first?.pStatus == 2 /*|| MarketWDetailData?.productdetail?.first?.saleType == "Donate"*/ {
            lblSellDonate.isHidden = false
        } else {
            lblSellDonate.isHidden = true
        }
        self.DescLbl.text = self.MarketWDetailData?.productdetail?.first?.catName
        self.timeLbl.text = self.MarketWDetailData?.productdetail?.first?.createdTime
        self.CreatorLbl.text = self.MarketWDetailData?.productdetail?.first?.sellerName
        self.secLbl.text = self.MarketWDetailData?.productdetail?.first?.neighborhoodName
        self.LblCat.text = self.MarketWDetailData?.productdetail?.first?.pTitle
        
        if let readCount = self.MarketWDetailData?.productdetail?.first?.readCount {
            if readCount > 0 {
                self.LblCount.text = "\(readCount)"
                self.LblCount.isHidden = false
                self.countView.isHidden = false
            } else {
                self.LblCount.isHidden = true
                self.countView.isHidden = true
            }
        } else {
            self.LblCount.isHidden = true
            self.countView.isHidden = true
        }
        
        if self.MarketWDetailData?.productdetail?.first?.wishlistStatus == 1 {
            RemoveWishList.isHidden = false
            AddWishList.isHidden = true
            RemoveWishList.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            RemoveWishList.tintColor = UIColor(hexString: "#008000")
        }
        
        let url = URL(string: self.MarketWDetailData?.productdetail?.first?.userpic ?? "")
        self.profileImgView.kf.indicatorType = .activity
        self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "MarketDefault"))
        
        self.SimilarCollectionView.reloadData()
        self.updateSimilarProductsVisibility()
        
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let id = UserDefaults.standard.string(forKey: "userid")
        self.btnChat.setTitle("Chat", for: .normal)
        self.btnDel.isHidden = id != idCr
        self.btnEdit.isHidden = id != idCr
        self.AddWishList.isHidden = id == idCr
        
        self.RemoveWishList.isHidden = self.MarketWDetailData?.productdetail?.first?.wishlistStatus != 1
        //        self.SoldImgView.isHidden = self.MarketWDetailData?.productdetail?.first?.pStatus != 2
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            MarketFullView.backgroundColor = .black
            UserLbl.textColor = .white
            rsLbl.textColor = .white
            DescLbl.textColor = .white
            CreatorLbl.textColor = .white
            secLbl.textColor = .white
            timeLbl.textColor = .white
            LblCat.textColor = .white
            
        } else {
            MarketFullView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            UserLbl.textColor =  UIColor.secondaryLabel
            rsLbl.textColor =  UIColor.secondaryLabel
            DescLbl.textColor =  UIColor.secondaryLabel
            CreatorLbl.textColor =  defaultTextColor
            secLbl.textColor =  UIColor.secondaryLabel
            timeLbl.textColor =  UIColor.secondaryLabel
            LblCat.textColor =  UIColor.secondaryLabel
            
            
        }
        //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            //            updateColors()
        }
    }
    
    
    func updateSimilarProductsVisibility() {
        if let similarProducts = decryptMarketDeatils?.data.data.Similar_Products.count, similarProducts != 0 {
            SimilarProductLbl.isHidden = false
            SimilarCollectionView.isHidden = false
            simillarCollectionViewHightConst.constant = 152
        } else {
            SimilarProductLbl.isHidden = true
            SimilarCollectionView.isHidden = true
            simillarCollectionViewHightConst.constant = -50
        }
    }
    
    @IBAction func btnShareApp(_ : UIButton) {
        let appName = "NeighboursNook"
        let appDescription = "\(appName) is a hyperlocal social networking service . Connecting with your neighborhood today!"
        let appLink = "https://testflight.apple.com/join/1G74jNEC"
        let shareText = "\(appDescription) \nDownload now: \(appLink)"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnChat(_ : UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketChatListViewController") as? MarketChatListViewController else {return}
        vc.NewidD = idD
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnProfile(_ : UIButton) {
        //        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}
        //                vc.Oid = String(self.MarketWDetailData?.productdetail?.first?.createdBy ?? 0)
        //        self.navigationController?.pushViewController(vc, animated: true)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else { return }
        guard let currentUserId = UserDefaults.standard.string(forKey: "userid") else { return }
        guard let createdBy = MarketWDetailData?.productdetail?.first?.createdBy else { return }
        let createdByString = String(createdBy)
        vc.Oid = createdByString
        if currentUserId == createdByString {
            vc.sourceViewController = "MyProfile"
        } else {
            vc.sourceViewController = "OtherProfile"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnEdit(_ : UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditMarketViewController") as? EditMarketViewController else {return}
        vc.idD = idD
        vc.onUpdateForBlock = { [weak self] in
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNewChat(_ : UIButton) {
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let id = UserDefaults.standard.string(forKey: "userid")
        
        if id == idCr {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketChatListViewController") as? MarketChatListViewController else { return }
            vc.NewidD = idD
            vc.isFromChatList = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketChatViewController") as? MarketChatViewController else { return }
            vc.Productid = String(self.MarketWDetailData?.productdetail?.first?.id ?? 0)
            vc.userName = (self.MarketWDetailData?.productdetail?.first?.sellerName)!
            vc.senderUserpic = (self.MarketWDetailData?.productdetail?.first?.userpic)!
            vc.isFromChatList = false // ✅ Set the flag here
            self.callMarketReadStatus2{}
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func DeletePopUpBtnAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"DeleteMarketViewController")as! DeleteMarketViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc , animated: true)
    }
    
    @IBAction func DeletePopUpNewBtnAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to remove this product?", preferredStyle: .alert)
        let messageText = "Are you sure you want to remove this product?"
        let attributedMessage = NSAttributedString(
            string: messageText, attributes: [ .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.darkGray ] )
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.marketDeleteApi()
        }
        yesAction.setValue(UIColor.systemGreen, forKey: "titleTextColor")
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func AddWishlistBtnAction(_ sender: UIButton) {
        toggleWishListApi()
    }
    
    @IBAction func DelWishlistBtnAction(_ sender: UIButton) {
        toggleWishListApi()
    }
    
    func callMarketReadStatus2(completion: @escaping () -> Void) {
        let url = "https://neighbrsnook.com/admin/api/chat_read_status"
        let id = UserDefaults.standard.string(forKey: "userid")
        let createdBy = UserDefaults.standard.integer(forKey: "SenderidN")
        let dictParams: Dictionary<String, Any> = [
            "product_id": idD,
            "sender_id": "\(createdBy)",
            "receiver_id": id ?? ""
        ]
        print("Param for chat read api is :\(dictParams)")
        //            RSNetworkManager.shared.newRequestApi(
        //                withServiceName: url,
        //                requestMethod: .PUT,
        //                requestParameters: dictParams,
        //                withProgressHUD: true
        //            ) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
        //                switch statusCode {
        //                case .SUCCESS, .CREATED:
        //                    do {
        //                        let data = try JSONDecoder().decode(ChatReadModel.self, from: result!)
        //                        
        //                        // Update UI and UserDefaults on main thread
        //                        DispatchQueue.main.async {
        //                            self.objChatRead = data
        //                            completion()
        //                        }
        //                    } catch {
        //                        print("Decoding error: \(error.localizedDescription)")
        //                        DispatchQueue.main.async {
        //                            completion()
        //                        }
        //                    }
        //                    
        //                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
        //                    do {
        //                        let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
        //                        print("Bad reuqest is :\(data)")
        //                    } catch {
        //                        print(error.localizedDescription)
        //                    }
        //                    DispatchQueue.main.async {
        //                        completion()
        //                    }
        //                    
        //                case .UNAUTHORIZED:
        //                    print(error?.localizedDescription ?? "")
        //                    DispatchQueue.main.async {
        //                        completion()
        //                    }
        //                default:
        //                    DispatchQueue.main.async {
        //                        completion()
        //                    }
        //                }
        //            }
    }
}


extension MarketDetailViewController {
    
    func setupUI() {
        collectionViewEvent.delegate = self
        collectionViewEvent.dataSource = self
        collectionViewEvent.reloadData()
        self.lblHeading.text = "Item Details"
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.LblCount.font = UIFont(name: "Montserrat-Medium", size: 11)
        self.LblCat.font = UIFont(name: "Montserrat-Medium", size: 19)
        self.UserLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.DescLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.timeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.secLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.CreatorLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.SimilarProductLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.timeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.btnChat.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        defaultTextColor = CreatorLbl.textColor
        SimilarCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func marketDetailsApi() {
        UtilityMethods.showIndicator()
        let request = MarketDetailsRequest(product_id: jMarketId)
        let param:[String:Any] = [
            "product_id":request.product_id
        ]
        print("Pram is: \(param)")
        ViewModel.fetchMarketDetailsData(parameter: param, request: request) { [weak self] marketDetilsResponse in
            guard let self = self else { return }
            if let marketDetailsData = marketDetilsResponse {
                let encryptedString = marketDetailsData.data
                self.objMarketDetails?.data = encryptedString
                DispatchQueue.main.async {
                    self.decryptMarketDetailsApi(encryptedString: encryptedString)
                }
            }
        }
    }
    
    func decryptMarketDetailsApi(encryptedString: String) {
        ViewModel.decryptMarketDetailsData(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.decryptMarketDeatils = decryptedData
                    let marketItem =  self.decryptMarketDeatils?.data.data.productdetail
                    self.LblCat.text = marketItem?.p_title
                    self.timeLbl.text = marketItem?.created_at
                    self.UserLbl.text = marketItem?.sale_price
                    self.rsLbl.text = marketItem?.cat_name
                    self.DescLbl.text = marketItem?.p_description
                    if marketItem?.p_status == false {
                        self.lblSellDonate.isHidden = false
                    } else {
                        self.lblSellDonate.isHidden = true
                    }
                    if let priceString = marketItem?.sale_price,
                       let price = Double(priceString) {
                        self.rsLbl.text = "Rs. \(Int(price))"
                        if price == 0.0 {
                            self.rsLbl.text = "Free"
                            self.lblSellDonate.text = "Given"
                        } else {
                            self.lblSellDonate.text = "SOLD"
                        }
                        
                    } else {
                        self.rsLbl.text = "Rs. 0"
                    }
                    self.CreatorLbl.text = marketItem?.username
                    self.secLbl.text = marketItem?.neighborhood_name
                    let readCount = marketItem?.read_count
                    if readCount == 0 {
                        self.countView.isHidden = true
                        self.LblCount.isHidden = true
                    } else {
                        self.countView.isHidden = false
                        self.LblCount.text = String(readCount ?? 0)
                    }
                    ImageLoader.shared.setImage(on: self.profileImgView, urlString: marketItem?.userpic ?? "", placeholder: "MarketDefault")
                    let userID = UserDefaults.standard.string(forKey: "userId")
                    let marketUserId = marketItem?.user_id
                    self.btnDel.isHidden = userID != String(marketUserId ?? 0)
                    self.btnEdit.isHidden = userID != String(marketUserId ?? 0)
                    if userID == String(marketUserId ?? 0) {
                        self.AddWishList.isHidden = true
                        self.RemoveWishList.isHidden = true
                    } else {
                        let isInWishlist = marketItem?.auth_wishlist_status ?? false
                        self.AddWishList.isHidden = isInWishlist
                        self.RemoveWishList.isHidden = !isInWishlist
                    }
                    UtilityMethods.hideIndicator()
                    self.updateSimilarProductsVisibility()
                    self.SimilarCollectionView.reloadData()
                    self.collectionViewEvent.reloadData()
                }
            } else {
                print("❌ Failed to decrypt poll list data")
            }
        }
    }
    
    func toggleWishListApi() {
        let request = MarketWishlistRequest(product_id: jMarketId)
        let param:[String:Any] = [
            "product_id": request.product_id
        ]
        print("Param is: \(param)")
        wishListViewModel.toggleWishList(parameter: param, request: request) { response in
            DispatchQueue.main.async {
                if let wishListData = response {
                    self.objWishListData = wishListData
                    if self.objWishListData?.message == "added" {
                        self.AddWishList.isHidden = true
                        self.RemoveWishList.isHidden = false
                    } else if self.objWishListData?.message == "removed" {
                        self.AddWishList.isHidden = false
                        self.RemoveWishList.isHidden = true
                    }
                    self.marketDetailsApi()
                }
            }
        }
    }
    
    func marketDeleteApi() {
        let request = MarketDeleteRequest(product_id: jMarketId)
        let param:[String:Any] = [
            "product_id":request.product_id ?? 0
        ]
        print("Param is: \(param)")
        marketDeleteVM.marketDelete(parameter: param, request: request) { response in
            DispatchQueue.main.async {
                if let deleteMarket = response {
                    self.objMarketDelete = deleteMarket
                    print("Delete market response is: \(deleteMarket)")
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}


extension MarketDetailViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let productItem =  self.decryptMarketDeatils?.data.data.productdetail
        let similarProduct =  self.decryptMarketDeatils?.data.data.Similar_Products
        if collectionView == collectionViewEvent {
            return productItem?.media.count ?? 0
        }
        else {
            return similarProduct?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewEvent {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketDetailCollectionViewCell", for: indexPath) as! MarketDetailCollectionViewCell
            let item =  self.decryptMarketDeatils?.data.data.productdetail
            let mediaItem = item?.media[indexPath.row]
            if let mediaItem = mediaItem {
                cell.configure(with: mediaItem)
            }
            if let img = mediaItem?.img, !img.isEmpty {
                ImageLoader.shared.setImage(on: cell.profileImgView, urlString: img, placeholder: "MarketDefault")
                cell.pauseButton.isHidden = true
                cell.muteButton.isHidden = true
            } else if let video = mediaItem?.video, !video.isEmpty {
                ImageLoader.shared.setImage(on: cell.profileImgView, urlString: video, placeholder: "MarketDefault")
                cell.pauseButton.isHidden = false
                cell.muteButton.isHidden = false
            } else {
                cell.profileImgView.image = UIImage(named: "MarketDefault")
                print("No media available")
            }
            cell.numberLabel.text = "\(indexPath.item + 1)"
            let totalNumberOfImages =  item?.media.count ?? 0
            cell.totalImagesLabel.text =  "/  \(totalNumberOfImages)"
            cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarProductCollectionViewCell", for: indexPath) as! SimilarProductCollectionViewCell
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
            if let similarProducts = self.decryptMarketDeatils?.data.data.Similar_Products, !similarProducts.isEmpty {
                cell.viewItems.layer.applyShadow(color: .gray,  alpha: 0.5,x: 0, y: 0, blur: 10, spread: 0, cornerRadius: 2)
                cell.ViewSimilar.isHidden = false
                cell.EventLbl.isEnabled = true
                cell.rsLbl.isEnabled = true
                cell.secttLbl.isEnabled = true
                cell.DayLbl.isEnabled = true
                cell.profileImgView.isHidden = false
                cell.EventLbl.text = similarProducts[indexPath.row].p_title
                cell.rsLbl.text = "Rs." + (similarProducts[indexPath.row].sale_price)
                cell.secttLbl.text = similarProducts[indexPath.row].neighborhood_name
                cell.DayLbl.text = similarProducts[indexPath.row].created_at
                ImageLoader.shared.setImage(on: cell.profileImgView, urlString: similarProducts[indexPath.row].image, placeholder: "MarketDefault")
            } else {
                cell.EventLbl.isEnabled = false
                cell.rsLbl.isEnabled = false
                cell.ViewSimilar.isHidden = true
                cell.secttLbl.isEnabled = false
                cell.DayLbl.isEnabled = false
                cell.profileImgView.isHidden = true
                cell.EventLbl.text = ""
                cell.rsLbl.text = ""
                cell.secttLbl.text = ""
                cell.DayLbl.text = ""
                cell.profileImgView.image = nil
            }
            cell.DetailCallback = { [self] value in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
                vc.idD = String(MarketWDetailData?.similarproducts?[indexPath.row].id ?? 0)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewEvent {
            thisWidth = CGFloat(self.collectionViewEvent.width) / 1
            return CGSize(width: thisWidth, height: 450)
        }
        else {
            thisWidth = CGFloat(self.SimilarCollectionView.width) / 2
            return CGSize(width: thisWidth, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewEvent {
            let item = self.decryptMarketDeatils?.data.data.productdetail.media
            guard let mediaItems = item else { return }
            if let videoUrl = mediaItems[indexPath.row].video,
               let url = URL(string: videoUrl) {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                present(playerViewController, animated: true) {
                    player.play()
                }
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let enlargementVC = storyboard.instantiateViewController(withIdentifier: "MarketEnlargmentViewController") as? MarketEnlargmentViewController {
                    enlargementVC.images = mediaItems
                    enlargementVC.selectedIndex = indexPath.row
                    self.navigationController?.pushViewController(enlargementVC, animated: true)
                }
            }
        }
    }
}
