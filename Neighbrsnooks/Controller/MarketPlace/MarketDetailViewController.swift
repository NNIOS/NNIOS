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

@available(iOS 16.0, *)
class MarketDetailViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, ConfirmDeletemarket {
    func tapConfirm() {
        
    }
    
    
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
    
    @IBOutlet weak var AddWishList: UIButton!
    @IBOutlet weak var RemoveWishList : UIButton!
    @IBOutlet weak var btnChat : UIButton!
    @IBOutlet weak var btnDel : UIButton!
    @IBOutlet weak var btnEdit : UIButton!
    
    @IBOutlet weak var SoldImgView : UIImageView!
    
    var MarketWDetailData : ProductResponse?
    var MarketWDeleteData : DelMarketProductModel?
    var WishlistdataData : WishListModel?
    var WishlistdeleteData : WishListRemoveModel?
    // var imgDataM = [ProductImage]()
    var ProductDataM = [ProductDetail]()
    var thisWidth:CGFloat = 0
    var idD = ""
    var id = ""
    var productImages: [ProductImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewEvent.delegate = self
        collectionViewEvent.dataSource = self
        collectionViewEvent.reloadData()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.LblCat.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 0 // Space between items should be 0
        collectionViewEvent.collectionViewLayout = layout
        collectionViewEvent.isPagingEnabled = false // We'll handle custom snapping
        collectionViewEvent.decelerationRate = .fast // Fast scrolling stop
        collectionViewEvent.showsHorizontalScrollIndicator = false
        
        
        
        callMarketDetailWebService { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.updateUI()
            }
        }
        
        
        //        callMarketDetailWebService{ [self] in
        //            self.UserLbl.text = self.MarketWDetailData?.productdetail?.first?.pTitle
        //            // cell.rsLbl.text = "Rs." + (MarketWallData?.yourItems![indexPath.row].salePrice ?? "")
        //            self.rsLbl.text = "Rs." + (self.MarketWDetailData?.productdetail?.first?.salePrice ?? "")
        //            self.DescLbl.text = self.MarketWDetailData?.productdetail?.first?.pDescription
        //            self.timeLbl.text = self.MarketWDetailData?.productdetail?.first?.createdTime
        //            self.CreatorLbl.text = self.MarketWDetailData?.productdetail?.first?.sellerName
        //            self.secLbl.text = self.MarketWDetailData?.productdetail?.first?.neighborhoodName
        //            self.LblCat.text = self.MarketWDetailData?.productdetail?.first?.catName
        //
        //            let url = URL(string: (MarketWDetailData?.productdetail?.first?.userpic ?? ""))
        //            self.profileImgView.kf.indicatorType = .activity
        //            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
        //
        //          //  MarketWDetailData = ProductResponse // Update your data
        //            SimilarCollectionView.reloadData()
        //            updateSimilarProductsVisibility()
        //
        //
        //            let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        //            var id = UserDefaults.standard.string(forKey: "userid")
        //            if id == idCr {
        //
        //                btnChat.setTitle("Chat", for: .normal)
        //                self.btnDel.isHidden = false
        //                self.btnEdit.isHidden = false
        //                self.AddWishList.isHidden = true
        //            } else {
        //                btnChat.setTitle("Chat with seller", for: .normal)
        //                self.btnDel.isHidden = true
        //                self.btnEdit.isHidden = true
        //                self.AddWishList.isHidden = false
        //            }
        //
        //            if MarketWDetailData?.productdetail?.first?.wishlistStatus == 1 {
        //                RemoveWishList.isHidden = false
        //              //  AddWishList.isHidden = true
        //
        //            } else if MarketWDetailData?.productdetail?.first?.wishlistStatus == 0 {
        //
        //                RemoveWishList.isHidden = true
        //              //  AddWishList.isHidden = false
        //
        //            }
        //
        //            if MarketWDetailData?.productdetail?.first?.pStatus == 2 {
        //                self.SoldImgView.isHidden = false
        //
        //
        //            } else {
        //
        //                SoldImgView.isHidden = true
        //
        //
        //            }
        //
        //        }
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        self.UserLbl.text = self.MarketWDetailData?.productdetail?.first?.pTitle
        self.rsLbl.text = "Rs." + (self.MarketWDetailData?.productdetail?.first?.salePrice ?? "")
        self.DescLbl.text = self.MarketWDetailData?.productdetail?.first?.pDescription
        self.timeLbl.text = self.MarketWDetailData?.productdetail?.first?.createdTime
        self.CreatorLbl.text = self.MarketWDetailData?.productdetail?.first?.sellerName
        self.secLbl.text = self.MarketWDetailData?.productdetail?.first?.neighborhoodName
        self.LblCat.text = self.MarketWDetailData?.productdetail?.first?.catName
        
