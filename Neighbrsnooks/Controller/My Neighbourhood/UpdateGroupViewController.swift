//
//  UpdateGroupViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/06/24.
//

import UIKit
import SVProgressHUD
import Alamofire
import Photos

@available(iOS 16.0, *)
class UpdateGroupViewController: BaseViewController,CropViewControllerDelegate {
    
    
    @IBOutlet weak var tfGroupName: UITextField!
    @IBOutlet weak var tvaboutGroup: UITextView!
  //  @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var btnAnyone: UIButton!
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var HEADINGLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    
    @IBOutlet weak var lblUploadImg: UILabel!
    @IBOutlet weak var lblWho: UILabel!
    @IBOutlet weak var lblAnyone: UILabel!
    @IBOutlet weak var lblApproved: UILabel!
    
    var groupid : String?
    var userid : String?
    var GrouDetailsData : GroupDetailsModel?
    var GrouUpdatesData : UpdateGroupModel?
    var account = ""
    
    var imagePicker:UIImagePickerController?
    private weak var delegate: UIImagePickerControllerDelegate?
    var selectedImge: UIImage? = nil

    override func viewDidLoad() {
            super.viewDidLoad()
            account = "1"
            print("By Default group is :\(account)")
            self.imagePicker = UIImagePickerController()
            self.imagePicker?.delegate = self
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
            profileImgView.isUserInteractionEnabled = true
            profileImgView.addGestureRecognizer(tapGestureRecognizer)
            profileImgView.layer.masksToBounds = true
            
            
            self.tfGroupName.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.tvaboutGroup.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.lblUploadImg.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.lblWho.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.lblAnyone.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.lblApproved.font = UIFont(name: "Montserrat-Regular", size: 17)
            
            let url = URL(string: (self.GrouDetailsData?.image ?? ""))
            self.profileImgView.kf.indicatorType = .activity
           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupImg"))
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.HEADINGLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
            SVProgressHUD.show()
            callDetailsGroupWebService{ [self] in
                SVProgressHUD.dismiss()
                self.tfGroupName.text = self.GrouDetailsData?.groupname
                self.tvaboutGroup.text = self.GrouDetailsData?.description
             
                let url = URL(string: (self.GrouDetailsData?.image ?? ""))
                self.profileImgView.kf.indicatorType = .activity
               self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "groupImg"))
                
                if GrouDetailsData?.groupType == "Public" {

                    btnAnyone.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
                  

                } else if GrouDetailsData?.groupType == "Private" {
                    self.btnApprove.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
                 
                }
               
