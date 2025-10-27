//
//  UpdateGroupViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/06/24.
//
//MARK: - :  Marks starts here
import UIKit
import SVProgressHUD
import Alamofire
import Photos
import CropViewController

@available(iOS 16.0, *)
class UpdateGroupViewController: BaseViewController,CropViewControllerDelegate {
    
    //MARK: - :  outlets
    @IBOutlet weak var tfGroupName: UITextField!
    @IBOutlet weak var tvaboutGroup: UITextView!
    @IBOutlet weak var btnAnyone: UIButton!
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var HEADINGLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var lblUploadImg: UILabel!
    @IBOutlet weak var lblWho: UILabel!
    @IBOutlet weak var lblAnyone: UILabel!
    @IBOutlet weak var lblApproved: UILabel!
    
    //MARK: - :  variables
    var account = ""
    var groupid : Int?
    var userid : String?
    var objData:GroupDetailItem?
    var imageArray = [UIImage]()
    var selectedImge: UIImage? = nil
    var imagePicker:UIImagePickerController?
    var onUpdateComplete: ((GroupDetailItem) -> Void)?
    private weak var delegate: UIImagePickerControllerDelegate?
    
    //MARK: - :  life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reach().isInternet() {
            self.setupUI()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    //MARK: - :  button's action
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AnyOneBtnAction(_ sender: UIButton) {
        btnAnyone.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnApprove.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "public"
    }
    
    @IBAction func ApprovedBtnAction(_ sender: UIButton) {
        btnApprove.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnAnyone.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "private"
        
    }
    
    @objc func imageViewTapped(_ sender:AnyObject) {
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
        validation()
    }
}

//MARK: - :  Extenison for UIviewController
extension UpdateGroupViewController {
    
    // MARK - function for UI setup
    func setupUI() {
        self.imagePicker?.delegate = self
        self.imagePicker = UIImagePickerController()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        profileImgView.isUserInteractionEnabled = true
        profileImgView.addGestureRecognizer(tapGestureRecognizer)
        profileImgView.layer.masksToBounds = true
        
        self.lblWho.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblAnyone.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblApproved.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.HEADINGLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.tfGroupName.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tvaboutGroup.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblUploadImg.font = UIFont(name: "Montserrat-Regular", size: 17)
        let imageURL = objData?.group_image ?? ""
        tfGroupName.text = objData?.group_name
        tvaboutGroup.text = objData?.group_description
        // Only set image from objData if no new image was picked
           if let selected = selectedImge {
               profileImgView.image = selected
           } else {
               let imageURL = objData?.group_image ?? ""
               ImageLoader.shared.setImage(on: profileImgView, urlString: imageURL.isEmpty ? nil : imageURL, placeholder: "groupImg")
           }
        guard let type = objData?.group_type?.lowercased() else {
            btnAnyone.setImage(UIImage(named: "radio-blank"), for: .normal)
            btnApprove.setImage(UIImage(named: "radio-blank"), for: .normal)
            return
        }
        if type == "public" {
            btnAnyone.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            btnApprove.setImage(UIImage(named: "radio-blank"), for: .normal)
            account = "public"
        } else if type == "private" {
            btnApprove.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
            btnAnyone.setImage(UIImage(named: "radio-blank"), for: .normal)
            account = "private"
        } else {
            btnAnyone.setImage(UIImage(named: "radio-blank"), for: .normal)
            btnApprove.setImage(UIImage(named: "radio-blank"), for: .normal)
        }
    }
    
    // MARK - function for handle create button for Upadte Group API call
    func validation() {
        let groupName = tfGroupName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let groupDescription = tvaboutGroup.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if groupName.isEmpty {
            alertToast(Message: "Please enter group name")
        } else if containsBadWords(groupName) {
            alertToast(Message: "Group name contains inappropriate words")
        } else  if groupDescription.isEmpty {
            alertToast(Message: "Please Enter Description")
        } else  if containsBadWords(groupDescription) {
            alertToast(Message: "Description contains inappropriate words")
        } else  if account == "" {
            alertToast(Message: "Please select who can join")
        }
        else {
            self.callUpdateGroupApi()
        }
    }
    
