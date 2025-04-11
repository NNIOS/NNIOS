//
//  RegisterFirstViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
  
import SVProgressHUD
import TOCropViewController
import Alamofire
import SwiftUI



@available(iOS 16.0, *)
class RegisterFirstViewController: UIViewController,PopupSelectionDelegate {
    
    @IBOutlet weak var lblAlittleMoreAbout: UILabel!
    
    
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblneighbourhood: UILabel!
    @IBOutlet weak var lblEmergencyContact: UILabel!
    
    @IBOutlet weak var neighbourhoodLblHeight: NSLayoutConstraint!
    @IBOutlet weak var interestLblHeight: NSLayoutConstraint!
    @IBOutlet weak var viewInterestHeight: NSLayoutConstraint!
    
     
    
    @IBOutlet weak var viewIntrestHeight: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSecName: UILabel!

    @IBOutlet weak var lblDo: UILabel!
    @IBOutlet weak var tfIntrest: UILabel!
    
    @IBOutlet weak var tfNeighbour: UILabel!
     
    @IBOutlet weak var tfEmergency: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    
    
    @IBOutlet weak var viewThankYou: UIView!
    @IBOutlet weak var lblThank: UILabel!
    
    
    
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
    var imageArray = [UIImage]()
    // var selectedAnswer : String = "blank"
    
    var imagePicker:UIImagePickerController?
    private weak var delegate: UIImagePickerControllerDelegate?
    
    let color = UIColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
//        updateInterestViewHeight() // Initial height update
        
        // Retrieve from UserDefaults
                let firstName = UserDefaults.standard.string(forKey: "FirstName") ?? "No First Name"
                let lastName = UserDefaults.standard.string(forKey: "LastName") ?? "No Last Name"
                
                // Set labels
                lblName.text = firstName
                lblSecName.text = lastName
        NetworkMonitor.shared.startMonitoring()
        //        lblYourneighbhood.font = UIFont(name: "Montserrat-Regular", size: 16)
        //        lblYourneighbhood.textColor = .darkGray
        viewCornerRed.layer.cornerRadius = 10
        viewCornerRed.clipsToBounds = true
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
        
        
        
       
        
        
        //                tfGender.inputView = pickerView
        //                tfDo.inputView = pickerView
        
        
        // Create a toolbar with a Done button
        //                let toolbar = UIToolbar()
        //                toolbar.sizeToFit()
        //
        //                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        //                toolbar.setItems([doneButton], animated: true)
        
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
    
//
//    func updateContainerViewHeight() {
//        // Calculate the height of the label
//        let labelSize = tfIntrest.sizeThatFits(CGSize(width: tfIntrest.frame.width, height: CGFloat.greatestFiniteMagnitude))
//        let labelHeight = labelSize.height
//
//        // Update the height of the containerView
//        var containerFrame = containerView.frame
//        containerFrame.size.height = labelHeight
//        containerView.frame = containerFrame
//
//        // Optionally, you might need to update layout constraints if you're using Auto Layout
//        containerView.layoutIfNeeded()
//    }
    
    
//    private func updateInterestViewHeight() {
//           let maxLabelWidth = tfIntrest.frame.width
//           let maxHeight: CGFloat = 200.0 // Set a maximum height if needed
//
//           // Calculate height required for the label text
//           let newSize = tfIntrest.sizeThatFits(CGSize(width: maxLabelWidth, height: CGFloat.greatestFiniteMagnitude))
//           let calculatedHeight = min(newSize.height, maxHeight)
//
//           // Update constraints
//           interestLblHeight.constant = max(calculatedHeight, 70) // Default 100, adjusts for text
//           viewInterestHeight.constant = interestLblHeight.constant + 20 // Add padding if needed
//
//           // Animate layout changes (optional)
//           UIView.animate(withDuration: 0.3) {
//               self.view.layoutIfNeeded()
//           }
//       }
    
    
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    //    func updateContainerViewHeight() {
    //        let labelSize = tfIntrest.sizeThatFits(CGSize(width: tfIntrest.frame.width, height: CGFloat.greatestFiniteMagnitude))
    //        containerHeightConstraint.constant = labelSize.height
    //        view.layoutIfNeeded() // Animate if needed
    //    }
    
    
    
