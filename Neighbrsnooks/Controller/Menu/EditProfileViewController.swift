//
//  EditProfileViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 29/11/24.
//

import UIKit
import SVProgressHUD
import AVKit
 
import Kingfisher

@available(iOS 16.0, *)
class EditProfileViewController: UIViewController,CropViewControllerDelegate,PopupSelectionDelegate {
    
    @IBOutlet weak var lblAlittleMoreAbout: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblneighbourhood: UILabel!
    @IBOutlet weak var lblEmergencyContact: UILabel!
    @IBOutlet weak var neighbourhoodLblHeight: NSLayoutConstraint!
    @IBOutlet weak var interestLblHeight: NSLayoutConstraint!
    @IBOutlet weak var viewInterestHeight: NSLayoutConstraint!
    @IBOutlet weak var mainNeigHeight: UIView!
    @IBOutlet weak var viewIntrestHeight: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNameBig: UILabel!
    @IBOutlet weak var lblSecName: UILabel!
    @IBOutlet weak var tfGender: UITextField!
    @IBOutlet weak var lblDo: UILabel!
    @IBOutlet weak var tfIntrest: UILabel!
    @IBOutlet weak var tfNeighbour: UILabel!
    @IBOutlet weak var tfDob: UITextField!
    @IBOutlet weak var tfEmergency: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var dropTower: UIButton!
    @IBOutlet var dropIntrest: UIButton!
    
    @IBOutlet weak var viewThankYou: UIView!
    @IBOutlet weak var lblThank: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var viewCornerRed: UIView!
    
    
    @IBOutlet weak var intDropDown: UIImageView!
    @IBOutlet weak var whatDoDropDown: UIImageView!
    @IBOutlet weak var neigDropDown: UIImageView!
    
    
    
    
    var selectedItems: [String] = []
    
    var selectedInterestItems: [String] = []
    var selectedNeighbourItems: [String] = []
    var staticLabel: UILabel!
    
    let pickerView = UIPickerView()
    let doPickerView = UIPickerView()
    
    var name = ""
    var secname = ""
    var Neighbourname : String! = nil
//    var GenderDropdownData = DropDown()
    var AddProjectData : ProffessionModel?
    var profileData : ProfileModel?
    var IntrsetData : IntrestModel?
    var NeighbourData : NeighbourModel?
//    var serviceDropdownData = DropDown()
    var serviceName = [String]()
//    var IntrestDropdownData = DropDown()
    var attributedItems: [NSAttributedString] = []
    var intrsetName = [String]()
//    var NeighbourDropdownData = DropDown()
    var NeighbourName = [String]()
    var genderList = ["Select Gender"," Male"," Female"," Other"]
    let boldText = "This is bold text."
    var serviceId : String?
    var selectedImge: UIImage? = nil
    var userid : String?
    //    var MoreData : RegisterFirstModel?
    var MoreDataF : Welcome?
    var isCircularWithStroke: Bool = false
    // var colorArray: [String] = []
    
    var ProfileUpload = ""
    var overlayView: UIView!
    
    let items = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    let timePicker = UIDatePicker()
    let datePicker = UIDatePicker()
    var timePickerContainer = UIView()
    // var selectedAnswer : String = "blank"
    
    var imagePicker:UIImagePickerController?
    private weak var delegate: UIImagePickerControllerDelegate?
    let color = UIColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        updateInterestViewHeight() // Initial height update
        
        // Retrieve from UserDefaults
        let firstName = UserDefaults.standard.string(forKey: "FirstName") ?? "No First Name"
        let lastName = UserDefaults.standard.string(forKey: "LastName") ?? "No Last Name"
        
        // Set labels
        lblName.text = firstName
        lblSecName.text = lastName
        NetworkMonitor.shared.startMonitoring()
         
