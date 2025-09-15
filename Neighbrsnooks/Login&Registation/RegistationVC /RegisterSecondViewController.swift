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
import FirebaseAnalytics

import Vision
import TOCropViewController


protocol neigSelectionDelegate: AnyObject {
    func didSelectItems(selectedItems: [String], forLabel tag: Int)
}

protocol LocationDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}



@available(iOS 16.0, *)
class RegisterSecondViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate  {
    
    @IBOutlet weak var tabNeighourhoodView: UIView!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    
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
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    // Enum to manage selected state of documents
    enum SelectedDocument {
        case aadhaar, passport, voterID, drivingLicense,rentdocs, none
    }
    
    enum DocumentType {
        case aadhaar, passport, voterID, drivingLicense,rentdocs, none
    }
    enum ImageSide {
        case front
        case back
    }
    enum SelectedDocumentType {
        case aadhaar, passport, voterID, drivingLicense,rentdocs, none
    }
    
    var selectedDocumentType: DocumentType?
    
    // Default images for front and back
    let defaultFrontImage = UIImage(named: "PhotoIDProof")
    let defaultBackImage = UIImage(named: "PhotoIDProof")
    
    var isFromProfile: Bool = false
    
    var hasCheckedNeighbourhood = false
    
    var allowMultipleSelection: Bool = true
    var data: [String] = []
    var selectedItems: [String] = []
    weak var delegate: neigSelectionDelegate?
    var labelTag: Int = 0
    var selectedIndexPath: IndexPath?
    var selectedLocation: String?
    weak var delegateSe: LocationDelegate?
    
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
    var originalHeight: CGFloat = 0
    var isDocumentSelected: Bool = false
    var isComingFromImagePicker: Bool = false
    var isPermissionPopupShown = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         UserDefaults.standard.set("step1", forKey: "registrationStep")
        
        setUp()
        self.navigationItem.hidesBackButton = true
        callDeviceInfoWebService() // Save device Info
        if !isComingFromSearchVC {
            locationManager.delegate = self
            checkLocationAuthorization()
            
        }
        originalHeight = addressProofViewheight.constant
        setInitialCollapsedView()
        self.btnReachout.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isComingFromSearchVC {
            isComingFromSearchVC = false
            print("📍 Coming from Search VC — Forcing setup")
            setUp() // ✅ Force API to call again
            return
        }
        
        if shouldSkipLocationPopup() {
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted {
            // showPermissionDeniedAlert()
        }
    }
    
    
    
    
    func shouldSkipLocationPopup() -> Bool {
        if isComingFromImagePicker {
            return true
        }
        if isComingFromSearchVC {
            isComingFromSearchVC = false
            return true
        }
        return false
    }
    