    func getCustomImage(imageDisplayName: String?, imageView: UIImageView!) {
        if let name = imageDisplayName, !name.isEmpty {
            // Extract initials
            let initials = name.components(separatedBy: " ").compactMap { $0.first }.map { String($0) }.joined()

            // Convert initials to image
            if let initialsImage = generateInitialsImage(initials: initials) {
                imageView.image = initialsImage
                
                // Convert image to JPEG and upload
                if let jpegData = initialsImage.jpegData(compressionQuality: 0.5) {
                    let jpegImage = UIImage(data: jpegData)
                    imageArray = [jpegImage!]
                    callProfileUploadWebService {
                        print("Profile initials image uploaded successfully.")
                    }
                }
            }
        } else {
            imageView.setImage(string: "Display Picture", color: UIColor.colorHash(name: "Display Picture"), circular: isCircularWithStroke, stroke: isCircularWithStroke)
        }
    }

    
    //    @objc func donePressed() {
    //            tfGender.resignFirstResponder()
    //        }
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    @IBAction func serviceBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //        self.showDropdownData(showOn: tfDo, DropdownName: serviceDropdownData)
        //        serviceDropdownData.cellHeight = 35
        //
        //        serviceDropdownData.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
        //  serviceDropdownData.bottomOffset = CGPoint(x: 50, y: 24)
        // self.ServiceDescriptionLabel.text = self.ServiceTypeData?.data.seri
    }
    
    @IBAction func intrstBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
////        self.intrestNewDropdownData(showOn: tfIntrest, DropdownName: IntrestDropdownData)
//        IntrestDropdownData.cellHeight = 35
//        IntrestDropdownData.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
    }
    
    @IBAction func neighborBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
//        self.neigbourNewNewDropdownData(showOn: tfNeighbour, DropdownName: NeighbourDropdownData)
//        NeighbourDropdownData.cellHeight = 35
//        NeighbourDropdownData.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
//        // self.ServiceDescriptionLabel.text = self.ServiceTypeData?.data.seri
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
        
        //        tfDob.inputAccessoryView = toolbar
        //        tfDob.inputView = datePicker
        
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
        
        
               
        callMoreYouWebService{ [self] in
//            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            viewThankYou.isHidden = false
//            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
        
        
   
    }
    
    
    @IBAction func actionSkip(_ sender: Any) {
        
        
// callMoreYouWebService{ [self] in
     let vc  = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//     viewThankYou.isHidden = false
     self.navigationController?.pushViewController(vc, animated: true)
     
     
 }

//    }
    
    
//    func callProfileUploadWebService(_ completionClosure: @escaping () -> ()) {
//        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
//
//        // Base parameters
//        var params: [String: Any] = ["userid": userId]
//
//        if imageArray.isEmpty {
//            // If no image, send a predefined value for the "userpic" parameter
//            params["userpic"] = "deleted" // Use the server-defined value for deletion
//            AF.request(kBASEURL + WebServiceName.kUploadPhoto, method: .post, parameters: params, encoding: URLEncoding.default).response { response in
//                if let error = response.error {
//                    print("Error in upload: \(error.localizedDescription)")
//                } else {
//                    do {
//                        if let jsonData = response.data {
//                            let parsedData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
//                            print("Response: \(String(describing: parsedData))")
//                            if let status = parsedData?["status"] as? String, status == "success" {
//                                print("Profile photo successfully deleted on server.")
//                            } else {
//                                print("Failed to delete profile photo: \(parsedData?["message"] ?? "Unknown error")")
//                            }
//                            completionClosure()
//                        }
//                    } catch {
//                        print("Error parsing response: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
// else {
//            // If there's an image, call the upload function with the image array
//            callsendImageAPI(param: params, arrImage: imageArray, imageKey: "userpic", URlName: kBASEURL + WebServiceName.kUploadPhoto) {
//                completionClosure()
//            }
//        }
//    }
    
//    func callsendImageAPI(param: [String: Any], arrImage: [UIImage], imageKey: String, URlName: String, withblock: @escaping () -> Void) {
//        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
//
//        AF.upload(multipartFormData: { (multipartFormData) in
//            // Append all parameters
//            for (key, value) in param {
//                if let value = value as? String {
//                    multipartFormData.append(Data(value.utf8), withName: key)
//                }
//            }
//
//            // Append images
//            for img in arrImage {
//                if let imgData = img.jpegData(compressionQuality: 0.1) {
//                    let fileName = "\(NSDate().timeIntervalSince1970.rounded()).jpeg"
//                    multipartFormData.append(imgData, withName: imageKey, fileName: fileName, mimeType: "image/jpeg")
//                }
//            }
//        }, to: URlName, method: .post, headers: headers).response { response in
//            if let error = response.error {
//                print("Error in upload: \(error.localizedDescription)")
//            } else {
//                do {
//                    if let jsonData = response.data {
//                        let parsedData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
//                        print("Response: \(String(describing: parsedData))")
//                        withblock()
//                    }
//                } catch {
//                    print("Error parsing response: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
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
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController else {return}
        
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
            //            "dob":self.tfDob.text ?? "",
            //                                                    "gender":self.tfGender.text ?? "",
                        "profession":idProfession ?? 0,
                        "interest":idIntrest ?? 0,
            
