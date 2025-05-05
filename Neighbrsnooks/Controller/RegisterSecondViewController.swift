//
//  RegisterSecondViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit

import CoreLocation
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import AVKit
import SystemConfiguration
import Alamofire
import Vision

protocol neigSelectionDelegate: AnyObject {
    func didSelectItems(selectedItems: [String], forLabel tag: Int)
}

protocol LocationDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}



@available(iOS 16.0, *)
class RegisterSecondViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var tabNeighourhoodView: UIView!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    var selectedLocation: String?
    weak var delegateSe: LocationDelegate?
    
    @IBOutlet weak var addressProofViewheight: NSLayoutConstraint!
    @IBOutlet weak var yourneighbourhoodViewCornR: UIView!
    @IBOutlet weak var yourneighbourhoodTblViewCornRe: UIView!
    @IBOutlet weak var neighbourhoodDataShowTableView: UITableView!
    @IBOutlet weak var neigbourhoodtblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var neigbourhoodViewHeightConstraint: NSLayoutConstraint! // UIView ke liye height constraint
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var lblIDProof: UILabel!
    // Outlets for document selection buttons
    @IBOutlet weak var aadhaarButton: UIButton!
    @IBOutlet weak var passportButton: UIButton!
    @IBOutlet weak var voterIDButton: UIButton!
    @IBOutlet weak var drivingLicenseButton: UIButton!
    @IBOutlet weak var rentdocsButton: UIButton!
    // Outlets for image views to display front and back images
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var lblCityH: UILabel!
    @IBOutlet weak var lblStateH: UILabel!
    @IBOutlet weak var lblpinCodeH: UILabel!
    @IBOutlet weak var lblDobH: UILabel!
    @IBOutlet weak var lblGenderH: UILabel!
    @IBOutlet weak var btnReachout: UIButton!
    @IBOutlet weak var lblYourNeighHeading: UILabel!
    @IBOutlet weak var lblSubHeadingSelectLocation: UILabel!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var cityView: UIView!
    
    
    @IBOutlet weak var lblForNeighourhood_ID: UILabel!
    @IBOutlet weak var lblForNeighourhood_Address: UILabel!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblNeighbr: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var tfPincode: UITextField!
    
    @IBOutlet weak var tfFlat: UITextField!
    @IBOutlet weak var tfStreet: UITextField!
    @IBOutlet weak var ivLocation: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var lblresi: UILabel!
    @IBOutlet weak var lblYourneighbhood: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblAdharDetails: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var viewYourAddress: UIView!
    
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var lblFront: UILabel!
    
    // Enum to manage selected state of documents
    enum SelectedDocument {
        case aadhaar, passport, voterID, drivingLicense,RentDoc, none
    }
    
    enum DocumentType {
        case aadhar, passport, voterID, drivingLicense,RentDoc, none
    }
    enum ImageSide {
        case front
        case back
    }
    enum SelectedDocumentType {
        case aadhar, passport, voterID, drivingLicense,RentDoc, none
    }
    
    var selectedDocumentType: DocumentType?
    
    // Default images for front and back
    let defaultFrontImage = UIImage(named: "PhotoIDProof")
    let defaultBackImage = UIImage(named: "PhotoIDProof")
    
    var isFromProfile: Bool = false
    
    
    var allowMultipleSelection: Bool = true
    var data: [String] = []
    var selectedItems: [String] = []
    weak var delegate: neigSelectionDelegate?
    var labelTag: Int = 0
    var selectedIndexPath: IndexPath?
    
    
    // code irshad malik
    var selectedIndex: IndexPath?
    var selectedIndices = Set<Int>()
    var frontLabel: UILabel = UILabel()
    var backLabel: UILabel = UILabel()
    
    var selectedImageSide: ImageSide?
    // Variable to keep track of the selected document
    var selectedDocument: SelectedDocument = .none
    var imageViewToUpdate: UIImageView? = nil
    var RegistrationSec : RegistrationSecModel?
    var NeighbrhdData : NgbbrhoodModel?
    var AddressData : AddressModel?
    var ReachoutNeighborhoodData : ReachoutNeighborhoodModel?
    var NeighborhoodStatusByStateData: NeighborhoodStatusByStateModel?
    var isComingFromSearchVC: Bool = false
    var UserLocation: UserLocationModel?
    
    private let datePicker = UIDatePicker()
    // Array of gender options
    let genderOptions = ["Choose Your Gender","Male", "Female", "Other"]
    // Picker view for gender selection
    private let genderPicker = UIPickerView()
    var latitudeCurrentLocation: CLLocationDegrees = 0.0
    var longitudeCurrentLocation: CLLocationDegrees = 0.0
    var speedCurrentLocation: CLLocationDegrees = 0.0
    let locationManager = CLLocationManager()
    var selectedImage: UIImage?
    var countryData : CountryModel?
    var stateData : StateModel?
    var cityData : cityModel?
    //    var countryDropdownData = DropDown()
    var countryName = [String]()
    //    var stateDropdownData = DropDown()
    var stateName = [String]()
    //    var cityDropdownData = DropDown()
    var cityName = [String]()
    var nbdName = [String]()
    var shortAddress : String?
    var latitudeS: Double?
    var longitudeS: Double?
    var countryId : String?
    var stateId : String?
    var cityId : String?
    var lat :Double?
    var long : Double?
    var name: String?
    var secname: String?
    var from = 0
    var serch = 0
    var city: String?
    var state: String?
    var zipcode: String = ""
    var userId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        
        self.navigationItem.hidesBackButton = true
        callDeviceInfoWebService() // Save device Info
        if !isComingFromSearchVC {
            startLocationUpdates()
            locationManager.delegate = self
            requestLocationAuthorization()
            callCurrentSearchNeighbrWebService()
            self.locationManager.requestAlwaysAuthorization()
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        // Location authorize aur fetch karne ke liye
        requestLocationAuthorization()
        startLocationUpdates()
        
        // Location manager setup
        //           locationManager.delegate = self
        //           locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //           locationManager.requestWhenInUseAuthorization()
        //           locationManager.startUpdatingLocation()
    }
    
    
    
    
    func setUp(){
        frontImageView.isHidden = true
        backImageView.isHidden = true
        lblFront.isHidden = true
        lblBack.isHidden = true
        tfCity.text = city ?? ""
        tfState.text = state ?? ""
        tfPincode.text = zipcode
        // Debug prints to check the values
        print("City in RegisterSecondVC: \(city ?? "No City")")
        print("State in RegisterSecondVC: \(state ?? "No State")")
        print("Zipcode in RegisterSecondVC: \(zipcode ?? "No Zipcode")")
        print("Received Latitude: \(latitudeS ?? 0.0)")
        print("Received Longitude: \(longitudeS ?? 0.0)")
        
        
        if let location = selectedLocation {
            // Directly set the full address to lblSector
            lblSector.text = location
            
            let components = location.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            print("Components: \(components)") // Debugging
            
            // Sub Locality ko lblArea par set karo
            if components.count > 1 {
                // Assuming sub locality is in the second index (components[1])
                lblArea.text = components[1]
                lblForNeighourhood_ID.text = ("(For \(components[1]))")
                lblForNeighourhood_Address.text = ("(For \(components[1]))")
                self.callRegSecWebService{}
                callSearchNeighbrWebService(location: CLLocationCoordinate2D(latitude: latitudeS ?? 0.0, longitude: longitudeS ?? 0.0))
            } else {
                lblArea.text = "Sub Locality not found"
            }
            
            
        }
        
        tabNeighourhoodView.layer.cornerRadius = 10
        tabNeighourhoodView.clipsToBounds = true
        yourneighbourhoodViewCornR.layer.cornerRadius = 20 // Adjust the value as needed
        yourneighbourhoodViewCornR.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top corners only
        
        // Bottom corner radius for yourneighbourhoodTblViewCornRe
        yourneighbourhoodTblViewCornRe.layer.cornerRadius = 20 // Adjust the value as needed
        yourneighbourhoodTblViewCornRe.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // Bottom corners only
        
        // Optional: To make sure the corners are clipped
        yourneighbourhoodViewCornR.layer.masksToBounds = true
        yourneighbourhoodTblViewCornRe.layer.masksToBounds = true
        // TableView ke delegate aur dataSource ko set karo
        neighbourhoodDataShowTableView.delegate = self
        neighbourhoodDataShowTableView.dataSource = self
        btnReachout.layer.cornerRadius = 10
        btnReachout.clipsToBounds = true
        btnReachout.layer.borderColor = UIColor.red.cgColor
        genderView.layer.cornerRadius = 10
        genderView.clipsToBounds = true
        cityView.clipsToBounds = true
        viewYourAddress.clipsToBounds = true
        viewYourAddress.layer.cornerRadius = 20 // Adjust the value as needed
        viewYourAddress.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top corners only
        cityView.layer.cornerRadius = 20 // Adjust the value as needed
        cityView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // Bottom corners only
        buttonTitleName()
        frontImageView.layer.cornerRadius = 10
        frontImageView.clipsToBounds = true
        frontImageView.tintColor = .gray
        backImageView.tintColor = .gray
        backImageView.layer.cornerRadius = 10
        backImageView.clipsToBounds = true
        aadhaarButton.layer.cornerRadius = aadhaarButton.size.width/7
        aadhaarButton.clipsToBounds = true
        aadhaarButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        aadhaarButton.tintColor = .darkGray
        passportButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        passportButton.tintColor = .darkGray
        voterIDButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        voterIDButton.tintColor = .darkGray
        drivingLicenseButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        drivingLicenseButton.tintColor = .darkGray
        lblCityH.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblCityH.tintColor = .darkGray
        lblStateH.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblStateH.tintColor = .darkGray
        lblpinCodeH.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblpinCodeH.tintColor = .darkGray
        lblGenderH.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblGenderH.tintColor = .darkGray
        lblGenderH.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblGenderH.tintColor = .darkGray
        lblDobH.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblDobH.tintColor = .darkGray
        lblSector.font = UIFont(name: "Montserrat-Regular", size: 14)
        passportButton.layer.cornerRadius = passportButton.size.width/7
        passportButton.clipsToBounds = true
        voterIDButton.layer.cornerRadius = voterIDButton.size.width/7
        voterIDButton.clipsToBounds = true
        drivingLicenseButton.layer.cornerRadius = 10
        drivingLicenseButton.clipsToBounds = true
        
        // Add tap gesture recognizers to image views
        let frontTapGesture = UITapGestureRecognizer(target: self, action: #selector(frontImageTapped))
        frontImageView.isUserInteractionEnabled = true
        frontImageView.addGestureRecognizer(frontTapGesture)
        
        let backTapGesture = UITapGestureRecognizer(target: self, action: #selector(backImageTapped))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(backTapGesture)
        
        
        setupGenderPicker()
        setupDatePicker()
        updateButtonStates()
        setupImageViews()
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
                self.neighbourhoodDataShowTableView.reloadData()
            }
        }
        
         // self.lblresi.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        //        callCountryWebService()
        tfFlat.autocapitalizationType = .words
        tfStreet.autocapitalizationType = .words
        
        //         search old code neighborhood
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //             self.getCurrentLocation()
        }
        SVProgressHUD.dismiss()
        //     callRegSecWebService()
        //         getCurrentLocation()
       
        let areaTapGesture = UITapGestureRecognizer(target: self, action: #selector(areaLabelTapped))
        tabNeighourhoodView.isUserInteractionEnabled = true
        tabNeighourhoodView.addGestureRecognizer(areaTapGesture)
        NetworkMonitor.shared.startMonitoring()
        
        
    }
    
    
    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
    }
    
    @objc func areaLabelTapped() {
        openLocationSearchScreen(for: "Area")
    }
    
    
    
    func openLocationSearchScreen(for type: String) {
        // Initialize the SearchNeighouhoodViewController
        if let searchNeighouhoodVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchNeighouhoodViewController") as? SearchNeighouhoodViewController {
            
            self.navigationController?.pushViewController(searchNeighouhoodVC, animated: true)
        }
    }
    
    
    
    func detectText(in image: UIImage, completion: @escaping ([VNRecognizedTextObservation]) -> Void) {
        guard let cgImage = image.cgImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let observations = request.results as? [VNRecognizedTextObservation] {
                completion(observations)
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-IN"]
        request.usesLanguageCorrection = true
        
        try? requestHandler.perform([request])
    }
    
    
    func findAadhaarNumbers(in observations: [VNRecognizedTextObservation]) -> [(text: String, boundingBox: CGRect)] {
        var result: [(text: String, boundingBox: CGRect)] = []
        
        for observation in observations {
            guard let candidate = observation.topCandidates(1).first else { continue }
            let text = candidate.string.replacingOccurrences(of: " ", with: "")
            
            if text.range(of: #"^\d{12}$"#, options: .regularExpression) != nil {
                result.append((candidate.string, observation.boundingBox))
            }
        }
        
        return result
    }
    
    
    func maskDigits(in image: UIImage, from observations: [VNRecognizedTextObservation]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(at: .zero)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        for obs in observations {
            guard let candidate = obs.topCandidates(1).first else { continue }
            let fullText = candidate.string.replacingOccurrences(of: " ", with: "")
            
            if fullText.count == 12 {
                let box = obs.boundingBox
                let imageSize = image.size
                let rect = CGRect(x: box.origin.x * imageSize.width,
                                  y: (1 - box.origin.y - box.size.height) * imageSize.height,
                                  width: box.size.width * imageSize.width,
                                  height: box.size.height * imageSize.height)
                let digitWidth = rect.width / 12.0
                let maskRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: digitWidth * 8, height: rect.height)
                context.setFillColor(#colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1))
                context.fill(maskRect)
            }
        }
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    
    func convertImageToBase64(image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 0.8)?.base64EncodedString()
    }
    
    //    fetchDataFromAPI
    
    func buttonTitleName() {
        
        lblYourneighbhood.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblYourneighbhood.textColor = .darkGray
        self.tfCity.font = UIFont(name: "Montserrat-Regular", size: 14)
        tfCity.textColor = .darkGray
        self.tfCountry.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.tfState.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.tfPincode.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.genderTextField.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.dobTextField.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.backLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        self.frontLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.lblresi.font = UIFont(name: "Montserrat-Regular", size: 16)
        //        self.lblYourneighbhood.font = UIFont(name: "Montserrat-Regular", size: 16)
        //        self.lblAddress.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        
        
        let font = UIFont(name: "Montserrat-Regular", size: 12) // Apna font aur size specify karein
        
        // Aadhaar Button
        let aadhaarTitle = "Aadhar"
        let aadhaarAttributes: [NSAttributedString.Key: Any] = [
            .font: font as Any
        ]
        let aadhaarAttributedTitle = NSAttributedString(string: aadhaarTitle, attributes: aadhaarAttributes)
        aadhaarButton.setAttributedTitle(aadhaarAttributedTitle, for: .normal)
        
        // Passport Button
        let passportTitle = "Passport"
        let passportAttributes: [NSAttributedString.Key: Any] = [
            .font: font as Any
        ]
        let passportAttributedTitle = NSAttributedString(string: passportTitle, attributes: passportAttributes)
        passportButton.setAttributedTitle(passportAttributedTitle, for: .normal)
        
        // Voter ID Button
        let voterIDTitle = "Voter ID"
        let voterIDAttributes: [NSAttributedString.Key: Any] = [
            .font: font as Any
        ]
        let voterIDAttributedTitle = NSAttributedString(string: voterIDTitle, attributes: voterIDAttributes)
        voterIDButton.setAttributedTitle(voterIDAttributedTitle, for: .normal)
        
        // Driving License Button
        let drivingLicenseTitle = "DL"
        let drivingLicenseAttributes: [NSAttributedString.Key: Any] = [
            .font: font as Any
        ]
        let drivingLicenseAttributedTitle = NSAttributedString(string: drivingLicenseTitle, attributes: drivingLicenseAttributes)
        drivingLicenseButton.setAttributedTitle(drivingLicenseAttributedTitle, for: .normal)
        
        //
        let rentdocTitle = "Rent Lease\nElectricity Bill"
        let rentdocAttributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor.black // optional
        ]
        
        let rentdocAttributedTitle = NSAttributedString(string: rentdocTitle, attributes: rentdocAttributes)
        rentdocsButton.setAttributedTitle(rentdocAttributedTitle, for: .normal)
        
        // MULTILINE SUPPORT
        rentdocsButton.titleLabel?.lineBreakMode = .byWordWrapping
        rentdocsButton.titleLabel?.textAlignment = .center
        rentdocsButton.titleLabel?.numberOfLines = 2
        
        
        
    }
    
    
    
    @IBAction func documentButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            selectedDocumentType = .aadhar
            handleDocumentSelection(.aadhaar)
            print("Aadhaar selected")
        case 2:
            selectedDocumentType = .passport
            handleDocumentSelection(.passport)
            print("Passport selected")
        case 3:
            selectedDocumentType = .voterID
            handleDocumentSelection(.voterID)
            print("Voter ID selected")
        case 4:
            selectedDocumentType = .drivingLicense
            handleDocumentSelection(.drivingLicense)
            print("Driving License selected")
        case 5:
            selectedDocumentType = .RentDoc
            handleDocumentSelection(.RentDoc)
            print("Driving License selected")
            
        default:
            selectedDocumentType = nil
        }
    }
    
    
    // Document selection update function
    private func handleDocumentSelection(_ document: SelectedDocument) {
        selectedDocument = document
        updateButtonStates()
        
        frontImageView.isUserInteractionEnabled = selectedDocument != .none
        backImageView.isUserInteractionEnabled = selectedDocument != .none
        lblFront.isUserInteractionEnabled = selectedDocument != .none
        lblBack.isUserInteractionEnabled = selectedDocument != .none
        
        // Image views ko update karein document ke hisaab se
        showImageViews()
    }
    
    
    
    
    
    
    @IBAction func aadhaarButtonTapped(_ sender: UIButton) {
        showImageViews()
    }
    
    @IBAction func passportButtonTapped(_ sender: UIButton) {
        showImageViews()
    }
    
    @IBAction func voterIDButtonTapped(_ sender: UIButton) {
        showImageViews()
    }
    
    @IBAction func drivingLicenseButtonTapped(_ sender: UIButton) {
        showImageViews()
    }
    
    @IBAction func rentdocsTapped(_ sender: Any) {
        showImageViews()
    }
    
    
    func showImageViews() {
        if selectedDocumentType == .RentDoc {
            frontImageView.isHidden = false
            backImageView.isHidden = true
            lblFront.isHidden = false
            lblBack.isHidden = true
        } else {
            frontImageView.isHidden = false
            backImageView.isHidden = false
            lblFront.isHidden = false
            lblBack.isHidden = false
        }
    }
    
    
    
    // Update buttons and image views states
    func updateButtonStates() {
        let buttons: [(UIButton?, SelectedDocument)] = [
            (aadhaarButton, .aadhaar),
            (passportButton, .passport),
            (voterIDButton, .voterID),
            (drivingLicenseButton, .drivingLicense),
            (rentdocsButton, .RentDoc)
        ]
        
        for (button, document) in buttons {
            guard let button = button else { continue }
            
            // Configure image (circle) for selected and unselected states
            let config = UIImage.SymbolConfiguration(pointSize: 13) // Increase circle size
            let selectedImage = UIImage(systemName: "largecircle.fill.circle", withConfiguration: config)
            let unselectedImage = UIImage(systemName: "circle", withConfiguration: config)
            
            if selectedDocument == document {
                button.setImage(selectedImage, for: .normal)
                button.tintColor = UIColor(red: 0, green: 100/255, blue: 0, alpha: 1) // Dark green
                button.setTitleColor(.black, for: .normal)
            } else {
                button.setImage(unselectedImage, for: .normal)
                button.tintColor = .black
            }
            
            // Add spacing between circle and button title
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 1) // Circle spacing
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: -1) // Text spacing
        }
        
        // Enable or disable image views based on document selection
        let isDocumentSelected = selectedDocument != .none
        frontImageView.isUserInteractionEnabled = isDocumentSelected
        backImageView.isUserInteractionEnabled = isDocumentSelected
        
        // Default image set when no document is selected
        if !isDocumentSelected {
            frontImageView.image = UIImage(named: "PhotoIDProof") // Default image
            backImageView.image = UIImage(named: "PhotoIDProof")  // Default image
        }
    }
    
 
    
    // Front image view tap gesture
    @objc private func frontImageTapped() {
        // Check if a document is selected
        guard selectedDocument != .none else {
            // Alert message ya kuch nahi karna hai, sirf return kare
            return
        }
        
        // Proceed with the existing logic for handling image tap
        if frontImageView.image != nil && frontImageView.image != UIImage(named: "PhotoIDProof") {
            // Agar uploaded image hai, to popup dikhaye
            let popupVC = storyboard?.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as! RegisterThirdImageShowPopupVC
            popupVC.selectedImage = frontImageView.image
            
            // Image delete karne ka option
            popupVC.onDeleteImage = { [weak self] in
                self?.frontImageView.image = UIImage(named: "PhotoIDProof") // Wapas default image set karo jab delete ho
            }
            // Popup style and animation
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            
            present(popupVC, animated: true, completion: nil)
        } else {
            // Yadi koi image uploaded nahi hai, to image picker open karo
            imageViewToUpdate = frontImageView
            presentImageSourceOptions()
        }
    }
    
    // Back image view tap gesture
    @objc private func backImageTapped() {
        // Check if a document is selected
        guard selectedDocument != .none else {
            // Alert message ya kuch nahi karna hai, sirf return kare
            return
        }
        
        // Proceed with the existing logic for handling image tap
        if backImageView.image != nil && backImageView.image != UIImage(named: "PhotoIDProof") {
            // Agar uploaded image hai, to popup dikhaye
            let popupVC = storyboard?.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as! RegisterThirdImageShowPopupVC
            popupVC.selectedImage = backImageView.image
            
            // Image delete karne ka option
            popupVC.onDeleteImage = { [weak self] in
                self?.backImageView.image = UIImage(named: "PhotoIDProof") // Wapas default image set karo jab delete ho
            }
            // Popup style and animation
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            
            present(popupVC, animated: true, completion: nil)
        } else {
            // Yadi koi image uploaded nahi hai, to image picker open karo
            imageViewToUpdate = backImageView
            presentImageSourceOptions()
        }
    }
    
    
    
    // Function to display alerts
    func showAlert(title: String = "", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // Image tap handler
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        // Check if a document is selected first
        guard selectedDocument != .none else {
            showAlert(message: "Please select a document before uploading an image.")
            return
        }
        
        let tappedImageView = sender.view as! UIImageView
        
        // Check if an image is already uploaded
        if tappedImageView.image == UIImage(named: "PhotoIDProof") {
            // No image uploaded, present image picker to upload
            imageViewToUpdate = tappedImageView
            presentImageSourceOptions()
        } else {
            // Image already uploaded, show it in the popup
            let popupVC = storyboard?.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as! RegisterThirdImageShowPopupVC
            popupVC.selectedImage = tappedImageView.image
            
            // Handle the deletion of the image
            popupVC.onDeleteImage = { [weak self] in
                self?.imageViewToUpdate?.image = UIImage(named: "PhotoIDProof") // Reset to default
            }
            present(popupVC, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    // Default image ke liye tap gestures setup karna
    private func setupImageViews() {
        frontImageView.isUserInteractionEnabled = true
        backImageView.isUserInteractionEnabled = true
        
        
        let frontTapGesture = UITapGestureRecognizer(target: self, action: #selector(frontImageTapped))
        let backTapGesture = UITapGestureRecognizer(target: self, action: #selector(backImageTapped))
        
        frontImageView.addGestureRecognizer(frontTapGesture)
        backImageView.addGestureRecognizer(backTapGesture)
    }
    
    
    // Image picker ko dikhane ka function
    private func presentImageSourceOptions() {
        let alertController = UIAlertController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take photo", style: .default) { _ in
                self.openImagePicker(sourceType: .camera)
            }
            alertController.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: "Choose photo", style: .default) { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }
        alertController.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // 8. Jab image select ho jaaye
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // Prefer edited image, fallback to original
        let selectedImage = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        guard let image = selectedImage else {
            print("No image found")
            return
        }
        
        // Run OCR and masking
        detectText(in: image) { observations in
            let aadhaarTexts = self.findAadhaarNumbers(in: observations)
            
            if let maskedImage = self.maskDigits(in: image, from: observations) {
                DispatchQueue.main.async {
                    self.imageViewToUpdate?.image = maskedImage
                    self.imageViewToUpdate = nil
                }
            } else {
                // No Aadhaar number found or failed to mask — fallback to original image
                DispatchQueue.main.async {
                    self.imageViewToUpdate?.image = image
                    self.imageViewToUpdate = nil
                }
            }
        }
    }
    
    
    
    
    
    
    // Jab image picker cancel ho jaye
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imageViewToUpdate = nil
    }
    
    // Function to present the image picker
    func showImagePicker(for side: ImageSide) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // You can also use .camera if needed
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupDatePicker() {
        // Set the date picker mode to date only
        datePicker.datePickerMode = .date
        
        // Set the maximum date to today to prevent future dates selection
        datePicker.maximumDate = Date()
        
        // Set a minimum date (13 years ago from today)
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -13, to: Date())
        datePicker.maximumDate = minDate // Maximum date ko 13 saal pehle set kar rahe hain
        
        // Configure for iOS 14 and later
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels // Use wheel style for better UX
        }
        
        // Set the date picker as the input view for the text field
        dobTextField.inputView = datePicker
        
        // Add target for the date picker value change
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // Set placeholder for the text field
        dobTextField.placeholder = "Select Date"
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Calculate the difference between current date and selected date
        let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: currentDate)
        if let age = ageComponents.year, age < 13 {
            showAlert(message: "Age should be above 13 years")
            dobTextField.text = "" // Clear the text field
        } else {
            // Format the selected date and set it in the text field
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dobTextField.text = dateFormatter.string(from: selectedDate)
        }
    }
    
    
    
    func setupGenderPicker() {
        // Set delegate and data source for picker
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        // Set the picker as the input view for the text field
        genderTextField.inputView = genderPicker
        
        // Set placeholder for the text field
        genderTextField.placeholder = "Select Gender"
    }
    
    
    
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Single column for gender
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count // genderOptions is your array of gender strings
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row] // Display gender options in the picker
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Set the selected gender to the text field
        genderTextField.text = genderOptions[row]
        
        // Dismiss the picker after selection
        genderTextField.resignFirstResponder()
    }
    
    
    
    
    
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            })
        })
        
        var flags: SCNetworkReachabilityFlags = []
        SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
        
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
    
    @IBAction func backAction(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation",
                                      message: "Are you sure you want to go back?\nUnsaved changes might be lost.",
                                      preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func actionReachout(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        callReachoutWebService()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func btnRegister(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterThirdViewController") as? RegisterThirdViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func countryBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //        self.countryNewDropdownData(showOn: tfCountry, DropdownName: countryDropdownData)
        // self.ServiceDescriptionLabel.text = self.ServiceTypeData?.data.seri
    }
    
    @IBAction func stateBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //        self.stateNewDropdownData(showOn: tfState, DropdownName: stateDropdownData)
        //        callStateWebService()
        //        self.ServiceDescriptionLabel.text = self.ServiceTypeData?.data.seri
    }
    
    @IBAction func cityBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //   self.cityNewDropdownData(showOn: tfCity, DropdownName: cityDropdownData)
        // self.ServiceDescriptionLabel.text = self.ServiceTypeData?.data.seri
    }
    
    
    
    
    
    func showErrorMessage(_ message: String) {
        // Set the error message
        tfCountry.text = message
        
        // Make sure the label is visible
        tfCountry.isHidden = false
        
        // Optionally, hide the label after a few seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.tfCountry.isHidden = true
        }
    }
    
    
    
    //MARK: -    **************************** Button Call Api Next Button *************************
    
    @IBAction func nextBtn(_ sender: UIButton){
        
        if let validationMessage = validateForm() {
            // Agar form valid nahi hai, to alert show karo
            showAlert(message: validationMessage)
            return
        }
        
        // Show loader on button before API call
        UIHelper.showLoader(on: sender, show: true)
        
        // Sab checks pass hone ke baad API call karein
        callRegSecWebService {
            DispatchQueue.main.async {
                // Hide loader after API response
                UIHelper.showLoader(on: sender, show: false)
                
                print("Call API")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController") as! RegisterFirstViewController
                vc.name = self.name ?? ""
                vc.secname = self.secname ?? ""
                if let selectedIndexPath = self.selectedIndexPath {
                    vc.Neighbourname = self.NeighbrhdData?.data[selectedIndexPath.row].nbdName ?? ""
                } else {
                    vc.Neighbourname = "" // Default value
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    func validateForm() -> String? {
        if tfCountry.text?.isEmpty ?? true {
            return "Please enter country"
        } else if tfState.text?.isEmpty ?? true {
            return "Please enter state"
        } else if tfFlat.text?.isEmpty ?? true {
            return "Please enter flat/house /door #, tower/unit #"
        } else if tfStreet.text?.isEmpty ?? true {
            return "Please enter apartment name, road/street name"
        } else if selectedIndexPath == nil {
            return "Please select the neighbourhood"
        } else if selectedDocumentType == nil {
            return "Please select the document name"
        }
        
        // RentDoc ke liye sirf front image validate karein
        if selectedDocumentType == .RentDoc {
            if frontImageView.image == nil || frontImageView.image == UIImage(named: "PhotoIDProof") {
                return "Please upload Front image"
            }
        }
        // Baki sab documents ke liye dono images validate karein
        else if selectedDocumentType != .none {
            if frontImageView.image == nil || frontImageView.image == UIImage(named: "PhotoIDProof") {
                return "Please upload Front image"
            }
            if backImageView.image == nil || backImageView.image == UIImage(named: "PhotoIDProof") {
                return "Please upload Back image"
            }
        }
        
        if genderTextField.text?.isEmpty ?? true {
            return "Please select gender"
        } else if dobTextField.text?.isEmpty ?? true {
            return "Please select date of birth"
        }
        
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: -       call apni with irshad malik
    
    // Function to upload selected document and call web service
    
    func callRegSecWebService(_ completionClosure: @escaping () -> ()) {
        let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
        let latString = latitudeS != nil ? String(latitudeS!) : ""
        let longString = longitudeS != nil ? String(longitudeS!) : ""
        
        // Gender ko numeric value mein map karein (1 for Male, 2 for Female)
        var genderValue: String = ""
        if let genderText = self.genderTextField.text {
            if genderText.lowercased() == "male" {
                genderValue = "1"
            } else if genderText.lowercased() == "female" {
                genderValue = "2"
            }
        }
        
        // Parameters prepare karein
        let dictParams: [String: String] = [
            "userid": userID,
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "dob": self.dobTextField.text ?? "",
            "areas": self.NeighbrhdData?.data.first?.nbdID ?? "",
            "gender": genderValue,
            "addlineone": self.tfFlat.text ?? "",
            "addlinetwo": self.tfStreet.text ?? "",
            "pincode": self.tfPincode.text ?? "",
            "countryid": "100",
            "stateid": self.tfState.text ?? "",    //self.stateData?.nbdata.first?.id ?? "",
            "cityid": self.tfCity.text ?? "",//self.cityData?.nbdata.first?.id ?? "",
            "lati": latString,
            "longi": longString,
            "term": "1"
        ]
        print(dictParams)
        
        // Handle document type selection and image upload logic
        var images: [(key: String, image: UIImage?)] = []
        
        switch selectedDocumentType {
        case .aadhar:
            if let frontImage = self.frontImageView.image {
                images.append(("aadharFront", frontImage))
            } else {
                print("Aadhaar Front image upload karein")
                return
            }
            
            if let backImage = self.backImageView.image {
                images.append(("aadharBack", backImage))
            } else {
                print("Aadhaar Back image upload karein")
                return
            }
            
        case .passport:
            if let frontImage = self.frontImageView.image {
                images.append(("passportFront", frontImage))
            } else {
                print("Passport Front image upload karein")
                return
            }
            
            if let backImage = self.backImageView.image {
                images.append(("passportBack", backImage))
            } else {
                print("Passport Back image upload karein")
                return
            }
            
        case .voterID:
            if let frontImage = self.frontImageView.image {
                images.append(("voterFront", frontImage))
            } else {
                print("Voter ID Front image upload karein")
                return
            }
            
            if let backImage = self.backImageView.image {
                images.append(("voterBack", backImage))
            } else {
                print("Voter ID Back image upload karein")
                return
            }
            
        case .drivingLicense:
            if let frontImage = self.frontImageView.image {
                images.append(("dlFront", frontImage))
            } else {
                print("Driving License Front image upload karein")
                return
            }
            
            if let backImage = self.backImageView.image {
                images.append(("dlBack", backImage))
            } else {
                print("Driving License Back image upload karein")
            }
            
            
        case .RentDoc:
            if let frontImage = self.frontImageView.image {
                images.append(("rentdocs", frontImage))
            } else {
                print("RentDoc Front image upload karein")
                return
            }
            
            if let backImage = self.backImageView.image {
                images.append(("rentdocs", backImage))
            } else {
                print("RentDoc Back image upload karein")
            }
            
        default:
            print("Koi document selected nahi hai")
            return
        }
        
        // Set URL
        guard let url = URL(string: "https://dev.neighbrsnook.com/oldadmin/api/master?flag=reg-step-II") else {
            print("URL invalid hai")
            return
        }
        
        // Setup request aur execute karein
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createMultipartBody(with: dictParams, images: images, boundary: boundary)
        request.httpBody = body
        
        // Execute network request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("Koi data nahi mila")
                return
            }
            
            do {
                if let jsonResponse = String(data: data, encoding: .utf8) {
                    print("Response Data: \(jsonResponse)")
                }
                
                let decoder = JSONDecoder()
                self.RegistrationSec = try decoder.decode(RegistrationSecModel.self, from: data)
                
                if self.RegistrationSec?.status == "success" {
                    DispatchQueue.main.async {
                        completionClosure()
                    }
                } else {
                    DispatchQueue.main.async {
                        print(self.RegistrationSec?.message ?? "Unknown error")
                    }
                }
            } catch let jsonError {
                print("JSON parse karne mein error: \(jsonError)")
            }
        }
        task.resume()
    }
    
    // Function to create multipart body
    func createMultipartBody(with parameters: [String: String], images: [(key: String, image: UIImage?)], boundary: String) -> Data {
        var body = Data()
        
        // Parameters ko body mein add karein
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Images ko body mein add karein
        for (key, image) in images {
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.7) else { continue }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
            
            // Debugging ke liye image key print karein
            print("Uploading image with key: \(key)")
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    
    
    
    
    
    
    func callCountryWebService() {
        let dictParams: Dictionary<String, Any> = ["":""]
        WebService.sharedInstance.callCountryWebService(withParams: dictParams) { data in
            self.countryData = data
            self.countryName.removeAll()
            for value in self.countryData?.nbdata ?? [] {
                self.countryName.append(value.countryname ?? "")
            }
            //            self.countryDropdownData.dataSource = self.countryName
            //    self.ServiceDescriptionLabel.text = self.ServiceTypeData?.data.servicede
            
            
        }
    }
    
    
    
    
    //     call api callStateWebService & callCityWebService *************-----------------/
    func callStateWebService() {
        
        let dictParams: [String: Any] = [
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken() ?? "defaultToken", // Handle nil token
            "state_name": stateId ?? "" // Safely unwrap stateId
        ]
        print(dictParams)
        
        WebService.sharedInstance.callStateWebService(withParams: dictParams) { data in
            self.stateData = data
            
            // Debugging the response data
            print("State Data: \(String(describing: data))")
            
            // Check if stateData is nil or nbdata is empty
            guard let nbdata = self.stateData?.nbdata, !nbdata.isEmpty else {
                print("No state data available")
                return
            }
            
            self.stateName.removeAll()
            for value in nbdata {
                print("State Name: \(value.stateName), State ID: \(value.id)") // Debugging print
                self.stateName.append(value.stateName)
            }
            //            self.stateDropdownData.dataSource = self.stateName
        }
    }
    
    func callCityWebService() {
        let dictParams: [String: Any] = [
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken() ?? "defaultToken", // Handle nil token
            "city_name": cityId ?? "" // Safely unwrap cityId
        ]
        print("Request Parameters: \(dictParams)")
        
        WebService.sharedInstance.callCityWebService(withParams: dictParams) { data in
            self.cityData = data
            
            // Debugging response data
            print("City Data: \(String(describing: data))")
            
            // Check if data is empty
            guard let nbdata = self.cityData?.nbdata, !nbdata.isEmpty else {
                print("No city data available")
                return
            }
            
            self.cityName.removeAll()
            for value in nbdata {
                print("City Name: \(value.cityName), City ID: \(value.id)") // Debugging print
                self.cityName.append(value.cityName)
            }
            //            self.cityDropdownData.dataSource = self.cityName
        }
    }
    
    
    
    func setStateAndCallCity(stateId: String) {
        self.stateId = stateId
        print("Selected State ID: \(stateId)") // Debugging ke liye print karo
        callCityWebService()
    }
    
    
    func setCity(cityId: String) {
        self.cityId = cityId
        print("Selected City ID: \(cityId)") // Debugging ke liye print karo
    }
    
    
    
    // Function to set Country ID and call State Web Service
    private func setCountryAndCallState(countryId: String) {
        self.countryId = countryId
        callStateWebService()
    }
    
    
    
    
    func callReachoutWebService() {
        // Define the parameters for the API call
        let dictParams: Dictionary<String, Any> = [
            "areas": self.NeighbrhdData?.data.first?.nbdID ?? "",
            "addlineone": self.tfFlat.text ?? "",
            "addlinetwo": self.tfStreet.text ?? "",
            "pincode": self.tfPincode.text ?? "",
            "countryid": "100",
            "stateid": self.stateData?.nbdata.first?.id ?? "", // Safely unwrap stateId
            "cityid": self.cityData?.nbdata.first?.id ?? ""  // Safely unwrap cityId
        ]
        
        // Call the Reachout API
        WebService.sharedInstance.CallReachoutWebService(withParams: dictParams) { [weak self] data in
            guard let self = self else { return }
            
            // Handle the API response
            self.ReachoutNeighborhoodData = data
            
            // For example, print the status and message
            print(self.ReachoutNeighborhoodData?.status ?? "")
            print(self.ReachoutNeighborhoodData?.message ?? "")
            
            // Update UI or do further processing based on the response
            // For example, reloading a table view, updating labels, etc.
        }
    }
    
    
    
    
    
    
    //MARK: - Function to show alert
    
    func showNeighborhoodAlert(withMessage message: String) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        
        // Title attributed
        let title = "Neighborhood"
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16)!,
                         NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attributedTitle = NSAttributedString(string: title, attributes: titleFont)
        alert.setValue(attributedTitle, forKey: "attributedTitle")

        // Message attributed
        let messageFont = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 14)!,
                           NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attributedMessage = NSAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")

        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alert, animated: true) {
                // Auto-dismiss after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            print("Failed to find a view controller to present the alert.")
        }
    }


    
    
    
    //MARK: - call Search Neighborhood api
    
    func callSearchNeighbrWebService(location: CLLocationCoordinate2D) {
        let dictParams: [String: Any] = [
            "lati": latitudeS ?? 0.0,
            "longi": longitudeS ?? 0.0,
            "areas": lblArea.text ?? ""
        ]
        print(dictParams)
        self.callNeighorhodStatusStateCity()
        
        WebService.sharedInstance.callSearchNeighbrWebService(withParams: dictParams) { [weak self] data in
            guard let self = self else { return }
            
            // Clear previous data
            self.NeighbrhdData?.data.removeAll()
            print("API Status:", data.status)

            self.callNeighorhodStatusStateCity()
            DispatchQueue.main.async {
                if data.status == "success" {
                    if !data.data.isEmpty {
                        self.NeighbrhdData = data
                        self.btnReachout.isHidden = true
                        self.saveButton.isHidden = false
                    } else {
                        self.NeighbrhdData = nil
                        self.btnReachout.isHidden = false
                        self.saveButton.isHidden = true
                    }
                } else {
                    self.NeighbrhdData = nil
                    self.btnReachout.isHidden = false
                    self.saveButton.isHidden = true
                    self.callNeighorhodStatusStateCity()
                }
                
                // Reload table view and update height
                self.neighbourhoodDataShowTableView.reloadData()
                self.updateTableViewHeight()
                
                // Call this in all cases
                self.callStateWebService()
                self.callCityWebService()
               
            }
           
        }
    }

    
 
    // MARK: - ---------***********   Neighborhood Status By State/City/Pincode api  post ---------------**************
    
    func callNeighorhodStatusStateCity() {
        let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "area": lblArea.text ?? "",
            "countryid": "100",
            "stateid": self.tfState.text ?? "",
            "cityid": self.tfCity.text ?? "",
            "pincode": self.tfPincode.text ?? "",
            "userid": userID
        ]
        
        print("Calling API with parameters:", dictParams)
        
        WebService.sharedInstance.callNeighborhoodStatusByState(withParams: dictParams) { [weak self] (responseModel: NeighborhoodStatusByStateModel) in
            guard let self = self else { return }

            print("API Response - Status: \(responseModel.status), Message: \(responseModel.message)")

            // Always show the message
            DispatchQueue.main.async {
                self.showNeighborhoodAlert(withMessage: responseModel.message)
            }
        }
    }

    
    
    //MARK: - CurrentSearch location
    
    func callCurrentSearchNeighbrWebService() {
        let dictParams: [String: Any] = [
            "areas": lblArea.text ?? "",
            "lati": lat ?? 0.0,
            "longi": long ?? 0.0
        ]
        print(dictParams)
         // API Call
        WebService.sharedInstance.callCurrentSearchNeighbrWebService(withParams: dictParams) { [weak self] data in
            guard let self = self else { return }
             // Clear previous data and load new data
            self.NeighbrhdData?.data.removeAll()
             DispatchQueue.main.async {
                // Update neighbourhood data
                self.NeighbrhdData = data
                
                // Check if neighbourhood data is available
                if let neighbourhoods = self.NeighbrhdData?.data, !neighbourhoods.isEmpty {
                    self.btnReachout.isHidden = true
                    self.saveButton.isHidden = false
                } else {
                    self.btnReachout.isHidden = false
                    self.saveButton.isHidden = true
                }
                
                // Reload table view and update height
                self.neighbourhoodDataShowTableView.reloadData()
                self.updateTableViewHeight()
            }
        }
    }
    
    
    // MARK: - Address api call
    
    func callAddressWebService() {
        let id = UserDefaults.standard.string(forKey: "userid")
        if self.from == 1
        {
            let dictParams: Dictionary<String, Any> = [
                "lati":  latitudeCurrentLocation,
                "longi":longitudeCurrentLocation,
                "areas": self.NeighbrhdData?.data.first?.nbdID ?? 0,
                "addlineone":self.tfFlat.text ?? "",
                "addlinetwo":self.tfStreet.text ?? "",
                "countryid": countryId ?? "",
                "stateid": stateId ?? "",
                "cityid":cityId ?? "",
                "pincode":self.tfPincode.text ?? "",
                "userid": id ?? ""
            ]
            
            print(dictParams)
            WebService.sharedInstance.callAddressWebService(withParams: dictParams) { data in
                self.AddressData = data
                self.callStateWebService()
                self.callCityWebService()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController")as! RegisterFirstViewController
                vc.name = self.name ?? ""
                vc.secname = self.secname ?? ""
                //                vc.Neighbourname = self.lblNeighbr.text ?? ""
                if let selectedIndexPath = self.selectedIndexPath {
                    vc.Neighbourname = self.NeighbrhdData?.data[selectedIndexPath.row].nbdName ?? ""
                } else {
                    vc.Neighbourname = "" // Default value
                }
                self.navigationController?.pushViewController(vc, animated: false)
                //
            }
        }
        
        else if self.from == 2
        {
            let dictParams: Dictionary<String, Any> = [
                "lati":  lat,
                "longi":long,
                "areas": self.NeighbrhdData?.data.first?.nbdID ?? 0,
                "addlineone":self.tfFlat.text ?? "",
                "addlinetwo":self.tfStreet.text ?? "",
                "countryid": countryId ?? "",
                "stateid": stateId ?? "",
                "cityid":cityId ?? "",
                "pincode":self.tfPincode.text ?? "",
                "userid": id ?? ""
            ]
            WebService.sharedInstance.callAddressWebService(withParams: dictParams) { data in
                self.AddressData = data
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController")as! RegisterFirstViewController
                 vc.name = self.name ?? ""
                vc.secname = self.secname ?? ""
                //                vc.Neighbourname = self.lblNeighbr.text ?? ""
                if let selectedIndexPath = self.selectedIndexPath {
                    vc.Neighbourname = self.NeighbrhdData?.data[selectedIndexPath.row].nbdName ?? ""
                } else {
                    vc.Neighbourname = "" // Default value
                }
                self.navigationController?.pushViewController(vc, animated: false)
                //
            }
            
        }
    }
    
    
    // MARK: -  CALL API FOR USER LOCATION   UserLocation current
    
    func callUserLocationWebService() {
        let id = UserDefaults.standard.string(forKey: "userid")
        print("✅ User ID after login: \(id ?? "Not Found")")
        let url = "https://dev.neighbrsnook.com/admin/api/user-location"
        let params: [String: Any] = [
            "userid": id,
            "latitude": lat ?? 0.0,
            "longitude": long ?? 0.0,
            "area_name": (self.lblArea.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines),
            "addlineone": self.tfFlat.text ?? "",
            "addlinetwo": self.tfStreet.text ?? "",
            "country_name": "India",
            "state_name": self.tfState.text ?? "",
            "city_name": self.tfCity.text ?? "",
            "pincode": Int(self.tfPincode.text ?? "0") ?? 0
        ]
        print(params)
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("✅ Response: \(data)")
            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    // MARK: - API call to post device information
    
    func callDeviceInfoWebService() {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        
        // Get device information
        let deviceInfo = getDeviceInfo()
        
        // Set up parameters for API
        let dictParams: [String: Any] = [
            "device_model": deviceInfo.deviceModel,
            "device_imei": deviceInfo.deviceIMEI,  // This will contain UUID
            "device_platform": deviceInfo.devicePlatform,
            "device_id": deviceInfo.deviceID,
            "user_id": userId
        ]
        
        // Call the Web Service
        WebService.sharedInstance.callDeviceInfo(withParams: dictParams) { data in
            // Handle the response here
            print("Device info posted successfully")
        }
    }
    
    
}




