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
    var NeighbrhdData : DecryptedNeighborhoodModel?
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
    
    let getReachoutData : ReachOutNeighborhoodV_M? = nil
    var userProfileData: UserData?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(profileData)
        print(userProfileData)
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
        
        if isComingFromSearchVC {
            lblNeighbrhood.text = selectedLocation ?? ""
            lblNeighbroodAddresh.text = fullAddress ?? ""
            lblCity.text = city ?? ""
            lblState.text = state ?? ""
            lblPincode.text = zipcode ?? ""
            print(city)
            print(state)
            self.selectedLatitude = latitudeS
            self.selectedLongitude = longitudeS
            self.SearchNeighborhood(
                area: selectedLocation ?? "",
                latitude: "\(latitudeS ?? 0.0)",
                longitude: "\(longitudeS ?? 0.0)"
            ) { result in
                print(result)
            }

         } else if sourceScreen != "profile" && sourceScreen != "secondStep" && sourceScreen != "home" && sourceScreen != "profileback" && sourceScreen != "profilebackUn" {
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
        registerCurrentDevice()
        self.txtFieldFlatHouse.text = userProfileData?.full_address ?? ""
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.adjustTextViewHeight(self.txtFieldFlatHouse)
//        if sourceScreen == "FirstSteep" && shouldUpdateUIOnAppear == false {
//            shouldUpdateUIOnAppear = true // always reset for next appear
//            shouldCallAPIOnAppear = false // safety (agar API nahi chahiye)
//            return
//        }
//        
//        // Agar flag false hai toh UI update skip karo
//        guard shouldUpdateUIOnAppear else {
//            updateUIWithSavedData()
//            shouldUpdateUIOnAppear = true // Reset karo for next time
//            return
//        }
//        
//        // Normal UI update
//        self.txtFieldFlatHouse.text = userProfileData?.full_address ?? ""
//        self.isComingFromImagePicker = true
//        self.lblCity.text = userProfileData?.city ?? ""
//        self.lblState.text = userProfileData?.state ?? ""
//        self.lblPincode.text = userProfileData?.pincode ?? ""
//        self.lblNeighbrhood.text = userProfileData?.neighborhood_name
//        self.lblNeighbroodAddresh.text = userProfileData?.address
//        if shouldCallAPIOnAppear {
//                let lat = latitudeS ?? 0.0
//                let long = longitudeS ?? 0.0
//                self.SearchNeighborhood(
//                    area: selectedLocation ?? "",
//                    latitude: "\(lat)",
//                    longitude: "\(long)"
//                ) { result in
//                    print(result)
//                }
//                shouldCallAPIOnAppear = false
//            }
//        
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adjustTextViewHeight(self.txtFieldFlatHouse)
        
        if sourceScreen == "FirstSteep" && shouldUpdateUIOnAppear == false {
            shouldUpdateUIOnAppear = true // always reset for next appear
            shouldCallAPIOnAppear = false // safety (agar API nahi chahiye)
            return
        }
        
        // Agar flag false hai toh UI update skip karo
        var didUpdateUI = false
        if shouldUpdateUIOnAppear {
            // Normal UI update
            self.txtFieldFlatHouse.text = userProfileData?.full_address ?? ""
            self.isComingFromImagePicker = true
            self.lblCity.text = userProfileData?.city ?? ""
            self.lblState.text = userProfileData?.state ?? ""
            self.lblPincode.text = userProfileData?.pincode ?? ""
            self.lblNeighbrhood.text = userProfileData?.neighborhood_name
            self.lblNeighbroodAddresh.text = userProfileData?.address
            didUpdateUI = true
        } else {
            updateUIWithSavedData()
            shouldUpdateUIOnAppear = true // Reset karo for next time
        }
        
        // API call: ALWAYS check after flag logic, never inside return/guard blocks
        if shouldCallAPIOnAppear {
            let lat = latitudeS ?? 0.0
            let long = longitudeS ?? 0.0
            self.SearchNeighborhood(
                area: userProfileData?.neighborhood_name ?? "",
                latitude: "\(lat)",
                longitude: "\(long)"
            ) { result in
                print(result)
            }
            shouldCallAPIOnAppear = false
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
        let numberOfItems = NeighbrhdData?.data?.data?.count ?? 0
        let contentHeight = tblViewNeighbrhood.contentSize.height
        
        if numberOfItems > 0 {
            tblViewHeightConstraint.constant = contentHeight
        } else {
            tblViewHeightConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
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
        let numberOfItems = self.NeighbrhdData?.data?.data?.count ?? 0
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

        let selectedNbrID = NeighbrhdData?.data?.data?[selectedIndexPath?.row ?? 0].id ?? 0
        
        self.callRegisterSecondStepAPI(
            address: txtFieldFlatHouse.text ?? "",
            latitude: "\(self.selectedLatitude ?? 0.0)",
            longitude: "\(self.selectedLongitude ?? 0.0)",
            neighborhoodID: selectedNbrID,
            pincode: lblPincode.text ?? ""
        ) { result in
            print("Register API result:", result ?? "nil")
            
            // ---- YE CHANGE KARDO -----
            // Just call global function, NO self. prefix
            if let encryptedString = result?.data, !encryptedString.isEmpty {
                decryptCompleteData(encryptedString: encryptedString) { decrypted in
                    print("Decrypted response:", decrypted ?? "")
                    DispatchQueue.main.async {
                        self.pushToRegistrationProofVC()
                    }
                }
            } else {
                self.showAlert(title: "Error", message: "No encrypted data received from server.")
            }
        }
    }
    
    func callRegisterSecondStepAPI(
        address: String,
        latitude: String,
        longitude: String,
        neighborhoodID: Int,
        pincode: String,
        completion: @escaping (SecondCompleteModel?) -> Void
    ) {
        let parameters: Parameters = [
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "neighborhood_id": "\(neighborhoodID)",
            "pincode": pincode
        ]
        print(parameters)
        
        SecondSteepCompleteV_M.shared.SearchNeighborhood(parameters: parameters) { result in
            completion(result)
        }
    }


    
    
    
    @IBAction func actionReachout(_ sender: Any) {
        ReachOut_Neighborhood(dataFound: nil)
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
            searchNeighouhoodVC.userProfileData = self.userProfileData
            searchNeighouhoodVC.sourceScreen = self.sourceScreen
            
            self.navigationController?.pushViewController(searchNeighouhoodVC, animated: true)
        }
    }
    
    
  
    func pushToRegistrationProofVC() {
        if self.sourceScreen == "home" {
            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                homeVC.uploadedDocuments = self.savedUploadedDocuments
                homeVC.userProfileData = self.userProfileData
                homeVC.bntNameUpdate = "Update"
                homeVC.sourceScreen = "home"
                homeVC.selectedLocation = self.selectedLocation
                print(selectedLocation ?? "")
                self.navigationController?.setViewControllers([homeVC], animated: true)
            }
        } else if self.sourceScreen == "profile" {
            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                homeVC.uploadedDocuments = self.savedUploadedDocuments
                homeVC.userProfileData = self.userProfileData
                homeVC.bntNameUpdate = "Update"
                homeVC.sourceScreen = "profileback"
                homeVC.selectedLocation = self.selectedLocation
                print(selectedLocation ?? "")
                self.navigationController?.setViewControllers([homeVC], animated: true)
            }
           
        }
        else if self.sourceScreen == "profilebackUn" {
            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                homeVC.uploadedDocuments = self.savedUploadedDocuments
                homeVC.userProfileData = self.userProfileData
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
                vc.userProfileData = self.userProfileData
                vc.uploadedDocuments = self.savedUploadedDocuments
                
                Analytics.logEvent("registration_step2_completed_iOS", parameters: [
                    "name": self.name ?? "",
                    "secname": self.secname ?? "",
                    "neighbourhood": (self.selectedIndexPath != nil) ? String(self.NeighbrhdData?.data?.data?[self.selectedIndexPath!.row].id ?? 0) : "",
                    "timestamp": Date().timeIntervalSince1970,
                    "platform": "iOS"
                ])
                
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if self.sourceScreen == "secondStep" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                vc.selectedLocation = self.selectedLocation
                print(selectedLocation ?? "")
                vc.name = self.name ?? ""
                vc.secname = self.secname ?? ""
                vc.userProfileData = self.userProfileData
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
                // Firebase Analytics event yahan log karein
                Analytics.logEvent("registration_step2_completed_iOS", parameters: [
                    "name": self.name ?? "",
                    "secname": self.secname ?? "",
                    "neighbourhood": (self.selectedIndexPath != nil) ? String(self.NeighbrhdData?.data?.data?[self.selectedIndexPath!.row].id ?? 0) : "",
                    "timestamp": Date().timeIntervalSince1970,
                    "platform": "iOS"
                ])
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
    
    
    
    
  
    
    
    // MARK: - API call to post device information
    
    func registerCurrentDevice() {
        let deviceInfo = getDeviceInfo()
        let parameters: Parameters = [
            "device_id": deviceInfo.deviceID,
            "device_model": deviceInfo.deviceModel,
            "device_platform": deviceInfo.devicePlatform,
            "device_imei": deviceInfo.deviceIMEI
        ]
        DeviceRegisterManager.shared.saveDeviceRegisterManager(parameters: parameters) { response in
            DispatchQueue.main.async {
                if let res = response, res.code == 200 {
                    print("Device Registered: \(res.message)")
                } else {
                    print("Device Registration Failed!")
                }
            }
        }
    }

   
    
    
    //MARK: - New APi saveNeighborhood
    
//    func SearchNeighborhood(area: String, latitude: String, longitude: String, completion: @escaping (String) -> Void) {
//        let parameters: Parameters = [
//            "name": area,
//            "lati": latitude,
//            "longi": longitude
//        ]
//        let start = Date()
//        SearchNeighborhoodManager.shared.SearchNeighborhood(parameters: parameters) { response in
//            print("API Response Time:", Date().timeIntervalSince(start))
//            if let res = response, res.code == 200 {
//                let encryptedString = res.data
//                let decStart = Date()
//                SearchNeighborhoodManager.shared.decryptNeighborhoodData(encryptedString: encryptedString) { decrypted in
//                    print("Decrypt Time:", Date().timeIntervalSince(decStart))
//                    DispatchQueue.main.async {
//                        print("Neighborhood List Count:", decrypted?.data?.data?.count ?? 0)
//                        self.NeighbrhdData = decrypted
//                        if let selected = self.NeighbrhdData?.data?.data?.first {
//                            self.selectedLocation = selected.name
//                            self.latitudeS = Double(latitude)
//                            self.longitudeS = Double(longitude)
//                        }
//                        self.ReachOut_Neighborhood()
//                        self.tblViewNeighbrhood.reloadData()
//                    }
//                }
//            } else {
//                print("Neighborhood API failed")
//            }
//        }
//    }

    
    func SearchNeighborhood(area: String, latitude: String, longitude: String, completion: @escaping (String) -> Void) {
        let parameters: Parameters = [
            "name": area,
            "lati": latitude,
            "longi": longitude,
            "City_Name": lblCity.text ?? ""
        ]
        print(parameters)
        let start = Date()
        SearchNeighborhoodManager.shared.SearchNeighborhood(parameters: parameters) { response in
            print("API Response Time:", Date().timeIntervalSince(start))
            if let res = response, res.code == 200 {
                if case let .string(encryptedString) = res.data {
                    let decStart = Date()
                    SearchNeighborhoodManager.shared.decryptNeighborhoodData(encryptedString: encryptedString) { decrypted in
                        print("Decrypt Time:", Date().timeIntervalSince(decStart))
                        DispatchQueue.main.async {
                            print("Neighborhood List Count:", decrypted?.data?.data?.count ?? 0)
                            self.NeighbrhdData = decrypted

                            let neighborhoodList = decrypted?.data?.data
                            if let list = neighborhoodList, !list.isEmpty {
                                // ✅ Data mil gaya toh normal flow
                                
                                if let selected = list.first {
                                    self.selectedLocation = selected.name
                                    self.latitudeS = Double(latitude)
                                    self.longitudeS = Double(longitude)
                                }
                                self.btnNext.isHidden = false      // show next
                                self.btnReachout.isHidden = true   // hide reachout
                                self.ReachOut_Neighborhood(dataFound: true)
                                self.tblViewNeighbrhood.reloadData()
                            } else {
                                // ✅ status check properly
                                switch decrypted?.data?.status {
                                case .int(0), .bool(false):
                                    let msg = decrypted?.data?.message ?? res.message ?? "No neighborhoods found."
                                    self.showAlertRegistration(message: msg, yesNo: "OK")
                                    self.btnNext.isHidden = true       // hide next
                                    self.btnReachout.isHidden = false
                                    // call ReachOut with dataFound = false
                                    self.ReachOut_Neighborhood(dataFound: false)
                                default:
                                    break
                                }

                            }
                        }
                    }
                } else {
                    // Yaha handle karo jab data string na ho (jaise [])
                    let msg = res.message
                    DispatchQueue.main.async {
                        self.btnNext.isHidden = true
                        self.btnReachout.isHidden = false
                        self.showAlertRegistration(message: msg, yesNo: "OK")
                    }
                }
            } else {
                self.btnNext.isHidden = true
                self.btnReachout.isHidden = false
                let msg = response?.message ?? "Neighborhood API failed"
                DispatchQueue.main.async {
                    self.showAlertRegistration(message: msg, yesNo: "OK")
                }
            }
        }
    }
    


    func showAlertRegistration(message: String, yesNo: String = "OK") {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        // ✅ Attributed message with Montserrat-Regular, size 17
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 17)!,
                .paragraphStyle: paragraphStyle
            ]
        )
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: yesNo, style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Present the alert on main thread
        DispatchQueue.main.async {
            if let topVC = UIApplication.shared.keyWindow?.rootViewController {
                var presentedVC = topVC
                while let pvc = presentedVC.presentedViewController {
                    presentedVC = pvc
                }
                presentedVC.present(alert, animated: true, completion: nil)
            }
        }
    }


    

    
    func ReachOut_Neighborhood(dataFound: Bool? = nil) {
        // Step 1: Collect fields/assign (Assume ye vars pehle set ho chuki hain)
        let latitude = "\(latitudeS ?? 0.0)"
        let longitude = "\(longitudeS ?? 0.0)"
        let area = selectedLocation ?? ""
        let address = txtFieldFlatHouse.text ?? ""
        let city = lblCity.text ?? ""
        let state = lblState.text ?? ""
        let pincode = lblPincode.text ?? ""
        let country = "india"
        let reachout: String
            let autosearch: String
            
            if let found = dataFound {
                if found {
                    // data mil gaya
                    reachout = "0"
                    autosearch = "1"
                } else {
                    // auto data nahi mila
                    reachout = "1"
                    autosearch = "1"
                }
            } else {
                // manual click
                reachout = "1"
                autosearch = "0"
            }
        // Step 2: Request object if needed
        let request = ReachOutRequest(
            address: address,
            latitude: latitude,
            longitude: longitude,
            area: area,
            city: city,
            state: state,
            country: country,
            pincode: pincode,
            reachout: reachout
        )
        
        // Step 3: Prepare parameters for API
        let parameters: Parameters = [
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "area": area,
            "city": city,
            "state": state,
            "country": country,
            "pincode": pincode,
            "reachout": reachout,
            "autosearch": autosearch
        ]
        print(parameters)
        ReachOutNeighborhoodV_M.shared.ReachOutNeighborhood(parameters: parameters) { [weak self] (response) in
            print(response ?? "No response from API")
            DispatchQueue.main.async {
                UtilityMethods.hideIndicator()
                if let response = response {
                    // Show message only if NOT "Success"
                    if response.status.isSuccess {
                        if response.message != "Success" {
                            AlertViewManager.shared.alertMessage(
                                title: "Neighborhood",
                                message: response.message,
                                controller: self ?? UIViewController()
                            )
                        }
                        // Add navigation, label updates, etc. here as needed
                    } else {
                        AlertViewManager.shared.alertMessage(
                            title: "Neighborhood",
                            message: response.message,
                            controller: self ?? UIViewController()
                        )
                        if response.message.uppercased() == "UNAUTHORIZED REQUEST" {
                            // Handle unauthorized scenario
                        }
                    }
                } else {
                    AlertViewManager.shared.alertMessage(
                        title: "Neighborhood",
                        message: "Something went wrong",
                        controller: self ?? UIViewController()
                    )
                }
            }

        }
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
        let numberOfItems = NeighbrhdData?.data?.data?.count ?? 0
        print(numberOfItems)
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
        let data = NeighbrhdData?.data?.data?[indexPath.row]
        cell.selectionStyle = .none
        cell.lblNeighbrhood.text = data?.name
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
        let selectedData = NeighbrhdData?.data?.data?[indexPath.row]
        
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
            
         
        }
    }
    
    // Jab location fetch fail ho
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func fetchAddress(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                print("Geocode fail:", error ?? "")
                return
            }
            let latitude = "\(location.coordinate.latitude)"
            let longitude = "\(location.coordinate.longitude)"
            let area = placemark.subLocality ?? ""
            let address = placemark.name ?? ""
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? ""
            let country = placemark.country ?? "india"
            let pincode = placemark.postalCode ?? ""
            
            // UI update (optional)
            self.lblNeighbrhood.text = area
            self.lblCity.text = city
            self.lblState.text = state
            self.lblPincode.text = pincode
            
            var addressString = ""
            if !address.isEmpty { addressString += address + ", " }
            if !city.isEmpty { addressString += city + ", " }
            if !state.isEmpty { addressString += state + ", " }
            if !pincode.isEmpty { addressString += pincode }
            self.lblNeighbroodAddresh.text = addressString
            
            let parameters: Parameters = [
                "latitude": latitude,
                "longitude": longitude,
                "address": address,
                "area": area,
                "city": city,
                "state": state,
                "country": country,
                "pincode": pincode
            ]
            print("Calling saveCurrentLocation ->", parameters)
            
            LocationServiceManager.shared.saveCurrentLocation(parameters: parameters) { response in
                DispatchQueue.main.async {
                    if let res = response {
                        if res.status == true {
                            print("✅", res.message ?? "")
                            self.SearchNeighborhood(area: area, latitude: latitude, longitude: longitude) { result in
                                print("SearchNeighborhood completion:", result)
                            }
                        } else {
                            AlertViewManager.shared.alertMessage(
                                title: "Error",
                                message: res.message ?? "Something went wrong",
                                controller: self
                            )
                        }
                    } else {
                        AlertViewManager.shared.alertMessage(
                            title: "Error",
                            message: "No response from server",
                            controller: self
                        )
                    }
                }
            }
        }
    }
    
    
    
    
    

}
