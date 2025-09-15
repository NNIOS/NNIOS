//
//  WishListmarketViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/09/24.
//

import UIKit
@available(iOS 16.0, *)
class WishListmarketViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    var WishListListData : WishlistModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeading.text = "Wish List"
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        
        DispatchQueue.main.async {
            self.callMarketWishlistWebService {
                // This ensures collection view is updated on main thread
                DispatchQueue.main.async {
                    self.collectionViewMyEvent.reloadData()
                }
            }
        }
    }
    

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        callMarketWishlistWebService{}
//
//
//    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnCreateMarketAction(_ sender: UIButton) {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMarketViewController") as? CreateMarketViewController else {return}
            self.navigationController?.pushViewController(vc, animated: true)
            print("Abdul Aleem Usmani")
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WishListListData?.wishlist?.count ?? 0
       
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItemCollectionViewCell", for: indexPath) as! MyItemCollectionViewCell
            
            cell.viewItems.layer.shadowColor = UIColor.gray.cgColor
            cell.viewItems.layer.shadowOpacity = 0.5
            cell.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewItems.layer.shadowRadius = 5
            cell.viewItems.layer.masksToBounds = false
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
            cell.EventLbl.text = WishListListData?.wishlist?[indexPath.row].pTitle
            if let priceString = WishListListData?.wishlist?[indexPath.row].salePrice,
               let price = Double(priceString) {
                if price == 0.0 {
                    cell.rsLbl.text = "Free"
                    cell.lblSellDonate.text = "GIVEN"
                } else {
                    cell.rsLbl.text = "Rs. \(Int(price))"
                    cell.lblSellDonate.text = "SOLD"
                }
                
            } else {
                cell.rsLbl.text = "Rs. 0"
            }
            
            cell.secttLbl.text = WishListListData?.wishlist?[indexPath.row].neighborhoodName
            if WishListListData?.wishlist?[indexPath.row].pStatus == 2 /*|| WishListListData?.wishlist?[indexPath.row].saleType == "Donate"*/{
                cell.lblSellDonate.isHidden = false
            } else {
                cell.lblSellDonate.isHidden = true
            }
            let url = URL(string: (WishListListData?.wishlist?[indexPath.row].pImages ?? ""))
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
            
            cell.DetailCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
               // vc.idD = (MarketWallData?.yourItems?[indexPath.row].id)!
                vc.idD = String(WishListListData?.wishlist?[indexPath.row].productID ?? 0)
             
                self.navigationController?.pushViewController(vc, animated: true)
                
                

            }
    //
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionViewMyEvent.frame.width / 2 - 5
       let height = width - 20
        return CGSize(width: width , height: height)
    
    }
    
    //dev.
    func callMarketWishlistWebService(completion: @escaping () -> Void) {
        
        guard let id = UserDefaults.standard.string(forKey: "userid"), !id.isEmpty else {
                print("Product ID is not available")
                return
            }
       // let idPr = UserDefaults.standard.string(forKey: "producttId")
        let url = "https://neighbrsnook.com/admin/api/wishlist/\(id)"

        
       
        // let dictParams: Dictionary<String, Any> = ["":""]
       
       
        let dictParams: Dictionary<String, Any> = ["":""]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(WishlistModel.self, from: result!)
                    self.WishListListData = data
                 //   UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "CrId")
                    self.collectionViewMyEvent.reloadData()
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.WishListListData = data // Your actual data fetching logic
                       // self.collectionViewMyEvent.reloadData()
                        DispatchQueue.main.async {
                            self.collectionViewMyEvent.reloadData()
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(WishlistModel.self, from: result!)
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

}