    func setInitialCollapsedView() {
        frontImageView.isHidden = true
        backImageView.isHidden = true
        lblFront.isHidden = true
        lblBack.isHidden = true
        // Reduce height by 100
        addressProofViewheight.constant = originalHeight - 50
        self.view.layoutIfNeeded()
    }
    
//    func setUp(){
//        frontImageView.isHidden = true
//        backImageView.isHidden = true
//        lblFront.isHidden = true
//        lblBack.isHidden = true
//        tfCity.text = city ?? ""
//        tfState.text = state ?? ""
//        tfPincode.text = zipcode
//        // Debug prints to check the values
//        print("City in RegisterSecondVC: \(city ?? "No City")")
//        print("State in RegisterSecondVC: \(state ?? "No State")")
//        print("Zipcode in RegisterSecondVC: \(zipcode ?? "No Zipcode")")
//        print("Received Latitude: \(latitudeS ?? 0.0)")
//        print("Received Longitude: \(longitudeS ?? 0.0)")
//        
//        
//        if let location = selectedLocation {
//            lblSector.text = location
//            let coordinate = CLLocationCoordinate2D(
//                latitude: self.latitudeS ?? 0.0,
//                longitude: self.longitudeS ?? 0.0
//            )
//            //            self.callSearchNeighbrWebService(location: coordinate)
//            let geocoder = CLGeocoder()
//            let clLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            geocoder.reverseGeocodeLocation(clLocation) { [weak self] placemarks, error in
//                guard let self = self else { return }
//                
//                if let placemark = placemarks?.first {
//                    let subLocality = placemark.subLocality ?? "Sub Locality not found"
//                    self.lblArea.text = subLocality
//                    self.lblForNeighourhood_ID.text = "(For \(subLocality))"
//                    self.lblForNeighourhood_Address.text = "(For \(subLocality))"
//                    print("✅ SubLocality set:", subLocality)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        self.callRegSecWebService {}
//                        self.callSearchNeighbrWebService(location: coordinate)
//                    }
//                } else {
//                    self.lblArea.text = "Sub Locality not found"
//                }
//            }
//        }
    
    
    func setUp() {
        // Basic Form fields
        tfCity.text    = city ?? ""
        tfState.text   = state ?? ""
        tfPincode.text = zipcode ?? ""
        print("City in RegisterSecondVC: \(city ?? "No City")")
        print("State in RegisterSecondVC: \(state ?? "No State")")
        print("Zipcode in RegisterSecondVC: \(zipcode ?? "No Zipcode")")
        print("Received Latitude: \(latitudeS ?? 0.0)")
        print("Received Longitude: \(longitudeS ?? 0.0)")


        
        if let location = selectedLocation {
                lblSector.text = location

                let coordinate = CLLocationCoordinate2D(
                    latitude: self.latitudeS ?? 0.0,
                    longitude: self.longitudeS ?? 0.0
                )

                // 👇 Yeh dono case me same selectedLocation pass karo
                lblArea.text = location
                lblForNeighourhood_ID.text = "(For \(location))"
                lblForNeighourhood_Address.text = "(For \(location))"

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.callRegSecWebService {}
                    self.callSearchNeighbrWebService(location: coordinate)
                }
            } else {
                lblArea.text = "Area not found"
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
    
    
    
    
    func updateLocationDetails(latitude: Double, longitude: Double) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let placemark = placemarks?.first {
                // ✅ Sub Locality (like Sector 16A, Andheri East)
                let subLocality = placemark.subLocality ?? "Sub Locality not found"
                self.lblArea.text = subLocality
                self.lblForNeighourhood_ID.text = "(For \(subLocality))"
                self.lblForNeighourhood_Address.text = "(For \(subLocality))"
                
                print("✅ SubLocality Set:", subLocality)
                
                // Call APIs after setting sublocality
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.callRegSecWebService {}
                    
                    self.callSearchNeighbrWebService(
                        location: CLLocationCoordinate2D(
                            latitude: latitude,
                            longitude: longitude
                        )
                    )
                }
            } else {
                self.lblArea.text = "Sub Locality not found"
            }
        }
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
                    print("Musk text is : \(text)")
                }
            }
            
            if result.isEmpty {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: nil, message: "Couldn’t read the Aadhaar card. Please take a clearer photo.", preferredStyle: .alert)
                    let attributedMessage = NSAttributedString(
                        string: "Couldn’t read the Aadhaar card. Please take a clearer photo.",
                        attributes: [
                            .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
                        ])
                    alert.setValue(attributedMessage, forKey: "attributedMessage")
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
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
            selectedDocumentType = .rentdocs
            handleDocumentSelection(.rentdocs)
            print("RentDoc License selected")
        case 2:
            selectedDocumentType = .drivingLicense
            handleDocumentSelection(.drivingLicense)
            print("Driving License selected")
        case 3:
            selectedDocumentType = .voterID
            handleDocumentSelection(.voterID)
            print("Voter ID selected")
        case 4:
            selectedDocumentType = .passport
            handleDocumentSelection(.passport)
            print("Passport selected")
        case 5:
            selectedDocumentType = .aadhaar
            handleDocumentSelection(.aadhaar)
            print("Aadhaar selected")
        default:
            selectedDocumentType = nil
        }
    }
    
    
    
    // Document selection update function
    private func handleDocumentSelection(_ document: SelectedDocument) {
        clearUploadedImagesIfDocumentChanged(to: document)
        
        updateButtonStates()
        isDocumentSelected = true
        frontImageView.isUserInteractionEnabled = selectedDocument != .none
        backImageView.isUserInteractionEnabled = selectedDocument != .none
        lblFront.isUserInteractionEnabled = selectedDocument != .none
        lblBack.isUserInteractionEnabled = selectedDocument != .none
        showImageViews()
        // Document name
        var documentName = ""
        switch document {
        case .aadhaar:
            documentName = "Aadhaar card"
        case .passport:
            documentName = "Passport"
        case .voterID:
            documentName = "Voter ID"
        case .drivingLicense:
            documentName = "Driving License"
        case .rentdocs:
            documentName = "Rent Lease / Electricity Bill"
        case .none:
            return
        }
        // Neighbourhood/area
        let sector = lblArea.text ?? "your neighbourhood"
        // Build attributed message
        let fullMessage = NSMutableAttributedString()
        
        // Common message for all
        let messagePart = NSAttributedString(
            string: "Please upload your \(documentName)—must show address in ",
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.darkGray
            ]
        )
        fullMessage.append(messagePart)
        // Area/sector name
        let areaPart = NSAttributedString(
            string: "\(sector).", // ya sirf "." agar space bilkul nahi chahiye
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.fromHex("#008000")
            ]
        )
        
        
        fullMessage.append(areaPart)
        // Aadhaar-specific safety note
        if document == .aadhaar {
            let safetyNote = NSAttributedString(
                string: "\nFor your safety, it will be automatically masked.",
                attributes: [
                    .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor.gray
                ]
            )
            fullMessage.append(safetyNote)
        }
        // Show the alert
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(fullMessage, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    
    @IBAction func aadhaarButtonTapped(_ sender: UIButton) {
        clearUploadedImagesIfDocumentChanged(to: .aadhaar)
        selectedDocument = .aadhaar
        showImageViews()
        updateButtonStates()
    }
    
    @IBAction func passportButtonTapped(_ sender: UIButton) {
        clearUploadedImagesIfDocumentChanged(to: .passport)
        selectedDocument = .passport
        showImageViews()
        updateButtonStates()
    }
    
    @IBAction func voterIDButtonTapped(_ sender: UIButton) {
        clearUploadedImagesIfDocumentChanged(to: .voterID)
        selectedDocument = .voterID
        showImageViews()
        updateButtonStates()
    }
    
    @IBAction func drivingLicenseButtonTapped(_ sender: UIButton) {
        clearUploadedImagesIfDocumentChanged(to: .drivingLicense)
        selectedDocument = .drivingLicense
        showImageViews()
        updateButtonStates()
    }
    
    @IBAction func rentdocsTapped(_ sender: Any) {
        clearUploadedImagesIfDocumentChanged(to: .rentdocs)
        selectedDocument = .rentdocs
        showImageViews()
        updateButtonStates()
    }
    
    
    func clearUploadedImagesIfDocumentChanged(to newDocument: SelectedDocument) {
        if selectedDocument != newDocument {
            frontImageView.image = nil
            backImageView.image = nil
        }
        selectedDocument = newDocument // Ensure selectedDocument is updated here
    }
    
    func showImageViews() {
        if selectedDocument == .rentdocs {
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
        
        // ✅ Always show default image if image is nil
        if frontImageView.image == nil {
            frontImageView.image = UIImage(named: "PhotoIDProof")
        }
        if backImageView.image == nil && selectedDocument != .rentdocs {
            backImageView.image = UIImage(named: "PhotoIDProof")
        }
        
        if isDocumentSelected {
            addressProofViewheight.constant = originalHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    
    // Update buttons and image views states
    func updateButtonStates() {
        let buttons: [(UIButton?, SelectedDocument)] = [
            (aadhaarButton, .aadhaar),
            (passportButton, .passport),
            (voterIDButton, .voterID),
            (drivingLicenseButton, .drivingLicense),
            (rentdocsButton, .rentdocs)
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
                button.tintColor = .darkGray
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
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let font = UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let messageAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.darkGray
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
        
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
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
                checkCameraPermission { granted in // ✅ NO `self.`
                    if granted {
                        self.openImagePicker(sourceType: .camera)
                    }
                }
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
    
    
    
    
    
    // MARK: - Image Picker Setup
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        isComingFromImagePicker = true // ✅ Set before opening picker
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            self.isComingFromImagePicker = false // ✅ Reset flag after dismiss
        }
        
        if let originalImage = info[.originalImage] as? UIImage {
            let cropViewController = TOCropViewController(croppingStyle: .default, image: originalImage)
            cropViewController.delegate = self
            cropViewController.aspectRatioLockEnabled = false
            cropViewController.resetAspectRatioEnabled = true
            cropViewController.aspectRatioPickerButtonHidden = false
            cropViewController.toolbar.clampButtonHidden = false
            cropViewController.toolbar.rotateClockwiseButtonHidden = false
            cropViewController.cropView.cropBoxResizeEnabled = true
            
            present(cropViewController, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.isComingFromImagePicker = false  // ✅ Delay reset
            }
        }
        imageViewToUpdate = nil
    }
    
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
            cropViewController.dismiss(animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.isComingFromImagePicker = false
                }
            }

            // Aadhaar validation only if selectedDocumentType == .aadhar
            if selectedDocumentType == .aadhaar {
                detectText(in: image) { observations in
                    let aadhaarObservations = self.findAadhaarNumbers(in: observations)

                    DispatchQueue.main.async {
                        if !aadhaarObservations.isEmpty,
                           let maskedImage = self.maskDigits(in: image, from: observations) {
                            // ✅ Aadhaar found, apply masked image
                            self.imageViewToUpdate?.image = maskedImage
                        } else {
                            // ❌ Aadhaar not found, show placeholder for front/back
                            if self.imageViewToUpdate === self.frontImageView || self.imageViewToUpdate === self.backImageView {
                                self.imageViewToUpdate?.image = UIImage(named: "PhotoIDProof")
                            } else {
                                self.imageViewToUpdate?.image = nil
                            }
                        }

                        self.imageViewToUpdate = nil
                    }
                }
            } else {
                // For other document types, just assign the image directly
                DispatchQueue.main.async {
                    self.imageViewToUpdate?.image = image
                    self.imageViewToUpdate = nil
                }
            }
        }
    
    
    
    
    //MARK: -   crop end
    
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
//        let alert = UIAlertController(title: "Heads up!",
//                                      message: "If you go back now, you'll be logged out and everything you've filled will be lost.\nWant to continue?",
//                                      preferredStyle: .alert)
//        
//        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
//        
//        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
//            // ✅ Clear session-related data
//            let defaults = UserDefaults.standard
//            defaults.removeObject(forKey: "userid")
//            defaults.removeObject(forKey: "registrationStep")
//            defaults.set(false, forKey: "isRegistered")
//            defaults.synchronize()
//            
//            // ✅ Reset full root controller to LoginViewController
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//            let navController = UINavigationController(rootViewController: loginVC)
//            
//            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = scene.windows.first {
//                window.rootViewController = navController
//                window.makeKeyAndVisible()
//            }
//        }
//        
//        alert.addAction(noAction)
//        alert.addAction(yesAction)
//        self.present(alert, animated: true, completion: nil)
        let alert = UIAlertController(title: "Heads up!", message: nil, preferredStyle: .alert)
                  
                  let attributedMessage = NSAttributedString(
                      string: "If you go back now, you'll be logged out and everything you've filled will be lost.Want to continue?",
                      attributes: [
                          .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                          .foregroundColor: #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
                      ])
                  alert.setValue(attributedMessage, forKey: "attributedMessage")
                  
                  let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                  
                  let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                      if let navController = self.navigationController {
                          for controller in navController.viewControllers {
                              if controller is RegisterViewController {
                                  navController.popToViewController(controller, animated: true)
                                  return
                              }
                          }
                      }

                      // If not found in stack, fallback: instantiate and present it
                      let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                      vc.modalPresentationStyle = .fullScreen
                      self.present(vc, animated: true, completion: nil)
                  }

                  // Optional: Customize "Yes" and "No" action title color
                  yesAction.setValue(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
                  noAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")

                  alert.addAction(noAction)
                  alert.addAction(yesAction)
                  
                  self.present(alert, animated: true, completion: nil)
    }
    
    
    //    @IBAction func actionReachout(_ sender: Any) {
    //
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    //        callReachoutWebService()
    //        self.navigationController?.pushViewController(vc, animated: true)
    //
    //    }
    
    @IBAction func actionReachout(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let message = "Thank you for sharing your address details. We will get a Neighborhood created for you soon."
        
        let font = UIFont(name: "Montserrat-Regular", size: 18) ?? UIFont.systemFont(ofSize: 14)
        let attributedMessage = NSAttributedString(string: message, attributes: [
            .font: font,
            .foregroundColor: UIColor.darkGray
        ])
        
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.callReachoutWebService()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
    
    //    @IBAction func nextBtn(_ sender: UIButton){
    //
    //        if let validationMessage = validateForm() {
    //            // Agar form valid nahi hai, to alert show karo
    //            showAlert(message: validationMessage)
    //            return
    //        }
    //        UserDefaults.standard.set("step2", forKey: "registrationStep")
    //
    //
    //        // Show loader on button before API call
    //        UIHelper.showLoader(on: sender, show: true)
    //
    //        // Sab checks pass hone ke baad API call karein
    //        callRegSecWebService {
    //            DispatchQueue.main.async {
    //                // Hide loader after API response
    //                UIHelper.showLoader(on: sender, show: false)
    //
    //                print("Call API")
    //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController") as! RegisterFirstViewController
    //                vc.name = self.name ?? ""
    //                vc.secname = self.secname ?? ""
    //                if let selectedIndexPath = self.selectedIndexPath {
    //                    vc.Neighbourname = self.NeighbrhdData?.data?[selectedIndexPath.row].nbdName ?? ""
    //                } else {
    //                    vc.Neighbourname = "" // Default value
    //                }
    //                self.navigationController?.pushViewController(vc, animated: true)
    //            }
    //        }
    //    }
    
    @IBAction func nextBtn(_ sender: UIButton){
        
        // First check only selectedIndexPath
        if !hasCheckedNeighbourhood {
            guard selectedIndexPath != nil else {
                showAlert(message: "Please select your neighbourhood")
                return
            }
            hasCheckedNeighbourhood = true
        }
        
        // Full validation
        if let validationMessage = validateForm() {
            showAlert(message: validationMessage)
            return
        }
        
//        UserDefaults.standard.set("step2", forKey: "registrationStep")
        UIHelper.showLoader(on: sender, show: true)
        
        callRegSecWebService {
            DispatchQueue.main.async {
                UIHelper.showLoader(on: sender, show: false)
                print("Call API")
                
                // Firebase Analytics event yahan log karein
                Analytics.logEvent("registration_step2_completed_iOS", parameters: [
                    "name": self.name ?? "",
                    "secname": self.secname ?? "",
                    "neighbourhood": (self.selectedIndexPath != nil) ? (self.NeighbrhdData?.data?[self.selectedIndexPath!.row].nbdName ?? "") : "",
                    "timestamp": Date().timeIntervalSince1970,
                    "platform": "iOS"
                ])
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterFirstViewController") as! RegisterFirstViewController
                vc.name = self.name ?? ""
                vc.secname = self.secname ?? ""
                if let selectedIndexPath = self.selectedIndexPath {
                    vc.Neighbourname = self.NeighbrhdData?.data?[selectedIndexPath.row].nbdName ?? ""
                } else {
                    vc.Neighbourname = ""
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
            return "Please enter flat/house/door #, tower/unit #"
        } else if selectedDocumentType == nil {
            return "Please upload one ID-Address proof."
        }
        
        if selectedDocumentType == .rentdocs {
            if frontImageView.image == nil || frontImageView.image == UIImage(named: "PhotoIDProof") {
                return "Please upload the front photo of the ID."
            }
        } else if selectedDocumentType != .none {
            if frontImageView.image == nil || frontImageView.image == UIImage(named: "PhotoIDProof") {
                return "Please upload the front photo of the ID."
            }
            if backImageView.image == nil || backImageView.image == UIImage(named: "PhotoIDProof") {
                return "Please upload the back photo of the ID."
            }
        }
        
        if genderTextField.text?.isEmpty ?? true {
            return "Please select gender"
        } else if dobTextField.text?.isEmpty ?? true {
            return "Please select date of birth"
        }
        
        return nil
    }
    
    
    
    //    func validateForm() -> String? {
    //        if tfCountry.text?.isEmpty ?? true {
    //            return "Please enter country"
    //        } else if tfState.text?.isEmpty ?? true {
    //            return "Please enter state"
    //        } else if tfFlat.text?.isEmpty ?? true {
    //            return "Please enter flat/house/door #, tower/unit #"
    //            //        } else if tfStreet.text?.isEmpty ?? true {
    //            //            return "Please enter apartment name, road/street name"
    //        } else if selectedIndexPath == nil {
    //            return "Please select the neighbourhood"
    //        } else if selectedDocumentType == nil {
    //            return "Please upload one ID-Address proof."
    //        }
    //
    //        // RentDoc ke liye sirf front image validate karein
    //        if selectedDocumentType == .rentdocs {
    //            if frontImageView.image == nil || frontImageView.image == UIImage(named: "PhotoIDProof") {
    //                return "Please upload the front photo of the ID."
    //            }
    //        }
    //        // Baki sab documents ke liye dono images validate karein
    //        else if selectedDocumentType != .none {
    //            if frontImageView.image == nil || frontImageView.image == UIImage(named: "PhotoIDProof") {
    //                return "Please upload the front photo of the ID."
    //            }
    //            if backImageView.image == nil || backImageView.image == UIImage(named: "PhotoIDProof") {
    //                return "Please upload the back photo of the ID."
    //            }
    //        }
    //
    //        if genderTextField.text?.isEmpty ?? true {
    //            return "Please select gender"
    //        } else if dobTextField.text?.isEmpty ?? true {
    //            return "Please select date of birth"
    //        }
    //
    //        return nil
    //    }
    //
    
    func getValidImageURL(from docsData: Docsdata, isBackImage: Bool = false) -> String? {
        if isBackImage {
            // Check back images
            if !docsData.passportBack.isEmpty {
                return docsData.passportBack
            } else if !docsData.aadharBack.isEmpty {
                return docsData.aadharBack
            } else if !docsData.voteridBack.isEmpty {
                return docsData.voteridBack
            } else if !docsData.drivingLicenseBack.isEmpty {
                return docsData.drivingLicenseBack
            } else if !docsData.rentDocs.isEmpty {
                return docsData.rentDocs
            }
        } else {
            // Check front images
            if !docsData.passportFront.isEmpty {
                return docsData.passportFront
            } else if !docsData.aadharFront.isEmpty {
                return docsData.aadharFront
            } else if !docsData.voteridFront.isEmpty {
                return docsData.voteridFront
            } else if !docsData.drivingLicenseFront.isEmpty {
                return docsData.drivingLicenseFront
            } else if !docsData.rentDocs.isEmpty {
                return docsData.rentDocs
            }
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
        
        var formattedDOB = ""
        if let dobString = self.dobTextField.text, !dobString.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let date = dateFormatter.date(from: dobString) {
                formattedDOB = dateFormatter.string(from: date)
            } else {
                formattedDOB = dobString // fallback: pass as is
            }
        }

        
        // Parameters prepare karein
        let dictParams: [String: String] = [
            "userid": userID,
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "dob": formattedDOB,
            "areas": self.NeighbrhdData?.data?.first?.nbdID ?? "",
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
        case .aadhaar:
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
            
        case .rentdocs:
            if let frontImage = self.frontImageView.image {
                images.append(("rentdocs", frontImage))  // TEST: intentionally send rentdocs image with Aadhaar key
            }
            
            
            
        default:
            print("Koi document selected nahi hai")
            return
        }
        
        // Set URL //dev.
        guard let url = URL(string: "https://neighbrsnook.com/oldadmin/api/master?flag=reg-step-II") else {
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
            "areas": self.NeighbrhdData?.data?.first?.nbdID ?? "",
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
            
            
            // Event log for Reachout Call
            Analytics.logEvent("reachout_api_called_iOS", parameters: [
                "status": self.ReachoutNeighborhoodData?.status ?? "",
                "message": self.ReachoutNeighborhoodData?.message ?? "",
                "area": self.NeighbrhdData?.data?.first?.nbdID ?? "",
                "platform": "iOS"
            ])
            
        }
    }
    
    
    
    //MARK: - Function to show alert
    func showNeighborhoodAlert(withMessage message: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        // Message attributed
        let messageFont = [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 14)!,
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ]
        let attributedMessage = NSAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        // Add OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        // Present alert
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        } else {
            print("Failed to find a view controller to present the alert.")
        }
    }
    
    
    //MARK: - call Search Neighborhood api
    
    //    func callSearchNeighbrWebService(location: CLLocationCoordinate2D) {
    //        let dictParams: [String: Any] = [
    //            "lati": latitudeS ?? 0.0,
    //            "longi": longitudeS ?? 0.0,
    //            "areas": lblArea.text ?? ""
    //        ]
    //
    //        print("📤 [callSearchNeighbrWebService] Params:", dictParams)
    //
    //        WebService.sharedInstance.callSearchNeighbrWebService(withParams: dictParams) { [weak self] data in
    //            guard let self = self else {
    //                print("⚠️ Self is nil")
    //                return
    //            }
    //
    //            DispatchQueue.main.async {
    //                let status = data.status?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    //                print("📥 Status: \(status ?? "nil")")
    //
    //                self.NeighbrhdData?.data?.removeAll()
    //
    //                if status == "success" {
    //                    print("✅ CASE 1: SUCCESS")
    //                    if let validData = data.data, !validData.isEmpty {
    //                        self.NeighbrhdData = data
    //
    //                    } else {
    //                        print("⚠️ Success but no data")
    //                        self.NeighbrhdData = nil
    //                    }
    //                } else {
    //                    print("❌ CASE 0: FAILURE — calling fallback")
    //                    self.NeighbrhdData = nil
    //                    self.callNeighorhodStatusStateCity()
    //                }
    //                self.callNeighorhodStatusStateCity()
    //
    //                // ✅ always called now
    //                self.neighbourhoodDataShowTableView.reloadData()
    //                self.updateTableViewHeight()
    //            }
    //        }
    //    }
    //
    
    
    func callSearchNeighbrWebService(location: CLLocationCoordinate2D) {
        let dictParams: [String: Any] = [
            "lati": latitudeS ?? 0.0,
            "longi": longitudeS ?? 0.0,
            "areas": lblArea.text ?? ""
        ]
        
        print("📤 [callSearchNeighbrWebService] Params:", dictParams)
        
        WebService.sharedInstance.callSearchNeighbrWebService(withParams: dictParams) { [weak self] data in
            guard let self = self else {
                print("⚠️ Self is nil")
                return
            }
            
            DispatchQueue.main.async {
                let status = data.status?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                print("📥 Status: \(status ?? "nil")")
                
                self.NeighbrhdData?.data?.removeAll()
                
                var shouldShowMessage = false
                
                if status == "success", let validData = data.data, !validData.isEmpty {
                    // ✅ Data mila
                    self.NeighbrhdData = data
                    shouldShowMessage = false
                    
                    // ✅ Show Save Button, Hide Reachout
                    self.saveButton.isHidden = false
                    self.btnReachout.isHidden = true
                } else {
                    // ❌ Data nahi mila
                    self.NeighbrhdData = nil
                    shouldShowMessage = true
                    
                    // ❌ Hide Save Button, Show Reachout
                    self.saveButton.isHidden = true
                    self.btnReachout.isHidden = false
                }
                
                self.callNeighorhodStatusStateCity(shouldShowAlert: shouldShowMessage)
                self.neighbourhoodDataShowTableView.reloadData()
                self.updateTableViewHeight()
            }
        }
    }
    
    
    
    
    
    
    // MARK: - ---------***********   Neighborhood Status By State/City/Pincode api  post ---------------**************
    
    //    func callNeighorhodStatusStateCity() {
    //        let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
    //        let dictParams: [String: Any] = [
    //            "area": lblArea.text ?? "",
    //            "countryid": "100",
    //            "lati": latitudeS ?? 0.0,
    //            "longi": longitudeS ?? 0.0,
    //            "stateid": self.tfState.text ?? "",
    //            "cityid": self.tfCity.text ?? "",
    //            //            "pincode": self.tfPincode.text ?? "",
    //            "userid": userID
    //        ]
    //        print("Calling API with parameters:", dictParams)
    //        WebService.sharedInstance.callNeighborhoodStatusByState(withParams: dictParams) { [weak self] (responseModel: NeighborhoodStatusByStateModel) in
    //            guard let self = self else { return }
    //            print("API Response - Status: \(responseModel.status), Message: \(responseModel.message)")
    //            DispatchQueue.main.async {
    //                if responseModel.message == "Neighborhood found." {
    //                    self.btnReachout.isHidden = true
    //                    self.saveButton.isHidden = false
    //                } else {
    //                    self.btnReachout.isHidden = false
    //                    self.saveButton.isHidden = true
    //                    self.showNeighborhoodAlert(withMessage: responseModel.message)
    //                }
    //            }
    //        }
    //    }
    
    
    
    
    func callNeighorhodStatusStateCity(shouldShowAlert: Bool = true) {
        let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "area": lblArea.text ?? "",
            "countryid": "100",
            "lati": latitudeS ?? 0.0,
            "longi": longitudeS ?? 0.0,
            "stateid": self.tfState.text ?? "",
            "cityid": self.tfCity.text ?? "",
            "userid": userID
        ]
        
        print("Calling API with parameters:", dictParams)
        
        WebService.sharedInstance.callNeighborhoodStatusByState(withParams: dictParams) { [weak self] (responseModel: NeighborhoodStatusByStateModel) in
            guard let self = self else { return }
            print("API Response - Status: \(responseModel.status), Message: \(responseModel.message)")
            
            DispatchQueue.main.async {
                if shouldShowAlert && responseModel.message != "Neighborhood found." {
                    self.showNeighborhoodAlert(withMessage: responseModel.message)
                }
                
                // Event log karo yahan
                Analytics.logEvent("neighborhood_status_fetched_iOS", parameters: [
                    "status": responseModel.status,
                    "message": responseModel.message,
                    "area": self.lblArea.text ?? "",
                    "userid": UserDefaults.standard.string(forKey: "userid") ?? "",
                    "platform": "iOS"
                ])
                
            }
        }
    }
    
    
    
    
    
    //MARK: - CurrentSearch location
    
    func callCurrentSearchNeighbrWebService(withArea area: String) {
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
            self.NeighbrhdData?.data?.removeAll()
            DispatchQueue.main.async {
                // Update neighbourhood data
                self.NeighbrhdData = data
                
                // Check if neighbourhood data is available
                if let neighbourhoods = self.NeighbrhdData?.data, !neighbourhoods.isEmpty {
                    self.btnReachout.isHidden = true
                    self.saveButton.isHidden = false
                    // Event: Neighborhood data found
                    Analytics.logEvent("neighborhood_search_success_iOS", parameters: [
                        "area": self.lblArea.text ?? "",
                        "count": neighbourhoods.count,
                        "platform": "iOS"
                    ])
                    
                } else {
                    self.btnReachout.isHidden = false
                    self.saveButton.isHidden = true
                }
                
                // Reload table view and update height
                self.neighbourhoodDataShowTableView.reloadData()
                self.callUserLocationWebService()
                self.updateTableViewHeight()
                
            }
            
        }
    }
    
    
    
    
    
    // MARK: -  CALL API FOR USER LOCATION   UserLocation current dev.
    
    func callUserLocationWebService() { //dev.
        let id = UserDefaults.standard.string(forKey: "userid")
        print("✅ User ID after login: \(id ?? "Not Found")")
        let url = "https://neighbrsnook.com/admin/api/user-location"
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
    
    
    func checkLocationAuthorization() {
        if isComingFromSearchVC {
            return // skip alert logic
        }
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            requestLocationAuthorization() // ✅ yahi sahi jagah hai
//        case .restricted, .denied:
//            showPermissionDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            break
        }
    }
    
    
    
    
    // ✅ Correct place — inside RegisterSecondViewController
    func showPermissionDeniedAlert() {
        if isPermissionPopupShown { return } // Agar popup already show ho raha hai, to return kar jao
        isPermissionPopupShown = true // Mark as shown
        
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "LocationPermissionPopupVC") as? LocationPermissionPopupVC {
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            
            popupVC.onEnableLocation = { [weak self] in
                guard let self = self else { return }
                self.isPermissionPopupShown = false // Reset flag when action taken
                
                let status = CLLocationManager.authorizationStatus()
                
                if status == .denied || status == .restricted {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.requestLocationAuthorization()
                    }
                }
            }
            
            popupVC.onManualLocation = { [weak self] in
                self?.isPermissionPopupShown = false // Reset flag
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let manualVC = self?.storyboard?.instantiateViewController(withIdentifier: "SearchNeighouhoodViewController") as? SearchNeighouhoodViewController {
                        self?.navigationController?.pushViewController(manualVC, animated: true)
                    }
                }
            }
            
            self.present(popupVC, animated: true) {
                // Optional: reset after presenting is done if needed
            }
        }
    }
    
    func requestLocationAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // ✅ This triggers iOS permission alert
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.showPermissionDeniedAlert() // ✅ Yahi sahi place hai alert dikhane ka
            }
        case .notDetermined:
            break
        default:
            break
        }
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
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
                // ✅ Update properties
                self.lat = location.coordinate.latitude
                self.long = location.coordinate.longitude
                self.city = city
                self.state = state
                self.zipcode = postalCode
                
                // ✅ Set UI values
                self.lblSector.text = "\(sector), \(city), \(state), \(postalCode), \(country)"
                self.lblArea.text = "\(sector)" // <-- Yeh yahan set ho raha hai
                self.tfCity.text = city
                self.tfState.text = state
                self.tfPincode.text = postalCode
                self.lblForNeighourhood_ID.text = "(For \(sector).)"
                self.lblForNeighourhood_Address.text = "(For \(sector).)"
                
                print("✅ lblArea.text:", self.lblArea.text ?? "nil")
                print("✅ Lat:", self.lat ?? 0.0)
                print("✅ Long:", self.long ?? 0.0)
                
                // ✅ Ab yahan API call karo, jab lblArea.text set ho chuka
                self.callCurrentSearchNeighbrWebService(withArea: sector)
                //                  self.callSearchNeighbrWebService(location: CLLocationCoordinate2D(latitude: self.lat ?? 0.0, longitude: self.long ?? 0.0))
                
            }
        }
    }
    
}



