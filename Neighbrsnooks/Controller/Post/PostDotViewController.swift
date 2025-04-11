//
//  PostDotViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 24/10/24.
//

import UIKit

@available(iOS 16.0, *)
class PostDotViewController: BottomPopupViewController {
    
    @IBOutlet weak var btnFavourite : UIButton!
    @IBOutlet weak var btnUnFavourite : UIButton!
    @IBOutlet weak var btnDm: UIButton!
    @IBOutlet weak var btnSharePost: UIButton!
    @IBOutlet weak var btnDeletePost: UIButton!
    @IBOutlet weak var btnReportPost: UIButton!
    
    
    @IBOutlet weak var viewHideDmDown: UIView!
    @IBOutlet weak var viewDMHeight: NSLayoutConstraint!
    @IBOutlet weak var viewFavtHeight: NSLayoutConstraint!
    @IBOutlet weak var viewShareHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDeletePostHeight: NSLayoutConstraint!
    @IBOutlet weak var viewReportHeight: NSLayoutConstraint!
    @IBOutlet weak var shareDownView: NSLayoutConstraint!
    @IBOutlet weak var FvrtLbl: UILabel!
    @IBOutlet weak var removeLbl: UILabel!
    
    @IBOutlet weak var imgDM: UIImageView!
    @IBOutlet weak var lblDM: UILabel!
    @IBOutlet weak var lblSendDM: UILabel!
    @IBOutlet weak var lblSharePost: UILabel!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var lblShareThisPost: UILabel!
    @IBOutlet weak var lblDeletePost: UILabel!
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var lblDeleteThisPost: UILabel!
    @IBOutlet weak var lblReportThisPost: UILabel!
    @IBOutlet weak var lblReportPost: UILabel!
    @IBOutlet weak var imgReport: UIImageView!
    
    var createdBy: String?
    var userId: String?

    
    var postUserID: String?
    var DotCallback : ((UIButton) -> Void)?
    var callback : ((_ range : String?) ->())?
    var BussinessFavouriteData : FavouriteBussinessModel?
    var BussinessRemoveFavouriteData : RemoveFavouriteBussiness?
    var PollDetailData : PollDetailModel?
    var business_id : String?
    var poststs : Int?
    var height: CGFloat?
    var CommentPostListData : CommentPostModel?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var eventID : String?
    var UserName = ""
    var sectorName = ""
    var MonthName = ""
    var GeneralName = ""
    var DescriptionlName = ""
    var CommentName = ""
    var likeName = ""
    var postid = ""
    var emoji = ""
    var timer: Timer?
    var counter = 0
    var imgData = [PostImage]()
    var imgDataF = [PostImageF]()
    var PostidDe = [Postlistdatum]()
    var PostListData : PostListModel?
    var navigateToPollsCallback: (() -> Void)?
    var navigateToMDCallback: (() -> Void)?
    var navigateToDeleteCallback: (() -> Void)?
    var navigateToReportCallback: (() -> Void)?
    
    
    
    
    override var popupTopCornerRadius: CGFloat {
        return topCornerRadius ?? CGFloat(0) // Customize top corner radius
    }
    
    override var popupPresentDuration: Double {
        return presentDuration ?? 1.0 // Customize presentation duration
    }
    
    override var popupDismissDuration: Double {
        return dismissDuration ?? 1.0 // Customize dismissal duration
    }
    
    override var popupShouldDismissInteractivelty: Bool {
        return shouldDismissInteractivelty ?? true // Enable or disable interactive dismiss
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postUserID = createdBy
        checkUserID()
        self.FvrtLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblDM.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblSharePost.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblReportPost.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblDeletePost.font = UIFont(name: "Montserrat-Regular", size: 16)
        
        self.lblSendDM.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.removeLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.lblShareThisPost.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.lblReportThisPost.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.lblDeleteThisPost.font = UIFont(name: "Montserrat-Regular", size: 13)
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callPostCommenteWebService {
            if self.poststs == 0 {
                self.btnUnFavourite.isHidden = true
                self.FvrtLbl.text = "Favourite Post"
            } else if self.poststs == 1 {
                self.btnFavourite.isHidden = true
                self.FvrtLbl.text = "Unfavourite Post"
            }

            // ✅ Recalculate height after UI updates
             self.height = self.calculateDynamicHeight()
            self.view.setNeedsLayout()
        }
    }

    override var popupHeight: CGFloat {
        return calculateDynamicHeight() // ✅ Dynamically set height
    }

    
    @IBAction func btnDotPoll(_ sender: UIButton) {
        DotCallback?(sender)
    }
    
