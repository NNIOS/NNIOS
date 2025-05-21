//
//  MessageViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 02/05/24.
//

import UIKit
import SVProgressHUD
import Kingfisher
@available(iOS 16.0, *)
class MessageViewController: BaseViewController, UITextViewDelegate {
    
    
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
    @IBOutlet weak var tvmessageHeightConstraint: NSLayoutConstraint!
    

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
        if let imageUrl = userImage, let url = URL(string: imageUrl) {
            profileImgView.kf.setImage(with: url) // Use Kingfisher for async loading
        } else {
            profileImgView.image = UIImage(named: "placeholder") // Fallback image
        }
        placeholderLabel.text = "Type a message..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTableView), userInfo: nil, repeats: true)
        tableviewMembers.transform = CGAffineTransform(scaleX: 1, y: -1) // Flip the table view
        tableviewMembers.reloadData()
       // addShadowToView(view: viewMessage)
//        tableviewMembers.rowHeight = UITableView.automaticDimension
//        tableviewMembers.estimatedRowHeight = 350  // Provide a reasonable estimate
        
       
        
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        startChatRefreshTimer()
//    }
    
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
        callChatMessageListWebService {
            print("Chat refreshed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
       // self.tfSubject.font = UIFont(name: "Montserrat-SemiBold", size: 13)
//self.subjectLbl.font = UIFont(name: "Montserrat-SemiBold", size: 13)
        var data = DirectMessageData?.nbdata
        
     //   profileImgView. = userImage
      //  ChatMessageData?.nbdata[indexPath.row].message
        
        NameLbl.text = userName
        if let url = URL(string: senderUserpic) {
            profileImgView.kf.setImage(with: url)
        } else {
            print("Invalid URL for senderUserpic")
        }
       // SVProgressHUD.show()
        
        // Load the image
            if let imageUrl = userImage, let url = URL(string: imageUrl) {
                profileImgView.kf.setImage(with: url) // Use Kingfisher for async loading
            } else {
                profileImgView.image = UIImage(named: "placeholder") // Fallback image
            }

            // Optional: Style the image view
            profileImgView.layer.cornerRadius = profileImgView.frame.height / 2
            profileImgView.clipsToBounds = true
        
        callChatMessageListWebService{
           // SVProgressHUD.dismiss()
//            let url = URL(string: (self.ChatMessageData?.nbdata.first?.userpic ?? ""))
//            self.profileImgView.kf.indicatorType = .activity
//           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "letter-b"))
//
            self.tableviewMembers.reloadData()
            
           
        }
        
     
    }
    
    func addShadowToView(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor // Shadow color
        view.layer.shadowOffset = CGSize(width: 0, height: 4) // Shadow offset (horizontal, vertical)
        view.layer.shadowRadius = 6 // Shadow blur radius
        view.layer.shadowOpacity = 0.3 // Shadow opacity (0.0 to 1.0)
        
        // Optional: Set corner radius if you want rounded corners
        view.layer.cornerRadius = 10
        
        // Optional: Set masksToBounds to false to allow shadow to extend beyond view's bounds
        view.layer.masksToBounds = false
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        let fixedWidth = textView.frame.size.width
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//
//        let maxHeight: CGFloat = 120
//        tvmessage.isScrollEnabled = newSize.height > maxHeight
//        tvmessageHeightConstraint.constant = min(newSize.height, maxHeight)
//
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
//    }

    
    func textViewDidChange(_ textView: UITextView) {
        // Show or hide placeholder
        placeholderLabel.isHidden = !textView.text.isEmpty

        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        let minHeight: CGFloat = 50   // 📏 default height
        let maxHeight: CGFloat = 120  // 📏 max expandable height

        // Calculate final height between 60 and 120
        var finalHeight = newSize.height
        if finalHeight < minHeight {
            finalHeight = minHeight
        } else if finalHeight > maxHeight {
            finalHeight = maxHeight
        }

        // Set scroll only if exceeding max height
        tvmessage.isScrollEnabled = newSize.height > maxHeight

        // Update height constraint
        tvmessageHeightConstraint.constant = finalHeight

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    
    @objc func refreshTableView() {
            // Call reloadData to refresh the table view
        tableviewMembers.reloadData()
     //   scrollToBottom()
        }
    
//    @objc func updateUI() {
//           // Update your UI here
//           counter += 1
//           DispatchQueue.main.async {
//               cell.lblMessage.text = "Counter: \(self.counter)"
//               // Update other UI elements as needed
//           }
//       }
    
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
        startChatRefreshTimer()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            MessageFullView.backgroundColor = .black
            viewMessage.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)

            
            viewMessage.layer.borderWidth = 1.0 // En
           
           
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          //  questionView.textColor = UIColor.secondaryLabel
          
            MessageFullView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    @IBAction func btnProfile(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}
        
        vc.sourceViewController = "MessageViewController"
        vc.Newid = otherid // Pass the other user ID
        vc.headingTitle = "Profile" // Always set "Profile"
        vc.isFromMessage = true // 👈 Add this line

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func SendBtn(_ sender: UIButton){
 
        
       
        
        if tvmessage.text == "" {
                showAlert(message: "Please enter your message")
            }

        else{
            callUserChatMessageListWebService{ [self] in
                callChatMessageListWebService{
                    tvmessage.text = ""
                    self.placeholderLabel.isHidden = false
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
}

@available(iOS 16.0, *)
extension MessageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ChatMessageData?.nbdata.count ?? 0
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if let count = self.ChatMessageData?.nbdata.count, count > 0 {
                let indexPath = IndexPath(row: 0, section: 0) // Scroll to the first row (which is actually the last message)
                self.tableviewMembers.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }

  
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageChatTableViewCell", for: indexPath) as! MessageChatTableViewCell
        
        let reversedIndex = (ChatMessageData?.nbdata.count ?? 0) - 1 - indexPath.row

        // Set message and time
        
        
        cell.lblMessage.text = ChatMessageData?.nbdata[reversedIndex].message
        cell.lblTime.text = ChatMessageData?.nbdata[reversedIndex].dttime
        

        cell.transform = CGAffineTransform(scaleX: 1, y: -1)  // Flip the cell

        // Set fonts
        cell.lblTime.font = UIFont(name: "Montserrat-SemiBold", size: 7)
        cell.lblMessage.font = UIFont(name: "Montserrat-Regular", size: 13)

        cell.lblMessage.numberOfLines = 0  // Allows multi-line messages
        
       


        // Set preferred max width (adjusted for padding)
        cell.lblMessage.preferredMaxLayoutWidth = tableView.frame.width * 0.9

        cell.viewNotification.setNeedsLayout()
        cell.viewNotification.layoutIfNeeded()
        
        let messageText = ChatMessageData?.nbdata[reversedIndex].message ?? ""
        let wordCount = messageText.split(separator: " ").count

        // Calculate message width
        let maxWidth = tableView.frame.width * 0.7
        let messageSize = cell.lblMessage.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))

        let messageWidth = min(maxWidth, messageSize.width - 20)

        // Let Auto Layout determine the height dynamically (NO need for manual height adjustment)
        cell.viewNotification.setNeedsLayout()
        cell.viewNotification.layoutIfNeeded()


      
        if ChatMessageData?.nbdata[reversedIndex].type == "receiver" {
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8901960784, blue: 0.8274509804, alpha: 1)

            // Align to left (Receiver)
            cell.updateLeadingConstraint(newConstant: 10)
            cell.updateTrailingConstraint(newConstant: tableView.frame.width - messageWidth - 30)
            cell.applyChatBubbleStyle(isSender: false)

        } else { // Sender
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9294117647, blue: 0.7882352941, alpha: 1)

            // ✅ Shift sender bubble more left by increasing leading constraint
            let extraShift: CGFloat = 50  // Adjust this value to shift more left
            cell.updateLeadingConstraint(newConstant: tableView.frame.width - messageWidth - 50 - extraShift)
            cell.updateTrailingConstraint(newConstant: 0)
            cell.applyChatBubbleStyle(isSender: true)
        }


        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let reversedIndex = (ChatMessageData?.nbdata.count ?? 0) - 1 - indexPath.row
        let messageText = ChatMessageData?.nbdata[reversedIndex].message ?? ""
        let wordCount = messageText.split(separator: " ").count

        if wordCount > 20 {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }


    
    func callChatMessageListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
                                                    "fromuserid":id ?? "",
                                                    "touserid": otherid ?? "",
                                                    "owner":id ?? "",
                                                                        ]
          WebService.sharedInstance.callChatMessageListWebService(withParams: dictParams) { data in
            self.ChatMessageData = data
            

            completionClosure()
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
}