        viewCornerRed.layer.cornerRadius = 10
        viewCornerRed.clipsToBounds = false // Important: shadow ke liye false karein
        viewCornerRed.layer.shadowColor = UIColor.gray.cgColor
        viewCornerRed.layer.shadowOpacity = 0.2 // Shadow visibility (0 to 1)
        viewCornerRed.layer.shadowOffset = CGSize(width: 0, height: 3) // Shadow direction
        viewCornerRed.layer.shadowRadius = 4 // Blur effect
        viewCornerRed.layer.borderWidth = 0.1
        viewCornerRed.layer.borderColor = UIColor.lightGray.cgColor

        
        viewCornerRed.layer.borderColor = UIColor.lightGray.cgColor
        lblProfession.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblProfession.tintColor = .darkGray
        lblneighbourhood.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblneighbourhood.tintColor = .darkGray
        lblInterest.tintColor = .darkGray
        lblInterest.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblEmergencyContact.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblEmergencyContact.tintColor = .darkGray
        tfEmergency.font = UIFont(name: "Montserrat-Regular", size: 14)
        tfEmergency.tintColor = .darkGray
        lblAlittleMoreAbout.font = UIFont(name: "Montserrat-Regular", size: 20)
        
        
        lblName.text = name ?? "Name not provided"
        lblSecName.text = secname ?? "Surname not provided"
        getCustomImage(imageDisplayName: lblName.text, imageView: profilePic)
        
        lblName.font = UIFont.boldSystemFont(ofSize: 60)
        viewThankYou.isHidden = true
        self.lblThank.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        lblDo.text = "Select"
        tfIntrest.text = "Select "
        tfNeighbour.text = "Select"
        
        callUserProfileWebService {
               print("Profile data fetched successfully")
           }
        
        
        
        
        
        
        // Adding tap gestures to both the labels and dropdowns
        // Adding tap gestures for profession label and image
        let professionLabelTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
        lblDo.isUserInteractionEnabled = true
        lblDo.addGestureRecognizer(professionLabelTap)
        
        let professionImageTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
        whatDoDropDown.isUserInteractionEnabled = true
        whatDoDropDown.addGestureRecognizer(professionImageTap)
        
        // Adding tap gestures for interest label and image
        let interestLabelTap = UITapGestureRecognizer(target: self, action: #selector(interestLabelTapped))
        tfIntrest.isUserInteractionEnabled = true
        tfIntrest.addGestureRecognizer(interestLabelTap)
        
        let interestImageTap = UITapGestureRecognizer(target: self, action: #selector(interestLabelTapped))
        intDropDown.isUserInteractionEnabled = true
        intDropDown.addGestureRecognizer(interestImageTap)
        
        // Adding tap gestures for neighbour label and image
        let neighbourLabelTap = UITapGestureRecognizer(target: self, action: #selector(neighbourLabelTapped))
        tfNeighbour.isUserInteractionEnabled = true
        tfNeighbour.addGestureRecognizer(neighbourLabelTap)
        
        let neighbourImageTap = UITapGestureRecognizer(target: self, action: #selector(neighbourLabelTapped))
        neigDropDown.isUserInteractionEnabled = true
        neigDropDown.addGestureRecognizer(neighbourImageTap)
        
        
        
        //         end
        
        self.intrsetName.append("Select Intrest")
        self.serviceName.append("Select Profession")
        //   self.genderList.append("Select Gender")
        self.NeighbourName.append("Select our Love Neighbourhood")
        
        viewThankYou.layer.shadowColor = UIColor.gray.cgColor
        viewThankYou.layer.shadowOpacity = 0.5
        viewThankYou.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewThankYou.layer.shadowRadius = 5
        viewThankYou.layer.masksToBounds = false
        
        
        self.lblName.font = UIFont(name: "Montserrat-Medium", size: 20)
        self.lblSecName.font = UIFont(name: "Montserrat-Medium", size: 20)
        
        
        
        self.lblProfession.font = UIFont(name: "Montserrat-Medium", size: 16)
        lblProfession.textColor = .darkGray
        self.lblInterest.font = UIFont(name: "Montserrat-Medium", size: 16)
        lblInterest.textColor = .darkGray
        self.lblneighbourhood.font = UIFont(name: "Montserrat-Medium", size: 16)
        lblneighbourhood.textColor = .darkGray
        self.lblEmergencyContact.font = UIFont(name: "Montserrat-Medium", size: 16)
        lblEmergencyContact.textColor = .darkGray
        self.lblDo.font = UIFont(name: "Montserrat-Regular", size: 14)
        lblDo.textColor = .darkGray
        
        self.tfIntrest.font = UIFont(name: "Montserrat-Regular", size: 14)
        tfIntrest.textColor = .darkGray
        self.tfNeighbour.font = UIFont(name: "Montserrat-Regular", size: 14)
        tfNeighbour.textColor =  .darkGray
        let dateFormatter = Date.createPassiveFormatter(format: DateFormat.utc)
        datePicker.minimumDate = dateFormatter.date(from: "1980-04-01T00:00:00Z")
        datePicker.maximumDate = dateFormatter.date(from: "2011-04-01T00:00:00Z")
        datePicker.preferredDatePickerStyle = .inline
        
        
        
//        self.GenderDropdownData.dataSource = self.genderList
        showStartDatePicker()
        CallProffesoinWebService()
        CallIntrestWebService()
        CallNeighbourWebService()
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer)
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        //        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
//        DropDown.appearance().setupCornerRadius(10)
        
        tfIntrest.numberOfLines = 0 // Allow label to have multiple lines
        tfIntrest.lineBreakMode = .byWordWrapping
        //        adjustLabelHeight()
        
    }
    
    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
    }
    
    @objc func professionLabelTapped() {
        showPopup(for: 1, allowMultipleSelection: false, hideOkButton: true) // lblDo ke liye OK button hidden
    }
    
    @objc func interestLabelTapped() {
        showPopup(for: 2, allowMultipleSelection: true, hideOkButton: false) // OK button visible
    }
    
    @objc func neighbourLabelTapped() {
        showPopup(for: 3, allowMultipleSelection: true, hideOkButton: false) // OK button visible
    }
    
    func showPopup(for labelTag: Int, allowMultipleSelection: Bool, hideOkButton: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "RegisterFirstPopupVC") as? RegisterFirstPopupVC {
            popupVC.allowMultipleSelection = allowMultipleSelection
            popupVC.hideOkButton = hideOkButton // Pass flag to control OK button visibility
            
            if labelTag == 1 {
                if let professionData = AddProjectData?.nbdata.map({ $0.memberTitle }) {
                    popupVC.data = professionData
                }
            } else if labelTag == 2 {
                if let interestData = IntrsetData?.nbdata.map({ $0.memberTitle }) {
                    popupVC.data = interestData
                }
                popupVC.selectedItems = selectedInterestItems
            } else if labelTag == 3 {
                if let neighbourData = NeighbourData?.nbdata.map({ $0.memberTitle }) {
                    popupVC.data = neighbourData
                }
                popupVC.selectedItems = selectedNeighbourItems
            }
            
            popupVC.labelTag = labelTag
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            self.present(popupVC, animated: true, completion: nil)
        }
    }
    
