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
    @IBOutlet weak var messMainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewMessageBottomConstraint: NSLayoutConstraint!

    var userName : String?
    var userImage :  String?
    var groupid : String?
    var GroupName : String?
    var GroupChatData : GroupChatListModel?
    var GroupMessageData : GroupChatModel?
    var id = ""
    var timer: Timer?
    var counter = 0
    let maxTextViewHeight: CGFloat = 150
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowToMainView()
        tableviewMembers.showsVerticalScrollIndicator = false
        placeholderLabel.text = "Type a message..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
        tvmessage.isScrollEnabled = false
        tableviewMembers.rowHeight = UITableView.automaticDimension
        tableviewMembers.estimatedRowHeight = 44
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTableView), userInfo: nil, repeats: true)
        tableviewMembers.register(UINib(nibName: "GroupMeTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupMeTableViewCell")
        tableviewMembers.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.MembersLbl.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.tfSubject.font = UIFont(name: "Montserrat-SemiBold", size: 13)
        // self.subjectLbl.font = UIFont(name: "Montserrat-SemiBold", size: 13)
        var data = GroupChatData?.data
        MembersLbl.text = GroupName
        // Load the image
        if let imageUrl = userImage, let url = URL(string: imageUrl) {
            profileImgView.kf.setImage(with: url) // Use Kingfisher for async loading
        } else {
            profileImgView.image = UIImage(named: "groupImg") // Fallback image
        }
        callGroupChatListWebService{
            //   SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            self.scrollToBottom()
            self.scrollToBottomWithoutAnimation()
            // Do any additional setup after loading the view.
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollToBottom()
        }
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            MessageFullView.backgroundColor = .black
            mainView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            mainView.layer.borderWidth = 1.0 // En
        } else {
            MessageFullView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            mainView.layer.borderWidth = 0 // En
            
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
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
        placeholderLabel.isHidden = !textView.text.isEmpty
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if estimatedSize.height <= maxTextViewHeight {
            textView.isScrollEnabled = false
            messMainViewHeight.constant = estimatedSize.height + 16  // Add padding
        } else {
            textView.isScrollEnabled = true
            messMainViewHeight.constant = maxTextViewHeight
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func refreshTableView() {
        callGroupChatListWebService {
            self.tableviewMembers.reloadData()
            self.scrollToBottomWithoutAnimation()
        }
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
            callGroupMessageWebService { [self] in
                callGroupChatListWebService {
                    tvmessage.text = ""
                    self.placeholderLabel.isHidden = false
                    
                    // 🔽 Reset height to default
                    self.messMainViewHeight.constant = 50 // Full view height
                    self.view.layoutIfNeeded()
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
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let section = 0
            let rowCount = self.tableviewMembers.numberOfRows(inSection: section)
            if rowCount > 0 {
                let indexPath = IndexPath(row: rowCount - 1, section: section)
                self.tableviewMembers.scrollToRow(at: indexPath, at: .bottom, animated: false)
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
        guard let message = GroupChatData?.data[indexPath.row] else {
            return UITableViewCell()
        }
        
        if message.type == "sender" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMeTableViewCell", for: indexPath) as! GroupMeTableViewCell
            cell.lblMessage.text = message.message
            cell.lblTime.text = message.date
            cell.lblMessage.font = UIFont(name: "Montserrat-Regular", size: 16)
            cell.lblTime.font = UIFont(name: "Montserrat-SemiBold", size: 10)
            cell.lblMessage.textColor = .darkGray
            cell.lblMessage.layer.cornerRadius = 8
            cell.lblMessage.clipsToBounds = true
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as! GroupTableViewCell
            cell.lblMessage.text = message.message
            cell.lblTime.text = message.date
            cell.lblMessage.font = UIFont(name: "Montserrat-Regular", size: 16)
            cell.lblTime.font = UIFont(name: "Montserrat-SemiBold", size: 10)
            // ✅ Load user profile image using message.userPic
            if let imgUrlStr = message.userpic, let url = URL(string: imgUrlStr) {
                cell.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_profile"))
            } else {
                cell.profileImageView.image = UIImage(named: "placeholder_profile")
            }
            cell.lblMessage.textColor = .darkGray
            cell.lblMessage.layer.cornerRadius = 8
            cell.lblMessage.clipsToBounds = true
            return cell
        }
        
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
            
            if self.GroupMessageData?.status == "success"{
                completionClosure()
            }else{
                self.showAlert(Message: self.GroupMessageData?.message ?? "")
            }
        }
    }
}
