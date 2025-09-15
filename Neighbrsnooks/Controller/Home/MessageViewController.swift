//
//  MessageViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 02/05/24.
//

import UIKit
import SVProgressHUD
import Kingfisher
import IQKeyboardManager
import Alamofire
@available(iOS 16.0, *)
class MessageViewController: BaseViewC, UITextViewDelegate {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var MembersLbl: UILabel!
    @IBOutlet weak var tfSubject: UITextField!
    @IBOutlet weak var tvmessage: UITextView!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var MessageFullView: UIView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewMessageBottomConstraint: NSLayoutConstraint!

    
    
    var userName : String?
    var userImage :  String?
    var otherid : String?
    var DirectMessageData : DirectMessageModel?
    var ChatNewMessageData : ChatMessageModel?
    var senderUserpic = ""
    var id = ""
    var timer: Timer?
    var counter = 0
    var chatRefreshTimer: Timer?
    var ChatMessageData : MessageModel?
    var previousMessageCount = 0
    var tempMessageData: [ChatMessageData] = []
    var DirectMessageDelete : DeleteMessMDModel?
    let maxTextViewHeight: CGFloat = 150
    var deleteType:String?
    var messageId: Int?
    var messageTimer: Timer?
    
//    var ChatMessageData : MessageModel?
    var objDeleteDMeassgae: DeactivateModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMessage.layer.cornerRadius = 10
        viewMessage.clipsToBounds = true
        tableviewMembers.showsVerticalScrollIndicator = false
        MessageFullView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        
        if let imageUrl = userImage, let url = URL(string: imageUrl) {
            profileImgView.kf.setImage(with: url) // Use Kingfisher for async loading
        } else {
            profileImgView.image = UIImage(named: "placeholder") // Fallback image
        }
        placeholderLabel.text = "Type a message..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
        tvmessage.isScrollEnabled = false
        tableviewMembers.reloadData()
        tableviewMembers.rowHeight = UITableView.automaticDimension
        tableviewMembers.estimatedRowHeight = 44
        tableviewMembers.register(UINib(nibName: "SentMessageCell", bundle: nil), forCellReuseIdentifier: "SentMessageCell")
        tableviewMembers.register(UINib(nibName: "ReceivedMessageCell", bundle: nil), forCellReuseIdentifier: "ReceivedMessageCell")
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.tableviewMembers.addGestureRecognizer(longPressGesture)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MembersLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        NameLbl.text = userName
        
        // Image loading with priority to senderUserpic
        if !senderUserpic.isEmpty, let url = URL(string: senderUserpic) {
            profileImgView.kf.setImage(with: url)
            print("📸 Image loaded from senderUserpic")
        } else if let imageUrl = userImage, let url = URL(string: imageUrl) {
            profileImgView.kf.setImage(with: url)
            print("🖼️ Image loaded from userImage")
        } else {
            profileImgView.image = UIImage(named: "placeholder")
            print("❌ No image URL found, using placeholder")
        }