// MARK: - current location get first time screen call

@available(iOS 16.0, *)
extension RegisterSecondViewController: CLLocationManagerDelegate {
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            showPermissionDeniedAlert()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func showPermissionDeniedAlert() {
        let alert = UIAlertController(title: "Location Access Denied",
                                      message: "Please enable location access in settings.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        
        fetchAddress(from: location)
        locationManager.stopUpdatingLocation()
    }
    
    func fetchAddress(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first, error == nil else {
                print("Error in reverse geocoding: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let sector = placemark.subLocality ?? "Sector Not Found"
            let city = placemark.locality ?? "City Not Found"
            let state = placemark.administrativeArea ?? "State Not Found"
            let postalCode = placemark.postalCode ?? "PIN Not Found"
            let country = placemark.country ?? "Country Not Found"
            
            DispatchQueue.main.async {
                // ✅ Save to your variables
                self.lat = location.coordinate.latitude
                self.long = location.coordinate.longitude
                self.city = city
                self.state = state
                self.zipcode = postalCode
                
                // ✅ Set UI values
                self.lblSector.text = "\(sector), \(city), \(state), \(postalCode), \(country)"
                self.lblArea.text = "\(sector)"
                self.tfCity.text = city
                self.tfState.text = state
                self.tfPincode.text = postalCode
                self.lblForNeighourhood_ID.text = "(For \(sector).)"
                self.lblForNeighourhood_Address.text = "(For \(sector).)"
                self.callUserLocationWebService()
                
                // ✅ Move your print statements here
                print("City in RegisterSecondVC: \(self.city ?? "No City")")
                print("State in RegisterSecondVC: \(self.state ?? "No State")")
                print("Zipcode in RegisterSecondVC: \(self.zipcode ?? "No Zipcode")")
                print("Received Latitude: \(self.lat ?? 0.0)")
                print("Received Longitude: \(self.long ?? 0.0)")
            }
        }
    }
}



@available(iOS 16.0, *)
extension RegisterSecondViewController: UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - TableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = NeighbrhdData?.data.count ?? 0
        
        // Update label text based on the number of items
        if numberOfItems == 1 {
            lblYourneighbhood.text = "Your neighbourhood"
        } else if numberOfItems > 1 {
            lblYourneighbhood.text = "Select your neighbourhood"
        } else {
            lblYourneighbhood.text = "Your neighbourhood"
            selectedIndexPath = nil // Clear selection when there are no items
        }
        
        DispatchQueue.main.async {
            self.updateTableViewHeight()
        }
        
        return numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NeighbourhoodDataShowTableViewCell", for: indexPath) as! NeighbourhoodDataShowTableViewCell
        let data = NeighbrhdData?.data[indexPath.row]
        cell.textLabel?.text = data?.nbdName // Set name in the cell
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        // If there's only one item, automatically select it
        if NeighbrhdData?.data.count == 1 {
            selectedIndexPath = indexPath // Set first row as selected
        }
        // Update checkbox appearance based on selection
        cell.isCheckedNeig = (selectedIndexPath == indexPath) // Update selection
        cell.updateButtonAppearanceN() // Update button appearance
        // If cell is selected, change label color to green
        if selectedIndexPath == indexPath {
            cell.textLabel?.textColor = UIColor(red: 0.0, green: 128/255.0, blue: 0.0, alpha: 1.0) // Green for selected
            cell.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        } else {
            cell.textLabel?.textColor = UIColor.darkGray // Default color
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = NeighbrhdData?.data[indexPath.row]
        
        // If there are more than one items, allow selection
        if let previousIndexPath = selectedIndexPath {
            if previousIndexPath != indexPath {
                tableView.deselectRow(at: previousIndexPath, animated: false) // Deselect previous row
            }
        }
        
        selectedIndexPath = indexPath // Update the selected row
        tableView.reloadData() // Refresh the table view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // Automatic height based on content
    }
    
    // This function is for loading data and clearing existing data
    func loadDataForTableView() {
        // Clear existing data
        NeighbrhdData?.data = [] // Clear old data
        
        // Fetch new data
        callSearchNeighbrWebService(location: CLLocationCoordinate2D()) // Fetch data
        
        DispatchQueue.main.async {
            self.neighbourhoodDataShowTableView.reloadData() // Reload table
        }
    }
    
    func updateTableViewHeight() {
        let numberOfItems = NeighbrhdData?.data.count ?? 0
        let contentHeight = neighbourhoodDataShowTableView.contentSize.height
        
        if numberOfItems > 0 {
            neigbourhoodtblViewHeightConstraint.constant = contentHeight
            neigbourhoodViewHeightConstraint.constant = contentHeight // Set UIView height
        } else {
            neigbourhoodtblViewHeightConstraint.constant = 0
            neigbourhoodViewHeightConstraint.constant = 0 // Hide both if no items
        }
        
        // Call layoutIfNeeded to update the layout
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // Ensure layout update
        }
    }
}