//            "interest": tfIntrest.text ?? "",
//            "profession": lblDo.text ?? "",
            "reason":self.tfNeighbour.text ?? "",
            "emerphoneno":self.tfEmergency.text ?? "",
            "userid":id ?? "",
            // "userid": userid ?? "",
            "userpic": ""
        ]
        
//        WebService.sharedInstance.callMoreYouWebService(withParams: dictParams) {
//
//        }
        
        WebService.sharedInstance.callMoreYouWebService(withParams: dictParams) { data in
            self.MoreDataF = data
            completionClosure()
        }
    }
    
    
    
}



//extension RegisterFirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
//        // volunteerProfileVM.profileImg = image
//        picker.dismiss(animated: true, completion: nil)
//        //   imageview.image = image
//        showCrop(image: image)
//        self.profilePic.image = image
//        self.selectedImge = image
//    }
//
//    func showCrop(image: UIImage) {
//        let vc = CropViewController(croppingStyle: .default, image: image)
//        vc.aspectRatioPreset = .presetSquare
//        vc.aspectRatioLockEnabled = false
//        vc.toolbarPosition = .bottom
//        vc.doneButtonTitle = "Continue"
//        vc.cancelButtonTitle = "Quit"
//        vc.delegate = self
//        present(vc, animated: true)
//    }
//
//    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
//        cropViewController.dismiss(animated: true)
//    }
//
//    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        cropViewController.dismiss(animated: true)
//        print("Did crop")
//        //rajuuuuu
//
//
//    }
//
//
//    func openCameraGallery() {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
//            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//                print("Camera not available")
//                return
//            }
//            let picker = UIImagePickerController()
//            picker.sourceType = .camera
//            picker.delegate = self
//            self.present(picker, animated: true, completion: nil)
//        }))
//
//        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
//            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
//                print("Photo library not available")
//                return
//            }
//            let picker = UIImagePickerController()
//            picker.sourceType = .photoLibrary
//            picker.delegate = self
//            self.present(picker, animated: true, completion: nil)
//        }))
//
//        // Add the "Delete Photo" action
//        alert.addAction(UIAlertAction(title: "Delete Photo", style: .destructive, handler: { _ in
//          //  self.deletePhoto() // Call deletePhoto function to update profileImgView
//
//            // Send the API call to upload the change with a nil image
//            self.callProfileUploadWebService {
//                print("Profile photo deleted and updated on server.")
////                self.callUserProfileWebService{ [self] in
////                    let url = URL(string: (self.profileData?.userpic ?? ""))
////                    self.profileImgView.kf.indicatorType = .activity
////                   self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "letter-b"))
////                }
//            }
//        }))
//
//
//
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//
//}

@available(iOS 16.0, *)
extension RegisterFirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        picker.dismiss(animated: true, completion: nil)
        showCrop(image: image)
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
    