    func checkUserID() {
        let savedUserID = UserDefaults.standard.string(forKey: "userid")

        print("📌 Saved User ID: \(savedUserID ?? "nil")")
        print("📌 Post Created By: \(createdBy ?? "nil")")

        if savedUserID == createdBy {
            print("✅ Same User ID - Hiding labels and images")

            lblReportThisPost.isHidden = true
            lblReportPost.isHidden = true
            imgReport.isHidden = true
            imgDM.isHidden = true
            lblDM.isHidden = true
            lblSendDM.isHidden = true
            viewHideDmDown.isHidden = true
            
            // ✅ Height 0 kar do jab hide ho
            viewDMHeight.constant = 0
            viewReportHeight.constant = 0
        } else {
            print("❌ Different User ID - Showing labels and images")

            lblReportThisPost.isHidden = false
            lblReportPost.isHidden = false
            imgReport.isHidden = false
            imgDM.isHidden = false
            lblDM.isHidden = false
            lblSendDM.isHidden = false
            lblDeletePost.isHidden = true
            lblDeleteThisPost.isHidden = true
            imgDelete.isHidden = true
            btnDeletePost.isHidden = true

            // ✅ Height wapas set kar do jab show ho
            viewDMHeight.constant = 44  // Jo bhi original height ho
            viewReportHeight.constant = 44
             
        }

        // 🛠 Smooth animation ke liye layout update
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func calculateDynamicHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        
        // ✅ Check visible elements only
        if !lblReportThisPost.isHidden { totalHeight += lblReportThisPost.frame.height + 10 }
        if !lblReportPost.isHidden { totalHeight += lblReportPost.frame.height + 10 }
        if !imgReport.isHidden { totalHeight += imgReport.frame.height + 10 }
        if !imgDM.isHidden { totalHeight += imgDM.frame.height + 10 }
        if !lblDM.isHidden { totalHeight += lblDM.frame.height + 10 }
        if !lblSendDM.isHidden { totalHeight += lblSendDM.frame.height + 10 }
        if !lblDeletePost.isHidden { totalHeight += lblDeletePost.frame.height + 10 }
        if !lblDeleteThisPost.isHidden { totalHeight += lblDeleteThisPost.frame.height + 10 }
        if !imgDelete.isHidden { totalHeight += imgDelete.frame.height + 10 }
        if !btnDeletePost.isHidden { totalHeight += btnDeletePost.frame.height + 10 }

        // ✅ Ensure minimum height for UI to look good
        return max(totalHeight + 50, 200) // At least 200 height
    }

    

    
    
    @IBAction func navigateButtonTapped(_ sender: UIButton) {
        // Trigger the navigation callback
        navigateToPollsCallback?(
            
            
        )
        // Dismiss PostDotViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnFavourite(_ : UIButton){
        
        callFavouriteBussinessWebService{
            self.showTemporaryAlert(message: "Added to favorite successfully")
        }
        
    }
    
    @IBAction func actionDelete(_ : UIButton) {
        navigateToDeleteCallback?()
    }
    
    @IBAction func btnUnFavourite(_ : UIButton){
        
        callFavouriteRemoveBussinessWebService{
            self.showTemporaryAlert(message: "Removed to favorite successfully")
        }
        
    }
    
    @IBAction func shareTapped(sender: UIButton)
    {
        let appName = "Neighbrsnook"
        let appDescription = "Neighbrsnook is a hyperlocal social networking service connecting neighbours."
        let appLink = "https://testflight.apple.com/join/1G74jNEC"
        
        let shareText = "\(appDescription) \nDownload now: \(appLink)"
        
        // Step 2: Show share popup
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // Step 3: Present the share popup
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnReport(_ : UIButton){
        navigateToReportCallback?()
     }
    
    @IBAction func actionDirectMessage(_ sender: Any) {
        navigateToMDCallback?()
        print("Delete post")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
   
    
    func showTemporaryAlert(message: String) {
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // Present the alert
        self.present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alertController.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true)
            }
        }
    }
    
    func callFavouriteBussinessWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let Newid = UserDefaults.standard.string(forKey: "useidProfile")
        let Busid = UserDefaults.standard.string(forKey: "Businessid")
        let Busimg = UserDefaults.standard.string(forKey: "Businessfirstimg")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "" ,
            "postid":business_id ?? "",
            "type": "Post" ,
            "neighbrhood":idNeighbour ?? "",
        ]
        WebService.sharedInstance.callFavouriteBussinessWebService(withParams: dictParams) { data in
            self.BussinessFavouriteData = data
            
            
            completionClosure()
        }
    }
    
    func callFavouriteRemoveBussinessWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let Newid = UserDefaults.standard.string(forKey: "useidProfile")
        let Busid = UserDefaults.standard.string(forKey: "Businessid")
        let Busimg = UserDefaults.standard.string(forKey: "Businessfirstimg")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "" ,
            "postid":business_id ?? "",
            "type": "Post" ,
        ]
        WebService.sharedInstance.callFavouriteRemoveBussinessWebService(withParams: dictParams) { data in
            self.BussinessRemoveFavouriteData = data
            completionClosure()
        }
    }
    
    func callPostCommenteWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "postid": business_id ?? "",
            
        ]
        WebService.sharedInstance.callPostCommenteWebService(withParams: dictParams) { data in
            self.CommentPostListData = data
            completionClosure()
        }
    }
    
}
