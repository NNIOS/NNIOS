import UIKit

class MarketChatViewController: BaseViewC, UITextViewDelegate {
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var tvmessage: UITextView!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var viewItems: UIView!
    
    @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var viewMessageBottomConstraint: NSLayoutConstraint!

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
    let maxTextViewHeight: CGFloat = 200
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderLabel.text = "Type a message..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
        tvmessage.isScrollEnabled = false
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tvmessage.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        
        self.viewItems.layer.shadowColor = UIColor.gray.cgColor
        self.viewItems.layer.shadowOpacity = 0.5
        self.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewItems.layer.shadowRadius = 5
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTableView), userInfo: nil, repeats: true)
        //   tableviewMembers.transform = CGAffineTransform(scaleX: 1, y: -1) // Flip the table view
         tableviewMembers.reloadData()
        tableviewMembers.rowHeight = UITableView.automaticDimension
        tableviewMembers.estimatedRowHeight = 44
        tableviewMembers.register(UINib(nibName: "SentMessageCell", bundle: nil), forCellReuseIdentifier: "SentMessageCell")
        tableviewMembers.register(UINib(nibName: "ReceivedMessageCell", bundle: nil), forCellReuseIdentifier: "ReceivedMessageCell")
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //callProductListWebService{}
        
        lblHeading.text = userName
        callMarketChatWebService { [self] in
            if let imageUrlString = senderUserpic,
               !imageUrlString.isEmpty,
               let url = URL(string: imageUrlString) {
                profileImgView.kf.indicatorType = .activity
                profileImgView.kf.setImage(with: url, placeholder: generatePlaceholderImage(for: userName))
            } else {
                profileImgView.image = generatePlaceholderImage(for: userName)
            }
            
            self.tableviewMembers.reloadData()
            self.scrollToBottomWithoutAnimation()
        }
        startChatRefreshTimer()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height

            // Animate bottom constraint change
            UIView.animate(withDuration: 0.3) {
                self.viewMessageBottomConstraint.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }

            // Scroll to bottom
            self.scrollToBottom()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.viewMessageBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }

    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @objc func refreshTableView() {
        // Call reloadData to refresh the table view
        tableviewMembers.reloadData()
        self.scrollToBottomWithoutAnimation()
        //   scrollToBottom()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Show or hide placeholder label based on text view content
        placeholderLabel.isHidden = !textView.text.isEmpty
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if estimatedSize.height <= maxTextViewHeight {
            textView.isScrollEnabled = false
            messageViewHeight.constant = estimatedSize.height + 16  // Add padding
        } else {
            textView.isScrollEnabled = true
            messageViewHeight.constant = maxTextViewHeight
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
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
    
    
    
    @IBAction func SendBtn(_ sender: UIButton) {
        if tvmessage.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(message: "Please enter your message")
        }
        // 🔴 Bad word check
        else if containsBadWords(tvmessage.text ?? "") {
            showAlert(message: "Please remove inappropriate words from your message")
        }
        else {
            placeholderLabel.isHidden = true

            let messageText = tvmessage.text!
            tvmessage.text = ""

            callMarketChatPostWebService(message: messageText) { [self] in
                callMarketChatWebService {
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
    
    //dev.
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
                    self.scrollToBottomWithoutAnimation()
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

  
    
    //  "https://dev.neighbrsnook.com/admin/api/mpk_home_wall?" dev.
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
                    self.scrollToBottomWithoutAnimation()
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
    
    
    func scrollToBottomWithoutAnimation() {
        DispatchQueue.main.async {
            let sections = self.tableviewMembers.numberOfSections
            if sections > 0 {
                let rows = self.tableviewMembers.numberOfRows(inSection: sections - 1)
                if rows > 0 {
                    let indexPath = IndexPath(row: rows - 1, section: sections - 1)
                    self.tableviewMembers.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let messages = MarketChatData?.messages else {
            return UITableViewCell()
        }

        // Reverse index (for flipped table)
        let message = messages[indexPath.row]

        if message.sendertype == "sender" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as! SentMessageCell
            cell.lblMessage.text = message.message
            cell.lblTime.text = message.createdAts
             return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell", for: indexPath) as! ReceivedMessageCell
            cell.lblMessage.text = message.message
            cell.lblTime.text = message.createdAts
 
            // Optional: Set profile image
            if let urlStr = message.senderUserpic, let url = URL(string: urlStr) {
                cell.profileImageView.kf.setImage(with: url)
            } else {
                cell.profileImageView.image = UIImage(named: "defaultProfile")
            }

            return cell
        }
    }

    func generatePlaceholderImage(for name: String) -> UIImage {
        let letter = String(name.first ?? "U")
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        label.text = letter.uppercased()
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        UIGraphicsBeginImageContext(label.bounds.size)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage(named: "letter-b")!
    }

    
}
