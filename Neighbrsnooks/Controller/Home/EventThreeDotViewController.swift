//
//  EventThreeDotViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 02/01/25.
//

import UIKit
@available(iOS 16.0, *)
class EventThreeDotViewController: BottomPopupViewController {
    
    @IBOutlet weak var btnFavourite : UIButton!
    @IBOutlet weak var btnUnFavourite : UIButton!
    @IBOutlet weak var ShareLbl: UILabel!
    @IBOutlet weak var FvrtLbl: UILabel!
     @IBOutlet weak var lblAddThisFavouritPost: UILabel!
     @IBOutlet weak var lblShareThisPost: UILabel!
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
         self.lblAddThisFavouritPost.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.lblShareThisPost.font = UIFont(name: "Montserrat-Regular", size: 13)


       
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
            self.showTemporaryAlert(message: "Added to favorite successfully")
        }
       

       }
    
    @IBAction func btnUnFavourite(_ : UIButton){

        callFavouriteRemoveBussinessWebService{
            self.showTemporaryAlert(message: "Removed to favorite successfully")
        
        }

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