    // MARK - function for handle update group API
    func callUpdateGroupApi() {
        let request = GroupUpdate_Request(group_id:  objData?.groupid ?? 0,
                                          name: tfGroupName.text ?? "",
                                          image: imageArray.isEmpty && selectedImge == nil ? "" : "hasImage",
                                          description: tvaboutGroup.text ?? "",
                                          join_type: account)
        
        var param:[String: Any] = [
            "group_id":request.group_id,
            "name":request.name,
            "image":request.image,
            "description":request.description,
            "join_type":request.join_type
        ]
        print("param is: \(param)")
        
        var uploadImages = imageArray
        if let profileImage = selectedImge {
            uploadImages.append(profileImage)
        }
        if uploadImages.isEmpty {
            if let defaultImg = UIImage(named: "groupImg") {
                uploadImages.append(defaultImg)
            }
        }
        for img in uploadImages {
            if !isImageSizeValid(img) {
                self.alertToast(Message: "Image size should be less than 5 MB")
                return
            }
        }
        if !uploadImages.isEmpty {
            param.removeValue(forKey: "image")
        }
        self.callsendMediaAPI(param: param, arrImage: uploadImages, mediaKey: "image", URlName: API.updateGroup) {
            DispatchQueue.main.async {
                if let obj = self.objData {
                    var updatedObj = obj
                    updatedObj.group_type = self.account.capitalized
                    if let newImage = self.selectedImge {
                        updatedObj.group_image = "hasImage"
                        self.profileImgView.image = newImage
                    }
                    self.onUpdateComplete?(updatedObj)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK - function for handle send media Api
    func callsendMediaAPI(param: [String: Any], arrImage: [UIImage],  mediaKey: String,   URlName: String,  withblock: @escaping () -> Void) {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data"
        ]
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                if let valueString = value as? String, !valueString.isEmpty {
                    if let data = valueString.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                } else if let valueInt = value as? Int {
                    let data = "\(valueInt)".data(using: .utf8)!
                    multipartFormData.append(data, withName: key)
                }
            }
            for img in arrImage {
                if let imgData = img.jpegData(compressionQuality: 0.3) {
                    multipartFormData.append( imgData,  withName: mediaKey, fileName: "image\(Date().timeIntervalSince1970).jpg",  mimeType: "image/jpeg" )
                }
            }
        }, to: URlName, method: .post, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let parsed = try JSONSerialization.jsonObject(with: data, options: [])
                        print("✅ Upload successful:", parsed)
                        withblock()
                    } catch {
                        print("❌ JSON parsing error:", error.localizedDescription)
                        if let raw = response.data, let rawStr = String(data: raw, encoding: .utf8) {
                            print("🔍 Raw response:", rawStr)
                        }
                    }
                } else {
                    print("❌ Empty response data.")
                }
            case .failure(let error):
                print("❌ Upload failed:", error.localizedDescription)
                self.retryUpload(param: param, images: arrImage, mediaKey: mediaKey, URlName: URlName, withblock: withblock)
            }
        }
    }
    
    // MARK - function for handle retry multipart iamge
    func retryUpload(param: [String: Any], images: [UIImage],  mediaKey: String, URlName: String, withblock: @escaping () -> Void) {
        self.callsendMediaAPI(param: param, arrImage: images,mediaKey: mediaKey,URlName: URlName,withblock: withblock)
    }
    
    // MARK - function for handle image size
    func isImageSizeValid(_ image: UIImage, maxSizeKB: Int = 5048) -> Bool {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let imageSizeKB = imageData.count / 1024
            let imageSizeMB = Double(imageSizeKB) / 1024.0
            print("Image size: \(imageSizeKB) KB (\(String(format: "%.2f", imageSizeMB)) MB)")
            return imageSizeKB <= maxSizeKB
        }
        print("❌ Could not convert image to data")
        return false
    }
}

@available(iOS 16.0, *)
//MARK: - :  Extenison for UIImagePickerControllerDelegate
extension UpdateGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK  function for handle didFinishPickingMediaWithInfo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[.originalImage] as? UIImage) else { return }
        picker.dismiss(animated: true, completion: nil)
        self.profileImgView.image = image
        self.selectedImge = image
        showCrop(image: image)  // only this
    }

    
    // MARK - function for handle image crop
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "continue"
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    // MARK - function for handle image crop after finished
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    // MARK - function for handle image crop delegate
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        self.profileImgView.image = image
        self.selectedImge = image
    }

    
    // MARK - function for open camera
    func openCameraGallery() {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker = UIImagePickerController()
                self.imagePicker?.sourceType = .camera
                self.imagePicker?.allowsEditing = false
                self.imagePicker?.delegate = self
                self.present(self.imagePicker!, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker = UIImagePickerController()
                self.imagePicker?.sourceType = .photoLibrary
                self.imagePicker?.allowsEditing = false
                self.imagePicker?.delegate = self
                self.present(self.imagePicker!, animated: true, completion: nil)
            } else {
                print("Photo library not available")
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in }))
        self.present(alert, animated: true, completion: { print("completion block") })
    }
}
//MARK: - :  Marks ends here
