import UIKit
@available(iOS 16.0, *)
class MyitemsMarketViewController: UIViewController {
    
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    
    var Newid: String?
    var sourceViewController: String?
    var MyitemsData: MyeventsMarketmodel?
    var MySearchitemsData: SearchItemModel?
    var AllListMarketData: AlllistMarketModel?
    
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
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callMarketMyItemsWebService()
        callSearchAllMarketListWebService()
        self.searchView.isHidden = true
    }
    
    @IBAction func btnSearch(_ : UIButton){
        self.searchView.isHidden = false
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
    //        return MyitemsData?.myProductList?.count ?? 0
                
                if sourceViewController == "OtherProfile" {
                    return MyitemsData?.myProductList?.count ?? 0
                } else if sourceViewController == "MyProfile" {
                    return MyitemsData?.myProductList?.count ?? 0
                } else {
                    return AllListMarketData?.producthomelist?.count ?? 0
                }
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
            
            cell.EventLbl.text = AllListMarketData?.producthomelist?[indexPath.row].pTitle
    //        cell.rsLbl.text = "Rs." + (AllListMarketData?.producthomelist?[indexPath.row].salePrice ?? "")
            if let priceString = AllListMarketData?.producthomelist?[indexPath.row].salePrice,
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
            
            if AllListMarketData?.producthomelist?[indexPath.row].pStatus == 2 /*|| AllListMarketData?.producthomelist?[indexPath.row].saleType == "Donate"*/ {
                cell.lblSellDonate.isHidden = false
            } else {
                cell.lblSellDonate.isHidden = true
            }
            
            cell.DayLbl.text = AllListMarketData?.producthomelist?[indexPath.row].createdTime
            let url = URL(string: (AllListMarketData?.producthomelist?[indexPath.row].pImages ?? ""))
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
            cell.secttLbl.text = AllListMarketData?.producthomelist?[indexPath.row].neighborhoodName
            cell.DetailCallback = { [self] value in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
                vc.idD = String(AllListMarketData?.producthomelist?[indexPath.row].id ?? 0)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionViewMyEvent.frame.width / 2 - 5
        let height = width - 20
        return CGSize(width: width , height: height)
    }
}

extension MyitemsMarketViewController {
    
    func callMarketMyItemsWebService() { //dev.
        let url = "https://neighbrsnook.com/admin/api/mpk_product_list?"
        let id = UserDefaults.standard.string(forKey: "userid")
        var dictParams: [String: Any] = [:]
        
        if sourceViewController == "MyProfile" {
            dictParams = [ "user_id": Newid ?? "" ]
        }
        else  if sourceViewController == "OtherProfile" {
            dictParams = [ "user_id": Newid ?? "" ]
        }
        
        RSNetworkManager.shared.newMarketRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                do {
                    let data = try JSONDecoder().decode(MyeventsMarketmodel.self, from: result!)
                    self.MyitemsData = data
                    self.collectionViewMyEvent.reloadData()
                    
                    //    completionClosure(data)
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(MyeventsMarketmodel.self, from: result!)
                    print(data)
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
    
    func callSearchAllMarketListWebService() { //dev.
        let url = "https://neighbrsnook.com/admin/api/mpk_product_home?"
        let id = UserDefaults.standard.string(forKey: "userid")
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
                    print(data)
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
}

extension MyitemsMarketViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !updatedText.isEmpty {
                self.tfSearch.text = updatedText
                self.callSearchAllMarketListWebService()
            }
        }
        return true
    }
}
