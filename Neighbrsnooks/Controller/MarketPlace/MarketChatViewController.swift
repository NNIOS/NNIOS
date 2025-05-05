import UIKit

@available(iOS 16.0, *)
class MarketChatViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var tvmessage: UITextView!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var viewItems: UIView!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    var MarketChatData : MarketChatModel?
    var MarketChatPostData : CreateChatMarketModel?
    
    var NewidD = ""
    var userName = ""
    var Productid = ""
    var SenderidN = ""
    var chatRefreshTimer: Timer?
    var senderUserpic: String?
    var timer: Timer?
    var counter = 0
    var Sid = ""
    var isFromChatList: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderLabel.text = "Type a message..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tvmessage.font = UIFont(name: "Montserrat-Regular", size: 15)
        if let imageUrlString = senderUserpic, let url = URL(string: imageUrlString) {
            profileImgView.kf.indicatorType = .activity
            profileImgView.kf.setImage(with: url, placeholder: UIImage(named: ""))
        } else {
            profileImgView.image = UIImage(named: "") // Fallback image
        }
        
        self.viewItems.layer.shadowColor = UIColor.gray.cgColor
        self.viewItems.layer.shadowOpacity = 0.5
        self.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewItems.layer.shadowRadius = 5
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTableView), userInfo: nil, repeats: true)
        //   tableviewMembers.transform = CGAffineTransform(scaleX: 1, y: -1) // Flip the table view
        tableviewMembers.transform = CGAffineTransform(scaleX: 1, y: -1) // Flip the table view
        tableviewMembers.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //callProductListWebService{}
        
        lblHeading.text = userName
        callMarketChatWebService{ [self] in
            
            if let imageUrlString = senderUserpic, let url = URL(string: imageUrlString) {
                profileImgView.kf.indicatorType = .activity
                profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "letter-b"))
            } else {
                profileImgView.image = UIImage(named: "letter-b") // Fallback image
            }
            self.tableviewMembers.reloadData()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startChatRefreshTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopChatRefreshTimer()
    }
    
    // Timer start karne ka function
    func startChatRefreshTimer() {
        chatRefreshTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(refreshChat), userInfo: nil, repeats: true)
    }
    
    func stopChatRefreshTimer() {
        chatRefreshTimer?.invalidate()
        chatRefreshTimer = nil
    }
    
    // API call karne ka function jo timer se chalega
    @objc func refreshChat() {
        callMarketChatWebService {
            print("Chat refreshed")
        }
    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @objc func refreshTableView() {
        // Call reloadData to refresh the table view
        tableviewMembers.reloadData()
        //   scrollToBottom()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Show or hide placeholder label based on text view content
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func showNewAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )
        
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func SendBtn(_ sender: UIButton){
        
        if tvmessage.text == "" {
                showAlert(message: "Please enter your message")
            } else {
                placeholderLabel.isHidden = true // Placeholder hide karein

                let messageText = tvmessage.text! // Message store karein
                tvmessage.text = "" // Button press hote hi text clear karein
                
                callMarketChatPostWebService(message: messageText) { [self] in
                    callMarketChatWebService {
                        // API call ke baad additional actions

                        // Placeholder wapas dikhayein agar text field blank hai
                        DispatchQueue.main.async {
                            if tvmessage.text == "" {
                                placeholderLabel.isHidden = false
                            }
                        }
                    }
                }
            }
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 18, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
        )
        
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //  "https://dev.neighbrsnook.com/admin/api/mpk_home_wall?"
    
    func callMarketChatWebService(completion: @escaping () -> Void) {
        let baseURL = "https://dev.neighbrsnook.com/admin/api/messages/"
        let id = UserDefaults.standard.string(forKey: "userid")
        let Sid: String

        if isFromChatList {
            Sid = self.Sid ?? UserDefaults.standard.string(forKey: "SenderidN") ?? ""
        } else {
            Sid = UserDefaults.standard.string(forKey: "SenderidN") ?? ""
        }

        let url = "\(baseURL)\(id ?? "")/\(Sid)"

        let dictParams: [String: Any] = [
            "product_id": Productid ?? ""
        ]

        RSNetworkManager.shared.newRequestApi(withServiceName: url, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS, .CREATED:
                do {
                    let data = try JSONDecoder().decode(MarketChatModel.self, from: result!)
                    self.MarketChatData = data
                    UserDefaults.standard.set(self.MarketChatData?.messages?.first?.senderID, forKey: "Senderid")
                    self.tableviewMembers.reloadData()

                    DispatchQueue.global().async {
                        sleep(2)
                        self.MarketChatData = data
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
                } catch {
                    print(error.localizedDescription)
                }

            case .UNAUTHORIZED:
                print(error?.localizedDescription)

            default:
                break
            }
        }
    }

   // nichee
    
    
//    func callMarketChatWebService(completion: @escaping () -> Void) {
//
//        let baseURL = "https://dev.neighbrsnook.com/admin/api/messages/"
//           let id = UserDefaults.standard.string(forKey: "userid") ?? ""
//
//           // ✅ Condition: If Sid is passed from MarketChatListViewController, use it, otherwise fallback to UserDefaults
//           let senderId = self.Sid ?? UserDefaults.standard.string(forKey: "SenderidN") ?? ""
//
//           let url = "\(baseURL)\(id)/\(senderId)"
//           print("Final URL: \(url)")
//
//           let dictParams: [String: Any] = [
//               "product_id": Productid ?? ""
//           ]
//
//        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
//        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            switch statusCode {
//            case .SUCCESS ,.CREATED:
//
//                do {
//                    let data = try JSONDecoder().decode(MarketChatModel.self, from: result!)
//                    self.MarketChatData = data
//                    //                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
//                    UserDefaults.standard.set(self.MarketChatData?.messages?.first?.senderID, forKey: "Senderid")
//                    self.tableviewMembers.reloadData()
//
//
//                    DispatchQueue.global().async {
//                        // Simulate network delay
//                        sleep(2)
//
//                        // Update MarketWDetailData with fetched data
//                        // Example data assignment
//                        self.MarketChatData = data // Your actual data fetching logic
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
//                    let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
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
//    }
    
    
    //  "https://dev.neighbrsnook.com/admin/api/mpk_home_wall?"
    func callMarketChatPostWebService(message: String, completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/send-message"
        
        let id = UserDefaults.standard.string(forKey: "userid")
        let Sid = UserDefaults.standard.string(forKey: "SenderidN")
        
        let dictParams: [String: Any] = [
            "p_id": Productid ?? "",
            "sender_id": id ?? "",
            "receiver_id": Sid ?? "",
            "message": message // Yahan pe stored message bhej rahe hain
        ]
        
        RSNetworkManager.shared.newRequestApi(
            withServiceName: url,
            requestMethod: .POST,
            requestParameters: dictParams,
            withProgressHUD: true
        ) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS, .CREATED:
                guard let resultData = result else {
                    print("Error: API response data is nil")
                    return
                }
                do {
                    let data = try JSONDecoder().decode(CreateChatMarketModel.self, from: resultData)
                    self.MarketChatPostData = data
                    self.tableviewMembers.reloadData()
                } catch {
                    print("Decoding Error:", error.localizedDescription)
                }
            default:
                print("Unhandled status code:", statusCode)
            }
            completion() // API response milne ke baad completion block call karna na bhoolein
        }
    }
}


