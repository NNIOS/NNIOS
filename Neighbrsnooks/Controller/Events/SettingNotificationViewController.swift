//
//  SettingNotificationViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 03/09/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class SettingNotificationViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnPostMail: UIButton!
    @IBOutlet weak var btnPoll: UIButton!
    @IBOutlet weak var btnPollMail: UIButton!
    @IBOutlet weak var btnEvent: UIButton!
    @IBOutlet weak var btnEventMail: UIButton!
    @IBOutlet weak var btnGroups: UIButton!
    @IBOutlet weak var btnGroupsMail: UIButton!
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnBusinessMail: UIButton!
    @IBOutlet weak var btnDM: UIButton!
    @IBOutlet weak var btnDMMail: UIButton!
    @IBOutlet weak var lblActivity: UILabel!
    
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var pollLbl: UILabel!
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var MarketLbl: UILabel!
    
    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var BussinessLbl: UILabel!
    @IBOutlet weak var DmLbl: UILabel!
    @IBOutlet weak var NotificationLbl: UILabel!
    
    @IBOutlet weak var btnMarketPhone: UIButton!
    @IBOutlet weak var btnMarketMail: UIButton!
    @IBOutlet weak var SettingView: UIView!
    
    @IBOutlet weak var ActivitsView: UIView!
    @IBOutlet weak var PostView: UIView!
    @IBOutlet weak var PollView: UIView!
    @IBOutlet weak var EventView: UIView!
    @IBOutlet weak var GroupView: UIView!
    @IBOutlet weak var BusinessView: UIView!
    @IBOutlet weak var DMView: UIView!
    @IBOutlet weak var NotificationFullView: UIView!
   
    
    var UpdateNewNotificationsData : NewNotificationModel?
    var selectedButton: UIButton?
    var showConfirm = true
    var PostMail = true
    var pollPhone = true
    var pollMail = true
    var EventPhone = true
    var Eventmail = true
    var GroupPhone = true
    var Groupmail = true
    var BussiPhone = true
    var BussiMail = true
    var DMPhone = true
    var DMmail = true
    
    var MarketPhone = true
    var MarketMail = true
    
    var PostPhnShow = ""
    var PostMailShow = ""
    var PollPhnShow = ""
    var PollMailShow = ""

    var EventPhnShow = ""
    var EventMailMailShow = ""
    var GroupPhnShow = ""
    var GroupMailShow = ""
    
    var BussiPhnShow = ""
    var BussiMailMailShow = ""
    var DMPhnShow = ""
    var DMMailShow = ""
    
    var MarketPhnShow = ""
    var MarketMailShow = ""
    
    var isPostPhnShowChanged = false
       var isPostMailShowChanged = false
       var isPollPhnShowChanged = false
       var isPollMailShowChanged = false
       var isEventPhnShowChanged = false
       var isEventMailShowChanged = false
       var isDMPhnShowChanged = false
       var isDMMailShowChanged = false
       var isGroupPhnShowChanged = false
       var isGroupMailShowChanged = false
       var isBussiPhnShowChanged = false
       var isBussiMailMailShowChanged = false
    
    var isMarketPhnShowChanged = false
    var isMarketMailMailShowChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
        self.postLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.NotificationLbl.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.pollLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.groupLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.BussinessLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.DmLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.MarketLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        
        callNewNotificationWebService {
            self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
            self.lblActivity.font = UIFont(name: "Montserrat-Regular", size: 17)
            // Check if addresslinetwo exists
            self.updateRadioButtons()
        }

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callNewNotificationWebService {
            // Check if addresslinetwo exists
            self.updateRadioButtons()
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
           
            SettingView.backgroundColor = .black
            NotificationFullView.backgroundColor = .black
            ActivitsView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            PostView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            ActivitsView.layer.borderWidth = 1.0
            
            PollView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
            PostView.layer.borderWidth = 1.0
            
            EventView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            GroupView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            BusinessView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            DMView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            NotificationFullView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           // btnPost.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
           
            PollView.layer.borderWidth = 1.0
            EventView.layer.borderWidth = 1.0
            GroupView.layer.borderWidth = 1.0
            BusinessView.layer.borderWidth = 1.0
            DMView.layer.borderWidth = 1.0
            NotificationFullView.layer.borderWidth = 1.0
          //  btnPost.layer.borderWidth = 1.0
            NotificationLbl.textColor = .white
            lblActivity.textColor = .white
            btnPost.tintColor = .white
            btnPoll.tintColor = .white
            btnEvent.tintColor = .white
            btnGroups.tintColor = .white
            btnBusiness.tintColor = .white
            btnDM.tintColor = .white
            btnMarketPhone.tintColor = .white
            
            btnPostMail.tintColor = .white
            btnPollMail.tintColor = .white
            btnEventMail.tintColor = .white
            btnGroupsMail.tintColor = .white
            btnBusinessMail.tintColor = .white
            btnDMMail.tintColor = .white
            btnMarketMail.tintColor = .white
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          
            SettingView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            NotificationFullView.backgroundColor = .white
            NotificationLbl.textColor = UIColor.secondaryLabel
            lblActivity.textColor = UIColor.secondaryLabel
            NotificationFullView.layer.borderWidth = 0
            btnPost.tintColor = .black
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        SVProgressHUD.show()
        callUpdateNewNotificationWebService{
            SVProgressHUD.dismiss()
        }

   }
    
    func updateRadioButtons() {
        // Check and update the image for 'notificationForEventMB'
        if let emergencyContactno = self.UpdateNewNotificationsData?.commentOnYourPostsMB {
            if emergencyContactno == "1" {
                self.btnPost.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if emergencyContactno == "0" {
                self.btnPost.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        
       
        
        // Check and update the image for 'addresslineone'
        if let contactNo = self.UpdateNewNotificationsData?.commentpostmail {
            if contactNo == "1" {
                self.btnPostMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if contactNo == "0" {
                self.btnPostMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        
       
        
        if let addresslineone = self.UpdateNewNotificationsData?.pollForVoteMB {
            if addresslineone == "1" {
                self.btnPoll.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if addresslineone == "0" {
                self.btnPoll.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        
       
        if let addresslinetwo = self.UpdateNewNotificationsData?.pollvotemail {
            if addresslinetwo == "1" {
                self.btnPollMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if addresslinetwo == "0" {
                self.btnPollMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        
        if let notificationForEventMB = self.UpdateNewNotificationsData?.notificationForEventMB {
            if notificationForEventMB == "1" {
                self.btnEvent.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if notificationForEventMB == "0" {
                self.btnEvent.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        if let notificationeventmail = self.UpdateNewNotificationsData?.notificationeventmail {
            if notificationeventmail == "1" {
                self.btnEventMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if notificationeventmail == "0" {
                self.btnEventMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        if let newGroupMB = self.UpdateNewNotificationsData?.newGroupMB {
            if newGroupMB == "1" {
                self.btnGroups.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if newGroupMB == "0" {
                self.btnGroups.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        if let groupcreatemail = self.UpdateNewNotificationsData?.groupcreatemail {
            if groupcreatemail == "1" {
                self.btnGroupsMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if groupcreatemail == "0" {
                self.btnGroupsMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        if let ratingReviewsOnYourBusinessMB = self.UpdateNewNotificationsData?.ratingReviewsOnYourBusinessMB {
            if ratingReviewsOnYourBusinessMB == "1" {
                self.btnBusiness.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if ratingReviewsOnYourBusinessMB == "0" {
                self.btnBusiness.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        if let ratingCommentbusinessmail = self.UpdateNewNotificationsData?.ratingCommentbusinessmail {
            if ratingCommentbusinessmail == "1" {
                self.btnBusinessMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if ratingCommentbusinessmail == "0" {
                self.btnBusinessMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        if let directMessageMB = self.UpdateNewNotificationsData?.directMessageMB {
            if directMessageMB == "1" {
                self.btnDM.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if directMessageMB == "0" {
                self.btnDM.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        if let directmsgmail = self.UpdateNewNotificationsData?.directmsgmail {
            if directmsgmail == "1" {
                self.btnDMMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if directmsgmail == "0" {
                self.btnDMMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        
        if let SendMessageMarketMB = self.UpdateNewNotificationsData?.sendMessageMarketMB {
            if SendMessageMarketMB == "1" {
                self.btnMarketPhone.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if SendMessageMarketMB == "0" {
                self.btnMarketPhone.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
        if let SendMessageMarketEmail = self.UpdateNewNotificationsData?.sendMessageMarketEmail {
            if SendMessageMarketEmail == "1" {
                self.btnMarketMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            } else if SendMessageMarketEmail == "0" {
                self.btnMarketMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            }
        }
    }
    
    @IBAction func btnPostPhone(_ sender: UIButton) {
        
        if showConfirm {
               showConfirm = false
               btnPost.setImage(UIImage(named: "notificationsetting"), for: .normal)
               PostPhnShow = "1"
           } else {
               showConfirm = true
               btnPost.setImage(UIImage(named: "radio-blank"), for: .normal)
               PostPhnShow = "0"
           }

        isPostPhnShowChanged = true  // Mark this flag as true to indicate that this field has changed
    }
    
    @IBAction func btnPostmail(_ sender: UIButton) {
        
        if PostMail
        {
            PostMail = false
            btnPostMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            PostMailShow = "1"
        }
        else
        {
            PostMail = true
            btnPostMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            PostMailShow = "0"
        }
        isPostMailShowChanged = true
    }
    
    @IBAction func btnPollPhone(_ sender: UIButton) {
        
        if pollPhone
        {
            pollPhone = false
            btnPoll.setImage(UIImage(named: "notificationsetting"), for: .normal)
            PollPhnShow = "1"
        }
        else
        {
            pollPhone = true
            btnPoll.setImage(UIImage(named: "radio-blank"), for: .normal)
            PollPhnShow = "0"
            
        }
        isPollPhnShowChanged = true
    }
    
    @IBAction func btnPollMail(_ sender: UIButton) {
        
        if pollMail
        {
            pollMail = false
            btnPollMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            PollMailShow = "1"
        }
        else
        {
            pollMail = true
            btnPollMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            PollMailShow = "0"
            
        }
        isPollMailShowChanged = true
    }
    
    @IBAction func btnEventPhone(_ sender: UIButton) {
        
        if EventPhone
        {
            EventPhone = false
            btnEvent.setImage(UIImage(named: "notificationsetting"), for: .normal)
            EventPhnShow = "1"
        }
        else
        {
            EventPhone = true
            btnEvent.setImage(UIImage(named: "radio-blank"), for: .normal)
            EventPhnShow = "0"
            
        }
        isEventPhnShowChanged = true
    }
    
    
    @IBAction func btnEventMail(_ sender: UIButton) {
        
        if Eventmail
        {
            Eventmail = false
            btnEventMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            EventMailMailShow = "1"
        }
        else
        {
            Eventmail = true
            btnEventMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            EventMailMailShow = "0"
        }
        isEventMailShowChanged = true
    }
    
    @IBAction func btnGroupPhone(_ sender: UIButton) {
        
        if GroupPhone
        {
            GroupPhone = false
            btnGroups.setImage(UIImage(named: "notificationsetting"), for: .normal)
            GroupPhnShow = "1"
        }
        else
        {
            GroupPhone = true
            btnGroups.setImage(UIImage(named: "radio-blank"), for: .normal)
            GroupPhnShow = "0"
        }
        isGroupPhnShowChanged = true
    }
    
    @IBAction func btnGroupMail(_ sender: UIButton) {
        
        if Groupmail
        {
            Groupmail = false
            btnGroupsMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            GroupMailShow = "1"
        }
        else
        {
            Groupmail = true
            btnGroupsMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            GroupMailShow = "0"
        }
        isGroupMailShowChanged = true
    }
    
    @IBAction func btnBussiPhone(_ sender: UIButton) {
        
        if BussiPhone
        {
            BussiPhone = false
            btnBusiness.setImage(UIImage(named: "notificationsetting"), for: .normal)
            BussiPhnShow = "1"
        }
        else
        {
            BussiPhone = true
            btnBusiness.setImage(UIImage(named: "radio-blank"), for: .normal)
            BussiPhnShow = "0"
        }
        isBussiPhnShowChanged = true
    }
    
    @IBAction func btnBussiMail(_ sender: UIButton) {
        
        if BussiMail
        {
            BussiMail = false
            btnBusinessMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            BussiMailMailShow = "1"
        }
        else
        {
            BussiMail = true
            btnBusinessMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            BussiMailMailShow = "0"
        }
        isBussiMailMailShowChanged = true
    }
    
    @IBAction func btnDMPhone(_ sender: UIButton) {
        
        if DMPhone
        {
            DMPhone = false
            btnDM.setImage(UIImage(named: "notificationsetting"), for: .normal)
            DMPhnShow = "1"
        }
        else
        {
            DMPhone = true
            btnDM.setImage(UIImage(named: "radio-blank"), for: .normal)
            DMPhnShow = "0"
        }
        isDMPhnShowChanged = true
    }
    
    @IBAction func btnDMMail(_ sender: UIButton) {
        
        if DMmail
        {
            DMmail = false
            btnDMMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            DMMailShow = "1"
        }
        else
        {
            DMmail = true
            btnDMMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            DMMailShow = "0"
        }
        isDMMailShowChanged = true
    }
    
    
    @IBAction func btnMarketPhone(_ sender: UIButton) {
        
        if MarketPhone
        {
            MarketPhone = false
            btnMarketPhone.setImage(UIImage(named: "notificationsetting"), for: .normal)
            MarketPhnShow = "1"
        }
        else
        {
            MarketPhone = true
            btnMarketPhone.setImage(UIImage(named: "radio-blank"), for: .normal)
            MarketPhnShow = "0"
        }
        isMarketPhnShowChanged = true
    }
    
    @IBAction func btnMarketMail(_ sender: UIButton) {
        
        if MarketMail
        {
            MarketMail = false
            btnMarketMail.setImage(UIImage(named: "notificationsetting"), for: .normal)
            MarketMailShow = "1"
        }
        else
        {
            MarketMail = true
            btnMarketMail.setImage(UIImage(named: "radio-blank"), for: .normal)
            MarketMailShow = "0"
        }
        isMarketMailMailShowChanged = true
    }
    
    func callNewNotificationWebService(_ completionClosure: @escaping () -> ()) {
        // Set up the parameters for the API request
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? ""
        ]
        
        // Call the web service
        WebService.sharedInstance.callNewNotificationWebService(withParams: dictParams) { responseData in
            // If `responseData` is already of type `NewNotificationModel`, assign it directly
            if let notificationData = responseData as? NewNotificationModel {
                self.UpdateNewNotificationsData = notificationData
                print("Decoded data: \(self.UpdateNewNotificationsData)")
                
                // Call the completion handler to update the UI
                completionClosure()
            } else {
                print("Error: Could not cast responseData to NewNotificationModel")
            }
        }
    }
    
//    func callUpdateNewNotificationWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//
//        // Prepare all parameters with their current states
//        var dictParams: Dictionary<String, Any> = [
//            "userid": id ?? "",
//            "commentOnYourPostsMb": PostPhnShow,            // Post phone status
//            "commentpostmail": PostMailShow,                // Post mail status
//            "pollForVoteMb": PollPhnShow,                   // Poll phone status
//            "pollvotemail": PollMailShow,                   // Poll mail status
//            "notificationForEventMb": EventPhnShow,         // Event phone status
//            "notificationeventmail": EventMailMailShow,     // Event mail status
//            "directMessageMb": DMPhnShow,                   // Direct message phone status
//            "directmsgmail": DMMailShow,                    // Direct message mail status
//            "newGroupMb": GroupPhnShow,                     // Group phone status
//            "groupcreatemail": GroupMailShow,               // Group mail status
//            "rating_reviewsOnYourBusinessMb": BussiPhnShow, // Business phone status
//            "rating_commentbusinessmail": BussiMailMailShow // Business mail status
//        ]
//
//        // Make the API call with all parameters
//        WebService.sharedInstance.callNewNotificationWebService(withParams: dictParams) { responseData in
//            // Handle the response
//            if let notificationData = responseData as? NewNotificationModel {
//                self.UpdateNewNotificationsData = notificationData
//                print("Decoded data: \(self.UpdateNewNotificationsData)")
//                completionClosure()
//            } else {
//                print("Error: Could not cast responseData to NewNotificationModel")
//            }
//        }
//    }
    
    
    func callUpdateNewNotificationWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        var dictParams: Dictionary<String, Any> = [
            "userid": id ?? ""
        ]

        // Send the parameters that have been changed, but still include all
        if isPostPhnShowChanged {
            dictParams["commentOnYourPostsMb"] = PostPhnShow
        }

        if isPostMailShowChanged {
            dictParams["commentpostmail"] = PostMailShow
        }

        // Continue for other parameters and their change flags...
        if isPollPhnShowChanged {
            dictParams["pollForVoteMb"] = PollPhnShow
        }
        if isPollMailShowChanged {
            dictParams["pollvotemail"] = PollMailShow
        }
        if isEventPhnShowChanged {
            dictParams["notificationForEventMb"] = EventPhnShow
        }
        // Add the rest...
        
        // Continue for other parameters and their change flags...
        if isEventMailShowChanged {
            dictParams["notificationeventmail"] = EventMailMailShow
        }
        if isGroupPhnShowChanged {
            dictParams["newGroupMb"] = GroupPhnShow
        }
        if isGroupMailShowChanged {
            dictParams["groupcreatemail"] = GroupMailShow
        }
        //new
        if isBussiPhnShowChanged {
            dictParams["rating_reviewsOnYourBusinessMb"] = BussiPhnShow
        }
        // Add the rest...
        
        // Continue for other parameters and their change flags...
        if isBussiMailMailShowChanged {
            dictParams["rating_commentbusinessmail"] = BussiMailMailShow
        }
        if isDMPhnShowChanged {
            dictParams["directMessageMb"] = DMPhnShow
        }
        if isDMMailShowChanged {
            dictParams["directmsgmail"] = DMMailShow
        }
        
        if isMarketPhnShowChanged {
            dictParams["SendMessageMarketMB"] = MarketPhnShow
        }
        if isMarketMailMailShowChanged {
            dictParams["SendMessageMarketEmail"] = MarketMailShow
        }

        WebService.sharedInstance.callNewNotificationWebService(withParams: dictParams) { responseData in
            // Handle the response
            if let notificationData = responseData as? NewNotificationModel {
                self.UpdateNewNotificationsData = notificationData
                print("Decoded data: \(self.UpdateNewNotificationsData)")
                completionClosure()
            } else {
                print("Error: Could not cast responseData to NewNotificationModel")
            }
        }
    }



}
