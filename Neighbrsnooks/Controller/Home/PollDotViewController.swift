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
    
    var callback : ((_ range : String?) ->())?
    var BussinessFavouriteData : FavouriteBussinessModel?
    var BussinessRemoveFavouriteData : RemoveFavouriteBussiness?
    var PollDetailData : PollDetailModel?
    var business_id : String?
    var height: CGFloat?
        var topCornerRadius: CGFloat?
        var presentDuration: Double?
        var dismissDuration: Double?
        var shouldDismissInteractivelty: Bool?

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
      //  self.DmLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.ShareLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
      //  self.SendLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.removeLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.SharethisLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //callProductListWebService{}
       
        callPollDetailWebService{
            
            if self.PollDetailData?.favouritstatus == 0 {
                self.btnUnFavourite.isHidden = true
                self.FvrtLbl.text = "Favourite"  // Set label title for "0"
               
               
            } else if self.PollDetailData?.favouritstatus == 1 {
               
                self.btnFavourite.isHidden = true
                self.FvrtLbl.text = "Unfavourite"  // Set label title for "1"
             
            }
           
        }
      
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
                print("Decoded data: \(self.PollDetailData)")
                completionClosure()
            } else {
                print("Error: Could not cast responseData to NewNotificationModel")
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
