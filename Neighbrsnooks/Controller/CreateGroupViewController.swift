import UIKit
import Alamofire
import Photos

@available(iOS 16.0, *)
class CreateGroupViewController: BaseViewController,CropViewControllerDelegate, UITextViewDelegate {
    
    
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
    
    var Anyone = ""
    var ApprovedMember = ""
    var account = ""
    var CreateGroupData : CreateGroupModel?
    
    var imagePicker:UIImagePickerController?
    private weak var delegate: UIImagePickerControllerDelegate?
    var selectedImge: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
       
        
        tfGroupName.autocapitalizationType = .sentences
        tvaboutGroup.autocapitalizationType = .sentences
       
//        btnApprove.isSelected = true
//        account = "2"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

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
            } else if account == "" { // Check if no option is selected
                showAlert(message: "Please select who can join")
            } else {
                callCreateGroupWebService {
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

    
    func callCreateGroupWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: [String: Any] = [
            "createdby": id ?? "",
            "groupname": self.tfGroupName.text ?? "",
            "description": self.tvaboutGroup.text ?? "",
            "join_type": account
        ]
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            // Append parameters
            for (key, value) in dictParams {
                if let valueStr = value as? String, let valueData = valueStr.data(using: .utf8) {
                    multipartFormData.append(valueData, withName: key)
                }
            }
            
            // Append image (profilePic)
            if let profilePicData = self.profilePic.image?.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(profilePicData, withName: "groupimage", fileName: "\(NSDate().timeIntervalSince1970.rounded()).jpeg", mimeType: "image/jpeg")
            }
        },
        to: kBASEURL + WebServiceName.kCreateGroup,
        method: .post,
        headers: headers).response { response in
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