    func didSelectItems(selectedItems: [String], forLabel tag: Int) {
        let selectedItemsString = selectedItems.isEmpty ? "Select" : selectedItems.joined(separator: ", ")
        
        if tag == 1 {
            lblDo.text = selectedItems.first ?? "Select"
        } else if tag == 2 {
            selectedInterestItems = selectedItems
            tfIntrest.text = selectedItemsString
            //            updateInterestViewHeight() // Update height after text change
        } else if tag == 3 {
            selectedNeighbourItems = selectedItems
            tfNeighbour.text = selectedItemsString
        }
    }
    
    
    func updateContainerViewHeight() {
        // Calculate the height of the label
        let labelSize = tfIntrest.sizeThatFits(CGSize(width: tfIntrest.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let labelHeight = labelSize.height
        
        // Update the height of the containerView
        var containerFrame = containerView.frame
        containerFrame.size.height = labelHeight
        containerView.frame = containerFrame
        
        // Optionally, you might need to update layout constraints if you're using Auto Layout
        containerView.layoutIfNeeded()
    }
    
    
    
    
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    
    
    
    func getCustomImage(imageDisplayName: String?, imageView: UIImageView!){
        if let name = imageDisplayName, !name.isEmpty {
            imageView.setImage(string:name, color: UIColor.colorHash(name: name), circular: isCircularWithStroke, stroke: isCircularWithStroke)
            
            
            //  let imageDisplayName = CGSize(width: 20, height: 20)
        }else{
            imageView.setImage(string:"Display Picture", color: UIColor.colorHash(name: "Display Picture"), circular: isCircularWithStroke, stroke: isCircularWithStroke)
        }
        
    }
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    @objc func imageViewTapped(_ sender:AnyObject){
        //   selectPictureThroughPhotoGallery()
        openCameraGallery()
        
    }
    
    
    func showStartDatePicker(){
        
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        datePickerMethod()
        
    }
    
    private func datePickerMethod() {
        
        let currentDate: Date = Date()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        
        components.year = -100
        // let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        //datePicker.minimumDate = Date()
        datePicker.maximumDate = Date()
        datePicker.maximumDate = datePicker.maximumDate
    }
    
    @objc func doneDatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        //        tfDob.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    @IBAction func nextBtn(_ sender: UIButton){
        //        adjustLabelHeight()
        // Pehle API call hogi
        callMoreYouWebService { [weak self] in
            guard let self = self else { return }
            // Uske baad MyProfileViewController ko push karein
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    @IBAction func actionSkip(_ sender: Any) {
        
        
        // callMoreYouWebService{ [self] in
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //     viewThankYou.isHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    //    }
    
    
    //MARK: - Function to fetch user profile and handle the response
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let loggedUser = UserDefaults.standard.string(forKey: "loggeduser") ?? ""
        
        let dictParams: [String: Any] = [
            "userid": id,
            "loggeduser": loggedUser // loggedUser ko use karna chahiye
        ]
        print(dictParams)
        
        // Call the web service
        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { (data: ProfileModel?) in
            guard let data = data else {
                print("Error: API response is nil")
                completionClosure()
                return
            }

            // **Assign API response to profileData**
            self.profileData = data

            // **Update UI on the main thread**
            DispatchQueue.main.async {
                self.updateProfileUI()
            }

            completionClosure()
        }
    }

    

    func updateProfileUI() {
        lblDo.text = profileData?.intersttype ?? "N/A"
        tfNeighbour.text = profileData?.reason ?? "N/A"
        tfIntrest.text = profileData?.nbrsType ?? "N/A"
        tfEmergency.text = profileData?.emerPhone
        
        if let imageUrl = profileData?.userpic, let url = URL(string: imageUrl) {
            profilePic.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            profilePic.image = UIImage(named: "placeholder") // Default image
        }
    }


  
    func CallProffesoinWebService() {
        
        let dictParams: Dictionary<String, Any> = ["":""]
        
        WebService.sharedInstance.CallProffesoinWebService(withParams: dictParams) { data in
            self.AddProjectData = data
            UserDefaults.standard.set(self.AddProjectData?.nbdata.first?.id, forKey: "id")
            for value in self.AddProjectData?.nbdata ?? [] {
                self.serviceName.append(value.memberTitle ?? "")
            }
//            self.serviceDropdownData.dataSource = self.serviceName
            //    self.ServiceDescriptionLabel.text = self.ServiceTypeData?.data.servicede
            
            
        }
    }
    
    @IBAction func btnThank(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func CallIntrestWebService() {
        
        let dictParams: Dictionary<String, Any> = ["":""]
        
        WebService.sharedInstance.CallIntrestWebService(withParams: dictParams) { data in
            self.IntrsetData = data
            UserDefaults.standard.set(self.IntrsetData?.nbdata.first?.id, forKey: "id")
            for value in self.IntrsetData?.nbdata ?? [] {
                self.intrsetName.append(value.memberTitle ?? "")
            }
//            self.IntrestDropdownData.dataSource = self.intrsetName
 
         }
    }
    
    func CallNeighbourWebService() {
        let dictParams: Dictionary<String, Any> = ["":""]
        WebService.sharedInstance.CallNeighbourWebService(withParams: dictParams) { data in
            self.NeighbourData = data
            for value in self.NeighbourData?.nbdata ?? [] {
                self.NeighbourName.append(value.memberTitle ?? "")
            }
//            self.NeighbourDropdownData.dataSource = self.NeighbourName
        }
    }
    
    func callMoreYouWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idProfession = UserDefaults.standard.string(forKey: "id")
        let idIntrest = UserDefaults.standard.string(forKey: "id")
        
        
        let dictParams: Dictionary<String, Any> = [
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
             "profession":idProfession ?? 0,
            "interest":idIntrest ?? 0,
             "reason":self.tfNeighbour.text ?? "",
            "emerphoneno":self.tfEmergency.text ?? "",
            "userid":id ?? "",
//             "userid": userid ?? "",
            "userpic": ""
        ]
 
        WebService.sharedInstance.callMoreYouWebService(withParams: dictParams) { data in
            self.MoreDataF = data
            completionClosure()
        }
    }
    
}


@available(iOS 16.0, *)
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        // volunteerProfileVM.profileImg = image
        picker.dismiss(animated: true, completion: nil)
        //   imageview.image = image
        showCrop(image: image)
        self.profilePic.image = image
        self.selectedImge = image
    }
    
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
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
        //rajuuuuu
        
        
    }
    
    
    func openCameraGallery()
    {
        
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
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
}