//    private func deletePhoto() {
//        // Get the user's name from UserDefaults or a placeholder
//        let userName = UserDefaults.standard.string(forKey: "username") ?? "User"
//        let firstLetter = String(userName.prefix(1)).uppercased()
//
//        // Create a UILabel to show the first letter
//        let label = UILabel()
//        label.frame = profileImgView.bounds
//        label.text = firstLetter
//        label.textColor = .white
//        label.backgroundColor = .gray // Set a default background color
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: profileImgView.bounds.height / 2)
//        label.clipsToBounds = true
//        label.layer.cornerRadius = profileImgView.bounds.height / 2
//
//        // Remove any existing subviews and add the label
//        profileImgView.subviews.forEach { $0.removeFromSuperview() }
//        profileImgView.addSubview(label)
//
//        // Call the API to update the server with a deleted photo
//        deletePhotoAndUpdateServer {
//            print("Profile updated with the first letter of the name.")
//        }
//    }


    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        handleSelectedImage(image)
    }

    func openCameraGallery() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                print("Camera not available")
                return
            }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("Photo library not available")
                return
            }
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }))

        // Add the "Delete Photo" action
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .destructive, handler: { _ in
          //  self.deletePhoto() // Call deletePhoto function to update profileImgView
            
            // Send the API call to upload the change with a nil image
            self.callProfileUploadWebService {
                print("Profile photo deleted and updated on server.")
//                self.callUserProfileWebService{ [self] in
//                    let url = URL(string: (self.profileData?.userpic ?? ""))
//                    self.profileImgView.kf.indicatorType = .activity
//                   self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "letter-b"))
//                }
            }
        }))
        
        

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }


    private func handleSelectedImage(_ image: UIImage) {
        // Compress the image
        guard let compressedImage = image.jpegData(compressionQuality: 0.5).flatMap(UIImage.init(data:)) else {
            print("Failed to compress image")
            return
        }

        // Set the profile image view
        profilePic.image = compressedImage

        // Prepare image for API upload
        imageArray = [compressedImage]

        // Call API to upload the image
        callProfileUploadWebService {
            print("Profile photo updated successfully.")

//            }
            
        }
        
    }
    
    func generateInitialsImage(initials: String, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            // Set background color
            UIColor.lightGray.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // Draw initials in the center
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.width / 2, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let textSize = initials.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            initials.draw(in: textRect, withAttributes: attributes)
        }
        return image
    }


    func callProfileUploadWebService(_ completionClosure: @escaping () -> ()) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        
        // Base parameters
        var params: [String: Any] = ["userid": userId]
        
        if imageArray.isEmpty {
            // If no image, send a predefined value for the "userpic" parameter
            params["userpic"] = "deleted" // Use the server-defined value for deletion
            AF.request(kBASEURL + WebServiceName.kUploadPhoto, method: .post, parameters: params, encoding: URLEncoding.default).response { response in
                if let error = response.error {
                    print("Error in upload: \(error.localizedDescription)")
                } else {
                    do {
                        if let jsonData = response.data {
                            let parsedData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                            print("Response: \(String(describing: parsedData))")
                            if let status = parsedData?["status"] as? String, status == "success" {
                                print("Profile photo successfully deleted on server.")
                            } else {
                                print("Failed to delete profile photo: \(parsedData?["message"] ?? "Unknown error")")
                            }
                            completionClosure()
                        }
                    } catch {
                        print("Error parsing response: \(error.localizedDescription)")
                    }
                }
            }
        }
 else {
            // If there's an image, call the upload function with the image array
            callsendImageAPI(param: params, arrImage: imageArray, imageKey: "userpic", URlName: kBASEURL + WebServiceName.kUploadPhoto) {
                completionClosure()
            }
        }
    }

    func deletePhotoAndUpdateServer(completion: @escaping () -> Void) {
        // Clear the image array to indicate deletion
        imageArray.removeAll()
        
        // Call the upload service with the "deleted" userpic parameter
        callProfileUploadWebService {
            print("Photo deletion handled successfully.")
            completion()
        }
    }


    func callsendImageAPI(param: [String: Any], arrImage: [UIImage], imageKey: String, URlName: String, withblock: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

        AF.upload(multipartFormData: { (multipartFormData) in
            // Append all parameters
            for (key, value) in param {
                if let value = value as? String {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
            }

            // Append images
            for img in arrImage {
                if let imgData = img.jpegData(compressionQuality: 0.1) {
                    let fileName = "\(NSDate().timeIntervalSince1970.rounded()).jpeg"
                    multipartFormData.append(imgData, withName: imageKey, fileName: fileName, mimeType: "image/jpeg")
                }
            }
        }, to: URlName, method: .post, headers: headers).response { response in
            if let error = response.error {
                print("Error in upload: \(error.localizedDescription)")
            } else {
                do {
                    if let jsonData = response.data {
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                        print("Response: \(String(describing: parsedData))")
                        withblock()
                    }
                } catch {
                    print("Error parsing response: \(error.localizedDescription)")
                }
            }
        }
    }

}





extension Date {
    // Creates a date exactly the same as the input string, with no adjustments for the user's local timezone
    // If no time stamp is provided, and a time component is required, the date returned is in UTC 00:00
    static func createPassiveFormatter(locale: String = "en_US_POSIX", format: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: locale)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let format = format {
            formatter.dateFormat = format
        }
        return formatter
    }
}
    enum DateFormat {
        static let utc = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }


extension UIColor {
    func toHexString() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let rgb: Int = (Int)(red * 255)<<16 | (Int)(green * 255)<<8 | (Int)(blue * 255)<<0
            return String(format: "#%06x", rgb)
        }
        
        return nil
    }
}
