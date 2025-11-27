//
//  SearchAllListViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 23/09/24.
//

import UIKit
@available(iOS 16.0, *)
class SearchAllListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    
    var AllListMarketData : AlllistMarketModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        collectionViewMyEvent.reloadData()
        collectionViewMyEvent.tag = 1
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.searchView.isHidden = false
        tfSearch.delegate = self
        self.collectionViewMyEvent.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callAllMarketListWebService()
        self.searchView.isHidden = false
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        tfSearch.becomeFirstResponder()  // Show keyboard when screen appears
       }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSearch(_ : UIButton){

        self.searchView.isHidden = false

       }
    @IBAction func btncancelSearch(_ : UIButton){

        self.searchView.isHidden = true

       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           // Capture the updated search text
           let currentText = textField.text ?? ""
           let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

           // Add a slight delay to throttle API calls
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
               // Only call the API if there is text in the search field
               if !updatedText.isEmpty {
                   self.tfSearch.text = updatedText
                   self.callAllMarketListWebService()
               }
           }

           return true
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AllListMarketData?.producthomelist?.count ?? 0
       
        
        
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
      //  cell.LargeImgView.image = imageArray[indexPath.row]
        
        cell.EventLbl.text = AllListMarketData?.producthomelist?[indexPath.row].pTitle
    //    self.lblImgLimit.text = "Max Images: " + (self.EventDetauilData?.eventImgRemainLimit ?? "")
        cell.rsLbl.text = "Rs." + (AllListMarketData?.producthomelist?[indexPath.row].salePrice ?? "")
       // cell.DayLbl.text = AllListMarketData?.producthomelist[indexPath.row].createdBy
        cell.DayLbl.text = AllListMarketData?.producthomelist?[indexPath.row].createdTime
        let url = URL(string: (AllListMarketData?.producthomelist?[indexPath.row].pImages ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
        
        cell.DetailCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
           // vc.idD = (MarketWallData?.yourItems?[indexPath.row].id)!
            vc.idD = String(AllListMarketData?.producthomelist?[indexPath.row].id ?? 0)
         
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
    func callAllMarketListWebService() {
                  let url = "https://laravelpanel.neighbrsnook.com/api/mpk_product_home?"

       // let dictParams: Dictionary<String, Any> = ["":""]
        
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "usercr")
          let dictParams: Dictionary<String, Any> = [
                                                    "user_id":id ?? "",
                                                    "search": self.tfSearch.text ?? ""
                                                   
                                                                        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
          switch statusCode {
          case .SUCCESS ,.CREATED:
          do {
              let data = try JSONDecoder().decode(AlllistMarketModel.self, from: result!)
            self.AllListMarketData = data
            self.collectionViewMyEvent.reloadData()
              
          //    completionClosure(data)
              } catch {
              print(error.localizedDescription)
              }
          case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
              do {
                  let data = try JSONDecoder().decode(AlllistMarketModel.self, from: result!)
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

//    else if collectionView == LatestCollectionViewWishList {
//      return MarketWallData?.wishlist?.count ?? 0
//  }
