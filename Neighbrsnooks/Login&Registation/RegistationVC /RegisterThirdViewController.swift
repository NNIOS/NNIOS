//
//  RegisterThirdViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
import Alamofire
import Photos
import TOCropViewController
@available(iOS 16.0, *)
class RegisterThirdViewController: UIViewController,CropViewControllerDelegate, TOCropViewControllerDelegate {
    
    
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var backAdharPic: UIImageView!
    
    @IBOutlet weak var ivIdFrontPic: UIImageView!
    @IBOutlet weak var ivIdBackPic: UIImageView!
    
    @IBOutlet weak var ivIdPassportFrontPic: UIImageView!
    @IBOutlet weak var ivIdPassportBackPic: UIImageView!
    
    @IBOutlet weak var ivIdFrontVoterPic: UIImageView!
    @IBOutlet weak var ivIdBackVoterePic: UIImageView!
    
    @IBOutlet weak var ivIdFrontDrivingPic: UIImageView!
    @IBOutlet weak var ivIdBackDrivingPic: UIImageView!
    
    @IBOutlet weak var lblNeighbougood: UILabel!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblProvide: UILabel!
    @IBOutlet weak var viewAdhar: UIView!
    @IBOutlet weak var viewPassport: UIView!
    @IBOutlet weak var viewVoter: UIView!
    @IBOutlet weak var viewDriving: UIView!
    
    @IBOutlet weak var viewSectorFinal: UIView!
    
    
    
    let retryLimit = 3
    var retryCount = 0
    
    
    var frontAadhaarPicBase64 = ""
    var backAadhaarPicBase64 = ""
    
    var frontPassportPicBase64 = ""
    var backPassportPicBase64 = ""
    
    var frontVoterIDPicBase64 = ""
    var backVoterIDPicBase64 = ""
    
    var frontDrivingPicBase64 = ""
    var backDrivingPicBase64 = ""
    //  var imagePicker:UIImagePickerController?
    private weak var delegate: UIImagePickerControllerDelegate?
    
    var selectedImge: UIImage? = nil
    //  var selectedImge: UIImage? = nil
    var selectedBackImge: UIImage? = nil
    var from = 0
    
    var userid : String?
    
    var AdressProofData : AdressProofModel?
    
    var name : String! = nil
    var secname : String? = nil
    var Neighbourname : String! = nil
    
    var selectedView: UIView!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkMonitor.shared.startMonitoring()
        self.imagePicker.delegate = self
        lblNeighbougood.text = Neighbourname
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.lblProvide.font = UIFont(name: "Montserrat-Regular", size: 18)
        viewPopup.isHidden = true
        self.imagePicker = UIImagePickerController()
        //  self...delegate! = self
        