        // Style the image view
        profileImgView.layer.cornerRadius = profileImgView.frame.height / 2
        profileImgView.clipsToBounds = true
        callChatMessageListWebService {
            self.tableviewMembers.reloadData()
            self.previousMessageCount = self.ChatMessageData?.data?.count ?? 0
            self.scrollToBottom()
            self.scrollToBottomWithoutAnimation() // <- ADD THIS HERE
            
        }
        startChatRefreshTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        stopChatRefreshTimer()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollToBottom()
        }
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        chatRefreshTimer?.invalidate()
        chatRefreshTimer = nil
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
    
    
    // MARK: - Fixed Refresh Chat Method
    @objc func refreshChat() {
        callChatMessageListWebService { [weak self] in
            guard let self = self else { return }
            
            let oldCount = self.ChatMessageData?.data?.count ?? 0
            self.tempMessageData = self.ChatMessageData?.data ?? []
            let newCount = self.tempMessageData.count
            
            if newCount > oldCount {
                self.ChatMessageData?.data = self.tempMessageData
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                
                self.tableviewMembers.performBatchUpdates({
                    self.tableviewMembers.insertRows(at: indexPaths, with: .automatic)
                }, completion: { _ in
                    self.tableviewMembers.beginUpdates()
                    self.tableviewMembers.endUpdates()
                    self.scrollToBottom()
                })
            }
        }
    }
    
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        scrollToBottom()
    }

    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            MessageFullView.backgroundColor = .black
            viewMessage.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            viewMessage.layer.borderWidth = 1.0 // En
        } else {
            MessageFullView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
        }
    }
    
    @IBAction func btnProfile(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}
        vc.sourceViewController = "MessageViewController"
        vc.Newid = otherid // Pass the other user ID
        vc.headingTitle = "Profile" // Always set "Profile"
        vc.isFromMessage = true // 👈 Add this line
        if id == otherid {
            vc.sourceViewController = "MyProfile"
            vc.Oid = otherid
        } else {
            vc.sourceViewController = "OtherProfile"
            vc.Oid = otherid
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
   
    
    @IBAction func SendBtn(_ sender: UIButton) {
        // Validate message
        guard let messageText = tvmessage.text, !messageText.isEmpty else {
            showAlert(message: "Please enter your message")
            return
        }
        
        if containsBadWords(messageText) {
            showAlert(message: "Please remove inappropriate words from your message")
            return
        }
        
        // Disable button during send to prevent duplicate sends
        sender.isEnabled = false
        
        callUserChatMessageListWebService { [weak self] in
            guard let self = self else { return }
            
            // Reset previous count to ensure proper refresh
            self.previousMessageCount = 0
            
            self.callChatMessageListWebService {
                // Always perform UI updates on main thread
                DispatchQueue.main.async {
                    // Clear input field
                    self.tvmessage.text = ""
                    self.placeholderLabel.isHidden = false
                    self.messageViewHeight.constant = 50 // Full view height
                    self.view.layoutIfNeeded()
                    // Reload table and scroll to bottom
                    self.tableviewMembers.reloadData()
                    self.scrollToBottom()
                    
                    // Re-enable send button
                    sender.isEnabled = true
                    
                    // Force immediate layout update if needed
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    
  
    
    func showAlert(message: String) {
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let font = UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.darkGray
            ]
            
            let attributedTitle = NSAttributedString(string: title ?? "", attributes: titleAttributes)
            let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
}

@available(iOS 16.0, *)
extension MessageViewController: UITableViewDataSource, UITableViewDelegate{
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatMessageData?.data?.count ?? 0
    }
   
    func scrollToBottom() {
        let sections = self.tableviewMembers.numberOfSections
        if sections > 0 {
            let rows = self.tableviewMembers.numberOfRows(inSection: sections - 1)
            if rows > 0 {
                self.tableviewMembers.scrollToRow(
                    at: IndexPath(row: rows - 1, section: sections - 1),
                    at: .bottom,
                    animated: true
                )
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
        guard let message = ChatMessageData?.data?[indexPath.row] else {
            return UITableViewCell()
        }
        
        if message.type == "sender" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as! SentMessageCell
            cell.lblMessage.text = message.message
            cell.lblTime.text = message.dateTime
            cell.lblMessage.font = UIFont(name: "Montserrat-Regular", size: 16)
            cell.lblTime.font = UIFont(name: "Montserrat-SemiBold", size: 10)
            cell.lblMessage.textColor = .darkGray
            cell.lblMessage.layer.cornerRadius = 8
            cell.lblMessage.clipsToBounds = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell", for: indexPath) as! ReceivedMessageCell
            cell.lblMessage.text = message.message
            cell.lblTime.text = message.dateTime
            cell.lblMessage.font = UIFont(name: "Montserrat-Regular", size: 16)
            cell.lblTime.font = UIFont(name: "Montserrat-SemiBold", size: 10)
            //            profileImageView
            
            // ✅ Load user profile image using message.userPic
            if let imgUrlStr = message.userPic, let url = URL(string: imgUrlStr) {
                cell.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_profile"))
            } else {
                cell.profileImageView.image = UIImage(named: "placeholder_profile")
            }
            // Receiver message bubble color (light gray)
            //            cell.lblMessage.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)
            cell.lblMessage.textColor = .darkGray
            cell.lblMessage.layer.cornerRadius = 8
            cell.lblMessage.clipsToBounds = true
            
            return cell
        }
        
    }
    
    
    // MARK: - Web Service Call with Data Source Update
    func callChatMessageListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: Dictionary<String, Any> = [
            "fromuserid": id,
            "touserid": otherid ?? "",
            "owner": id
        ]
        
        WebService.sharedInstance.callChatMessageListWebService(withParams: dictParams) { [weak self] data in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let oldCount = self.ChatMessageData?.data?.count ?? 0
                let newCount = data.data?.count ?? 0
                
                self.ChatMessageData = data
                
                if newCount > oldCount {
                    let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                    
                    self.tableviewMembers.performBatchUpdates({
                        self.tableviewMembers.insertRows(at: indexPaths, with: .automatic)
                    }, completion: { success in
                        if success {
                            self.previousMessageCount = newCount
                            self.scrollToBottom()
                        } else {
                            self.tableviewMembers.reloadData()
                            self.previousMessageCount = newCount
                            self.scrollToBottomWithoutAnimation() // <- ADD THIS HERE

                        }
                    })
                } else {
                    // No new messages, just reload
                    self.tableviewMembers.reloadData()
                    self.previousMessageCount = newCount
                    self.scrollToBottomWithoutAnimation() // <- ADD THIS HERE

                }
                
                completionClosure()
            }
        }
    }
    
    
    
    
    func callUserChatMessageListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let dictParams: Dictionary<String, Any> = [
            "fromuserid":id ?? "",
            "touserid": otherid ?? "",
            "subject": "",
            "textmessage":self.tvmessage.text ?? "",
        ]
        
        WebService.sharedInstance.callUserChatMessageListWebService(withParams: dictParams) { data in
            self.ChatNewMessageData = data
            if self.ChatNewMessageData?.status == "success"{
                completionClosure()
            }else{
                self.showAlert(Message: self.ChatNewMessageData?.message ?? "")
            }
        }
    }
    
    
    func isMessageWithin5Minutes(_ message: ChatMessageData) -> Bool {
            guard let timeString = message.dateTime else { return false }

            if timeString.lowercased() == "now" {
                return true
            }

            if timeString.contains("m") {
                let minutesString = timeString.replacingOccurrences(of: "m", with: "").trimmingCharacters(in: .whitespaces)
                if let minutes = Int(minutesString), minutes <= 15 {
                    return true
                }
            }

            return false
        }



        
       
        
        func handleDeleteMsgApi(_ completionClosure: @escaping () -> ()) {
            let id = UserDefaults.standard.string(forKey: "userid")
            let senderId  = otherid
            var dictParams: [String: Any] = [:]
            if deleteType == "me" {
                if id == senderId {
                    dictParams = [
                        "userid": id ?? "",
                        "otherUserId": otherid ?? "",
                        "msg_id": messageId ?? 0,
                        "delete_type": "me"
                    ]
                } else if id != senderId {
                    dictParams = [
                        "userid": id ?? "",
                        "otherUserId": otherid ?? "",
                        "msg_id": messageId ?? 0,
                        "delete_type": "me"
                    ]
                }
            } else if deleteType == "everyone" {
                dictParams = [
                    "userid": id ?? "",
                    "otherUserId": senderId ?? "",
                    "msg_id": messageId ?? 0,
                    "delete_type": "everyone"
                ]
            }
            print("Param is :\(dictParams)")
            
            WebService.sharedInstance.callDeleteMeassaAPI(withParams: dictParams) { data in
                self.objDeleteDMeassgae = data
                if self.objDeleteDMeassgae?.status == "success"{
                    completionClosure()
                }else{
                    self.showAlert(Message: self.objDeleteDMeassgae?.message ?? "")
                }
            }
        }
        
        
      
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: tableviewMembers)
            if let indexPath = tableviewMembers.indexPathForRow(at: point) {

                // ✅ No reversedIndex, directly accessing message from indexPath.row
                guard let message = ChatMessageData?.data?[safe: indexPath.row],
                      let msgTimeString = message.dateTime else { return }

                // ✅ Receiver message → Only "Delete for me"
                if message.type == "sender" {
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Delete for me", style: .destructive, handler: { _ in
                        self.deleteType = "me"
                        self.messageId = message.msg_id
                        self.handleDeleteMsgApi {
                            self.callChatMessageListWebService {
                                self.tableviewMembers.reloadData()
                            }
                        }
                        self.startChatRefreshTimer()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                        self.startChatRefreshTimer()
                    }))
                    self.present(alert, animated: true)
                    return
                }

                // ✅ Sender message with time check
                chatRefreshTimer?.invalidate()
                chatRefreshTimer = nil

                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let minutes = extractMinutes(from: msgTimeString)

                if let min = minutes, min < 15 {
                    alert.addAction(UIAlertAction(title: "Delete for me", style: .destructive, handler: { _ in
                        self.deleteType = "me"
                        self.messageId = message.msg_id
                        self.handleDeleteMsgApi {
                            self.callChatMessageListWebService {
                                self.tableviewMembers.reloadData()
                            }
                        }
                        self.startChatRefreshTimer()
                    }))
                    alert.addAction(UIAlertAction(title: "Delete for everyone", style: .destructive, handler: { _ in
                        self.deleteType = "everyone"
                        self.messageId = message.msg_id
                        self.handleDeleteMsgApi {
                            self.callChatMessageListWebService {
                                self.tableviewMembers.reloadData()
                            }
                        }
                        self.startChatRefreshTimer()
                    }))
                } else {
                    alert.addAction(UIAlertAction(title: "Delete for me", style: .destructive, handler: { _ in
                        self.deleteType = "me"
                        self.messageId = message.msg_id
                        self.handleDeleteMsgApi {
                            self.callChatMessageListWebService {
                                self.tableviewMembers.reloadData()
                            }
                        }
                        self.startChatRefreshTimer()
                    }))
                }

                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    self.startChatRefreshTimer()
                }))
                self.present(alert, animated: true)
            }
        }
    }

    
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
                self.startChatRefreshTimer()
            }
        
        func startChatRefreshTimer() {
            chatRefreshTimer?.invalidate()
            chatRefreshTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(refreshChat), userInfo: nil, repeats: true)
        }
        
        func stopChatRefreshTimer() {
            chatRefreshTimer?.invalidate()
            chatRefreshTimer = nil
        }

    
    
}
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


func extractMinutes(from timeString: String) -> Int? {
    if timeString.lowercased() == "now" {
        return 0 // Treat "now" as 0 minutes (i.e. fresh message)
    } else if timeString.contains("m") {
        return Int(timeString.replacingOccurrences(of: "m", with: "").trimmingCharacters(in: .whitespaces))
    } else if timeString.contains("h") {
        let hours = Int(timeString.replacingOccurrences(of: "h", with: "").trimmingCharacters(in: .whitespaces)) ?? 0
        return hours * 60
    } else if timeString.contains("d") {
        let days = Int(timeString.replacingOccurrences(of: "d", with: "").trimmingCharacters(in: .whitespaces)) ?? 0
        return days * 24 * 60
    }
    return nil
}