@available(iOS 16.0, *)
extension MarketChatViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MarketChatData?.messages?.count ?? 0
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if let count = self.MarketChatData?.messages?.count, count > 0 {
                let indexPath = IndexPath(row: 0, section: 0) // Scroll to the first row (which is actually the last message)
                self.tableviewMembers.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketChatTableViewCell", for: indexPath) as! MarketChatTableViewCell
        
        let reversedIndex = (MarketChatData?.messages?.count ?? 0) - 1 - indexPath.row
       
        cell.lblMessage.text = MarketChatData?.messages?[reversedIndex].message
        cell.lblTime.text = MarketChatData?.messages?[reversedIndex].createdAts
        
        cell.lblMessage.font = UIFont(name: "Montserrat-Regular", size: 14)
        

        
        
        cell.lblTime.font = UIFont(name: "Montserrat-Regular", size: 9)
        
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        cell.lblMessage.numberOfLines = 0  // Allows multi-line messages
        
       

        // Set preferred max width (adjusted for padding)
        cell.lblMessage.preferredMaxLayoutWidth = tableView.frame.width * 0.9

        cell.viewNotification.setNeedsLayout()
        cell.viewNotification.layoutIfNeeded()
        
        
        


        // Calculate message width
        let maxWidth = tableView.frame.width * 0.7
        let messageSize = cell.lblMessage.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))

        let messageWidth = min(maxWidth, messageSize.width - 20)

        // Let Auto Layout determine the height dynamically (NO need for manual height adjustment)
        cell.viewNotification.setNeedsLayout()
        cell.viewNotification.layoutIfNeeded()
        
       
        if MarketChatData?.messages![reversedIndex].sendertype == "receiver" {
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
          
         //  cell.viewNotification.frame.origin.x = 5
            cell.updateLeadingConstraint(newConstant: 10)
            cell.updateTrailingConstraint(newConstant: tableView.frame.width - messageWidth - 30)
            cell.applyChatBubbleStyle(isSender: false)
          
            
        }
        if MarketChatData?.messages![reversedIndex].sendertype == "sender" {
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9294117647, blue: 0.7882352941, alpha: 1)
            let extraShift: CGFloat = 20  // Adjust this value to shift more left
            cell.updateLeadingConstraint(newConstant: tableView.frame.width - messageWidth - 30 - extraShift)
            cell.updateTrailingConstraint(newConstant: 0)
            cell.applyChatBubbleStyle(isSender: true)
        }

       
        return cell
    }
   
    
    
}