        let tapPancardDetails = UITapGestureRecognizer(target: self, action: #selector(ivAadhaarBackTapped(_:)))
        self.ivIdBackPic.isUserInteractionEnabled = true
        self.ivIdBackPic.addGestureRecognizer(tapPancardDetails)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(ivAadhaarFrontTapped(_:)))
        self.ivIdFrontPic.isUserInteractionEnabled = true
        self.ivIdFrontPic.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGesturePassportFrontRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(ivPassportFrontTapped(_:)))
        self.ivIdPassportFrontPic.isUserInteractionEnabled = true
        self.ivIdPassportFrontPic.addGestureRecognizer(tapGesturePassportFrontRecognizer2)
        
        let tapGesturePassportBackRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(ivPassportBackTapped(_:)))
        self.ivIdPassportBackPic.isUserInteractionEnabled = true
        self.ivIdPassportBackPic.addGestureRecognizer(tapGesturePassportBackRecognizer3)
        
        
        
        let tapGesturePassportFrontRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(ivPassportFrontTapped(_:)))
        self.ivIdPassportFrontPic.isUserInteractionEnabled = true
        self.ivIdPassportFrontPic.addGestureRecognizer(tapGesturePassportFrontRecognizer2)
        
        let tapGesturePassportBackRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(ivPassportBackTapped(_:)))
        self.ivIdPassportBackPic.isUserInteractionEnabled = true
        self.ivIdPassportBackPic.addGestureRecognizer(tapGesturePassportBackRecognizer3)
        
        //         code changes Irshad
        
        
        let tapGestureVoterIdFrontRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(ivVoterIdFrontTapped(_:)))
        self.ivIdFrontVoterPic.isUserInteractionEnabled = true
        self.ivIdFrontVoterPic.addGestureRecognizer(tapGestureVoterIdFrontRecognizer6)
        
        let tapGestureVoterIdBackRecognizer7 = UITapGestureRecognizer(target: self, action: #selector(ivVoterIdBackTapped(_:)))
        self.ivIdBackVoterePic.isUserInteractionEnabled = true
        self.ivIdBackVoterePic.addGestureRecognizer(tapGestureVoterIdBackRecognizer7)
        
        
        
        let tapGestureDrivingFrontRecognizer8 = UITapGestureRecognizer(target: self, action: #selector(ivDrivingFrontTapped(_:)))
        self.ivIdFrontDrivingPic.isUserInteractionEnabled = true
        self.ivIdFrontDrivingPic.addGestureRecognizer(tapGestureDrivingFrontRecognizer8)
        
        let tapGestureDrivingBackRecognizer9 = UITapGestureRecognizer(target: self, action: #selector(ivDrivingBackTapped(_:)))
        self.ivIdBackDrivingPic.isUserInteractionEnabled = true
        self.ivIdBackDrivingPic.addGestureRecognizer(tapGestureDrivingBackRecognizer9)
        
        
        
        
        
        
        
        
        
        
        
        
        viewAdhar.layer.shadowColor = UIColor.gray.cgColor
        viewAdhar.layer.shadowOpacity = 0.5
        viewAdhar.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewAdhar.layer.shadowRadius = 5
        viewAdhar.layer.masksToBounds = false
        
        viewPassport.layer.shadowColor = UIColor.gray.cgColor
        viewPassport.layer.shadowOpacity = 0.5
        viewPassport.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewPassport.layer.shadowRadius = 5
        viewPassport.layer.masksToBounds = false
        
        viewVoter.layer.shadowColor = UIColor.gray.cgColor
        viewVoter.layer.shadowOpacity = 0.5
        viewVoter.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewVoter.layer.shadowRadius = 5
        viewVoter.layer.masksToBounds = false
        
        viewDriving.layer.shadowColor = UIColor.gray.cgColor
        viewDriving.layer.shadowOpacity = 0.5
        viewDriving.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewDriving.layer.shadowRadius = 5
        viewDriving.layer.masksToBounds = false
        
        
        viewSectorFinal.layer.shadowColor = UIColor.gray.cgColor
        viewSectorFinal.layer.shadowOpacity = 0.5
        viewSectorFinal.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewSectorFinal.layer.shadowRadius = 5
        viewSectorFinal.layer.masksToBounds = false
        //        imagePicker.delegate = self
        //               imagePicker.sourceType = .savedPhotosAlbum
        //               imagePicker.allowsEditing = false
        //
        //               [ivIdBackPic,ivIdPassportFrontPic,ivIdFrontPic,ivIdPassportBackPic].forEach {
        //                   $0?.isUserInteractionEnabled = true
        //                   $0?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
        //               }
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
            // Stop monitoring when the view controller is deallocated
            NetworkMonitor.shared.stopMonitoring()
        }
    
    
    @IBAction func actionSkip(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as? ForgotViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnRegister(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as? ForgotViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //    @IBAction func onTapProfile(_ : UIButton){
    //
    //        if from == 1 {
    //            addImageBtnPressed()
    //        }
    //    }
    //
    //    @IBAction func onTapBack(_ : UIButton){
    //
    //        if from == 1 {
    //            addImageBtnPressed()
    //        }
    //    }
    //
    @objc func ivAadhaarFrontTapped(_ sender:AnyObject){
        
        if profilePic.image == nil {
            from = 1
            checkPhotoLibraryPermission()
            openCameraGallery()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popupViewController = storyboard.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as? RegisterThirdImageShowPopupVC {
                // Set the modal presentation style
                popupViewController.imagePass = self.profilePic.image
                
                popupViewController.onDeleteImage = { [weak self] in
                    // Remove the image from the array
                    self?.profilePic.image = nil
                    print("Image deleted successfully.")
                }
                
                popupViewController.modalPresentationStyle = .overCurrentContext
                popupViewController.modalTransitionStyle = .crossDissolve
                
                // Present the popup view controller
                self.present(popupViewController, animated: true, completion: nil)
            }
            
            
            print("image clicked")
            
        }
        
    }
    
    @objc func ivAadhaarBackTapped(_ sender:AnyObject){
        
        if backAdharPic.image == nil {
            from = 2
            checkPhotoLibraryPermission()
            openCameraGallery()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popupViewController = storyboard.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as? RegisterThirdImageShowPopupVC {
                // Set the modal presentation style
                popupViewController.imagePass = self.backAdharPic.image
                
                popupViewController.onDeleteImage = { [weak self] in
                    self?.backAdharPic.image = nil
                    print("Image deleted successfully.")
                }
                
                popupViewController.modalPresentationStyle = .overCurrentContext
                popupViewController.modalTransitionStyle = .crossDissolve
                
                // Present the popup view controller
                self.present(popupViewController, animated: true, completion: nil)
            }
            
            
            print("image clicked")
            
        }
       
    }
    
    @objc func ivPassportFrontTapped(_ sender:AnyObject){
        if ivIdPassportFrontPic.image == nil{
            from = 3
            openCameraGallery()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popupViewController = storyboard.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as? RegisterThirdImageShowPopupVC {
                // Set the modal presentation style
                popupViewController.imagePass = self.ivIdPassportFrontPic.image
                
                popupViewController.onDeleteImage = { [weak self] in
                    self?.ivIdPassportBackPic.image = nil
                    print("Image deleted successfully.")
                }
                
                popupViewController.modalPresentationStyle = .overCurrentContext
                popupViewController.modalTransitionStyle = .crossDissolve
                
                // Present the popup view controller
                self.present(popupViewController, animated: true, completion: nil)
            }
            
            
        }
        
    }
    @objc func ivPassportBackTapped(_ sender:AnyObject){
        if ivIdPassportBackPic.image == nil{
            from = 4
            openCameraGallery()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popupViewController = storyboard.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as? RegisterThirdImageShowPopupVC {
                // Set the modal presentation style
                popupViewController.imagePass = self.ivIdPassportBackPic.image
                
                popupViewController.onDeleteImage = { [weak self] in
                    // Remove the image from the array
                    self?.ivIdPassportBackPic.image = nil
                    print("Image deleted successfully.")
                }
                
                popupViewController.modalPresentationStyle = .overCurrentContext
                popupViewController.modalTransitionStyle = .crossDissolve
                
                // Present the popup view controller
                self.present(popupViewController, animated: true, completion: nil)
            }
            
            
        }
        
    }
    
    @objc func ivVoterIdFrontTapped(_ sender:AnyObject){
        if ivIdFrontVoterPic.image == nil{
            from = 5
            openCameraGallery()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popupViewController = storyboard.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as? RegisterThirdImageShowPopupVC {
                // Set the modal presentation style
                popupViewController.imagePass = self.ivIdFrontVoterPic.image
                
                popupViewController.onDeleteImage = { [weak self] in
                    // Remove the image from the array
                    self?.ivIdFrontVoterPic.image = nil
                    print("Image deleted successfully.")
                }
                
                popupViewController.modalPresentationStyle = .overCurrentContext
                popupViewController.modalTransitionStyle = .crossDissolve
                
                // Present the popup view controller
                self.present(popupViewController, animated: true, completion: nil)
            }
            
            
        }
    }
    @objc func ivVoterIdBackTapped(_ sender:AnyObject){
        if ivIdBackVoterePic.image == nil{
            from = 6
            openCameraGallery()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popupViewController = storyboard.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as? RegisterThirdImageShowPopupVC {
                // Set the modal presentation style
                popupViewController.imagePass = self.ivIdBackVoterePic.image
                
                // Define the delete action
                popupViewController.onDeleteImage = { [weak self] in
                    // Clear the image from UIImageView
                    self?.ivIdBackVoterePic.image = nil
                    print("Image deleted successfully.")
                }
                
                popupViewController.modalPresentationStyle = .overCurrentContext
                popupViewController.modalTransitionStyle = .crossDissolve
                
                // Present the popup view controller
                self.present(popupViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func ivDrivingFrontTapped(_ sender:AnyObject){
        if ivIdFrontDrivingPic.image == nil{
            from = 7
            openCameraGallery()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popupViewController = storyboard.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as? RegisterThirdImageShowPopupVC {
                // Set the modal presentation style
                popupViewController.imagePass = self.ivIdFrontDrivingPic.image
                
                popupViewController.onDeleteImage = { [weak self] in
                    // Remove the image from the array
                    self?.ivIdFrontDrivingPic.image = nil
                    print("Image deleted successfully.")
                }
                
                popupViewController.modalPresentationStyle = .overCurrentContext
                popupViewController.modalTransitionStyle = .crossDissolve
                
                // Present the popup view controller
                self.present(popupViewController, animated: true, completion: nil)
            }
            
            
        }
    }
    @objc func ivDrivingBackTapped(_ sender:AnyObject){
        if ivIdBackDrivingPic.image == nil{
            from = 8
            openCameraGallery()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popupViewController = storyboard.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as? RegisterThirdImageShowPopupVC {
                // Set the modal presentation style
                popupViewController.imagePass = self.ivIdBackDrivingPic.image
                
                popupViewController.onDeleteImage = { [weak self] in
                    // Remove the image from the array
                    self?.ivIdBackDrivingPic.image = nil
                    print("Image deleted successfully.")
                }
                
                popupViewController.modalPresentationStyle = .overCurrentContext
                popupViewController.modalTransitionStyle = .crossDissolve
                
                // Present the popup view controller
                self.present(popupViewController, animated: true, completion: nil)
            }
            
            
        }
        
    }
    
    
    
    @IBAction func btnClose(_ : UIButton){
        
        viewPopup.isHidden = true
        
    }
    
    @IBAction func PopUpBtn(_ sender: UIButton){
        viewPopup.isHidden = false
        
    }
    
    @IBAction func NewRegBtn(_ sender: UIButton){
        callAddressProofWebService {
               // Code to execute after all images are uploaded
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController") as! RegisterFirstViewController
               vc.name = self.name ?? ""
               vc.secname = self.secname ?? ""
               self.navigationController?.pushViewController(vc, animated: false)
               self.viewPopup.isHidden = true
           }
        viewPopup.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController")as! RegisterFirstViewController
            self.navigationController?.pushViewController(vc, animated: true)
        
        
        
//        callAddressProofWebService{
//            
//            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController")as! RegisterFirstViewController
//            vc.name = self.name.self
//            vc.secname = self.secname!.self
//            self.navigationController?.pushViewController(vc, animated: false)
//            self.viewPopup.isHidden = true
//            
//            //   self.logoutAPI(params : param);
//            
//        }
//       
//        print("Api not fonds data")
//        viewPopup.isHidden = true
//        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController")as! RegisterFirstViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//        
    }
    
   
//     call api
//    rajat code
    
    
    //        if let maage  = ivIdFrontPic{
    //
    //            let id = UserDefaults.standard.string(forKey: "userid")
    //            let dictParams: Dictionary<String, Any> = [
    //                "userid":id ?? "",
    //            ]
    //
    //            callsendImageAPI(param: dictParams, arrImage: ivIdFrontPic.image!, imageKey: "aadharFront", URlName: kBASEURL + WebServiceName.kAddressProof, withblock: {
    //                completionClosure()
    //            })
    //
    //
    //
    //        } end
    
    
    
    
    
    
    
    
    
//  
//    func callAddressProofWebService(_ completionClosure: @escaping () -> ()) {
//
//        
//        if let image = ivIdFrontPic.image {
//            // Get the user ID from UserDefaults, using an empty string as a fallback if it's nil
//            let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
//            
//            // Create the parameters dictionary for the API call
//            let dictParams: [String: Any] = [
//                "userid": userID,
//            ]
//            
//            let url = kBASEURL + WebServiceName.kAddressProof
//            // Make the API call with the image since it's not nil
//            callsendImageAPI(param: dictParams, arrImage: image, imageKey: "dlFront", URlName: url) {
//                // Completion closure is called after the API call finishes
//                completionClosure()
//            }
//        }else if let backAdhar = ivIdBackPic.image{
//            
//            let id = UserDefaults.standard.string(forKey: "userid") ?? ""
//            
//            let dictParams: [String: Any] = [
//                "userid":id ?? "",
//            ]
//            
//            callsendImageAPI(param: dictParams, arrImage: backAdhar, imageKey: "aadharBack", URlName: kBASEURL + WebServiceName.kAddressProof, withblock: {
//                completionClosure()
//            })
//            
//            print(ivIdBackPic.image)
//            
//        } else if let passportFront = ivIdPassportFrontPic.image{
//            let id = UserDefaults.standard.string(forKey: "userid") ?? ""
//            let dictParams: [String: Any] = [
//                "userid":id ?? "",
//            ]
//            callsendImageAPI(param: dictParams, arrImage: passportFront, imageKey: "passportFront", URlName: kBASEURL + WebServiceName.kAddressProof, withblock: {
//                completionClosure()
//            })
//            
//        }else if let passportBack = ivIdPassportBackPic.image{
//            let id = UserDefaults.standard.string(forKey: "userid") ?? ""
//            let dictParams: [String: Any] = [
//                "userid":id ?? "",
//            ]
//            
//            callsendImageAPI(param: dictParams, arrImage: passportBack, imageKey: "passportBack", URlName: kBASEURL + WebServiceName.kAddressProof, withblock: {
//                completionClosure()
//            })
//            
//        }else if let voteridFront = ivIdFrontVoterPic.image{
//            let id = UserDefaults.standard.string(forKey: "userid") ?? ""
//            let dictParams: [String: Any] = [
//                "userid":id ?? "",
//            ]
//            
//            callsendImageAPI(param: dictParams, arrImage: voteridFront, imageKey: "voterFront", URlName: kBASEURL + WebServiceName.kAddressProof, withblock: {
//                completionClosure()
//            })
//        }else if let voteridBack = ivIdBackVoterePic.image{
//            
//            let id = UserDefaults.standard.string(forKey: "userid") ?? ""
//            let dictParams: [String: Any] = [
//                "userid":id ?? "",
//            ]
//            
//            callsendImageAPI(param: dictParams, arrImage: voteridBack , imageKey: "voterBack", URlName: kBASEURL + WebServiceName.kAddressProof, withblock: {
//                completionClosure()
//            })
//        }else if let drivingFront = ivIdFrontDrivingPic.image{
//            
//            let id = UserDefaults.standard.string(forKey: "userid") ?? ""
//            let dictParams: [String: Any] = [
//                "userid":id ?? "",
//            ]
//            
//            callsendImageAPI(param: dictParams, arrImage: drivingFront, imageKey: "dlFront", URlName: kBASEURL + WebServiceName.kAddressProof, withblock: {
//                completionClosure()
//            })
//        }else if let drivingBack = ivIdBackDrivingPic.image{
//            let id = UserDefaults.standard.string(forKey: "userid") ?? ""
//            let dictParams: [String: Any] = [
//                "userid":id ?? "",
//            ]
//            
//            callsendImageAPI(param: dictParams, arrImage: drivingBack, imageKey: "dlBack", URlName: kBASEURL + WebServiceName.kAddressProof, withblock: {
//                completionClosure()
//            })
//        }
//        else{
//            
//            viewPopup.isHidden = true
//            let alert = UIAlertController(title: "Alert", message: "Please Upload oneID-Address proof. ", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            
//            print("Irshad malik")
//        }
//        
//        
//    }
//    
    
    
   
    
    func callAddressProofWebService(completionClosure: @escaping () -> ()) {
        // Array of image data and corresponding keys
        let imageDetails: [(UIImage?, String)] = [
            (ivIdFrontPic.image, "dlFront"),
            (ivIdBackPic.image, "aadharBack"),
            (ivIdPassportFrontPic.image, "passportFront"),
            (ivIdPassportBackPic.image, "passportBack"),
            (ivIdFrontVoterPic.image, "voterFront"),
            (ivIdBackVoterePic.image, "voterBack"),
            (ivIdFrontDrivingPic.image, "dlFront"),
            (ivIdBackDrivingPic.image, "dlBack")
        ]
        
        // Function to handle uploading images one by one
        func uploadImagesSequentially(index: Int) {
            // Check if we are done with all images
            guard index < imageDetails.count else {
                // Call the completion closure after all images are uploaded
                completionClosure()
                return
            }
            
            let (image, key) = imageDetails[index]
            
            // If an image exists, proceed with the upload
            if let uploadImage = image {
                let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
                let dictParams: [String: Any] = ["userid": userID]
                let url = kBASEURL + WebServiceName.kAddressProof
                
                // Call the image upload API
                callsendImageAPI(param: dictParams, arrImage: uploadImage, imageKey: key, URlName: url) {
                    // Move to the next image in the array after the current one finishes
                    uploadImagesSequentially(index: index + 1)
                }
            } else {
                // If no image, skip to the next one
                uploadImagesSequentially(index: index + 1)
            }
        }
        
        // Start the uploading process
        uploadImagesSequentially(index: 0)
    }
    
    
    
    
    
//    new code Irshad
    
    func callsendImageAPI(param: [String: Any], arrImage: UIImage, imageKey: String, URlName: String, withblock: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

        AF.upload(multipartFormData: { multipartFormData in
            // Add parameters
            for (key, value) in param {
                if let stringValue = value as? String {
                    multipartFormData.append(Data(stringValue.utf8), withName: key)
                }
            }
            
            // Function to add images
            func appendImage(_ image: UIImage?, withName name: String) {
                guard let imageData = image?.jpegData(compressionQuality: 1) else { return }
                multipartFormData.append(imageData, withName: name, fileName: "\(NSDate().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            // Add all required images
            appendImage(arrImage, withName: imageKey)
            appendImage(self.ivIdBackPic.image, withName: "aadharBack")
            appendImage(self.ivIdPassportFrontPic.image, withName: "passportFront")
            appendImage(self.ivIdPassportBackPic.image, withName: "passportBack")
            appendImage(self.ivIdFrontVoterPic.image, withName: "voterFront")
            appendImage(self.ivIdBackVoterePic.image, withName: "voterBack")
            appendImage(self.ivIdFrontDrivingPic.image, withName: "dlFront")
            appendImage(self.ivIdBackDrivingPic.image, withName: "dlBack")
            
        }, to: URlName, method: .post, headers: headers)
        .response { response in
            if response.error == nil, let jsonData = response.data {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
                    print(parsedData ?? "No data")
                    withblock()
                } catch {
                    print("JSON Parsing Error")
                }
            } else {
                print(response.error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
//    
//    func callsendImageAPI(param:[String: Any],arrImage:UIImage,imageKey:String,URlName:String, withblock:@escaping ()->Void){
//        
//        let headers: HTTPHeaders
//        headers = ["Content-type": "multipart/form-data"]
//        
//        AF.upload(multipartFormData: { (multipartFormData) in
//            
//            for (key, value) in param {
//                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
//            }
//            
//            //    for img in arrImage {
//            guard let imgData = arrImage.jpegData(compressionQuality: 1) else { return }
//            multipartFormData.append(imgData, withName: imageKey, fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
//            guard let imgData2 = self.ivIdBackPic.image?.jpegData(compressionQuality: 1) else { return }
//            multipartFormData.append(imgData, withName: "aadharBack", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
//            guard let imgData3 = self.ivIdPassportFrontPic.image?.jpegData(compressionQuality: 1) else { return }
//            multipartFormData.append(imgData, withName: "passportFront", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
//            guard let imgData4 = self.ivIdPassportBackPic.image?.jpegData(compressionQuality: 1) else { return }
//            multipartFormData.append(imgData, withName: "passportBack", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
//            // }
//            
//            guard let imgData3 = self.ivIdFrontVoterPic.image?.jpegData(compressionQuality: 1) else { return }
//            multipartFormData.append(imgData, withName: "voterFront", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
//            guard let imgData4 = self.ivIdBackVoterePic.image?.jpegData(compressionQuality: 1) else { return }
//            multipartFormData.append(imgData, withName: "voterBack", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
//            
//            
//            guard let imgData3 = self.ivIdFrontDrivingPic.image?.jpegData(compressionQuality: 1) else { return }
//            multipartFormData.append(imgData, withName: "dlFront", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
//            guard let imgData4 = self.ivIdBackDrivingPic.image?.jpegData(compressionQuality: 1) else { return }
//            multipartFormData.append(imgData, withName: "dlBack", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
//            
//            
//            
//        },to: URL.init(string: URlName)!, usingThreshold: UInt64.init(),
//                  method: .post,
//                  headers: headers).response{ response in
//            
//            
//            if((response.error == nil)){
//                do{
//                    if let jsonData = response.data{
//                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
//                        print(parsedData)
//                        withblock()
//                        //   withblock(parsedData)
//                        //                        let status = parsedData[Message.Status] as? NSInteger ?? 0
//                        //
//                        //                        if (status == 1){
//                        if let jsonArray = parsedData["data"] as? [[String: Any]] {
//                            
//                        }
//                        //
//                        //                        }else if (status == 2){
//                        //                            print("error message")
//                        //                        }else{
//                        //                            print("error message")
//                        //                        }
//                    }
//                }catch{
//                    print("error message")
//                }
//            }else{
//                print(response.error?.localizedDescription ?? "hgh")
//            }
//        }
//    }
//    
}

@available(iOS 16.0, *)
extension RegisterThirdViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func chooseImage(_ gesture: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            selectedView = gesture.view
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        dismiss(animated: true)
        // showNewCrop
        if from == 1 {(image)
            self.ivIdFrontPic.image = image
            showNewCrop(image: image)
        }
        if from == 2 {(image)
            self.backAdharPic.image = image
            showNewCrop(image: image)
        }
        if from == 3 {(image)
            self.ivIdPassportFrontPic.image = image
            showNewCrop(image: image)
        }
        if from == 4 {(image)
            
            self.ivIdPassportBackPic.image = image
            showNewCrop(image: image)
        }
        if from == 5 {(image)
            self.ivIdFrontVoterPic.image = image
            showNewCrop(image: image)
        }
        if from == 6 {(image)
            self.ivIdBackVoterePic.image = image
            showNewCrop(image: image)
        }
        
        if from == 7 {(image)
            self.ivIdFrontDrivingPic.image = image
            showNewCrop(image: image)
        }
        
        if from == 8 {(image)
            self.ivIdBackDrivingPic.image = image
            showNewCrop(image: image)
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
    func showNewCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
//        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
        
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    
    
    
    
    @IBAction func presentCropViewController() {
        let cropViewController = TOCropViewController(image: UIImage(named: "yourImageName")!) // Replace 'yourImageName' with your actual image name or UIImage instance
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    // Example of adjusting button position after presenting the crop view controller
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Access the CropViewController if it's still presented
        if let cropViewController = presentedViewController as? TOCropViewController {
            let continueButton = cropViewController.toolbar.doneTextButton
            continueButton.setTitle("Continue", for: .normal)
            continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            continueButton.setTitleColor(.systemBlue, for: .normal)
            
            // Adjust button position to your needs
            adjustButtonPosition(button: continueButton)
        }
    }
    
    // Function to adjust the button's position
    private func adjustButtonPosition(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints to position the button at the bottom of the view
        if let superview = button.superview {
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -20), // Adjust as needed
                button.centerXAnchor.constraint(equalTo: superview.centerXAnchor), // Center button horizontally
                button.heightAnchor.constraint(equalToConstant: 50), // Set the height as needed
                button.widthAnchor.constraint(equalToConstant: 150) // Set the width as needed
            ])
        }
    }
    
    
    
    @nonobjc func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
        
        
    }
    
    @nonobjc func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        print("Did crop")
        //rajuuuuu
        
        //            let imageView = UIImageView(frame: view.frame)
        //            imageView.contentMode = .scaleAspectFit
        //            imageView.image = image
        //            view.addSubview(imageView)
    }
    
    func openCameraGallery()
    {
        debugPrint("from - ",from)
        
        //  let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let alert = UIAlertController()
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            print("User click Camera button")
            self.present(self.imagePicker, animated: true, completion: {
                self.imagePicker.sourceType = .camera
                //  self.imagePicker?.allowsEditing = true
                
                self.imagePicker.delegate = self
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default , handler:{ (UIAlertAction)in
            print("User click Gallery button")
            
            self.present(self.imagePicker, animated: true, completion: {
                self.imagePicker.sourceType = .photoLibrary
                //   self.imagePicker?.allowsEditing = true
                self.imagePicker.delegate = self
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("Completion block")
        })
    }
    
    func doneButtonDidPress(_ imagePicker: UIImagePickerController, images: [UIImage]) {
        
        if from == 1 {
            self.ivIdFrontPic.image = images[0].fixedOrientation()
        }
        else if from == 2 {
            self.ivIdBackPic.image = images[0].fixedOrientation()
        }
        else if from == 3 {
            self.ivIdPassportFrontPic.image = images[0].fixedOrientation()
        }
        else if from == 4 {
            self.ivIdPassportBackPic.image = images[0].fixedOrientation()
        }
        else if from == 5 {
            self.ivIdFrontVoterPic.image = images[0].fixedOrientation()
        }
        
        else if from == 6 {
            self.ivIdBackVoterePic.image = images[0].fixedOrientation()
        }
        else if from == 7 {
            self.ivIdFrontDrivingPic.image = images[0].fixedOrientation()
        }
        else if from == 8{
            self.ivIdBackDrivingPic.image = images[0].fixedOrientation()
        }
        
        
        
        
        getImageBase64()
    }
    
    func cancelButtonDidPress(_ imagePicker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: UIImagePickerController, images: [UIImage]) {
        
        if from == 1 {
            self.ivIdFrontPic.image = images[0].fixedOrientation()
        }
        else if from == 2 {
            self.ivIdBackPic.image = images[0].fixedOrientation()
        }
        else if from == 3 {
            self.ivIdPassportFrontPic.image = images[0].fixedOrientation()
        }
        else if from == 4 {
            self.ivIdPassportBackPic.image = images[0].fixedOrientation()
        }
        
        else if from == 5 {
            self.ivIdFrontVoterPic.image = images[0].fixedOrientation()
        }
        else if from == 6 {
            self.ivIdBackVoterePic.image = images[0].fixedOrientation()
        }
        
        else if from == 7 {
            self.ivIdFrontDrivingPic.image = images[0].fixedOrientation()
        }
        else if from == 8 {
            self.ivIdBackDrivingPic.image = images[0].fixedOrientation()
        }
        
        
        
        
        getImageBase64()
    }
    
    func getImageBase64()
    {
        if from == 1 {
            if(self.ivIdFrontPic.image != nil)
            {
                let imageData:NSData = ivIdFrontPic.image!.jpegData(compressionQuality:  0.3)! as NSData
                frontAadhaarPicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        else if from == 2 {
            if(self.ivIdBackPic.image != nil)
            {
                let imageData:NSData = ivIdBackPic.image!.jpegData(compressionQuality:  0.3)! as NSData
                backAadhaarPicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        
        else if from == 3 {
            if(self.ivIdPassportFrontPic.image != nil)
            {
                let imageData:NSData = ivIdPassportFrontPic.image!.jpegData(compressionQuality:  0.3)! as NSData
                frontPassportPicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        
        else if from == 4 {
            if(self.ivIdPassportBackPic.image != nil)
            {
                let imageData:NSData = ivIdPassportBackPic.image!.jpegData(compressionQuality:  0.3)! as NSData
                backPassportPicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        
        
        
        else if from == 5 {
            if(self.ivIdFrontVoterPic.image != nil)
            {
                let imageData:NSData = ivIdFrontVoterPic.image!.jpegData(compressionQuality:  0.3)! as NSData
                frontVoterIDPicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        
        else if from == 6 {
            if(self.ivIdBackVoterePic.image != nil)
            {
                let imageData:NSData = ivIdBackVoterePic.image!.jpegData(compressionQuality:  0.3)! as NSData
                backVoterIDPicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        
        
        
        else if from == 7 {
            if(self.ivIdFrontDrivingPic.image != nil)
            {
                let imageData:NSData = ivIdFrontDrivingPic.image!.jpegData(compressionQuality:  0.3)! as NSData
                frontDrivingPicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        
        else if from == 8 {
            if(self.ivIdBackDrivingPic.image != nil)
            {
                let imageData:NSData = ivIdBackDrivingPic.image!.jpegData(compressionQuality:  0.3)! as NSData
                backDrivingPicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        
        
        
        
        
        
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // Access to photo library allowed, do whatever you want to do with the image
            print("Access to photo library allowed")
        case .denied, .restricted :
            // User denied or restricted access to photo library, prompt them to change it in settings
            print("Access to photo library denied")
            let alert = UIAlertController(title: "Permission Denied", message: "Please allow access to the photo library in settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        case .notDetermined:
            // Permission not determined, request access
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    // Access to photo library allowed, do whatever you want to do with the image
                    print("Access to photo library allowed")
                } else {
                    // User denied access to photo library
                    print("Access to photo library denied")
                }
            })
        @unknown default:
            fatalError()
        }
    }
}

//     UserDefaults.standard.set(self.loginData?.data.email, forKey: "id")
//  let id = UserDefaults.standard.string(forKey: "id")
