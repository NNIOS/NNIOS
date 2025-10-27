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
import CropViewController

@available(iOS 16.0, *)
class EditProfileViewController: UIViewController,CropViewControllerDelegate {
    
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
    
    
    
    var selectedProfessionItems: [String] = []
    var selectedItems: [String] = []
    var onUpdateAboutYou: (() -> Void)?
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
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //        updateInterestViewHeight() // Initial height update
//        
//        // Retrieve from UserDefaults
//        let firstName = UserDefaults.standard.string(forKey: "FirstName") ?? "No First Name"
//        let lastName = UserDefaults.standard.string(forKey: "LastName") ?? "No Last Name"
//        
//        // Set labels
//        lblName.text = firstName
//        lblSecName.text = lastName
//        NetworkMonitor.shared.startMonitoring()
//         
//        viewCornerRed.layer.cornerRadius = 10
//        viewCornerRed.clipsToBounds = false // Important: shadow ke liye false karein
//        viewCornerRed.layer.shadowColor = UIColor.gray.cgColor
//        viewCornerRed.layer.shadowOpacity = 0.2 // Shadow visibility (0 to 1)
//        viewCornerRed.layer.shadowOffset = CGSize(width: 0, height: 3) // Shadow direction
//        viewCornerRed.layer.shadowRadius = 4 // Blur effect
//        viewCornerRed.layer.borderWidth = 0.1
//        viewCornerRed.layer.borderColor = UIColor.lightGray.cgColor
//
//        
//        viewCornerRed.layer.borderColor = UIColor.lightGray.cgColor
//        lblProfession.font = UIFont(name: "Montserrat-Regular", size: 16)
//        lblProfession.tintColor = .darkGray
//        lblneighbourhood.font = UIFont(name: "Montserrat-Regular", size: 16)
//        lblneighbourhood.tintColor = .darkGray
//        lblInterest.tintColor = .darkGray
//        lblInterest.font = UIFont(name: "Montserrat-Regular", size: 16)
//        lblEmergencyContact.font = UIFont(name: "Montserrat-Regular", size: 16)
//        lblEmergencyContact.tintColor = .darkGray
//        tfEmergency.font = UIFont(name: "Montserrat-Regular", size: 14)
//        tfEmergency.tintColor = .darkGray
//        lblAlittleMoreAbout.font = UIFont(name: "Montserrat-Regular", size: 20)
//        
//        
//        lblName.text = name ?? "Name not provided"
//        lblSecName.text = secname ?? "Surname not provided"
//        getCustomImage(imageDisplayName: lblName.text, imageView: profilePic)
//        
//        lblName.font = UIFont.boldSystemFont(ofSize: 60)
//        viewThankYou.isHidden = true
//        self.lblThank.font = UIFont(name: "Montserrat-SemiBold", size: 16)
//        
//        lblDo.text = "Select"
//        tfIntrest.text = "Select "
//        tfNeighbour.text = "Select"
//        
//        callUserProfileWebService {
//               print("Profile data fetched successfully")
//           }
//        
//        
//        
//        
//        
//        
//        // Adding tap gestures to both the labels and dropdowns
//        // Adding tap gestures for profession label and image
//        let professionLabelTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
//        lblDo.isUserInteractionEnabled = true
//        lblDo.addGestureRecognizer(professionLabelTap)
//        
//        let professionImageTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
//        whatDoDropDown.isUserInteractionEnabled = true
//        whatDoDropDown.addGestureRecognizer(professionImageTap)
//        
//        // Adding tap gestures for interest label and image
//        let interestLabelTap = UITapGestureRecognizer(target: self, action: #selector(interestLabelTapped))
//        tfIntrest.isUserInteractionEnabled = true
//        tfIntrest.addGestureRecognizer(interestLabelTap)
//        
//        let interestImageTap = UITapGestureRecognizer(target: self, action: #selector(interestLabelTapped))
//        intDropDown.isUserInteractionEnabled = true
//        intDropDown.addGestureRecognizer(interestImageTap)
//        
//        // Adding tap gestures for neighbour label and image
//        let neighbourLabelTap = UITapGestureRecognizer(target: self, action: #selector(neighbourLabelTapped))
//        tfNeighbour.isUserInteractionEnabled = true
//        tfNeighbour.addGestureRecognizer(neighbourLabelTap)
//        
//        let neighbourImageTap = UITapGestureRecognizer(target: self, action: #selector(neighbourLabelTapped))
//        neigDropDown.isUserInteractionEnabled = true
//        neigDropDown.addGestureRecognizer(neighbourImageTap)
//        
//        
//        
//        //         end
//        
//        self.intrsetName.append("Select Intrest")
//        self.serviceName.append("Select Profession")
//        //   self.genderList.append("Select Gender")
//        self.NeighbourName.append("Select our Love Neighbourhood")
//        
//        viewThankYou.layer.shadowColor = UIColor.gray.cgColor
//        viewThankYou.layer.shadowOpacity = 0.5
//        viewThankYou.layer.shadowOffset = CGSize(width: 0, height: 0)
//        viewThankYou.layer.shadowRadius = 5
//        viewThankYou.layer.masksToBounds = false
//        
//        
//        self.lblName.font = UIFont(name: "Montserrat-Medium", size: 20)
//        self.lblSecName.font = UIFont(name: "Montserrat-Medium", size: 20)
//        
//        
//        
//        self.lblProfession.font = UIFont(name: "Montserrat-Medium", size: 16)
//        lblProfession.textColor = .darkGray
//        self.lblInterest.font = UIFont(name: "Montserrat-Medium", size: 16)
//        lblInterest.textColor = .darkGray
//        self.lblneighbourhood.font = UIFont(name: "Montserrat-Medium", size: 16)
//        lblneighbourhood.textColor = .darkGray
//        self.lblEmergencyContact.font = UIFont(name: "Montserrat-Medium", size: 16)
//        lblEmergencyContact.textColor = .darkGray
//        self.lblDo.font = UIFont(name: "Montserrat-Regular", size: 14)
//        lblDo.textColor = .darkGray
//        
//        self.tfIntrest.font = UIFont(name: "Montserrat-Regular", size: 14)
//        tfIntrest.textColor = .darkGray
//        self.tfNeighbour.font = UIFont(name: "Montserrat-Regular", size: 14)
//        tfNeighbour.textColor =  .darkGray
//        let dateFormatter = Date.createPassiveFormatter(format: DateFormat.utc)
//        datePicker.minimumDate = dateFormatter.date(from: "1980-04-01T00:00:00Z")
//        datePicker.maximumDate = dateFormatter.date(from: "2011-04-01T00:00:00Z")
//        datePicker.preferredDatePickerStyle = .inline
//        
//        
//        
////        self.GenderDropdownData.dataSource = self.genderList
//        showStartDatePicker()
//        CallProffesoinWebService()
//        CallIntrestWebService()
//        CallNeighbourWebService()
//        
//        self.imagePicker = UIImagePickerController()
//        self.imagePicker?.delegate = self
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
//        profilePic.isUserInteractionEnabled = true
//        profilePic.addGestureRecognizer(tapGestureRecognizer)
//        profilePic.layer.masksToBounds = true
//        profilePic.layer.cornerRadius = profilePic.frame.height / 2
//        //        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
////        DropDown.appearance().setupCornerRadius(10)
//        
//        tfIntrest.numberOfLines = 0 // Allow label to have multiple lines
//        tfIntrest.lineBreakMode = .byWordWrapping
//        //        adjustLabelHeight()
//        
//    }
    
    
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
            lblName.font = UIFont.boldSystemFont(ofSize: 60)
            viewThankYou.isHidden = true
            self.lblThank.font = UIFont(name: "Montserrat-SemiBold", size: 16)
            