        let url = URL(string: self.MarketWDetailData?.productdetail?.first?.userpic ?? "")
        self.profileImgView.kf.indicatorType = .activity
        self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "MarketDefault"))
        
        self.SimilarCollectionView.reloadData()
        self.updateSimilarProductsVisibility()
        
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let id = UserDefaults.standard.string(forKey: "userid")
        self.btnChat.setTitle(id == idCr ? "Chat" : "Chat with seller", for: .normal)
        self.btnDel.isHidden = id != idCr
        self.btnEdit.isHidden = id != idCr
        self.AddWishList.isHidden = id == idCr
        
        self.RemoveWishList.isHidden = self.MarketWDetailData?.productdetail?.first?.wishlistStatus != 1
        self.SoldImgView.isHidden = self.MarketWDetailData?.productdetail?.first?.pStatus != 2
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //callProductListWebService{}
        //        callMarketDetailWebService{ [self] in
        //            self.UserLbl.text = self.MarketWDetailData?.productdetail?.first?.pTitle
        //            // cell.rsLbl.text = "Rs." + (MarketWallData?.yourItems![indexPath.row].salePrice ?? "")
        //            self.rsLbl.text = "Rs." + (self.MarketWDetailData?.productdetail?.first?.salePrice ?? "")
        //            self.DescLbl.text = self.MarketWDetailData?.productdetail?.first?.pDescription
        //            self.timeLbl.text = self.MarketWDetailData?.productdetail?.first?.createdTime
        //            self.CreatorLbl.text = self.MarketWDetailData?.productdetail?.first?.sellerName
        //            self.secLbl.text = self.MarketWDetailData?.productdetail?.first?.neighborhoodName
        //            self.LblCat.text = self.MarketWDetailData?.productdetail?.first?.catName
        //
        //            let url = URL(string: (MarketWDetailData?.productdetail?.first?.userpic ?? ""))
        //            self.profileImgView.kf.indicatorType = .activity
        //            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
        //
        //          //  MarketWDetailData = ProductResponse // Update your data
        //            SimilarCollectionView.reloadData()
        //            updateSimilarProductsVisibility()
        //
        //
        //            let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        //            var id = UserDefaults.standard.string(forKey: "userid")
        //            if id == idCr {
        //
        //                btnChat.setTitle("Chat", for: .normal)
        //                self.btnDel.isHidden = false
        //                self.btnEdit.isHidden = false
        //                self.AddWishList.isHidden = true
        //            } else {
        //                btnChat.setTitle("Chat with seller", for: .normal)
        //                self.btnDel.isHidden = true
        //                self.btnEdit.isHidden = true
        //                self.AddWishList.isHidden = false
        //            }
        //
        //            if MarketWDetailData?.productdetail?.first?.wishlistStatus == 1 {
        //                RemoveWishList.isHidden = false
        //              //  AddWishList.isHidden = true
        //
        //            } else if MarketWDetailData?.productdetail?.first?.wishlistStatus == 0 {
        //
        //                RemoveWishList.isHidden = true
        //              //  AddWishList.isHidden = false
        //
        //            }
        //
        //            if MarketWDetailData?.productdetail?.first?.pStatus == 2 {
        //                self.SoldImgView.isHidden = false
        //
        //
        //            } else {
        //
        //                SoldImgView.isHidden = true
        //
        //
        //            }
        //
        //        }
        
        
        
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func updateSimilarProductsVisibility() {
        if let similarProducts = MarketWDetailData?.similarproducts, !similarProducts.isEmpty {
            SimilarProductLbl.isHidden = false
            SimilarCollectionView.isHidden = false
        } else {
            SimilarProductLbl.isHidden = true
            SimilarCollectionView.isHidden = true
        }
    }
    
    
    @IBAction func btnChat(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketChatListViewController") as? MarketChatListViewController else {return}
        
        vc.NewidD = idD
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnProfile(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}
        
        vc.Oid = String(self.MarketWDetailData?.productdetail?.first?.createdBy ?? 0)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnEdit(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditMarketViewController") as? EditMarketViewController else {return}
        vc.idD = idD
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNewChat(_ : UIButton) {
        
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        var id = UserDefaults.standard.string(forKey: "userid")
        if id == idCr {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketChatListViewController") as? MarketChatListViewController else {return}
            
            vc.NewidD = idD
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketChatViewController") as? MarketChatViewController else {return}
            vc.Productid = String(self.MarketWDetailData?.productdetail?.first?.id ?? 0)
            // vc.userName = String(self.MarketWDetailData?.productdetail?.first?.sellerName )
            vc.userName = (self.MarketWDetailData?.productdetail?.first?.sellerName)!
            vc.senderUserpic = (self.MarketWDetailData?.productdetail?.first?.userpic)!
            
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
        
        // Customizing the message font and size
        let messageText = "Are you sure you want to remove this product?"
        let attributedMessage = NSAttributedString(string: messageText, attributes: [
            .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        ])
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        // Define RGB Colors
        let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)  // Green
        let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)   // Red
        
        // Yes Action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.callMarketDelWebService {
                // Pop one screen back after the API call is successful
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        yesAction.setValue(yesColor, forKey: "titleTextColor") // Set Yes button color
        
        // No Action
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(noColor, forKey: "titleTextColor") // Set No button color
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func AddWishlistBtnAction(_ sender: UIButton) {
        
        callWishListWebService { [weak self] in
            
            // After the API call is successful, navigate to HomeMarketViewController
            DispatchQueue.main.async {
                // Ensure that self is not nil
                guard let strongSelf = self else { return }
                self?.navigationController?.popViewController(animated: true)
                // Initialize HomeMarketViewController
                //                   if let homeMarketVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HomeMarketViewController") as? HomeMarketViewController {
                //
                //                       // Navigate to HomeMarketViewController
                //                       strongSelf.navigationController?.pushViewController(homeMarketVC, animated: true)
                //                   }
            }
        }
    }
    
    
    @IBAction func DelWishlistBtnAction(_ sender: UIButton) {
        
        callWishlistDeleteWebService{ [weak self] in
            
            // After the API call is successful, navigate to HomeMarketViewController
            DispatchQueue.main.async {
                // Ensure that self is not nil
                guard let strongSelf = self else { return }
                self?.navigationController?.popViewController(animated: true)
                // Initialize HomeMarketViewController
                //                if let homeMarketVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HomeMarketViewController") as? HomeMarketViewController {
                //
                //                    // Navigate to HomeMarketViewController
                //                    strongSelf.navigationController?.pushViewController(homeMarketVC, animated: true)
                //                }
            }
        }
    }
    
    func callMarketDelWebService(completion: @escaping () -> Void) {
        guard let idPr = UserDefaults.standard.string(forKey: "producttId"), !idPr.isEmpty else {
            print("Product ID is not available")
            return
        }
        
        let url = "https://dev.neighbrsnook.com/admin/api/mpk_product_add/edit/\(idPr)"
        
        let dictParams: [String: Any] = [:] // Empty dictionary if no parameters are required
        
        // Run API request in background thread for faster execution
        DispatchQueue.global(qos: .userInitiated).async {
            RSNetworkManager.shared.newRequestApi(withServiceName: url, requestMethod: .DELETE, requestParameters: dictParams, withProgressHUD: true) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                
                DispatchQueue.main.async { // Ensure UI updates on main thread
                    switch statusCode {
                    case .SUCCESS, .CREATED:
                        guard let result = result else {
                            print("No data received")
                            return
                        }
                        
                        do {
                            let data = try JSONDecoder().decode(DelMarketProductModel.self, from: result)
                            self.MarketWDeleteData = data
                            
                            // Save the deleted product ID
                            if let productID = self.MarketWDetailData?.productdetail?.first?.id {
                                UserDefaults.standard.set(productID, forKey: "CrId")
                            }
                            
                            completion() // Notify caller that API call is complete
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
    
    
    //    @IBAction func btnProfile(_ : UIButton){
    //
    //    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatOtherProfileViewController") as? ChatOtherProfileViewController else {return}
    //
    //        vc.Newid = idCr
    //
    //    self.navigationController?.pushViewController(vc, animated: true)
    //
    //       }
    
    func callMarketDetailWebService(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/mpk_product_detail?"
        
        // let dictParams: Dictionary<String, Any> = ["":""]
        
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let idPr = UserDefaults.standard.string(forKey: "producttId")
        let sellN = UserDefaults.standard.string(forKey: "sellerName")
        let Sid = UserDefaults.standard.string(forKey: "SenderidN")
        let dictParams: Dictionary<String, Any> = [
            "user_id":id ?? "",
            "product_id":idD ?? "",
            
            
        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
                    self.MarketWDetailData = data
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "producttId")
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.sellerName, forKey: "sellerName")
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "SenderidN")
                    self.collectionViewEvent.reloadData()
                    self.SimilarCollectionView.reloadData()
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        //self.MarketWDetailData = data // Your actual data fetching logic
                        
                        DispatchQueue.main.async {
                            self.MarketWDetailData = data
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                //   self.showLogoutAlert()
            default:
                break
            }
        }
    }
    
    func callWishListWebService(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/wishlist"
        
        
        
        // let dictParams: Dictionary<String, Any> = ["":""]
        
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let idPr = UserDefaults.standard.string(forKey: "producttId")
        let Sid = UserDefaults.standard.string(forKey: "Senderid")
        let dictParams: Dictionary<String, Any> = [
            "user_id":id ?? "",
            "product_id":idD ?? "",
            
            
        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(WishListModel.self, from: result!)
                    self.WishlistdataData = data
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "producttId")
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "Senderid")
                    self.collectionViewEvent.reloadData()
                    self.SimilarCollectionView.reloadData()
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.WishlistdataData = data // Your actual data fetching logic
                        
                        DispatchQueue.main.async {
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(WishListModel.self, from: result!)
                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                //   self.showLogoutAlert()
            default:
                break
            }
        }
    }
    
    func callWishlistDeleteWebService(completion: @escaping () -> Void) {
        
        //        guard let id = UserDefaults.standard.string(forKey: "userid"), !id.isEmpty else {
        //                print("Product ID is not available")
        //                return
        //            }
        // let idPr = UserDefaults.standard.string(forKey: "producttId")
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let url = "https://dev.neighbrsnook.com/admin/api/wishlist/\(idD)"
        
        // "https://dev.neighbrsnook.com/admin/api/mpk_product_detail?"
        
        // let dictParams: Dictionary<String, Any> = ["":""]
        
        
        let dictParams: Dictionary<String, Any> = ["":""]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.DELETE,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(WishListRemoveModel.self, from: result!)
                    self.WishlistdeleteData = data
                    //   UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "CrId")
                    
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.WishlistdeleteData = data // Your actual data fetching logic
                        
                        DispatchQueue.main.async {
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(WishListRemoveModel.self, from: result!)
                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                //   self.showLogoutAlert()
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return MarketWDetailData?.productdetail.count ?? 0
        if collectionView == collectionViewEvent
        {
            // return MarketWDetailData?.productdetail?.count ?? 0
            return MarketWDetailData?.productdetail?.first?.pImages?.count ?? 0
            
        }
        else{
            return MarketWDetailData?.productdetail?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewEvent
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketDetailCollectionViewCell", for: indexPath) as! MarketDetailCollectionViewCell
            
            
            
            if let postImage = MarketWDetailData?.productdetail?.first?.pImages?[indexPath.row] {
                cell.configure(with: postImage) // Configure the cell with the data
                
            }
            
            cell.numberLabel.text = "\(indexPath.item + 1)"
            //   let totalNumberOfImages =  BussinessDetailData?.image?.count ?? 0
            let totalNumberOfImages =  MarketWDetailData?.productdetail?.first?.pImages?.count ?? 0
            cell.totalImagesLabel.text =  "/ \(totalNumberOfImages)"
            cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
            
            //
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarProductCollectionViewCell", for: indexPath) as! SimilarProductCollectionViewCell
            
            
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
            
            if let similarProducts = MarketWDetailData?.similarproducts, !similarProducts.isEmpty {
                // Enable the code and configure the cell with similarproducts data
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
                // Disable the code if similarproducts is empty or nil
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
                // vc.idD = (MarketWallData?.yourItems?[indexPath.row].id)!
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
            
            // Get the selected media item (image or video)
            let selectedItem = pImages[indexPath.row]
            
            // Prepare media array (both images & videos)
            let mediaArray = pImages.compactMap { $0.video ?? $0.img }
            
            // Check if the selected item is a video
            if let videoUrl = selectedItem.video, let url = URL(string: videoUrl) {
                // ✅ Play video in fullscreen
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                player.isMuted = true // ✅ By default video mute rahega
                
                // Present video in full screen
                present(playerViewController, animated: true) {
                    player.play()
                }
                
            } else if let imageUrlString = selectedItem.img, let _ = URL(string: imageUrlString) {
                // ✅ If it's an image, navigate to PostViewShowImgVideosDataVC
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let enlargementVC = storyboard.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as? PostViewShowImgVideosDataVC {
                    
                    // ✅ Pass the selected media (image)
                    enlargementVC.selectedMediaDetailsUrl = imageUrlString
                    
                    // ✅ Pass the complete media array (both images & videos)
                    enlargementVC.mediaArrayMarketDetails = mediaArray
                    
                    // Navigate to PostViewShowImgVideosDataVC
                    self.navigationController?.pushViewController(enlargementVC, animated: true)
                }
            }
        }
    }
    
    
    
    
}

//status 2 dono gone
//0 deact gone, activate visible
//1 deact visible, activate gone
