//
//  NewRegistationSecondStepVC.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 02/08/25.
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
import FBSDKCoreKit


class NewRegistationSecondStepVC: BaseViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tblViewNeighbrhood: UITableView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewNeighbourhood: UIView!
    @IBOutlet weak var lblNeighbrhood: UILabel!
    @IBOutlet weak var lblNeighbroodAddresh: UILabel!
    @IBOutlet weak var viewNeighbourhoodAddresh: UIView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblPincode: UILabel!
    @IBOutlet weak var txtFieldFlatHouse: UITextView!
    @IBOutlet weak var lblYourNeighbiurhood: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblYourNeighbourhood: UILabel!
    @IBOutlet weak var lblSelectYourResidence: UILabel!
    @IBOutlet weak var llblNeighboursConnect: UILabel!
    @IBOutlet weak var txtFielsAddheight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnReachout: UIButton!
    
    var shouldCallAPIOnAppear: Bool = false
    let locationManager = CLLocationManager()
    var selectedLocation: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var latitudeS: Double?
    var longitudeS: Double?
    var lat: Double?
    var long: Double?
    var isFromProfile: Bool = false
    var isComingFromSearchVC: Bool = false
    var fullAddress: String?
    var RegistrationSec : RegistrationSecModel?
    var NeighbrhdData : NgbbrhoodModel?
    var AddressData : AddressModel?
    var ReachoutNeighborhoodData : ReachoutNeighborhoodModel?
    var NeighborhoodStatusByStateData: NeighborhoodStatusByStateModel?
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    var name: String?
    var secname: String?
    var sourceScreen: String?
    var backsourceScreen: String?
    var userId: String?
    var selectedIndexPath: IndexPath?
    var profileData: ProfileModel?
    var uploadedDocuments: UploadedDocumentsModel?
    var savedUploadedDocuments: UploadedDocumentsModel?
    var isComingFromImagePicker: Bool = false
    var shouldUpdateUIOnAppear = true
    var isComingrom:String?
    let baseViewHeight: CGFloat = 60
    var savedCity: String?
    var savedState: String?
    var savedZipcode: String?
    var savedFullAddress: String?
    var savedNeighbourhood: String?
    var savedLatitude: Double?
    var savedLongitude: Double?
    var referNeighbourhoodID: String?
    var referNeighbourhoodName: String?
    var referralStatus: Int?
    var referCityName: String?
    var referStateName : String?
    var referPincode : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Neighbourhood ID:", referNeighbourhoodID ?? "nil")
        print("Neighbourhood Name:", selectedLocation ?? "nil")
        print("Referral Status:", referralStatus ?? 0)
        lblNeighbrhood.text = selectedLocation ?? ""
        lblCity.text = city ?? ""
        lblPincode.text = zipcode ?? ""
        lblState.text = state ?? ""
        lblNeighbroodAddresh.text = selectedLocation ?? ""
        tblViewNeighbrhood.isScrollEnabled = false
        txtFieldFlatHouse.autocapitalizationType = .words
        tblViewNeighbrhood.isScrollEnabled = false
        btnReachout.isHidden = true
        
        if sourceScreen != "profile" && sourceScreen != "secondStep" && sourceScreen != "home" && sourceScreen != "profileback" && sourceScreen !=  "profilebackUn" && sourceScreen !=  "Malik" {
            UserDefaults.standard.set("step1", forKey: "registrationStep")
        }
        
        tblViewNeighbrhood.allowsSelection = true
        tblViewNeighbrhood.dataSource = self
        tblViewNeighbrhood.delegate = self
        tblViewNeighbrhood.layer.cornerRadius = 10
        tblViewNeighbrhood.layer.masksToBounds = true
        btnNext.layer.cornerRadius = 10
        btnNext.layer.masksToBounds = true
        btnReachout.layer.cornerRadius = 10
        btnReachout.layer.masksToBounds = true
        // Corner radius set karna
        viewNeighbourhoodAddresh.layer.cornerRadius = 10
        viewNeighbourhoodAddresh.layer.masksToBounds = true
        viewNeighbourhood.layer.cornerRadius = 10
        viewNeighbourhood.layer.masksToBounds = true
        
        //        if isComingFromSearchVC {
        //            lblNeighbrhood.text =  selectedLocation ?? ""
        //            lblNeighbroodAddresh.text = fullAddress ?? ""
        //            lblCity.text = city ?? ""
        //            lblState.text = state ?? ""
        //            lblPincode.text = zipcode ?? ""
        //            print(city)
        //            print(state)
        //            self.selectedLatitude = latitudeS
        //            self.selectedLongitude = longitudeS
        //            // User ne search kiya hai, toh API call
        //            if let lat = latitudeS, let long = longitudeS {
        //                callSearchNeighbrWebService(location: CLLocationCoordinate2D(latitude: lat, longitude: long))
        //            }
        //        } else if sourceScreen != "profile" && sourceScreen != "secondStep" && sourceScreen != "home" && sourceScreen != "profileback" && sourceScreen != "profilebackUn" && sourceScreen != "referralstatus"{
        //            locationManager.delegate = self
        //            locationManager.requestWhenInUseAuthorization()
        //            locationManager.startUpdatingLocation()
        //        }
        
        
        
        if referralStatus == 1 {
               if let area = selectedLocation, !area.isEmpty {
                   // Use dummy coordinates (0.0, 0.0) if actual lat/lon not available
                   let locationCoord = CLLocationCoordinate2D(latitude: latitudeS ?? 0.0,
                                                              longitude: longitudeS ?? 0.0)
                   callSearchNeighbrWebService(location: locationCoord)
               }
           } else {
               // Normal flow: request location if referralStatus != 1
               
           }
        
        if isComingFromSearchVC {
            lblNeighbrhood.text = selectedLocation ?? ""
            lblNeighbroodAddresh.text = fullAddress ?? ""
            lblCity.text = city ?? ""
            lblState.text = state ?? ""
            lblPincode.text = zipcode ?? ""
            
            self.selectedLatitude = latitudeS
            self.selectedLongitude = longitudeS
            
            // User ne search kiya hai, toh API call
            if let lat = latitudeS, let long = longitudeS {
                callSearchNeighbrWebService(location: CLLocationCoordinate2D(latitude: lat, longitude: long))
            }
        }
        else if referralStatus != 1,
                sourceScreen != "profile",
                sourceScreen != "secondStep",
                sourceScreen != "home",
                sourceScreen != "profileback",
                sourceScreen != "profilebackUn",
                sourceScreen != "referralstatus" {
            
            // Sirf tabhi location get karega jab referralStatus != 1
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
        
        let areaTapGesture = UITapGestureRecognizer(target: self, action: #selector(areaLabelTapped))
        viewNeighbourhood.isUserInteractionEnabled = true
        viewNeighbourhood.addGestureRecognizer(areaTapGesture)
        // Neighbours connect label (top)
        llblNeighboursConnect.font = UIFont(name: "Montserrat-Medium", size: 15)
        // Select your residence area
        lblSelectYourResidence.font = UIFont(name: "Montserrat-Regular", size: 16)
        // Your Neighbourhood (heading)
        lblYourNeighbourhood.font = UIFont(name: "Montserrat-Regular", size: 20)
        lblCity.font = UIFont(name: "Montserrat-Regular", size: 14)
        lblState.font = UIFont(name: "Montserrat-Regular", size: 14)
        lblPincode.font = UIFont(name: "Montserrat-Regular", size: 14)
        lblYourNeighbiurhood.font = UIFont(name: "Montserrat-Regular", size: 16)
        txtFieldFlatHouse.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblNeighbroodAddresh.font = UIFont(name: "Montserrat-Regular", size: 14)
        if let customFont = UIFont(name: "Montserrat-Regular", size: 20) {
            btnNext.titleLabel?.font = customFont
        }
        if let customFont = UIFont(name: "Montserrat-Regular", size: 20) {
            btnReachout.titleLabel?.font = customFont
        }
        
        //MARK: - Device api call
        callDeviceInfoWebService()
        self.txtFieldFlatHouse.text = profileData?.addressone ?? ""
        placeholderLabel.isHidden = !(txtFieldFlatHouse.text?.isEmpty ?? true)
        txtFieldFlatHouse.addSubview(placeholderLabel)
        // Constraints set karo taaki label left-top par hi rahe
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: txtFieldFlatHouse.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: txtFieldFlatHouse.leadingAnchor, constant: 5)
        ])
        placeholderLabel.isHidden = !txtFieldFlatHouse.text.isEmpty
        txtFieldFlatHouse.delegate = self
        
    }
    
    // View Controller mein property create karo
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your address..." // Apne placeholder yahan set karo
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adjustTextViewHeight(self.txtFieldFlatHouse)
        
        if referralStatus == 1 {
            print("Referral active — skipping location updates and API calls.")
            return   // stop further updates if needed
        }
        
        if sourceScreen == "FirstSteep" && shouldUpdateUIOnAppear == false {
            shouldUpdateUIOnAppear = true // always reset for next appear
            shouldCallAPIOnAppear = false // safety (agar API nahi chahiye)
            return
        }
        
        // Agar flag false hai toh UI update skip karo
        guard shouldUpdateUIOnAppear else {
            updateUIWithSavedData()
            shouldUpdateUIOnAppear = true // Reset karo for next time
            return
        }
        
        // Normal UI update
        self.txtFieldFlatHouse.text = profileData?.addressone ?? ""
        self.isComingFromImagePicker = true
        self.lblCity.text = profileData?.city ?? ""
        self.lblState.text = profileData?.state ?? ""
        self.lblPincode.text = profileData?.pincode ?? ""
        self.lblNeighbrhood.text = profileData?.neighborhood
        self.lblNeighbroodAddresh.text = profileData?.addressone
        if shouldCallAPIOnAppear {
            let lat = latitudeS ?? 0.0
            let long = longitudeS ?? 0.0
            let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
            callSearchNeighbrWebService(location: loc)
            shouldCallAPIOnAppear = false // Prevents repeat API calling
        }
        
    }
    
    func updateUIWithSavedData() {
        if let savedCity = savedCity {
            lblCity.text = savedCity
        }
        if let savedState = savedState {
            lblState.text = savedState
        }
        if let savedZipcode = savedZipcode {
            lblPincode.text = savedZipcode
        }
        if let savedNeighbourhood = savedNeighbourhood {
            lblNeighbrhood.text = savedNeighbourhood
        }
        if let savedFullAddress = savedFullAddress {
            lblNeighbroodAddresh.text = savedFullAddress
        }
        if let lat = savedLatitude, let long = savedLongitude {
            self.selectedLatitude = lat
            self.selectedLongitude = long
        }
    }
    
    
    func adjustTextViewHeight(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        txtFielsAddheight.constant = newSize.height
        
        let baseViewHeight: CGFloat = 120 // apne base ke hisaab se adjust karna
        viewHeight.constant = baseViewHeight + (newSize.height - textView.frame.height)
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
    // MARK: - Auto-resize + Placeholder + First Letter Capitalize
    func textViewDidChange(_ textView: UITextView) {
        // ---- Auto-resize ----
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        txtFielsAddheight.constant = newSize.height
        
        let baseViewHeight: CGFloat = 120 // Apne base height ke hisab se set karein
        viewHeight.constant = baseViewHeight + (newSize.height - textView.frame.height)
        
        // ---- Placeholder handling ----
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        // ---- Capitalize first letter only ----
        if let text = textView.text, !text.isEmpty {
            let first = String(text.prefix(1)).uppercased()
            let rest = String(text.dropFirst())
            let capitalizedText = first + rest
            
            if textView.text != capitalizedText {
                textView.text = capitalizedText
                // Cursor ko end pe set karo
                if let endPosition = textView.endOfDocument as UITextPosition? {
                    textView.selectedTextRange = textView.textRange(from: endPosition, to: endPosition)
                }
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Allow normal typing (no manual override)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    
    
    
    
    // MARK: - Tableview Height
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        adjustTableViewHeight()
        updateTableViewHeight()
    }
    //    func adjustTableViewHeight() {
    //        tblViewHeightConstraint.constant = tblViewNeighbrhood.contentSize.height
    //    }
    
    
    func updateTableViewHeight() {
        let numberOfItems = NeighbrhdData?.data?.count ?? 0
        let contentHeight = tblViewNeighbrhood.contentSize.height
        
        if numberOfItems > 0 {
            tblViewHeightConstraint.constant = contentHeight
            tblViewHeightConstraint.constant = contentHeight // Set UIView height
        } else {
            tblViewHeightConstraint.constant = 0
            tblViewHeightConstraint.constant = 0 // Hide both if no items
        }
        
        // Call layoutIfNeeded to update the layout
        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded() // Ensure layout update
        }
    }
    
    
    
    
    // MARK: - Action
    
    @IBAction func action_Back(_ sender: Any) {
        if sourceScreen == "profile" {
            if let profileVC = self.navigationController?.viewControllers.first(where: { $0 is MyProfileViewController }) {
                print(sourceScreen)
                self.navigationController?.popToViewController(profileVC, animated: true)
            } else {
                print(sourceScreen)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let profileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
            return
        }
        if sourceScreen == "profilebackUn" {
            if let profileVC = self.navigationController?.viewControllers.first(where: { $0 is MyProfileViewController }) {
                print(sourceScreen)
                self.navigationController?.popToViewController(profileVC, animated: true)
            } else {
                print(sourceScreen)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let profileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                    profileVC.sourceViewController = "profilebackUn"
                    profileVC.fromScreen = "profilebackUn"
                    UserDefaults.standard.set("done", forKey: "registrationStep")
                    UserDefaults.standard.set(true, forKey: "isRegistered")
                    UserDefaults.standard.set("completed", forKey: "registrationStep")
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
            return
        }
        else if sourceScreen == "home" {
            if let homeVC = self.navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
                print(sourceScreen)
                self.navigationController?.popToViewController(homeVC, animated: true)
            } else {
                print(sourceScreen)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
            return
        }
        // Baaki cases me logout confirmation alert dikhaye
        let alert = UIAlertController(title: "Heads up!", message: nil, preferredStyle: .alert)
        let attributedMessage = NSAttributedString(
            string: "Are you sure you want to go back? Unsaved changes might be lost",
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.gray
            ])
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navController = UINavigationController(rootViewController: loginVC)
                navController.navigationBar.isHidden = true
                sceneDelegate.window?.rootViewController = navController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
        yesAction.setValue(UIColor.red, forKey: "titleTextColor")
        noAction.setValue(UIColor.green, forKey: "titleTextColor")
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func action_NextRechout(_ sender: Any) {
        // 1. Area selection check
        let numberOfItems = self.NeighbrhdData?.data?.count ?? 0
        if numberOfItems == 0 {
            self.showAlert(title: "", message: "Please select your area") // First Alert
            return
        }
        
        // 2. Neighbourhood selection check if multiple items
        if numberOfItems > 1 && self.selectedIndexPath == nil {
            self.showAlert(title: "", message: "Please select your neighbourhood") // Second Alert
            return
        }
        
        // 3. Address validation (Flat/House/Unit)
        guard let flatHouse = self.txtFieldFlatHouse.text, !flatHouse.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.showAlert(title: "", message: "Please enter your address") // Third Alert
            return
        }
        
        if containsBadWords(flatHouse) {
            showAlert(title: "", message: "Contains inappropriate words.")
            return
        }
        
        // 2. Sab valid hai, abhi hi API call hogi!
        self.callNeighorhodStatusStateCity(shouldShowAlert: false) { message in
            if message == "Neighborhood found." {
                UIHelper.showLoader(on: sender as! UIButton, show: true)
                self.callRegSecWebService()
                UIHelper.showLoader(on: sender as! UIButton, show: false)
                UserDefaults.standard.set("step2", forKey: "registrationStep")
            } else {
                print("data not found") // Only debug print, no alert for user now
            }
        }
    }
    
    
    
    
    
    @IBAction func actionReachout(_ sender: Any) {
        
        self.callReachoutWebService { [weak self] apiMessage in
            guard let self = self else { return }
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let font = UIFont(name: "Montserrat-Regular", size: 18) ?? UIFont.systemFont(ofSize: 14)
            let attributedMessage = NSAttributedString(string: apiMessage, attributes: [
                .font: font,
                .foregroundColor: UIColor.darkGray
            ])
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // ✅ Push to LoginViewController
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
    }
    
    
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
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func areaLabelTapped() {
        openLocationSearchScreen(for: "Area")
    }
    
    func openLocationSearchScreen(for type: String) {
        // Initialize the SearchNeighouhoodViewController
        if let searchNeighouhoodVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchNewNeighouhoodViewController") as? SearchNewNeighouhoodViewController {
            searchNeighouhoodVC.backsourceScreen = "back"
            searchNeighouhoodVC.profileData = profileData
            searchNeighouhoodVC.sourceScreen = self.sourceScreen
            searchNeighouhoodVC.city = self.city
            searchNeighouhoodVC.state = self.state
            searchNeighouhoodVC.zipcode = self.zipcode
            
            
            self.navigationController?.pushViewController(searchNeighouhoodVC, animated: true)
        }
    }
    
    
    
    //    MARK: - API Call
    
    func callSearchNeighbrWebService(location: CLLocationCoordinate2D) {
        let dictParams: [String: Any] = [
            "lati": latitudeS ?? 0.0,
            "longi": longitudeS ?? 0.0,
            "areas": lblNeighbrhood.text ?? ""
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
                    self.NeighbrhdData = data
                    shouldShowMessage = false
                    // Set button to Next
                    self.btnNext.setTitle("Next", for: .normal)
                } else {
                    self.NeighbrhdData = nil
                    shouldShowMessage = true
                    // Tabhi dusre API call karo jab data nahi mila
                }
                self.tblViewNeighbrhood.reloadData()
                //                self.adjustTableViewHeight()
                self.updateTableViewHeight()
                self.callNeighorhodStatusStateCity(shouldShowAlert: shouldShowMessage)
                
                // ============ Analytics Event ================
                // Relevant variables
                let areaToSend = self.lblNeighbrhood.text ?? ""
                let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
                let message = data.message ?? ""
                let fetchedStatus = data.status ?? ""
                
                Analytics.logEvent("neighborhood_search_fetched_iOS", parameters: [
                    "status": fetchedStatus,
                    "message": message,
                    "area": areaToSend,
                    "userid": userID,
                    "platform": "iOS"
                ])
                
                AppEvents.shared.logEvent(
                    .init("neighborhood_search_fetched_iOS"),
                    parameters: [
                        AppEvents.ParameterName("status"): fetchedStatus,
                        AppEvents.ParameterName("message"): message,
                        AppEvents.ParameterName("area"): areaToSend,
                        AppEvents.ParameterName("userid"): userID,
                        AppEvents.ParameterName("platform"): "iOS"
                    ]
                )
                
                
            }
        }
    }
    
    
    
    func callNeighorhodStatusStateCity(shouldShowAlert: Bool = true, completion: ((String) -> Void)? = nil) {
        let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
        let areaToSend = self.NeighbrhdData?.data?.first?.nbdName?.isEmpty == false
        ? self.NeighbrhdData?.data?.first?.nbdName
        : lblNeighbrhood.text
        
        let dictParams: [String: Any] = [
            "area": areaToSend ?? "",
            "countryid": "100",
            "lati": selectedLatitude ?? 0.0,
            "longi": selectedLongitude ?? 0.0,
            "stateid": self.lblState.text ?? "",
            "cityid": self.lblCity.text ?? "",
            "userid": userID
        ]
        print("Calling API with parameters:", dictParams)
        WebService.sharedInstance.callNeighborhoodStatusByState(withParams: dictParams) { [weak self] (responseModel: NeighborhoodStatusByStateModel) in
            guard let self = self else { return }
            print("API Response - Status: \(responseModel.status), Message: \(responseModel.message)")
            DispatchQueue.main.async {
                if responseModel.message != "Neighborhood found." {
                    self.btnNext.isHidden = true
                    self.btnReachout.isHidden = false
                    if shouldShowAlert {
                        self.showNeighborhoodAlert(withMessage: responseModel.message)
                    }
                } else {
                    self.btnNext.setTitle("Next", for: .normal)
                    self.btnReachout.isHidden = true
                }
                Analytics.logEvent("neighborhood_status_fetched_iOS", parameters: [
                    "status": responseModel.status,
                    "message": responseModel.message,
                    "area": areaToSend ?? "",
                    "userid": userID,
                    "platform": "iOS"
                ])
                
                AppEvents.shared.logEvent(
                    .init("neighborhood_status_fetched_iOS"),
                    parameters: [
                        AppEvents.ParameterName("status"): responseModel.status,
                        AppEvents.ParameterName("message"): responseModel.message,
                        AppEvents.ParameterName("area"): areaToSend ?? "",
                        AppEvents.ParameterName("userid"): userID,
                        AppEvents.ParameterName("platform"): "iOS"
                    ]
                )
                
                completion?(responseModel.message)
            }
        }
    }
    
    
    //MARK: - Current location
    
    func callCurrentLocationNeighbrWebService(withArea area: String) {
        let dictParams: [String: Any] = [
            "areas": lblNeighbrhood.text ?? "",
            "lati": lat ?? 0.0,
            "longi": long ?? 0.0
        ]
        print(dictParams)
        
        WebService.sharedInstance.callCurrentSearchNeighbrWebService(withParams: dictParams) { [weak self] data in
            guard let self = self else { return }
            self.NeighbrhdData?.data?.removeAll()
            DispatchQueue.main.async {
                self.NeighbrhdData = data
                if let neighbourhoods = self.NeighbrhdData?.data, !neighbourhoods.isEmpty {
                    Analytics.logEvent("neighborhood_Current_success_iOS", parameters: [
                        "area": self.lblNeighbrhood.text ?? "",
                        "count": neighbourhoods.count,
                        "platform": "iOS"
                    ])
                    
                    AppEvents.shared.logEvent(
                        .init("neighborhood_Current_success_iOS"),
                        parameters: [
                            AppEvents.ParameterName("area"): self.lblNeighbrhood.text ?? "",
                            AppEvents.ParameterName("count"): neighbourhoods.count,
                            AppEvents.ParameterName("platform"): "iOS"
                        ]
                    )
                    
                }
                self.tblViewNeighbrhood.reloadData()
                self.callUserLocationWebService()
                //                self.adjustTableViewHeight()
                self.updateTableViewHeight()
                
                
            }
        }
    }
    
    
    
    // MARK: - Registation Api
    
    func callRegSecWebService() {
        let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "address": txtFieldFlatHouse.text ?? "",
            "areas": self.NeighbrhdData?.data?.first?.nbdID ?? "",
            "pincode": lblPincode.text ?? "",
            "lati": selectedLatitude ?? 0.0,
            "longi": selectedLongitude ?? 0.0,
            "userid": userID
        ]
        print("📤 [callRegSecWebService] Params:", dictParams)
        WebService.sharedInstance.callRegSecWebService(withParams: dictParams) { [weak self] data in
            guard let self = self else {
                print("⚠️ Self is nil")
                return
            }
            
            print("🌐 Full callRegSecWebService Response: \(data)")
            DispatchQueue.main.async { [self] in
                let status = data.status?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                print("📥 Status: \(status ?? "nil")")
                self.RegistrationSec = data
                
                if status == "success" {
                    if let referrerMessage = data.referrer_msg, !referrerMessage.isEmpty {
                        self.showReferrerAlert(message: referrerMessage, okHandler: {
                            self.pushToRegistrationProofVC() // Proceed after OK
                        }, cancelHandler: {
                            print("User tapped Cancel")
                        })
                    } else {
                        self.pushToRegistrationProofVC()
                    }
                } else {
                    self.showAlert(title: "Error", message: data.message ?? "Something went wrong.")
                }
                
            }
        }
    }
    
    
    // MARK: - Show Referrer Alert
    func showReferrerAlert(message: String, okHandler: @escaping () -> Void = {}, cancelHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Notice", message: nil, preferredStyle: .alert)
        
        // Title styling
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        let attributedTitle = NSAttributedString(string: "Notice", attributes: titleFont)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        
        // Message styling
        let messageAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        ]
        let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        // ✅ OK button (only triggers handler)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okHandler()
        }
        okAction.setValue(#colorLiteral(red: 0, green: 0.5603, blue: 0, alpha: 1), forKey: "titleTextColor")
        alert.addAction(okAction)
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelHandler?()
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    
    func pushToRegistrationProofVC() {
        let referNeighbourhoodID = self.RegistrationSec?.data?.first?.nbdID
        let referNeighbourhoodName = self.RegistrationSec?.data?.first?.nbdName
        let referrerNbhdStatus = self.RegistrationSec?.referrer_neighbourhood_status
        
        if self.sourceScreen == "home" {
            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                homeVC.uploadedDocuments = self.savedUploadedDocuments
                homeVC.profileData = self.profileData
                homeVC.bntNameUpdate = "Update"
                homeVC.sourceScreen = "home"
                homeVC.selectedLocation = self.selectedLocation
                homeVC.referNeighbourhoodID = referNeighbourhoodID
                homeVC.referNeighbourhoodName = referNeighbourhoodName
                homeVC.referrerNeighbourhoodStatus = referrerNbhdStatus
                print(selectedLocation ?? "")
                self.navigationController?.setViewControllers([homeVC], animated: true)
            }
        } else if self.sourceScreen == "profile" {
            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                homeVC.uploadedDocuments = self.savedUploadedDocuments
                homeVC.profileData = self.profileData
                homeVC.bntNameUpdate = "Update"
                homeVC.sourceScreen = "profileback"
                homeVC.selectedLocation = self.selectedLocation
                // Pass new values
                homeVC.referNeighbourhoodID = referNeighbourhoodID
                homeVC.referNeighbourhoodName = referNeighbourhoodName
                homeVC.referrerNeighbourhoodStatus = referrerNbhdStatus
                print(selectedLocation ?? "")
                self.navigationController?.setViewControllers([homeVC], animated: true)
            }
            
        }
        else if self.sourceScreen == "profilebackUn" {
            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                homeVC.uploadedDocuments = self.savedUploadedDocuments
                homeVC.profileData = self.profileData
                homeVC.bntNameUpdate = "Update"
                homeVC.sourceScreen = "profileback"
                homeVC.selectedLocation = self.selectedLocation
                print(selectedLocation ?? "")
                self.navigationController?.setViewControllers([homeVC], animated: true)
            }
            
        }
        else if self.sourceScreen == "FirstSteep" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                vc.selectedLocation = self.selectedLocation
                print(selectedLocation ?? "")
                vc.name = self.name ?? ""
                vc.sourceScreen = "FirstSteep"
                vc.secname = self.secname ?? ""
                vc.profileData = self.profileData
                vc.uploadedDocuments = self.savedUploadedDocuments
                vc.bntNameUpdate = "Register"
                vc.referNeighbourhoodID = referNeighbourhoodID
                vc.referNeighbourhoodName = referNeighbourhoodName
                vc.referrerNeighbourhoodStatus = referrerNbhdStatus
                
                Analytics.logEvent("registration_step2_completed_iOS", parameters: [
                    "name": self.name ?? "",
                    "secname": self.secname ?? "",
                    "neighbourhood": (self.selectedIndexPath != nil) ? (self.NeighbrhdData?.data?[self.selectedIndexPath!.row].nbdName ?? "") : "",
                    "timestamp": Date().timeIntervalSince1970,
                    "platform": "iOS"
                ])
                
                AppEvents.shared.logEvent(
                    .init("registration_step2_completed_iOS"),
                    parameters: [
                        AppEvents.ParameterName("name"): self.name ?? "",
                        AppEvents.ParameterName("secname"): self.secname ?? "",
                        AppEvents.ParameterName("neighbourhood"): (self.selectedIndexPath != nil) ? (self.NeighbrhdData?.data?[self.selectedIndexPath!.row].nbdName ?? "") : "",
                        AppEvents.ParameterName("timestamp"): Date().timeIntervalSince1970,
                        AppEvents.ParameterName("platform"): "iOS"
                    ]
                )
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if self.sourceScreen == "secondStep" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                vc.selectedLocation = self.selectedLocation
                print(selectedLocation ?? "")
                vc.name = self.name ?? ""
                vc.secname = self.secname ?? ""
                vc.bntNameUpdate = "Register"
                vc.profileData = self.profileData
                vc.referNeighbourhoodID = referNeighbourhoodID
                vc.referNeighbourhoodName = referNeighbourhoodName
                vc.referrerNeighbourhoodStatus = referrerNbhdStatus
                vc.uploadedDocuments = self.savedUploadedDocuments
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                vc.selectedLocation = self.selectedLocation
                print(selectedLocation ?? "")
                vc.name = self.name ?? ""
                vc.secname = self.secname ?? ""
                vc.sourceScreen = "FirstSteep"
                vc.bntNameUpdate = "Register"
                vc.referNeighbourhoodID = referNeighbourhoodID
                vc.referNeighbourhoodName = referNeighbourhoodName
                vc.referrerNeighbourhoodStatus = referrerNbhdStatus
                // Firebase Analytics event yahan log karein
                Analytics.logEvent("registration_step2_completed_iOS", parameters: [
                    "name": self.name ?? "",
                    "secname": self.secname ?? "",
                    "neighbourhood": (self.selectedIndexPath != nil) ? (self.NeighbrhdData?.data?[self.selectedIndexPath!.row].nbdName ?? "") : "",
                    "timestamp": Date().timeIntervalSince1970,
                    "platform": "iOS"
                ])
                
                
                // Facebook Analytics event log
                AppEvents.shared.logEvent(
                    .init("registration_step2_completed_iOS"),
                    parameters: [
                        AppEvents.ParameterName("name"): self.name ?? "",
                        AppEvents.ParameterName("secname"): self.secname ?? "",
                        AppEvents.ParameterName("neighbourhood"): (self.selectedIndexPath != nil) ? (self.NeighbrhdData?.data?[self.selectedIndexPath!.row].nbdName ?? "") : "",
                        AppEvents.ParameterName("timestamp"): Date().timeIntervalSince1970,
                        AppEvents.ParameterName("platform"): "iOS"
                    ]
                )
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    
    
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        if let vc = storyboard.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
    //            vc.selectedLocation = self.selectedLocation
    //            vc.name = self.name ?? ""
    //            vc.secname = self.secname ?? ""
    ////            vc.sourceScreen = "registration"
    //
    //            print(name)
    //
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        } else {
    //            print("❌ Could not instantiate RegistationAdressProofVC — check storyboard ID")
    //        }
    //    }
    
    
    
    
    // MARK: -  CALL API FOR USER LOCATION   UserLocation current //dev.
    
    func callUserLocationWebService() { // dev.
        let id = UserDefaults.standard.string(forKey: "userid")
        print("✅ User ID after login: \(id ?? "Not Found")")
        let url = "https://dev.neighbrsnook.com/admin/api/user-location"
        let params: [String: Any] = [
            "userid": id,
            "latitude": lat ?? 0.0,
            "longitude": long ?? 0.0,
            "area_name": (self.lblNeighbrhood.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines),
            "addlineone": self.txtFieldFlatHouse.text ?? "",
            "country_name": "India",
            "state_name": self.lblState.text ?? "",
            "city_name": self.lblCity.text ?? "",
            "pincode": Int(self.lblPincode.text ?? "0") ?? 0
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
    
    
    //MARK: - Reachout
    
    //    func callReachoutWebService() {
    //        // Define the parameters for the API call
    //        let id = UserDefaults.standard.string(forKey: "userid")
    //        let dictParams: Dictionary<String, Any> = [
    //            "userid": id,
    //            "area": self.lblNeighbrhood.text ?? "",
    //            "address": self.txtFieldFlatHouse.text ?? "",
    //            "pincode": self.lblPincode.text ?? "",
    //            "countryid": "100",
    //            "stateid": self.lblState.text ?? "",
    //            "cityid": self.lblCity.text ?? "",
    //            "lati": selectedLatitude ?? 0.0,
    //            "longi": selectedLongitude ?? 0.0,
    //        ]
    //        print(dictParams)
    //        // Call the Reachout API
    //        WebService.sharedInstance.CallReachoutWebService(withParams: dictParams) { [weak self] data in
    //            guard let self = self else { return }
    //
    //            // Handle the API response
    //            self.ReachoutNeighborhoodData = data
    //
    //            // For example, print the status and message
    //            print(self.ReachoutNeighborhoodData?.status ?? "")
    //            print(self.ReachoutNeighborhoodData?.message ?? "")
    //
    //
    ////            // Event log for Reachout Call
    ////            Analytics.logEvent("reachout_api_called_iOS", parameters: [
    ////                "status": self.ReachoutNeighborhoodData?.status ?? "",
    ////                "message": self.ReachoutNeighborhoodData?.message ?? "",
    ////                "area": self.NeighbrhdData?.data?.first?.nbdID ?? "",
    ////                "platform": "iOS"
    ////            ])
    //
    //        }
    //    }
    
    
    func callReachoutWebService(completion: @escaping (String) -> Void) {
        guard let id = UserDefaults.standard.string(forKey: "userid") else { return }
        
        let params: [String: String] = [
            "userid": id,
            "area": lblNeighbrhood.text ?? "",
            "address": txtFieldFlatHouse.text ?? "",
            "pincode": lblPincode.text ?? "",
            "countryid": "100",
            "stateid": lblState.text ?? "",
            "cityid": lblCity.text ?? "",
            "lati": String(selectedLatitude ?? 0.0),
            "longi": String(selectedLongitude ?? 0.0)
        ]
        print(params)
        
        let boundary = "Boundary-\(UUID().uuidString)" //dev.
        var request = URLRequest(url: URL(string: "https://dev.neighbrsnook.com/oldadmin/api/master?flag=requestneighborhood")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: "token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        var body = Data()
        for (key, value) in params {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error:", error)
                DispatchQueue.main.async {
                    completion("Something went wrong. Please try again.")
                }
                return
            }
            
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = json["message"] as? String {
                        DispatchQueue.main.async {
                            completion(message) // ✅ Pass the message from API
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion("Thank you for sharing your address details.") // ✅ Default message
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion("Something went wrong. Please try again.")
                    }
                }
            }
        }.resume()
    }
    
    
    
    
    
    
    
    //MARK: - Function to show alert
    func showNeighborhoodAlert(withMessage message: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        // Message attributed
        let messageFont = [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16)!,
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
    
    
}





// MARK: - Tableview Call

extension NewRegistationSecondStepVC : UITableViewDelegate, UITableViewDataSource,NeighbourhoodNewDataShowTableViewCellDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = NeighbrhdData?.data?.count ?? 0
        
        if numberOfItems == 1 {
            // Default select 0th index when only one row
            selectedIndexPath = IndexPath(row: 0, section: 0)
        } else if numberOfItems == 0 {
            // If no items, clear selection
            selectedIndexPath = nil
        } else if let sel = selectedIndexPath, sel.row >= numberOfItems {
            // In case the previous selection is out of bounds after update
            selectedIndexPath = nil
        }
        
        DispatchQueue.main.async {
            self.updateTableViewHeight()
        }
        
        
        return numberOfItems
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewNeighbrhood.dequeueReusableCell(withIdentifier: "NeighbrhoodTblViewCell", for: indexPath) as! NeighbrhoodTblViewCell
        let data = NeighbrhdData?.data?[indexPath.row]
        cell.selectionStyle = .none
        cell.lblNeighbrhood.text = data?.nbdName
        cell.lblNeighbrhood.textColor = (selectedIndexPath == indexPath)
        ? UIColor(red: 0.0, green: 128/255.0, blue: 0.0, alpha: 1.0)
        : UIColor.darkGray
        cell.lblNeighbrhood.font = UIFont(name: "Montserrat-Regular", size: 16)
        if selectedIndexPath == indexPath {
            cell.lblNeighbrhood?.textColor = UIColor(red: 0.0, green: 128/255.0, blue: 0.0, alpha: 1.0) // Green for selected
            cell.lblNeighbrhood?.font = UIFont(name: "Montserrat-Regular", size: 16)
        } else {
            cell.lblNeighbrhood?.textColor = UIColor.darkGray // Default color
        }
        
        cell.lblNeighbrhood?.textColor = (selectedIndexPath == indexPath)
        ? UIColor(red: 0.0, green: 128/255.0, blue: 0.0, alpha: 1.0)
        : .darkGray
        
        cell.isCheckedNeig = (selectedIndexPath == indexPath)
        cell.updateButtonAppearanceN()
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
    
    
    func didTapCheckbox(at indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        tblViewNeighbrhood.reloadData()
    }
    
    
}


// MARK: - Get current location

extension NewRegistationSecondStepVC: CLLocationManagerDelegate {
    
    // Ye function location update hone par chalega
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            self.lat = currentLocation.coordinate.latitude
            self.long = currentLocation.coordinate.longitude
            self.selectedLatitude = self.lat
            self.selectedLongitude = self.long
            fetchAddress(from: currentLocation)
            manager.stopUpdatingLocation()
            
            //            // ⭐️ Area pata chal gaya, ab API call karo:
            //            if let area = self.lblNeighbrhood.text, !area.isEmpty {
            //                self.callCurrentLocationNeighbrWebService(withArea: area)
            //            }
        }
    }
    
    // Jab location fetch fail ho
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    // Reverse Geocoding — Location se Address nikalega
    func fetchAddress(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                // Area Name
                if let area = placemark.subLocality {
                    self.lblNeighbrhood.text = area
                    self.selectedLocation = area
                }
                // Full Address
                var addressString = ""
                if let name = placemark.name {
                    addressString += name + ", "
                }
                if let city = placemark.locality {
                    addressString += city + ", "
                    self.lblCity.text = city
                }
                if let state = placemark.administrativeArea {
                    addressString += state + ", "
                    self.lblState.text = state
                }
                if let postalCode = placemark.postalCode {
                    addressString += postalCode
                    self.lblPincode.text = postalCode
                }
                self.lblNeighbroodAddresh.text = addressString
                if let area = self.lblNeighbrhood.text, !area.isEmpty {
                    self.callCurrentLocationNeighbrWebService(withArea: area)
                }
            }
        }
    }
}
