//
//  GroupThreeDotViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 20/01/25.
//

import UIKit

@available(iOS 16.0, *)
class GroupThreeDotViewController: BottomPopupViewController {
    
    @IBOutlet weak var btnFavourite : UIButton!
    @IBOutlet weak var btnUnFavourite : UIButton!
    @IBOutlet weak var ShareLbl: UILabel!
    @IBOutlet weak var FvrtLbl: UILabel!
    @IBOutlet weak var lblAddThisFavourite: UILabel!
    @IBOutlet weak var lblShareThisGroup: UILabel!
    var DotCallback : ((UIButton) -> Void)?
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
    
    var createdby: String?
    var onUpdateForBlock: (() -> Void)?
    var objBlockUserData : BlockUserModel?
    var onUpdateForFav: (() -> Void)?
    var isComingFromMenuBussinessVC:Bool = true
    
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
    var callback: ((_ range: Int) -> Void)?
    
    // Override popup configurations from BottomPopup
    override var popupHeight: CGFloat {
        return height ?? CGFloat(SCREEN_HEIGHT - 150) // Customize height
    }
    
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
        print("Received eventID: \(business_id ?? "Nil")")
        self.ShareLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.FvrtLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblAddThisFavourite.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.lblShareThisGroup.font = UIFont(name: "Montserrat-Regular", size: 13)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //callProductListWebService{}
        
        callPostCommenteWebService{
            
            if self.poststs == 0 {
                self.btnUnFavourite.isHidden = true
                self.FvrtLbl.text = "Favourite"  // Set label title for "0"
                
                
            } else if self.poststs == 1 {
                
                self.btnFavourite.isHidden = true
                self.FvrtLbl.text = "Unfavourite"  // Set label title for "1"
                
            }
            
        }
        
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
    
    
    
    // call api
    
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
    
    @IBAction func btnBlockAction(_ sender: UIButton) {
        ConfirmBlock()
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
    // dev.
    
    func handleBlockUnblockAPI(completion: @escaping () -> Void) {
        let url = "https://laravelpanel.neighbrsnook.com/api/toggle-block-user"
        guard let blockerId = UserDefaults.standard.string(forKey: "userid") else {
            print("Error: Missing blocker ID")
            return
        }
        
        guard let blockedId = createdby else {
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
                        self.onUpdateForBlock!()
                        self.dismiss(animated: true)
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
