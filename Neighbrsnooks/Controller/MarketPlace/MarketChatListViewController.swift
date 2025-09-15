//
//  MarketChatListViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 11/09/24.
//

import UIKit

class MarketChatListViewController: UIViewController {
    
   
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var tableviewMembers: UITableView!
    
    var MarketChatListData : MarketChatList?
    var Productid = ""
    var NewidD = ""
    var isFromChatList: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.text = "Chat List"
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //callProductListWebService{}
        callMarketChatListWebService{ [self] in
           
          
                self.tableviewMembers.reloadData()
                
               
        }
      
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    //dev.
    func callMarketChatListWebService(completion: @escaping () -> Void) {
       // let url = "https://dev.neighbrsnook.com/marketplace/api/seller-chat-list/"
        let baseURL = "https://neighbrsnook.com/admin/api/seller-chat-list/"
        let id = UserDefaults.standard.string(forKey: "userid")
        let Sid = UserDefaults.standard.string(forKey: "Senderid")
        // let dictParams: Dictionary<String, Any> = ["":""]
        let url = "\(baseURL)\(id ?? "")"
       // let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let dictParams: Dictionary<String, Any> = [
           // "":id ?? "",
            "p_id":NewidD ?? "",
            
            
        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(MarketChatList.self, from: result!)
                    self.MarketChatListData = data
                    UserDefaults.standard.set(self.MarketChatListData?.chats?.first?.senderID, forKey: "Senderid")
//                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
                    self.tableviewMembers.reloadData()
                   
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.MarketChatListData = data // Your actual data fetching logic
                        
                        DispatchQueue.main.async {
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

}

@available(iOS 16.0, *)
extension MarketChatListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MarketChatListData?.chats?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketChatListTableViewCell", for: indexPath) as! MarketChatListTableViewCell
       
        cell.lblName.text = MarketChatListData?.chats?[indexPath.row].senderName
        cell.lblSec.text = MarketChatListData?.chats?[indexPath.row].neighborhood
        
        cell.lblName.font = UIFont(name: "Montserrat-SemiBold", size: 17)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
        
      //  cell.profileImgView.image = UIImage(named: [indexPath.row]
        
        let url = URL(string: (MarketChatListData?.chats?[indexPath.row].senderUserpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketChatViewController")as! MarketChatViewController
        //  vc.userImage = DirectMessageData?.nbdata[indexPath.row].userpic
        
        vc.userName = (self.MarketChatListData?.chats?[indexPath.row].senderName)!
        vc.Sid = String(self.MarketChatListData?.chats?[indexPath.row].senderID ?? 0)
        UserDefaults.standard.set(vc.Sid, forKey: "SenderidN")
        let selectedChat = self.MarketChatListData?.chats?[indexPath.row]
        let senderId = String(selectedChat?.senderID ?? 0)
        let productId = String(selectedChat?.productID ?? 0)
        
        vc.userName = selectedChat?.senderName ?? ""
        vc.Sid = senderId
        vc.Productid = productId
        vc.senderUserpic = selectedChat?.senderUserpic
        // ✅ Save to UserDefaults for consistency
        UserDefaults.standard.set(senderId, forKey: "SenderidN")
        UserDefaults.standard.set(productId, forKey: "producttId")
        
        // ✅ First call API
        self.callMarketReadStatus2 {
            // ✅ Then push to next screen after API success
            //               self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        vc.Productid = String(self.MarketChatListData?.chats?[indexPath.row].productID ?? 0)
        
        //  vc.Productid = (self.MarketChatListData?.chats?[indexPath.row].productID)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func callMarketReadStatus2(completion: @escaping () -> Void) { //dev.
        let url = "https://neighbrsnook.com/admin/api/chat_read_status"
        
        let senderID = UserDefaults.standard.string(forKey: "SenderidN") ?? ""
        let receiverID = UserDefaults.standard.string(forKey: "userid") ?? ""
        let productID = UserDefaults.standard.string(forKey: "producttId") ?? ""

        let dictParams: [String: Any] = [
            "product_id": productID,
            "sender_id": senderID,
            "receiver_id": receiverID
        ]
        
        print("📩 Params (didSelect): \(dictParams)")
        
        RSNetworkManager.shared.newRequestApi(
            withServiceName: url,
            requestMethod: .PUT,
            requestParameters: dictParams,
            withProgressHUD: true
        ) { (result, error, errorType, statusCode) in
            switch statusCode {
            case .SUCCESS, .CREATED:
                print("🟢 Chat read updated from didSelect")
            default:
                print("❌ Chat read update failed")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    
    
}
