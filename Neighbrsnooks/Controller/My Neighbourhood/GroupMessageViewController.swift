//
//  GroupMessageViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 07/06/24.
//

import UIKit
import Kingfisher

@available(iOS 16.0, *)
class GroupMessageViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var MembersLbl: UILabel!
    @IBOutlet weak var tfSubject: UITextField!
    @IBOutlet weak var tvmessage: UITextView!
   
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var MessageFullView: UIView!
    
    
    var userName : String?
    var userImage :  String?
    var groupid : String?
    var GroupName : String?
    var GroupChatData : GroupChatListModel?
    var GroupMessageData : GroupChatModel?
    var id = ""
    var timer: Timer?
        var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
        addShadowToMainView()

        placeholderLabel.text = "Type a message..."
               placeholderLabel.textColor = UIColor.lightGray
               placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
        tableviewMembers.transform = CGAffineTransform(scaleX: 1, y: -1) // Flip the table view
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTableView), userInfo: nil, repeats: true)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.MembersLbl.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.tfSubject.font = UIFont(name: "Montserrat-SemiBold", size: 13)
       // self.subjectLbl.font = UIFont(name: "Montserrat-SemiBold", size: 13)
        var data = GroupChatData?.data
        MembersLbl.text = GroupName
        
//        if let url = URL(string: senderUserpic) {
//            profileImgView.kf.setImage(with: url)
//        } else {
//            print("Invalid URL for senderUserpic")
//        }
       // SVProgressHUD.show()
        
        // Load the image
            if let imageUrl = userImage, let url = URL(string: imageUrl) {
                profileImgView.kf.setImage(with: url) // Use Kingfisher for async loading
            } else {
                profileImgView.image = UIImage(named: "groupImg") // Fallback image
              //  self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupimg"))
            }

       
     //   SVProgressHUD.show()
        
        
        callGroupChatListWebService{
         //   SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
        
     
    }
    
   
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            MessageFullView.backgroundColor = .black
            mainView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)

            
            mainView.layer.borderWidth = 1.0 // En
           
           
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          //  questionView.textColor = UIColor.secondaryLabel
          
            MessageFullView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            mainView.layer.borderWidth = 0 // En
            
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    func addShadowToMainView() {
            mainView.layer.shadowColor = UIColor.black.cgColor
            mainView.layer.shadowOpacity = 0.25
            mainView.layer.shadowOffset = CGSize(width: 0, height: 2)
            mainView.layer.shadowRadius = 4
            mainView.layer.masksToBounds = false
            mainView.layer.cornerRadius = 8 // Optional: Add rounded corners
        }
    
    
    func textViewDidChange(_ textView: UITextView) {
            // Show or hide placeholder label based on text view content
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    
    @objc func refreshTableView() {
            // Call reloadData to refresh the table view
        tableviewMembers.reloadData()
     //   scrollToBottom()
        }
    
    
   
    
    @IBAction func SendBtn(_ sender: UIButton){
        
//        tfSubject.text = ""
       
        
        if tvmessage.text == "" {
                showAlert(message: "Please enter your message")
            }
        else{
            callGroupMessageWebService{ [self] in
                callGroupChatListWebService{
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
extension GroupMessageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GroupChatData?.data.count ?? 0
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if let count = self.GroupChatData?.data.count, count > 0 {
                let indexPath = IndexPath(row: 0, section: 0) // Scroll to the first row (which is actually the last message)
                self.tableviewMembers.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageChatTableViewCell", for: indexPath) as! MessageChatTableViewCell

        let reversedIndex = (GroupChatData?.data.count ?? 0) - 1 - indexPath.row
        cell.lblMessage.text = GroupChatData?.data[reversedIndex].message
        cell.lblTime.text = GroupChatData?.data[reversedIndex].date

        cell.lblTime.font = UIFont(name: "Montserrat-Regular", size: 7)
        cell.lblMessage.font = UIFont(name: "Montserrat-Regular", size: 13)

        cell.lblMessage.numberOfLines = 0  // Allows multi-line messages

        // Calculate message width
        let maxWidth = tableView.frame.width * 0.7
        let messageSize = cell.lblMessage.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))

        let messageWidth = min(maxWidth, messageSize.width - 20)

        // Let Auto Layout determine the height dynamically (NO need for manual height adjustment)
        cell.viewNotification.setNeedsLayout()
        cell.viewNotification.layoutIfNeeded()
        // Flip the cell back to normal so text appears correctly
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)

        if GroupChatData?.data[reversedIndex].type == "receiver" {
            // Move ReciverImgView more towards leading
            cell.updateLeadingConstraint(newConstant: 40) // Closer to leading
            cell.updateTrailingConstraint(newConstant: tableView.frame.width - messageWidth - 70) // More padding
            
            // Increase padding for viewNotification
            cell.viewNotification.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

            cell.applyChatBubbleStyle(isSender: false)
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8901960784, blue: 0.8274509804, alpha: 1)

            if let userpicURLString = GroupChatData?.data[reversedIndex].userpic,
               let url = URL(string: userpicURLString) {
                cell.ReciverImgView.kf.indicatorType = .activity
                cell.ReciverImgView.kf.setImage(with: url, placeholder: UIImage(named: ""))
            } else {
                cell.ReciverImgView.image = UIImage(named: "")
            }
            cell.ReciverImgView.isHidden = false

        } else if GroupChatData?.data[reversedIndex].type == "sender" {
            let extraShift: CGFloat = 70  // Shift more left
            cell.updateLeadingConstraint(newConstant: tableView.frame.width - messageWidth - 70 - extraShift)
            cell.updateTrailingConstraint(newConstant: 5) // More padding on right

            // Increase padding for viewNotification
            cell.viewNotification.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

            cell.applyChatBubbleStyle(isSender: true)
            cell.viewNotification.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9294117647, blue: 0.7882352941, alpha: 1)

            cell.ReciverImgView.isHidden = true
        }

        return cell
    }


    
   


    
    func callGroupChatListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "groupid": groupid ?? "",
                                                    
                                                                        ]
          WebService.sharedInstance.callGroupChatListWebService(withParams: dictParams) { data in
            self.GroupChatData = data
              if self.GroupChatData?.status == "success"{
                  completionClosure()
              }else{
                  self.showAlert(Message: self.GroupChatData?.message ?? "")
              }
          }
        }
    
    func callGroupMessageWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "groupid": groupid ?? "",
                                                    
                                                    "message":self.tvmessage.text ?? "",
                                                                        ]
          WebService.sharedInstance.callGroupMessageWebService(withParams: dictParams) { data in
            self.GroupMessageData = data
             // UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
            //  UserDefaults.standard.set("\(self.MemberListData?.listdata.first?.id ?? 0)", forKey: "userid")
//              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")

              if self.GroupMessageData?.status == "success"{
                  completionClosure()
              }else{
                  self.showAlert(Message: self.GroupMessageData?.message ?? "")
              }
          }
        }
}
