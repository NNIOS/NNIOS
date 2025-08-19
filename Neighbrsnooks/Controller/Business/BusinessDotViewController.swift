//
//  BusinessDotViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 12/11/24.
//

import UIKit
@available(iOS 16.0, *)
class BusinessDotViewController: BottomPopupViewController {
    
    @IBOutlet weak var btnFavourite : UIButton!
    @IBOutlet weak var btnUnFavourite : UIButton!
    @IBOutlet weak var FvrtLbl: UILabel!
    @IBOutlet weak var DmLbl: UILabel!
    @IBOutlet weak var ShareLbl: UILabel!
    
    @IBOutlet weak var SendLbl: UILabel!
    @IBOutlet weak var removeLbl: UILabel!
    @IBOutlet weak var SharethisLbl: UILabel!
    @IBOutlet weak var viewHideDmDown: UIView!
    @IBOutlet weak var viewHideDM: UIView!
    @IBOutlet weak var viewDMHeight: NSLayoutConstraint!
    @IBOutlet weak var btnClick: UIButton!
    @IBOutlet weak var imgDM: UIImageView!
    @IBOutlet weak var lblBlock: CustomMontserratLabel!
    @IBOutlet weak var lblBlockThisUser: CustomMontserratLabel!
    @IBOutlet weak var imgBlock: UIImageView!
    @IBOutlet weak var blockViewHeightConst: NSLayoutConstraint!
    
    
    var createdBy: String?
    var onUpdateForBlock: (() -> Void)?
    var objBlockUserData : BlockUserModel?
    var isComingFromMenuBussinessVC:Bool = true
    var callback : ((_ range : String?) ->())?
    var BussinessFavouriteData : FavouriteBussinessModel?
    var BussinessRemoveFavouriteData : RemoveFavouriteBussiness?
    var BussinessDetailData : BusinessDetailModel?
    var business_id : String?
    var userID : String?
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var onUpdateForFav: (() -> Void)?
 
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
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        NetworkMonitor.shared.startMonitoring()
    //        checkUserID()
    //        self.FvrtLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
    //        self.DmLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
    //        self.ShareLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
    //        self.SendLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
    //        self.removeLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
    //        self.SharethisLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
    //        // Do any additional setup after loading the view.
    //    }
    //    deinit {
    //           // Stop monitoring when the view controller is deallocated
    //           NetworkMonitor.shared.stopMonitoring()
    //       }
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        //callProductListWebService{}
    //        // ✅ Recalculate height after UI updates
    //         self.height = self.calculateDynamicHeight()
    //        self.view.setNeedsLayout()
    //
    //        callBussinesDetailPostWebService{
    //
    //            if self.BussinessDetailData?.fastatus == "0" {
    //                self.btnUnFavourite.isHidden = true
    //                self.FvrtLbl.text = "Favourite"  // Set label title for "0"
    //
    //
    //            } else if self.BussinessDetailData?.fastatus == "1" {
    //
    //                self.btnFavourite.isHidden = true
    //                self.FvrtLbl.text = "Unfavourite"  // Set label title for "1"
    //
    //            }
    //
    //        }
    //
    //    }
    //
    //    override var popupHeight: CGFloat {
    //        return calculateDynamicHeight() // ✅ Dynamically set height
    //    }
    //
    //
    //    func checkUserID() {
    //        let savedUserID = UserDefaults.standard.string(forKey: "userid")
    //
    //        print("📌 Saved User ID: \(savedUserID ?? "nil")")
    //        print("📌 Post Created By: \(userID ?? "nil")")
    //
    //        if savedUserID == userID {
    //            print("✅ Same User ID - Hiding labels and images")
    //
    //            DmLbl.isHidden = true
    //            SendLbl.isHidden = true
    //            viewHideDmDown.isHidden = true
    //            viewHideDM.isHidden = true
    //            imgDM.isHidden = true
    //            btnClick.isHidden = true
    //            // ✅ Height 0 kar do jab hide ho
    //            viewDMHeight.constant = 0
    //
    //            lblBlock.isHidden = true
    //            lblBlockThisUser.isHidden = true
    //            blockViewHeightConst.constant = 0
    //
    //        } else {
    //            print("❌ Different User ID - Showing labels and images")
    //
    //            DmLbl.isHidden = false
    //            SendLbl.isHidden = false
    //            // ✅ Height wapas set kar do jab show ho
    //            viewDMHeight.constant = 44  // Jo bhi original height ho
    //
    //            lblBlock.isHidden = false
    //            lblBlockThisUser.isHidden = false
    //            blockViewHeightConst.constant = 45
    //
    //        }
    //
    //        // 🛠 Smooth animation ke liye layout update
    //        UIView.animate(withDuration: 0.3) {
    //            self.view.layoutIfNeeded()
    //        }
    //    }
    //
    //    func calculateDynamicHeight() -> CGFloat {
    //        var totalHeight: CGFloat = 0
    //
    //        // ✅ Check visible elements only
    //        if !DmLbl.isHidden { totalHeight += DmLbl.frame.height + 10 }
    //        if !SendLbl.isHidden { totalHeight += SendLbl.frame.height + 10 }
    //
    //        if !imgDM.isHidden { totalHeight += imgDM.frame.height + 10 }
    //
    //        if !lblBlock.isHidden { totalHeight += DmLbl.frame.height + 10 }
    //        if !lblBlockThisUser.isHidden { totalHeight += SendLbl.frame.height + 10 }
    //
    //        if !imgBlock.isHidden { totalHeight += imgDM.frame.height + 10 }
    //
    //
    //        // ✅ Ensure minimum height for UI to look good
    //        return max(totalHeight + 50, 180) // At least 200 height
    //    }
    //
    //    var navigateTobussinessCallback: (() -> Void)?
    //
    //       @IBAction func navigateButtonTapped(_ sender: UIButton) {
    //           // Trigger the navigation callback
    //           navigateTobussinessCallback?(
    //
    //
    //           )
    //           // Dismiss PostDotViewController
    //           self.dismiss(animated: true, completion: nil)
    //       }
    //
    //    @IBAction func btnFavourite(_ : UIButton){
    //
    //        callFavouriteBussinessWebService{
    //            self.showTemporaryAlert(message: "Added to favorite successfully")
    //        }
    //
    //       }
    //
    //
    //    @IBAction func btnUnFavourite(_ : UIButton){
    //
    //        callFavouriteRemoveBussinessWebService{
    //            self.showTemporaryAlert(message: "Removed to favorite successfully")
    //        }
    //
    //       }
    //
    //    @IBAction func shareTapped(sender: UIButton)
    //    {
    //        let appName = "Neighbrsnook"
    //                let appDescription = "Neighbrsnook is a hyperlocal social networking service connecting neighbours."
    //                let appLink = "https://testflight.apple.com/join/1G74jNEC"
    //
    //                let shareText = "\(appDescription) \nDownload now: \(appLink)"
    //
    //                // Step 2: Show share popup
    //                let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
    //
    //                // Step 3: Present the share popup
    //                present(activityViewController, animated: true, completion: nil)
    //    }
    //
    //
    //    @IBAction func btnBlockAction(_ sender: UIButton) {
    //        ConfirmBlock()
    //    }
    //
    //    func ConfirmBlock() {
    //            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
    //            let titleText =  "Block"
    //            let messageText = "Are you sure you want to block this user"
    //
    //            let titleColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .label
    //            let messageColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .secondaryLabel
    //            let attributedTitle = NSAttributedString(string: titleText, attributes: [ .foregroundColor: titleColor, .font: UIFont.boldSystemFont(ofSize: 17)])
    //            let attributedMessage = NSAttributedString(string: messageText, attributes: [.foregroundColor: messageColor, .font: UIFont.systemFont(ofSize: 15) ])
    //            alertController.setValue(attributedTitle, forKey: "attributedTitle")
    //            alertController.setValue(attributedMessage, forKey: "attributedMessage")
    //
    //            let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
    //                self.dismiss(animated: true,completion: {
    //                    self.handleBlockUnblockAPI(completion: {
    //                        self.dismiss(animated: true)
    //                    })
    //                })
    //            }
    //            confirmAction.setValue(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), forKey: "titleTextColor")
    //            let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] _ in
    //                guard let self = self else { return }
    //                self.dismiss(animated: true, completion: nil)
    //            }
    //            alertController.addAction(confirmAction)
    //            alertController.addAction(cancelAction)
    //            self.present(alertController, animated: true, completion: nil)
    //        }
    //
    //    func showTemporaryAlert(message: String) {
    //        // Create the alert controller
    //        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    //
    //        // Present the alert
    //        self.present(alertController, animated: true) {
    //            // Duration of 3 seconds before dismissing
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //                alertController.dismiss(animated: true, completion: nil)
    //            }
    //        }
    //    }
    //
    //    func callFavouriteBussinessWebService(_ completionClosure: @escaping () -> ()) {
    //        let id = UserDefaults.standard.string(forKey: "userid")
    //        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
    //        let idPost = UserDefaults.standard.string(forKey: "postid")
    //        let Newid = UserDefaults.standard.string(forKey: "useidProfile")
    //        let Busid = UserDefaults.standard.string(forKey: "Businessid")
    //        let Busimg = UserDefaults.standard.string(forKey: "Businessfirstimg")
    //        let dictParams: Dictionary<String, Any> = [
    //                                                  "userid":id ?? "" ,
    //                                                  "postid":business_id ?? "",
    //                                                  "type": "Business" ,
    //                                                  "neighbrhood":idNeighbour ?? "",
    //
    //        ]
    //          WebService.sharedInstance.callFavouriteBussinessWebService(withParams: dictParams) { data in
    //            self.BussinessFavouriteData = data
    //
    //
    //            completionClosure()
    //          }
    //        }
    //
    //    func callFavouriteRemoveBussinessWebService(_ completionClosure: @escaping () -> ()) {
    //        let id = UserDefaults.standard.string(forKey: "userid")
    //        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
    //        let idPost = UserDefaults.standard.string(forKey: "postid")
    //        let Newid = UserDefaults.standard.string(forKey: "useidProfile")
    //        let Busid = UserDefaults.standard.string(forKey: "Businessid")
    //        let Busimg = UserDefaults.standard.string(forKey: "Businessfirstimg")
    //        let dictParams: Dictionary<String, Any> = [
    //                                                  "userid":id ?? "" ,
    //                                                  "postid":business_id ?? "",
    //                                                  "type": "Business" ,
    //
    //
    //        ]
    //          WebService.sharedInstance.callFavouriteRemoveBussinessWebService(withParams: dictParams) { data in
    //            self.BussinessRemoveFavouriteData = data
    //
    //
    //            completionClosure()
    //          }
    //        }
    //
    //    func callBussinesDetailPostWebService(_ completionClosure: @escaping () -> ()) {
    //        let id = UserDefaults.standard.string(forKey: "userid")
    //        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
    //        let idPost = UserDefaults.standard.string(forKey: "postid")
    //        let Newid = UserDefaults.standard.string(forKey: "useidProfile")
    //        let Busid = UserDefaults.standard.string(forKey: "Businessid")
    //        let Busimg = UserDefaults.standard.string(forKey: "Businessfirstimg")
    //        let dictParams: Dictionary<String, Any> = [
    //                                                  "userid":id ?? "" ,
    //                                                  "business_id":business_id ?? "",]
    //          WebService.sharedInstance.callBussinesDetailPostWebService(withParams: dictParams) { data in
    //            self.BussinessDetailData = data
    //            //  UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
    //
    //            //  let url = URL(string: (imgData[indexPath.row].img ?? ""))
    //           //   UserDefaults.standard.set(self.imgData[IndexPath.row].postid, forKey: "postid")
    //              UserDefaults.standard.set(self.BussinessDetailData?.userid, forKey: "useidProfile")
    //              UserDefaults.standard.set(self.BussinessDetailData?.id, forKey: "Businessid")
    //              UserDefaults.standard.set(self.BussinessDetailData?.image?.first?.img, forKey: "Businessfirstimg")
    //             // UserDefaults.standard.set(self.PostListData?.em.id, forKey: "id")
    //             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
    //
    //            completionClosure()
    //          }
    //        }
    //
    //    // dev.
    //    func handleBlockUnblockAPI(completion: @escaping () -> Void) {
    //            let url = "https://neighbrsnook.com/admin/api/toggle-block-user"
    //            guard let blockerId = UserDefaults.standard.string(forKey: "userid") else {
    //                print("Error: Missing blocker ID")
    //                return
    //            }
    //
    //            guard let blockedId = userID else {
    //                print("Error: Missing blocked ID")
    //                return
    //            }
    //            let dictParams: [String: Any] = [
    //                "blocker_userid": blockerId,
    //                "blocked_userid": blockedId,
    //                "action": "block"
    //            ]
    //            print("Block dictParams :\(dictParams)")
    //            RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true) {
    //                (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
    //                switch statusCode {
    //                case .SUCCESS ,.CREATED:
    //                    do {
    //                        let data = try JSONDecoder().decode(BlockUserModel.self, from: result!)
    //                        self.objBlockUserData = data
    //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //                            if self.isComingFromMenuBussinessVC == false {
    //                                self.onUpdateForBlock!()
    //                                self.dismiss(animated: true)
    //                            } else if self.isComingFromMenuBussinessVC == true {
    //                                self.onUpdateForBlock!()
    //                                self.dismiss(animated: true)
    //                            }
    //                        }
    //                    } catch {
    //                        print(error.localizedDescription)
    //                    }
    //                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
    //                    do {
    //                        let data = try JSONDecoder().decode(BlockUserModel.self, from: result!)
    //                        self.objBlockUserData = data
    //                    } catch {
    //                        print(error.localizedDescription)
    //                    }
    //                case .UNAUTHORIZED:
    //                    print(error?.localizedDescription ?? "")
    //                default:
    //                    break
    //                }
    //            }
    //        }
    //
    // }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        checkUserID()
        self.FvrtLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.DmLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.ShareLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.SendLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.removeLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.SharethisLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        // Do any additional setup after loading the view.
    }
    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //callProductListWebService{}
        // ✅ Recalculate height after UI updates
        self.height = self.calculateDynamicHeight()
        self.view.setNeedsLayout()
        
        callBussinesDetailPostWebService{
            
            if self.BussinessDetailData?.fastatus == "0" {
                self.btnUnFavourite.isHidden = true
                self.FvrtLbl.text = "Favourite"  // Set label title for "0"
                
                
            } else if self.BussinessDetailData?.fastatus == "1" {
                
                self.btnFavourite.isHidden = true
                self.FvrtLbl.text = "Unfavourite"  // Set label title for "1"
                
            }
            
        }
        
    }
    
    override var popupHeight: CGFloat {
        return calculateDynamicHeight() // ✅ Dynamically set height
    }
    
    
    func checkUserID() {
        let savedUserID = UserDefaults.standard.string(forKey: "userid")
        
        print("📌 Saved User ID: \(savedUserID ?? "nil")")
        print("📌 Post Created By: \(userID ?? "nil")")
        
        if savedUserID == userID {
            print("✅ Same User ID - Hiding labels and images")
            
            DmLbl.isHidden = true
            SendLbl.isHidden = true
            viewHideDmDown.isHidden = true
            viewHideDM.isHidden = true
            imgDM.isHidden = true
            btnClick.isHidden = true
            // ✅ Height 0 kar do jab hide ho
            viewDMHeight.constant = 0
            
            lblBlock.isHidden = true
            lblBlockThisUser.isHidden = true
            blockViewHeightConst.constant = 0
            
        } else {
            print("❌ Different User ID - Showing labels and images")
            
            DmLbl.isHidden = false
            SendLbl.isHidden = false
            // ✅ Height wapas set kar do jab show ho
            viewDMHeight.constant = 44  // Jo bhi original height ho
            
            lblBlock.isHidden = false
            lblBlockThisUser.isHidden = false
            blockViewHeightConst.constant = 45
            
        }
        
        // 🛠 Smooth animation ke liye layout update
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func calculateDynamicHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        // ✅ Check visible elements only
        if !DmLbl.isHidden { totalHeight += DmLbl.frame.height + 10 }
        if !SendLbl.isHidden { totalHeight += SendLbl.frame.height + 10 }
        
        if !imgDM.isHidden { totalHeight += imgDM.frame.height + 10 }
        
        if !lblBlock.isHidden { totalHeight += DmLbl.frame.height + 10 }
        if !lblBlockThisUser.isHidden { totalHeight += SendLbl.frame.height + 10 }
        
        if !imgBlock.isHidden { totalHeight += imgDM.frame.height + 10 }
        return max(totalHeight + 50, 130)
    }
    
    var navigateTobussinessCallback: (() -> Void)?
    
    @IBAction func navigateButtonTapped(_ sender: UIButton) {
        // Trigger the navigation callback
        navigateTobussinessCallback?(
            
            
        )
        // Dismiss PostDotViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnFavourite(_ : UIButton){
        
        callFavouriteBussinessWebService{
            self.dismiss(animated: true)
        }
        
    }
    
    
    @IBAction func btnUnFavourite(_ : UIButton){
        
        callFavouriteRemoveBussinessWebService{
            self.onUpdateForFav?()
            self.dismiss(animated: true)
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
    
    
    @IBAction func btnBlockAction(_ sender: UIButton) {
        ConfirmBlock()
    }
    
    func ConfirmBlock() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let titleText =  "Block"
        let messageText = "Are you sure you want to block this user ?"
        
        let titleColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .label
        let messageColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .secondaryLabel
        let attributedTitle = NSAttributedString(string: titleText, attributes: [ .foregroundColor: titleColor, .font: UIFont.boldSystemFont(ofSize: 17)])
        let attributedMessage = NSAttributedString(string: messageText, attributes: [.foregroundColor: messageColor, .font: UIFont.systemFont(ofSize: 15) ])
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.dismiss(animated: true,completion: {
                self.handleBlockUnblockAPI(completion: {
                    self.dismiss(animated: true)
                })
            })
        }
        confirmAction.setValue(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
//    func showTemporaryAlert(message: String) {
//        // Create the alert controller
//        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        
//        // Present the alert
//        self.present(alertController, animated: true) {
//            // Duration of 3 seconds before dismissing
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                alertController.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
    func showTemporaryAlert(message: String) {
            // Create the alert controller
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            // Present the alert
            self.present(alertController, animated: true) {
                // Duration of 3 seconds before dismissing
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    alertController.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true,completion: {
                        self.onUpdateForFav!()
    //                    if self.isComingFromMenuPollVC == true {
    //                        self.onUpdateForFav!()
    //                    } else if self.isComingFromMenuPollVC == false {
    //                        self.onUpdateForFav!()
    //                    }
                    })
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
            "type": "Business" ,
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
            "type": "Business" ,
            
        ]
        WebService.sharedInstance.callFavouriteRemoveBussinessWebService(withParams: dictParams) { data in
            self.BussinessRemoveFavouriteData = data
            
            
            completionClosure()
        }
    }
    
    func callBussinesDetailPostWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let Newid = UserDefaults.standard.string(forKey: "useidProfile")
        let Busid = UserDefaults.standard.string(forKey: "Businessid")
        let Busimg = UserDefaults.standard.string(forKey: "Businessfirstimg")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "" ,
            "business_id":business_id ?? "",]
        WebService.sharedInstance.callBussinesDetailPostWebService(withParams: dictParams) { data in
            self.BussinessDetailData = data
            //  UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
            
            //  let url = URL(string: (imgData[indexPath.row].img ?? ""))
            //   UserDefaults.standard.set(self.imgData[IndexPath.row].postid, forKey: "postid")
            UserDefaults.standard.set(self.BussinessDetailData?.userid, forKey: "useidProfile")
            UserDefaults.standard.set(self.BussinessDetailData?.id, forKey: "Businessid")
            UserDefaults.standard.set(self.BussinessDetailData?.image?.first?.img, forKey: "Businessfirstimg")
            // UserDefaults.standard.set(self.PostListData?.em.id, forKey: "id")
            // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
            
            completionClosure()
        }
    }
    
    func handleBlockUnblockAPI(completion: @escaping () -> Void) {
        let url = "https://neighbrsnook.com/admin/api/toggle-block-user"
        guard let blockerId = UserDefaults.standard.string(forKey: "userid") else {
            print("Error: Missing blocker ID")
            return
        }
        
        guard let blockedId = userID else {
            print("Error: Missing blocked ID")
            return
        }
        let dictParams: [String: Any] = [
            "blocker_userid": blockerId,
            "blocked_userid": blockedId,
            "action": "block"
        ]
        print("Block dictParams :\(dictParams)")
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true) {
            (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                do {
                    let data = try JSONDecoder().decode(BlockUserModel.self, from: result!)
                    self.objBlockUserData = data
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if self.isComingFromMenuBussinessVC == false {
                            self.onUpdateForBlock!()
                            self.dismiss(animated: true)
                        } else if self.isComingFromMenuBussinessVC == true {
                            self.onUpdateForBlock!()
                            self.dismiss(animated: true)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(BlockUserModel.self, from: result!)
                    self.objBlockUserData = data
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription ?? "")
            default:
                break
            }
        }
    }
}
