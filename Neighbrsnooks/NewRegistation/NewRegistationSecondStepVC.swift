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



class NewRegistationSecondStepVC: BaseViewController {
    
    @IBOutlet weak var tblViewNeighbrhood: UITableView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewNeighbourhood: UIView!
    @IBOutlet weak var lblNeighbrhood: UILabel!
    @IBOutlet weak var lblNeighbroodAddresh: UILabel!
    @IBOutlet weak var viewNeighbourhoodAddresh: UIView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblPincode: UILabel!
    @IBOutlet weak var txtFieldFlatHouse: UITextField!
    @IBOutlet weak var lblYourNeighbiurhood: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblYourNeighbourhood: UILabel!
    @IBOutlet weak var lblSelectYourResidence: UILabel!
    @IBOutlet weak var llblNeighboursConnect: UILabel!
    
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
    var userId: String?
    var selectedIndexPath: IndexPath?
    var profileData: ProfileModel?
    var uploadedDocuments: UploadedDocumentsModel?
    var savedUploadedDocuments: UploadedDocumentsModel?

    var isComingFromImagePicker: Bool = false
    var shouldUpdateUIOnAppear = true
    var isComingrom:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(profileData)
        if sourceScreen != "secondStep" { //  Only run when NOT coming from "secondStep"
            UserDefaults.standard.set("step1", forKey: "registrationStep")
        }
        tblViewNeighbrhood.allowsSelection = true

        tblViewNeighbrhood.dataSource = self
        tblViewNeighbrhood.delegate = self
        
        tblViewNeighbrhood.layer.cornerRadius = 10
        tblViewNeighbrhood.layer.masksToBounds = true
        
        btnNext.layer.cornerRadius = 10
        btnNext.layer.masksToBounds = true
        
        // Corner radius set karna
        viewNeighbourhoodAddresh.layer.cornerRadius = 10
        viewNeighbourhoodAddresh.layer.masksToBounds = true
        
        viewNeighbourhood.layer.cornerRadius = 10
        viewNeighbourhood.layer.masksToBounds = true
        
