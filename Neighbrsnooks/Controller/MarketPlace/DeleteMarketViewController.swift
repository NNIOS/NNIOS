//
//  DeleteMarketViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 16/09/24.
//

import UIKit

protocol ConfirmDeletemarket {
  func tapConfirm() -> Void
}

class DeleteMarketViewController: UIViewController {
    
    var delegate: ConfirmDeletemarket?
    var MarketWDeleteData : DelMarketProductModel?
    var MarketWDetailData : ProductResponse?
    var idD = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapDismiss(_ sender: UIButton) {
          self.dismiss(animated: true)
    }
    
    
    @IBAction func ExitYesBtn(_ sender: UIButton){
        
       
        callMarketDelWebService{
            self.delegate?.tapConfirm()
                self.dismiss(animated: true)
               
            }
        
        
      
    }
        //dev.
    
    func callMarketDelWebService(completion: @escaping () -> Void) {
        
        guard let idPr = UserDefaults.standard.string(forKey: "producttId"), !idPr.isEmpty else {
                print("Product ID is not available")
                return
            }
       // let idPr = UserDefaults.standard.string(forKey: "producttId")
        let url = "https://neighbrsnook.com/admin/api/mpk_product_add/edit/\(idPr)"

        
       
        // let dictParams: Dictionary<String, Any> = ["":""]
       
       
        let dictParams: Dictionary<String, Any> = ["":""]
        
//        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.DELETE,requestParameters: dictParams, withProgressHUD: true)
//        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            switch statusCode {
//            case .SUCCESS ,.CREATED:
//                
//                do {
//                    let data = try JSONDecoder().decode(DelMarketProductModel.self, from: result!)
//                    self.MarketWDeleteData = data
//                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "CrId")
//                   
//                    
//                    DispatchQueue.global().async {
//                        // Simulate network delay
//                        sleep(2)
//                        
//                        // Update MarketWDetailData with fetched data
//                        // Example data assignment
//                        self.MarketWDeleteData = data // Your actual data fetching logic
//                        
//                        DispatchQueue.main.async {
//                            completion() // Call completion handler
//                        }
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
//                do {
//                    let data = try JSONDecoder().decode(DelMarketProductModel.self, from: result!)
//                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .UNAUTHORIZED:
//                print(error?.localizedDescription)
//                //   self.showLogoutAlert()
//            default:
//                break
//            }
//        }
    }

}
