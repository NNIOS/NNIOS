//
//  PollDotViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 24/10/24.
//

import UIKit

@available(iOS 16.0, *)
class PollDotViewController: BottomPopupViewController {
    
    @IBOutlet weak var btnFavourite : UIButton!
    @IBOutlet weak var btnUnFavourite : UIButton!
    @IBOutlet weak var FvrtLbl: UILabel!
    @IBOutlet weak var DmLbl: UILabel!
    @IBOutlet weak var ShareLbl: UILabel!
    
    @IBOutlet weak var SendLbl: UILabel!
    @IBOutlet weak var removeLbl: UILabel!
    @IBOutlet weak var SharethisLbl: UILabel!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var blockViewHeightConst: NSLayoutConstraint!
    var createdBy: String?
    var userId: String??
    var callback : ((_ range : String?) ->())?
    var BussinessFavouriteData : FavouriteBussinessModel?
    var BussinessRemoveFavouriteData : RemoveFavouriteBussiness?
    var PollDetailData : PollDetailModel?
    var objBlockUserData : BlockUserModel?
    var business_id : String?
    var height: CGFloat?
    var onUpdateForBlock: (() -> Void)?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var isComingFromMenuPollVC:Bool = true
    var onUpdateForFav: (() -> Void)?
    
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
        self.FvrtLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.ShareLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.removeLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.SharethisLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.userId = UserDefaults.standard.string(forKey: "userid")
        print("User Id is : \(String(describing: userId ?? ""))")
        if self.userId == self.createdBy {
            self.height = 122
        } else if self.userId != self.createdBy {
            self.height = 180
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        callPollDetailWebService {
//            if self.PollDetailData?.favouritstatus == 0 {
//                self.btnUnFavourite.isHidden = true
//                self.FvrtLbl.text = "Favourite"  // Set label title for "0"
//            } else if self.PollDetailData?.favouritstatus == 1 {
//                self.btnFavourite.isHidden = true
//                self.FvrtLbl.text = "Unfavourite"  // Set label title for "1"
//            }
//        }
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            callPollDetailWebService {
                if self.PollDetailData?.favouritstatus == 0 {
                    self.btnUnFavourite.isHidden = true
                    self.FvrtLbl.text = "Favourite"
                    self.removeLbl.text = "Add this to my favourites"
                } else if self.PollDetailData?.favouritstatus == 1 {
                    self.btnFavourite.isHidden = true
                    self.FvrtLbl.text = "Unfavourite"
                    self.removeLbl.text = "Remove this from my favourites"
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
    
    @IBAction func btnFavourite(_ : UIButton){
        
        callFavouriteBussinessWebService{
            self.dismiss(animated: true)
//            self.showTemporaryAlert(message: "")
        }
        
    }
    
    
    @IBAction func btnUnFavourite(_ : UIButton){
        
        callFavouriteRemoveBussinessWebService{
//            self.showTemporaryAlert(message: "")
            self.onUpdateForFav?()
            self.dismiss(animated: true)
            

        }
        
    }
    
    @IBAction func btnBlockAction(_ sender: UIButton) {
        ConfirmBlock()
        print("Abdul Aleem Usmani")
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
    
    func showTemporaryAlert(message: String) {
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // Present the alert
        self.present(alertController, animated: true) {
            // Duration of 3 seconds before dismissing
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
            "type": "Poll" ,
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
            "type": "Poll" ,
            
            
        ]
        WebService.sharedInstance.callFavouriteRemoveBussinessWebService(withParams: dictParams) { data in
            self.BussinessRemoveFavouriteData = data
            
            
            completionClosure()
        }
    }
    
    func callPollDetailWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let Pollid = UserDefaults.standard.string(forKey: "Pollid")
        var dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "poll_id":business_id ?? ""
        ]
        
        
        
        WebService.sharedInstance.callPollDetailWebService(withParams: dictParams) { responseData in
            // Handle the response
            if let PollDetailData = responseData as? PollDetailModel {
                self.PollDetailData = PollDetailData
                UserDefaults.standard.set(self.PollDetailData?.pID, forKey: "Pollid")
                print("Decoded data: \(String(describing: self.PollDetailData))")
                completionClosure()
            } else {
                print("Error: Could not cast responseData to NewNotificationModel")
            }
        }
    }
    // dev.
    func handleBlockUnblockAPI(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/toggle-block-user"
        guard let blockerId = UserDefaults.standard.string(forKey: "userid"),
              let blockedId = PollDetailData?.userid else {
            print("Error: Missing user IDs")
            return
        }
        let dictParams: [String: Any] = [
            "blocker_userid": blockerId,
            "blocked_userid": blockedId,
            "action": "block"
        ]
        print("Block User URL :\(dictParams)")
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true) {
            (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                do {
                    let data = try JSONDecoder().decode(BlockUserModel.self, from: result!)
                    self.objBlockUserData = data
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if self.isComingFromMenuPollVC == false {
                            self.onUpdateForBlock!()
                            self.dismiss(animated: true)
                        } else if self.isComingFromMenuPollVC == true {
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

//Header: Authorization: Bearer
//Connecting to Host with URL http://dev.neighbrsnook.com/admin/api/neighbrsnook?flag=subscribe with parameters: {
//  "userid" : "1428",
//  "neighbrhood" : "Sector 16",
//  "sub_stat" : "1"
//}
//Success with JSON: {
//    message = "Updated Successfully";
//    status = success;
//}
//Success with status Code: Optional(200)
//Success with JSON: ["message": Updated Successfully, "status": success]
