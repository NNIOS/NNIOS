//
//  AllCategoryilViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 18/09/24.
//

import UIKit
@available(iOS 16.0, *)
class AllCategoryilViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource  {

    var CatAllData : CatViewAllModel?
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        collectionViewMyEvent.reloadData()
        collectionViewMyEvent.tag = 1
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callMarketMyItemsWebService()
        
      
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CatAllData?.category?.count ?? 0
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItemCollectionViewCell", for: indexPath) as! MyItemCollectionViewCell
        
        cell.viewItems.layer.shadowColor = UIColor.gray.cgColor
        cell.viewItems.layer.shadowOpacity = 0.5
        cell.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewItems.layer.shadowRadius = 5
        cell.viewItems.layer.masksToBounds = false
        cell.EventLbl.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        cell.EventLbl.text = CatAllData?.category?[indexPath.row].catTitle
       
      //  cell.secttLbl.text = MarketWallData?.yourItems![indexPath.row].neighborhoodName
        let url = URL(string: (CatAllData?.category?[indexPath.row].catImage ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
       // cell.DayLbl.text = MarketWallData?.todayList![indexPath.row].updatedTime
        
        
        
        
        cell.DetailCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailViewController")as! CategoryDetailViewController
           // vc.idD = (MarketWallData?.yourItems?[indexPath.row].id)!
            vc.idD = String(CatAllData?.category?[indexPath.row].id ?? 0)
            vc.userName = self.CatAllData?.category?[indexPath.row].catTitle
         
            self.navigationController?.pushViewController(vc, animated: true)
           
        }
//
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionViewMyEvent.frame.width / 4 - 8
       let height = width + 20
        return CGSize(width: width , height: height)
    
    }
    
    //dev.
    func callMarketMyItemsWebService() {
                  let url = "https://dev.neighbrsnook.com/admin/api/category"

        let dictParams: Dictionary<String, Any> = ["":""]
        
//        let idName = UserDefaults.standard.string(forKey: "name")
//        let idEvent = UserDefaults.standard.string(forKey: "eventid")
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idCr = UserDefaults.standard.string(forKey: "usercr")
//          let dictParams: Dictionary<String, Any> = [
//                                                    "user_id":id ?? "",
//
//
//                                                                        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
          switch statusCode {
          case .SUCCESS ,.CREATED:
          do {
              let data = try JSONDecoder().decode(CatViewAllModel.self, from: result!)
            self.CatAllData = data
            self.collectionViewMyEvent.reloadData()
              
          //    completionClosure(data)
              } catch {
              print(error.localizedDescription)
              }
          case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
              do {
                  let data = try JSONDecoder().decode(CatViewAllModel.self, from: result!)
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