                if GrouDetailsData?.groupType == "Public" {
                    account = "1"
                } else if GrouDetailsData?.groupType == "Private" {
                    account = "0"
                }
            }
        }
    
     
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func AnyOneBtnAction(_ sender: UIButton) {
       btnAnyone.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btnApprove.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "1"
//        btnPrivate.setImage(UIImage(named: "radio-blank"), for: .normal)
//        whoCanSeeList = "EveryOne"
   }
   
   @IBAction func ApprovedBtnAction(_ sender: UIButton) {
       btnApprove.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btnAnyone.setImage(UIImage(named: "radio-blank"), for: .normal)
       account = "0"
      
   }
    
    @objc func imageViewTapped(_ sender:AnyObject){
         //   selectPictureThroughPhotoGallery()
    //        openCameraGallery()
            checkCameraPermission { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    openCameraGallery()
                }
            }
            
        }
    
    @IBAction func PicUploadBtnAction(_ sender: UIButton) {
        
        openCameraGallery()
    }
    
    @IBAction func CreateBtn(_ sender: UIButton) {

        let groupName = tfGroupName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let groupDescription = tvaboutGroup.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if groupName.isEmpty {
            let alert = UIAlertController(title: "", message: "Please Enter Your Group Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if containsBadWords(groupName) {
            let alert = UIAlertController(title: "", message: "Group name contains inappropriate words", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if groupDescription.isEmpty {
            let alert = UIAlertController(title: "", message: "Please Enter Description", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if containsBadWords(groupDescription) {
            let alert = UIAlertController(title: "", message: "Description contains inappropriate words", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        callUpdateGroupWebService { success in
            DispatchQueue.main.async {
                if success {
                    if let eventsVC = self.navigationController?.viewControllers.first(where: { $0 is GroupsViewController }) {
                        self.navigationController?.popToViewController(eventsVC, animated: true)
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    self.showAutoDismissAlert(message: "Failed to update event. Please try again.")
                }
            }
        }
    }

    

    func callDetailsGroupWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "groupid": groupid ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callDetailsGroupWebService(withParams: dictParams) { data in
            self.GrouDetailsData = data
         

            completionClosure()
          }
        }
    
    func callsendImageAPI(param:[String: Any],arrImage:UIImage,imageKey:String,URlName:String, withblock:@escaping ()->Void){

        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
        //    for img in arrImage {
                guard let imgData = arrImage.jpegData(compressionQuality: 1) else { return }
            multipartFormData.append(imgData, withName: imageKey, fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
            guard let imgData2 = self.profileImgView.image?.jpegData(compressionQuality: 1) else { return }
            multipartFormData.append(imgData, withName: "aadharBack", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
            
           // }
            
            
        },to: URL.init(string: URlName)!, usingThreshold: UInt64.init(),
          method: .post,
          headers: headers).response{ response in
            
            if((response.error == nil)){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        withblock()
                     //   withblock(parsedData)
//                        let status = parsedData[Message.Status] as? NSInteger ?? 0
//
//                        if (status == 1){
                            if let jsonArray = parsedData["data"] as? [[String: Any]] {
                               
                            }
//
//                        }else if (status == 2){
//                            print("error message")
//                        }else{
//                            print("error message")
//                        }
                    }
                }catch{
                    print("error message")
                }
            }else{
                print(response.error?.localizedDescription ?? "hgh")
            }
        }
    }

    
    
    
    func callUpdateGroupWebService(_ completionClosure: @escaping (Bool) -> Void) {

        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "groupname":self.tfGroupName.text ?? "",
                                                    "description":self.tvaboutGroup.text ?? "",
                                                    "groupid":groupid ?? "",
                                                    "visibility": "1",
                                                    "join_type": account
                                                  //  "groupimage":  "\(NSDate().timeIntervalSince1970.rounded())"
                                                    
                                                   
                                                                        ]
        print("param is :\(dictParams)")
        WebService.sharedInstance.callUpdateGroupWebService(withParams: dictParams) { [self] data in
              
              self.GrouUpdatesData = data
            //  UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
              
              callsendImageAPI(param: dictParams, arrImage: profileImgView.image!, imageKey: "groupimage", URlName: kBASEURL + WebServiceName.kUpdateGroup, withblock: {})
             
              
            if self.GrouUpdatesData?.status == "success" {
                completionClosure(true)
            } else {
                self.showAlert(Message: self.GrouUpdatesData?.message ?? "")
                completionClosure(false)
            }

          }
        }

}

@available(iOS 16.0, *)
extension UpdateGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true) {
            self.showCrop(image: image) // Open crop view after dismissing the picker
        }
    }

    // Show Crop View Controller
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
//        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        present(vc, animated: true)
    }

    // CropViewController Delegate Methods
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            print("Did crop")
            self.profileImgView.image = image // Assign cropped image
            self.selectedImge = image
            
         //   self.updateProfileImageView() // ✅ Ensure profile image updates properly
        }
    }

//


    func openCameraGallery()
    {
      //  let alert = UIAlertController(title:  "", message: "", preferredStyle: .actionSheet)
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
                print("User click Camera button")
                self.present(self.imagePicker!, animated: true, completion: {
                    self.imagePicker?.sourceType = .camera
                    self.imagePicker?.allowsEditing = true
                    self.imagePicker?.delegate = self
                })
            }))

        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default , handler:{ (UIAlertAction)in
                print("User click Gallery button")

                self.present(self.imagePicker!, animated: true, completion: {
                    self.imagePicker?.sourceType = .photoLibrary
                    self.imagePicker?.allowsEditing = true
                    self.imagePicker?.delegate = self
                })
            }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))

            self.present(alert, animated: true, completion: {
                print("completion block")
        })
    }


}