@available(iOS 16.0, *)
extension RegisterSecondViewController: UITableViewDataSource, UITableViewDelegate , NeighbourhoodDataShowTableViewCellDelegate{
    
    // MARK: - TableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = NeighbrhdData?.data?.count ?? 0
        
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
        let data = NeighbrhdData?.data?[indexPath.row]
        cell.textLabel?.text = data?.nbdName // Set name in the cell
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        // If there's only one item, automatically select it
        if NeighbrhdData?.data?.count == 1 {
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
        
        // Mark selection
        cell.isCheckedNeig = (selectedIndexPath == indexPath)
        cell.updateButtonAppearanceN()
        
        // Label color change
        cell.textLabel?.textColor = (selectedIndexPath == indexPath)
        ? UIColor(red: 0.0, green: 128/255.0, blue: 0.0, alpha: 1.0)
        : .darkGray
        
        // Delegate setup
        cell.delegate = self
        cell.indexPath = indexPath
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = NeighbrhdData?.data?[indexPath.row]
        
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
    
    func didTapCheckbox(at indexPath: IndexPath) {
        // Select new index path
        if selectedIndexPath == indexPath {
            // Optional: allow deselection
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        neighbourhoodDataShowTableView.reloadData()
    }
    
    func updateTableViewHeight() {
        let numberOfItems = NeighbrhdData?.data?.count ?? 0
        let contentHeight = neighbourhoodDataShowTableView.contentSize.height
        
        if numberOfItems > 0 {
            neigbourhoodtblViewHeightConstraint.constant = contentHeight
            neigbourhoodViewHeightConstraint.constant = contentHeight // Set UIView height
        } else {
            neigbourhoodtblViewHeightConstraint.constant = 0
            neigbourhoodViewHeightConstraint.constant = 0 // Hide both if no items
        }
        
        // Call layoutIfNeeded to update the layout
        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded() // Ensure layout update
        }
    }
}