        // UI PAR DATA SHOW KARO:
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
            //  User ne search kiya hua hai, ab API ko call karo using selectedLocation ke lat/long:
            if let lat = latitudeS, let long = longitudeS {
                callSearchNeighbrWebService(location: CLLocationCoordinate2D(latitude: lat, longitude: long))
            }
        } else {
            //  User ki current location se area fetch hote hi API ko call karo
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
        
        let areaTapGesture = UITapGestureRecognizer(target: self, action: #selector(areaLabelTapped))
        viewNeighbourhood.isUserInteractionEnabled = true
        viewNeighbourhood.addGestureRecognizer(areaTapGesture)
        // Neighbours connect label (top)
        llblNeighboursConnect.font = UIFont(name: "Montserrat-Regular", size: 14)
        // Select your residence area
        lblSelectYourResidence.font = UIFont(name: "Montserrat-Regular", size: 16)
        // Your Neighbourhood (heading)
        lblYourNeighbourhood.font = UIFont(name: "Montserrat-Regular", size: 20)
        lblCity.font = UIFont(name: "Montserrat-Regular", size: 14)
        lblState.font = UIFont(name: "Montserrat-Regular", size: 14)
        lblPincode.font = UIFont(name: "Montserrat-Regular", size: 14)
        lblYourNeighbiurhood.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblNeighbroodAddresh.font = UIFont(name: "Montserrat-Regular", size: 16)
        if let customFont = UIFont(name: "Montserrat-Regular", size: 20) {
            btnNext.titleLabel?.font = customFont
        }
        
        //MARK: - Device api call
        callDeviceInfoWebService()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtFieldFlatHouse.text = profileData?.address ?? ""
        // Agar flag false hai toh UI update skip karo
        guard shouldUpdateUIOnAppear else {
            shouldUpdateUIOnAppear = true // Reset karo for next time
            return
        }
        
        // Normal UI update
        self.txtFieldFlatHouse.text = profileData?.address ?? ""
        self.isComingFromImagePicker = true
        self.lblCity.text = profileData?.city ?? ""
        self.lblState.text = profileData?.state ?? ""
        self.lblPincode.text = profileData?.pincode ?? ""
    }

    
    
    
    
    // MARK: - Tableview Height
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTableViewHeight()
    }
    func adjustTableViewHeight() {
        tblViewHeightConstraint.constant = tblViewNeighbrhood.contentSize.height
    }
    
    
    // MARK: - Action
    
    @IBAction func action_Back(_ sender: Any) {
        let alert = UIAlertController(title: "Heads up!", message: nil, preferredStyle: .alert)
        
        let attributedMessage = NSAttributedString(
            string: "If you go back now, you'll be logged out and everything you've filled will be lost. Want to continue?",
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
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
        
        yesAction.setValue(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
        noAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
    @IBAction func action_NextRechout(_ sender: Any) {
        
        self.callNeighorhodStatusStateCity(shouldShowAlert: false) { message in
            if message == "Neighborhood found." {
                // ✅ Neighborhood mil gaya
                guard let flatHouse = self.txtFieldFlatHouse.text, !flatHouse.trimmingCharacters(in: .whitespaces).isEmpty else {
                    self.showAlert(title: "", message: "Please enter flat/house/door #, tower/unit #")
                    return
                }
                UserDefaults.standard.set("step2", forKey: "registrationStep")
                UIHelper.showLoader(on: sender as! UIButton, show: true)
                self.callRegSecWebService()
                UIHelper.showLoader(on: sender as! UIButton, show: false)

            } else {
                // ❌ Neighborhood nahi mila
//                self.callReachoutWebService()
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
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func areaLabelTapped() {
        openLocationSearchScreen(for: "Area")
     }
    
    func openLocationSearchScreen(for type: String) {
        // Initialize the SearchNeighouhoodViewController
        if let searchNeighouhoodVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchNewNeighouhoodViewController") as? SearchNewNeighouhoodViewController {
            
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
                self.adjustTableViewHeight()
                self.callNeighorhodStatusStateCity(shouldShowAlert: shouldShowMessage)


            }
        }
    }

    
    
    func callNeighorhodStatusStateCity(shouldShowAlert: Bool = true, completion: ((String) -> Void)? = nil) {
        let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "area": lblNeighbrhood.text ?? "",
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
                    self.btnNext.setTitle("Reach Out", for: .normal)
                    if shouldShowAlert {
                        self.showNeighborhoodAlert(withMessage: responseModel.message)
                    }
                } else {
                    self.btnNext.setTitle("Next", for: .normal)
                }
                
                // ✅ Fire event
                Analytics.logEvent("neighborhood_status_fetched_iOS", parameters: [
                    "status": responseModel.status,
                    "message": responseModel.message,
                    "area": self.lblNeighbrhood.text ?? "",
                    "userid": userID,
                    "platform": "iOS"
                ])
                
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
                    Analytics.logEvent("neighborhood_search_success_iOS", parameters: [
                        "area": self.lblNeighbrhood.text ?? "",
                        "count": neighbourhoods.count,
                        "platform": "iOS"
                    ])
                }

                self.tblViewNeighbrhood.reloadData()
                self.callUserLocationWebService()
                self.adjustTableViewHeight()

                
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
            
            DispatchQueue.main.async {
                let status = data.status?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                print("📥 Status: \(status ?? "nil")")
                self.RegistrationSec = data
                
                if status == "success" {
                   
                    print("✅ Registration Step 2 successful — pushing to RegistationAdressProofVC")
                    self.pushToRegistrationProofVC()
                } else {
                    self.showAlert(title: "Error", message: data.message ?? "Something went wrong.")
                }
            }
        }
    }

    func pushToRegistrationProofVC() {
        if self.sourceScreen == "home" {
            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                homeVC.uploadedDocuments = self.savedUploadedDocuments
                homeVC.profileData = self.profileData // will be nil but okay if VC handles it
                self.navigationController?.setViewControllers([homeVC], animated: true)
            }
        } else {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                vc.selectedLocation = self.selectedLocation
                vc.name = self.name ?? ""
                vc.secname = self.secname ?? ""
                vc.profileData = self.profileData
                vc.uploadedDocuments = self.savedUploadedDocuments
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

    
    
    
    // MARK: -  CALL API FOR USER LOCATION   UserLocation current dev.
    
    func callUserLocationWebService() {
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
    
    func callReachoutWebService() {
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

        let boundary = "Boundary-\(UUID().uuidString)"
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
                return
            }
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
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
               
               // ⭐️ Area pata chal gaya, ab API call karo:
               if let area = self.lblNeighbrhood.text, !area.isEmpty {
                   self.callCurrentLocationNeighbrWebService(withArea: area)
               }
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
            }
        }
    }
}