            lblDo.text = "Select"
            tfIntrest.text = "Select "
            tfNeighbour.text = "Select"
            
            callUserProfileWebService {
                print("Profile data fetched successfully")
                let userName = self.profileData?.username ?? ""
                let firstLetter = String(userName.prefix(1)).uppercased()
//                self.getCustomImage(imageDisplayName: self.lblName.text, imageView: self.profilePic)
                if let imageUrlString = self.profileData?.userpic,
                   let url = URL(string: imageUrlString),
                   !imageUrlString.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.profilePic.kf.indicatorType = .activity
                    self.profilePic.kf.setImage(with: url, placeholder: UIImage(named: "profile 1")) { result in
                        switch result {
                        case .success(_):
                            break
                        case .failure(_):
                            self.setInitialLetterProfile(firstLetter)
                        }
                    }
                } else {
                    self.setInitialLetterProfile(firstLetter)
                }
            }
//            let professionLabelTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
//            lblDo.isUserInteractionEnabled = true
//            lblDo.addGestureRecognizer(professionLabelTap)
//            
//            let professionImageTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
//            whatDoDropDown.isUserInteractionEnabled = true
//            whatDoDropDown.addGestureRecognizer(professionImageTap)
//            
//            let interestLabelTap = UITapGestureRecognizer(target: self, action: #selector(interestLabelTapped))
//            tfIntrest.isUserInteractionEnabled = true
//            tfIntrest.addGestureRecognizer(interestLabelTap)
//            
//            let interestImageTap = UITapGestureRecognizer(target: self, action: #selector(interestLabelTapped))
//            intDropDown.isUserInteractionEnabled = true
//            intDropDown.addGestureRecognizer(interestImageTap)
//            
//            let neighbourLabelTap = UITapGestureRecognizer(target: self, action: #selector(neighbourLabelTapped))
//            tfNeighbour.isUserInteractionEnabled = true
//            tfNeighbour.addGestureRecognizer(neighbourLabelTap)
//            
//            let neighbourImageTap = UITapGestureRecognizer(target: self, action: #selector(neighbourLabelTapped))
            neigDropDown.isUserInteractionEnabled = true
