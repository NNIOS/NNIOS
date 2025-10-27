import UIKit
import CropViewController
import Alamofire
import Photos

@available(iOS 16.0, *)
class CreateGroupViewController: BaseViewController,CropViewControllerDelegate {
    
    //MARK: - :  Outlets
    @IBOutlet weak var tfGroupName: UITextField!
    @IBOutlet weak var tvaboutGroup: UITextView!
    @IBOutlet weak var btnAnyone: UIButton!
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnHide: UIButton!
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var profilePicHeight: NSLayoutConstraint!
    @IBOutlet weak var lblUploadImg: UILabel!
    @IBOutlet weak var lblWho: UILabel!
    @IBOutlet weak var lblAnyone: UILabel!
    @IBOutlet weak var lblApproved: UILabel!
    @IBOutlet weak var GroupView: UIView!
    @IBOutlet weak var GroupNameView: UIView!
    @IBOutlet weak var AboutGroupView: UIView!
    @IBOutlet weak var JoinView: UIView!
    @IBOutlet weak var UploadImgView: UIView!
    
    //MARK: - :  Variables
    var Anyone = ""
    var account = ""
    var ApprovedMember = ""
    var isCreatingGroup = false
    var imageArray = [UIImage]()
    var selectedImge: UIImage? = nil
    var CreateGroupData : CreateGroupModel?
    var imagePicker:UIImagePickerController?
    private weak var delegate: UIImagePickerControllerDelegate?
    
    //MARK: - :  Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.contentMode = .scaleAspectFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        NetworkMonitor.shared.startMonitoring()
        tfGroupName.delegate = self
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.tfGroupName.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tvaboutGroup.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblUploadImg.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblWho.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblAnyone.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblApproved.font = UIFont(name: "Montserrat-Regular", size: 17)
        placeholderLabel.text = "About Group..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvaboutGroup.text.isEmpty
        tvaboutGroup.delegate = self
        updateProfileImageView()
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer)
        profilePic.layer.masksToBounds = true
        tfGroupName.autocapitalizationType = .words
        tvaboutGroup.autocapitalizationType = .sentences
    }
    
    //MARK: - :  Button's Action
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
    
    @IBAction func PicUploadBtnAction(_ sender: UIButton) {
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                openCameraGallery()
            }
        }
    }
    
    @IBAction func CreateBtn(_ sender: UIButton) {
        if Reach().isInternet() {
            validation()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @objc func imageViewTapped(_ sender:AnyObject){
        openCameraGallery()
    }
}

//MARK: - :  Extenison for UIImagePickerControllerDelegate
@available(iOS 16.0, *)
extension CreateGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK  function for handle didFinishPickingMediaWithInfo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        picker.dismiss(animated: true, completion: nil)
        showCrop(image: image)
        self.profilePic.image = image
        self.selectedImge = image
        updateProfileImageView()
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
        print("Did crop")
        self.profilePic.image = image
        self.selectedImge = image
        updateProfileImageView()
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

//MARK: - :  Extenison for UIViewController
extension CreateGroupViewController {
    
    // MARK - function for handle all validation
    func validation() {
        let groupName = tfGroupName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let groupDescription = tvaboutGroup.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if groupName.isEmpty { alertToast(Message: "Please enter group name"); return }
        else if containsBadWords(groupName) { alertToast(Message: "Group name contains inappropriate words"); return }
        else if groupDescription.isEmpty { alertToast(Message: "Please enter group description"); return }
        else if containsBadWords(groupDescription) { alertToast(Message: "Group description contains inappropriate words"); return }
        else if account == "" { alertToast(Message: "Please select who can join"); return }
        else {
            self.callCreateGroupApi()
        }
    }
    
    // MARK - function for call Create Group Api
    func callCreateGroupApi() {
        let request = CreateGroup_Request(
            name: tfGroupName.text ?? "",
            image: imageArray.isEmpty && selectedImge == nil ? "" : "hasImage",
            description: tvaboutGroup.text ?? "",
            join_type: account
        )
        
        var param: [String: String] = [
            "name": request.name,
            "image": request.image,
            "description": request.description,
            "join_type": request.join_type
        ]
        
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
        
        
        self.callsendMediaAPI(param: param, arrImage: uploadImages, mediaKey: "image", URlName: API.createGroup) {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK - function for handle to send multipart iamge
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
    
    // MARK - function for handle hide/show image
    func updateProfileImageView() {
        if let _ = profilePic.image {
            profilePicHeight.constant = 150
        } else {
            profilePicHeight.constant = 0
        }
        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
        }
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

//MARK: - :  Extenison for UITextFieldDelegate
extension CreateGroupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfGroupName {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if updatedText.count > 30 {
                return false
            }
            return true
        }
        return true
    }
}

//MARK: - :  Extenison for UITextViewDelegate
extension CreateGroupViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
