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
class MarketDetailViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, ConfirmDeletemarket {
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        collectionViewEvent.delegate = self
        collectionViewEvent.dataSource = self
        collectionViewEvent.reloadData()
        self.lblHeading.text = "Item Details"
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.LblCat.font = UIFont(name: "Montserrat-Regular", size: 16)
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
        
        callMarketDetailWebService { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.updateUI()
                if self.MarketWDetailData?.similarproducts?.count == 0 {
//                    self.scrollView.isScrollEnabled = false
                } else {
//                    self.scrollView.isScrollEnabled = true
                }
                SVProgressHUD.dismiss()
            }
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
    //                rsLbl.text = "Rs. \(Int(price))"
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
                RemoveWishList.tintColor = UIColor(hex: "#008000")
               
                
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
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            callMarketDetailWebService { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.updateUI()
                    SVProgressHUD.dismiss()
                }
            }
        }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            
            MarketFullView.backgroundColor = .black
            UserLbl.textColor = .white
            rsLbl.textColor = .white
            DescLbl.textColor = .white
            CreatorLbl.textColor = .white
            secLbl.textColor = .white
            timeLbl.textColor = .white
            LblCat.textColor = .white
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            
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
        if let similarProducts = MarketWDetailData?.similarproducts?.count, similarProducts != 0 {
            SimilarProductLbl.isHidden = false
            SimilarCollectionView.isHidden = false
            simillarCollectionViewHightConst.constant = 152
        } else {
            SimilarProductLbl.isHidden = true
            SimilarCollectionView.isHidden = true
            simillarCollectionViewHightConst.constant = -50
        }
    }
    
    @IBAction func btnShareApp(_ : UIButton){
        // Step 1: Show share popup
        let appName = "NeighboursNook"
        let appDescription = "NeighbrsNook is a hyperlocal social networking service . Connecting with your neighborhood today!"
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
            self?.callMarketDetailWebService { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.updateUI()
                }
            }
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
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let messageText = "Are you sure you want to remove this product?"
        let attributedMessage = NSAttributedString(string: messageText, attributes: [
            .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        ])
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)
        let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.callMarketDelWebService {
                self.navigationController?.popViewController(animated: true)
            }
        }
        yesAction.setValue(yesColor, forKey: "titleTextColor")
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(noColor, forKey: "titleTextColor")
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func AddWishlistBtnAction(_ sender: UIButton) {
    //            SVProgressHUD.show()
                callWishListWebService { [weak self] in
                    DispatchQueue.main.async {
                        guard let strongSelf = self else { return }
    //                    self?.navigationController?.popViewController(animated: true)
                        strongSelf.callMarketDetailWebService {
                            strongSelf.updateUI()
                        }
                    }
                }
            }
            
            @IBAction func DelWishlistBtnAction(_ sender: UIButton) {
    //            SVProgressHUD.show()
                callWishlistDeleteWebService{ [weak self] in
                    DispatchQueue.main.async {
                        guard let strongSelf = self else { return }
    //                    self?.navigationController?.popViewController(animated: true)
                        strongSelf.callMarketDetailWebService {
                            strongSelf.updateUI()
                        }
                    }
                }
            }
    
    func callMarketDelWebService(completion: @escaping () -> Void) {
        guard let idPr = UserDefaults.standard.string(forKey: "producttId"), !idPr.isEmpty else {
            print("Product ID is not available")
            return
        }
        
        // dev.
        let url = "https://neighbrsnook.com/admin/api/mpk_product_add/edit/\(idPr)"
        
        let dictParams: [String: Any] = [:]
        DispatchQueue.global(qos: .userInitiated).async {
            RSNetworkManager.shared.newRequestApi(withServiceName: url, requestMethod: .DELETE, requestParameters: dictParams, withProgressHUD: true) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                
                DispatchQueue.main.async {
                    switch statusCode {
                    case .SUCCESS, .CREATED:
                        guard let result = result else {
                            print("No data received")
                            return
                        }
                        
                        do {
                            let data = try JSONDecoder().decode(DelMarketProductModel.self, from: result)
                            self.MarketWDeleteData = data
                            if let productID = self.MarketWDetailData?.productdetail?.first?.id {
                                UserDefaults.standard.set(productID, forKey: "CrId")
                            }
                            
                            completion()
                        } catch {
                            print("Decoding error:", error.localizedDescription)
                        }
                        
                    case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                        print("Error Response:", statusCode)
                        
                    case .UNAUTHORIZED:
                        print(error?.localizedDescription ?? "Unauthorized request")
                        
                    default:
                        print("Unhandled status code:", statusCode)
                    }
                }
            }
        }
    }
    
    //dev.
    
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
            RSNetworkManager.shared.newRequestApi(
                withServiceName: url,
                requestMethod: .PUT,
                requestParameters: dictParams,
                withProgressHUD: true
            ) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                switch statusCode {
                case .SUCCESS, .CREATED:
                    do {
                        let data = try JSONDecoder().decode(ChatReadModel.self, from: result!)
                        
                        // Update UI and UserDefaults on main thread
                        DispatchQueue.main.async {
                            self.objChatRead = data
                            completion()
                        }
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                    
                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                    do {
                        let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
                        print("Bad reuqest is :\(data)")
                    } catch {
                        print(error.localizedDescription)
                    }
                    DispatchQueue.main.async {
                        completion()
                    }
                    
                case .UNAUTHORIZED:
                    print(error?.localizedDescription ?? "")
                    DispatchQueue.main.async {
                        completion()
                    }
                default:
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }
    
    
   // dev.
     
    func callMarketDetailWebService(completion: @escaping () -> Void) {
        let url = "https://neighbrsnook.com/admin/api/mpk_product_detail?"
        
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "user_id": id ?? "",
            "product_id": idD ?? ""
        ]
        
        RSNetworkManager.shared.newRequestApi(
            withServiceName: url,
            requestMethod: .GET,
            requestParameters: dictParams,
            withProgressHUD: true
        ) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS, .CREATED:
                do {
                    let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
                    
                    // Update UI and UserDefaults on main thread
                    DispatchQueue.main.async {
                        self.MarketWDetailData = data
                        
                        // Store necessary values
                        if let productDetail = data.productdetail?.first {
                            UserDefaults.standard.set(productDetail.createdBy, forKey: "CreatorId")
                            UserDefaults.standard.set(productDetail.id, forKey: "producttId")
                            UserDefaults.standard.set(productDetail.sellerName, forKey: "sellerName")
                            UserDefaults.standard.set(productDetail.createdBy, forKey: "SenderidN")
                        }
                        
                        self.collectionViewEvent.reloadData()
                        self.SimilarCollectionView.reloadData()
                        completion()
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion()
                    }
                }
                
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                // Handle error cases
                do {
                    let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
                    // self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                } catch {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    completion()
                }
                
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                // self.showLogoutAlert()
                DispatchQueue.main.async {
                    completion()
                }
                
            default:
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    //dev.
    
    func callWishListWebService(completion: @escaping () -> Void) { //dev.
            let url = "https://neighbrsnook.com/admin/api/wishlist"
            let id = UserDefaults.standard.string(forKey: "userid")
            let dictParams: Dictionary<String, Any> = [
                "user_id":id ?? "",
                "product_id":idD,
            ]
            print("Param is : \(dictParams)")
            self.loadingAlert = self.showLoadingAlert(on: self)
            RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true)
            {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                switch statusCode {
                case .SUCCESS ,.CREATED:
                    self.loadingAlert?.dismiss(animated: true, completion: {
                        do {
                            let data = try JSONDecoder().decode(WishListModel.self, from: result!)
                            self.WishlistdataData = data
                            //                        SVProgressHUD.dismiss()
                            UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
                            UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "producttId")
                            UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "Senderid")
                            self.collectionViewEvent.reloadData()
                            self.SimilarCollectionView.reloadData()
                            DispatchQueue.global().async {
                                //                        sleep(2)
                                self.WishlistdataData = data
                                DispatchQueue.main.async {
                                    completion()
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                    
                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                    do {
                        let data = try JSONDecoder().decode(WishListModel.self, from: result!)
                        print("Bad reuqest is :\(data)")
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
        
        //dev.
        func callWishlistDeleteWebService(completion: @escaping () -> Void) { // dev.
            let url = "https://neighbrsnook.com/admin/api/wishlist/\(idD)"
            let dictParams: Dictionary<String, Any> = ["":""]
            print("Param is : \(dictParams)")
            self.loadingAlert = self.showLoadingAlert(on: self)
            RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.DELETE,requestParameters: dictParams, withProgressHUD: true)
            {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                switch statusCode {
                case .SUCCESS ,.CREATED:
                    self.loadingAlert?.dismiss(animated: true, completion: {
                        do {
                            let data = try JSONDecoder().decode(WishListRemoveModel.self, from: result!)
                            self.WishlistdeleteData = data
                            SVProgressHUD.dismiss()
                            DispatchQueue.global().async {
                                //                        sleep(2)
                                self.WishlistdeleteData = data
                                DispatchQueue.main.async {
                                    completion()
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                    
                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                    do {
                        let data = try JSONDecoder().decode(WishListRemoveModel.self, from: result!)
                        print("Bad reuqest is :\(data)")
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewEvent {
            return MarketWDetailData?.productdetail?.first?.pImages?.count ?? 0
        }
        else {
            return MarketWDetailData?.productdetail?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == collectionViewEvent {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketDetailCollectionViewCell", for: indexPath) as! MarketDetailCollectionViewCell
                if let postImage = MarketWDetailData?.productdetail?.first?.pImages?[indexPath.row] {
                    cell.configure(with: postImage)
                }
                
                cell.numberLabel.text = "\(indexPath.item + 1)"
                let totalNumberOfImages =  MarketWDetailData?.productdetail?.first?.pImages?.count ?? 0
                cell.totalImagesLabel.text =  "/ \(totalNumberOfImages)"
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
                if let similarProducts = MarketWDetailData?.similarproducts, !similarProducts.isEmpty {
                    cell.viewItems.layer.shadowColor = UIColor.gray.cgColor
                    cell.viewItems.layer.shadowOpacity = 0.5
                    cell.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.viewItems.layer.shadowRadius = 5
                    cell.viewItems.layer.masksToBounds = false
                    cell.ViewSimilar.isHidden = false
                    cell.EventLbl.isEnabled = true
                    cell.rsLbl.isEnabled = true
                    cell.secttLbl.isEnabled = true
                    cell.DayLbl.isEnabled = true
                    cell.profileImgView.isHidden = false
                    
                    cell.EventLbl.text = similarProducts[indexPath.row].pTitle
                    cell.rsLbl.text = "Rs." + (similarProducts[indexPath.row].salePrice ?? "")

                    cell.secttLbl.text = similarProducts[indexPath.row].salePrice
                    cell.DayLbl.text = similarProducts[indexPath.row].createdTime
                    
                    let url = URL(string: similarProducts[indexPath.row].pImages ?? "")
                    cell.profileImgView.kf.indicatorType = .activity
                    cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "MarketDefault"))
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
        if collectionView == collectionViewEvent
        {
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
            
            guard let pImages = MarketWDetailData?.productdetail?.first?.pImages else { return }
            let selectedItem = pImages[indexPath.row]
            if let videoUrl = selectedItem.video, let url = URL(string: videoUrl) {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                present(playerViewController, animated: true) {
                    player.play()
                }
            } else if let imageUrlString = selectedItem.img, let imageUrl = URL(string: imageUrlString) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let enlargementVC = storyboard.instantiateViewController(withIdentifier: "MarketEnlargmentViewController") as? MarketEnlargmentViewController {
                    enlargementVC.images = pImages
                    enlargementVC.selectedIndex = indexPath.row
                    self.navigationController?.pushViewController(enlargementVC, animated: true)
                }
            }
        }
    }
}