//            neigDropDown.addGestureRecognizer(neighbourImageTap)
            self.intrsetName.append("Select Intrest")
            self.serviceName.append("Select Profession")
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
            
    //        self.GenderDropdownData.dataSource = self.genderList
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
            tfIntrest.numberOfLines = 0
            tfIntrest.lineBreakMode = .byWordWrapping
    //                adjustLabelHeight()
        }
    
    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
    }
    
//    @objc func professionLabelTapped() {
//        showPopup(for: 1, allowMultipleSelection: false, hideOkButton: true) // lblDo ke liye OK button hidden
//    }
//    
//    @objc func interestLabelTapped() {
//        showPopup(for: 2, allowMultipleSelection: true, hideOkButton: false) // OK button visible
//    }
//    
//    @objc func neighbourLabelTapped() {
//        showPopup(for: 3, allowMultipleSelection: true, hideOkButton: false) // OK button visible
//    }
    
//    func showPopup(for labelTag: Int, allowMultipleSelection: Bool, hideOkButton: Bool) {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let popupVC = storyboard.instantiateViewController(withIdentifier: "RegisterFirstPopupVC") as? RegisterFirstPopupVC {
//                popupVC.allowMultipleSelection = allowMultipleSelection
//                popupVC.hideOkButton = hideOkButton // Pass flag to control OK button visibility
//                
//                if labelTag == 1 {
//                    if let professionData = AddProjectData?.nbdata.map({ $0.memberTitle }) {
//                        popupVC.data = professionData
//                    }
//                    popupVC.selectedItems = selectedProfessionItems
//                } else if labelTag == 2 {
//                    if let interestData = IntrsetData?.nbdata.map({ $0.memberTitle }) {
//                        popupVC.data = interestData
//                    }
//                    popupVC.selectedItems = selectedInterestItems
//                } else if labelTag == 3 {
//                    if let neighbourData = NeighbourData?.nbdata.map({ $0.memberTitle }) {
//                        popupVC.data = neighbourData
//                    }
//                    popupVC.selectedItems = selectedNeighbourItems
//                }
//                
//                popupVC.labelTag = labelTag
//                popupVC.delegate = self
//                popupVC.modalPresentationStyle = .overFullScreen
//                popupVC.modalTransitionStyle = .crossDissolve
//                self.present(popupVC, animated: true, completion: nil)
//            }
//        }
    
    func setInitialLetterProfile(_ letter: String) {
            let label = UILabel()
            label.frame = self.profilePic.bounds
            label.text = letter
            label.textAlignment = .center
            label.textColor = .white
            label.backgroundColor = .systemBlue
            label.font = UIFont.systemFont(ofSize: self.profilePic.bounds.height / 2, weight: .bold)
            label.layer.cornerRadius = self.profilePic.bounds.height / 2
            label.clipsToBounds = true

            // Label ko imageView ke andar add karo
            self.profilePic.image = nil
            self.profilePic.subviews.forEach { $0.removeFromSuperview() }
            self.profilePic.addSubview(label)
        }
        
    func didSelectItems(selectedItems: [String], forLabel tag: Int) {
        let selectedItemsString = selectedItems.isEmpty ? "Select" : selectedItems.joined(separator: ", ")
        
        if tag == 1 {
            lblDo.text = selectedItems.first ?? "Select"
            
            if let selectedTitle = selectedItems.first,
               let selected = AddProjectData?.nbdata.first(where: { $0.memberTitle == selectedTitle }) {
                UserDefaults.standard.set(selected.id, forKey: "professionId")
            }
            
        } else if tag == 2 {
            selectedInterestItems = selectedItems
            tfIntrest.text = selectedItemsString
            
            let selectedIds = IntrsetData?.nbdata.filter { selectedItems.contains($0.memberTitle) }.map { $0.id } ?? []
            let interestIdString = selectedIds.joined(separator: ",") // multiple ids as comma-separated string
            UserDefaults.standard.set(interestIdString, forKey: "interestIds")
            
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
    
    
    
    
//    func getCustomImage(imageDisplayName: String?, imageView: UIImageView!){
//        if let name = imageDisplayName, !name.isEmpty {
//            imageView.setImage(string:name, color: UIColor.colorHash(name: name), circular: isCircularWithStroke, stroke: isCircularWithStroke)
//            
//            
//            //  let imageDisplayName = CGSize(width: 20, height: 20)
//        }else{
//            imageView.setImage(string:"Display Picture", color: UIColor.colorHash(name: "Display Picture"), circular: isCircularWithStroke, stroke: isCircularWithStroke)
//        }
//        
//    }
//    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    @objc func imageViewTapped(_ sender:AnyObject){
//         openCameraGallery()
        //   selectPictureThroughPhotoGallery()
        //        openCameraGallery()
                checkCameraPermission { [weak self] granted in
                    guard let self = self else { return }
                    if granted {
                        openCameraGallery()
                    }
                }
     }
    
    
    
    
    
   
    
    
    @IBAction func nextBtn(_ sender: UIButton) {
            callMoreYouWebService { [weak self] in
                guard let self = self else { return }
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                    vc.sourceViewController = "HomeViewController"
                    vc.Oid = UserDefaults.standard.string(forKey: "userid")
                    self.navigationController?.popViewController(animated: true)
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
            "loggeduser": id // loggedUser ko use karna chahiye
        ]
        print(dictParams)
        
        // Call the web service
//        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { (data: ProfileModel?) in
//            guard let data = data else {
//                print("Error: API response is nil")
//                completionClosure()
//                return
//            }
//
//            // **Assign API response to profileData**
//            self.profileData = data
//
//            // **Update UI on the main thread**
//            DispatchQueue.main.async {
//                self.updateProfileUI()
//            }
//
//            completionClosure()
//        }
    }

    

//    func updateProfileUI() {
//        lblDo.text = profileData?.nbrsType ?? "N/A"
//        tfNeighbour.text = profileData?.reason ?? "N/A"
//        tfIntrest.text = profileData?.intersttype ?? "N/A"
//        tfEmergency.text = profileData?.emerPhone
//        
//        if let imageUrl = profileData?.userpic, let url = URL(string: imageUrl) {
//            profilePic.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
//        } else {
//            profilePic.image = UIImage(named: "placeholder") // Default image
//        }
//    }

    func updateProfileUI() {
            lblEmergencyContact.text = "Emergency contact"
            lblneighbourhood.text = "Neighbourhood Attributes"
            lblAlittleMoreAbout.text = "A little more about me!"
            lblAlittleMoreAbout.font = UIFont(name: "Montserrat-Regular", size: 18)
            lblDo.text = profileData?.nbrsType?.isEmpty == false ? profileData?.nbrsType: "What do you do?"
            tfIntrest.text = profileData?.intersttype?.isEmpty == false ? profileData?.intersttype: "Choose interest"
            tfEmergency.placeholder = profileData?.emerPhone?.isEmpty == false ? profileData?.emerPhone : "Emergency contact no"
            tfNeighbour.text = profileData?.reason?.isEmpty == false ? profileData?.reason: "I love my neighbourhood because"
            tfEmergency.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            if let imageUrl = profileData?.userpic, let url = URL(string: imageUrl) {
                profilePic.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            } else {
                profilePic.image = UIImage(named: "placeholder")
            }
        }

  
    func CallProffesoinWebService() {
        let dictParams: [String: Any] = [:]
//        WebService.sharedInstance.CallProffesoinWebService(withParams: dictParams) { data in
//            self.AddProjectData = data
//            // No default id set here, will be set after selection
//        }
    }

    func CallIntrestWebService() {
        let dictParams: [String: Any] = [:]
//        WebService.sharedInstance.CallIntrestWebService(withParams: dictParams) { data in
//            self.IntrsetData = data
//            // No default id set here, will be set after selection
//        }
    }

    
    @IBAction func btnThank(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func CallNeighbourWebService() {
        let dictParams: Dictionary<String, Any> = ["":""]
//        WebService.sharedInstance.CallNeighbourWebService(withParams: dictParams) { data in
//            self.NeighbourData = data
//            for value in self.NeighbourData?.nbdata ?? [] {
//                self.NeighbourName.append(value.memberTitle ?? "")
//            }
// 
//        }
    }
    
    func callMoreYouWebService(_ completionClosure: @escaping () -> ()) {
            let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
            let professionId = UserDefaults.standard.string(forKey: "professionId") ?? ""
            let interestIds = UserDefaults.standard.string(forKey: "interestIds") ?? ""
            
            let dictParams: [String: Any] = [
//                "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
                "profession": professionId,
                "interest": interestIds,
                "reason": (self.tfNeighbour.text == "I love my neighbourhood because") ? "" : (self.tfNeighbour.text ?? ""),
                "emerphoneno": self.tfEmergency.text ?? "",
                "userid": userId,
                "userpic": ""
            ]
            print("Param is : \(dictParams)")
//            WebService.sharedInstance.callMoreYouWebService(withParams: dictParams) { data in
//                self.MoreDataF = data
//                completionClosure()
//            }
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
//        vc.aspectRatioPreset = .presetSquare
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
    
    
    func openCameraGallery() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // 📷 Take Photo — Camera Permission (manual handling)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraAuthStatus {
            case .authorized:
                self.presentImagePicker(sourceType: .camera)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            self.presentImagePicker(sourceType: .camera)
                        } else {
                            self.showPermissionDeniedAlert(for: "Camera")
                        }
                    }
                }
            default:
                self.showPermissionDeniedAlert(for: "Camera")
            }
        }))

        // 🖼 Choose Photo — No manual permission check
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            // 🔥 Just open the picker — iOS will handle permission popup
            self.presentImagePicker(sourceType: .photoLibrary)
        }))

        

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        self.present(alert, animated: true)
    }

    
    
    
    
    
    
    
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Source type not available: \(sourceType)")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        self.present(picker, animated: true)
    }

    func showPermissionDeniedAlert(for type: String) {
        let alert = UIAlertController(
            title: "\(type) Permission Denied",
            message: "Please enable \(type.lowercased()) access from Settings > Privacy > \(type).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        self.present(alert, animated: true)
    }

    
    
    
    
    
    
}
