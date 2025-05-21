import UIKit
import Alamofire
import Photos

@available(iOS 16.0, *)
class CreateGroupViewController: BaseViewController,CropViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    
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

    var Anyone = ""
    var ApprovedMember = ""
    var account = ""
    var CreateGroupData : CreateGroupModel?
    var isCreatingGroup = false
    var imagePicker:UIImagePickerController?
    private weak var delegate: UIImagePickerControllerDelegate?
    var selectedImge: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
        NetworkMonitor.shared.startMonitoring()
        tfGroupName.delegate = self
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
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
        //  profilePic.layer.cornerRadius = profilePic.frame.height / 2
        
        //   updateCollectionView()
        
        tfGroupName.autocapitalizationType = .words
        tvaboutGroup.autocapitalizationType = .words
        
        //        btnApprove.isSelected = true
        //        account = "2"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            GroupNameView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImgView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            AboutGroupView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            JoinView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            btnAnyone.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            btnApprove.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            GroupNameView.layer.borderWidth = 1.0 // Enable border in dark mode
            UploadImgView.layer.borderWidth = 1.0
            AboutGroupView.layer.borderWidth = 1.0
            JoinView.layer.borderWidth = 1.0 // Enable border in dark mode
            GroupView.backgroundColor = .black
            GroupNameView.backgroundColor = .black
            UploadImgView.backgroundColor = .black
            btnAnyone.backgroundColor = .white
            btnApprove.backgroundColor = .white
            btnAnyone.setTitleColor(.black, for: .normal) // Adjust text color for contrast
            btnApprove.setTitleColor(.black, for: .normal)
        } else {
            GroupNameView.isUserInteractionEnabled = true
            UploadImgView.isUserInteractionEnabled = true
            AboutGroupView.isUserInteractionEnabled = true
            JoinView.isUserInteractionEnabled = true
            GroupNameView.layer.borderWidth = 0 // Remove border in light mode
            AboutGroupView.layer.borderWidth = 0
            UploadImgView.layer.borderWidth = 0
            JoinView.layer.borderWidth = 0 // Remove border in light mode
            GroupNameView.backgroundColor = .white
            UploadImgView.backgroundColor = .white
            GroupView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            btnAnyone.layer.borderColor = UIColor.white.cgColor
            btnApprove.layer.borderColor = UIColor.white.cgColor
            btnAnyone.backgroundColor = .white
            btnApprove.backgroundColor = .white
            btnAnyone.setTitleColor(.black, for: .normal) // Adjust text color for contrast
            btnApprove.setTitleColor(.black, for: .normal)
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        // Show or hide placeholder label based on text view content
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @IBAction func AnyOneBtnAction(_ sender: UIButton) {
        btnAnyone.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnApprove.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "1"
        
    }
    
    @IBAction func ApprovedBtnAction(_ sender: UIButton) {
        btnApprove.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btnAnyone.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "0"
        
    }
    
    @objc func imageViewTapped(_ sender:AnyObject){
        //   selectPictureThroughPhotoGallery()
        openCameraGallery()
        
    }
    
    @IBAction func PicUploadBtnAction(_ sender: UIButton) {
        
        openCameraGallery()
    }
    
    
    @IBAction func CreateBtn(_ sender: UIButton){
        
        if tfGroupName.text == "" {
            showAlert(message: "Please enter group name")
        } else if tvaboutGroup.text == "" {
            showAlert(message: "Please enter group description")
        } else if account == "" {
            showAlert(message: "Please select who can join")
        } else {
            sender.isEnabled = false // disable button
            callCreateGroupWebService {
                sender.isEnabled = true // re-enable after completion
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 18, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
        )
        
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfGroupName {
            // Get the current text in the text field
            let currentText = textField.text ?? ""
            
            // Create the new string after applying the replacement
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // If the character count exceeds 22, prevent further changes
            if updatedText.count > 30 {
                return false
            }
            
            return true
        }
        
        return true
    }
    
    
    
    
    
    
    func callCreateGroupWebService(_ completionClosure: @escaping () -> ()) {
        guard !isCreatingGroup else { return }
        isCreatingGroup = true
        
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: [String: Any] = [
            "createdby": id ?? "",
            "groupname": self.tfGroupName.text ?? "",
            "description": self.tvaboutGroup.text ?? "",
            "join_type": account
        ]
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in dictParams {
                if let valueStr = value as? String, let valueData = valueStr.data(using: .utf8) {
                    multipartFormData.append(valueData, withName: key)
                }
            }
            
            if let profilePicData = self.profilePic.image?.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(profilePicData, withName: "groupimage", fileName: "\(NSDate().timeIntervalSince1970.rounded()).jpeg", mimeType: "image/jpeg")
            }
        },
                  to: kBASEURL + WebServiceName.kCreateGroup,
                  method: .post,
                  headers: headers).response { response in
            self.isCreatingGroup = false  // Reset the flag
            
            if response.error == nil {
                do {
                    if let jsonData = response.data {
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]
                        print(parsedData)
                        
                        if let status = parsedData["status"] as? String, status == "success" {
                            completionClosure()
                        } else {
                            let message = parsedData["message"] as? String ?? "Unknown error"
                            self.showAlert(Message: message)
                        }
                    }
                } catch {
                    print("Error parsing response: \(error)")
                }
            } else {
                print("Upload error: \(response.error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    
}


@available(iOS 16.0, *)
extension CreateGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        picker.dismiss(animated: true, completion: nil)
        showCrop(image: image)
        
        self.profilePic.image = image
        self.selectedImge = image
        
        updateProfileImageView() // ✅ Yeh line add karein
    }
    
    
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "continue"
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        print("Did crop")
        
        // Assign the cropped image to profilePic
        self.profilePic.image = image
        self.selectedImge = image
        
        updateProfileImageView() // ✅ Yeh line zaroori hai
    }
    
    
    
    
    func openCameraGallery() {
        let alert = UIAlertController()
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            print("User clicked Camera button")
            
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
            print("User clicked Gallery button")
            
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
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            print("User clicked Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    
    
    func updateProfileImageView() {
        if let _ = profilePic.image {
            // 🟢 Image available -> Height 150
            profilePicHeight.constant = 150
        } else {
            // 🔴 No image -> Height 0
            profilePicHeight.constant = 0
        }
        
        // Animate layout changes for smooth effect
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func resetProfileImage() {
        self.profilePic.image = nil
        self.selectedImge = nil
        
        updateProfileImageView() // ✅ Height 0 hone ke liye
    }
    
    
}
