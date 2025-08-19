//
//  ReUploadDocSearchNeighouhoodVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 23/01/25.
//

import UIKit
import CoreLocation
import GooglePlaces
import Network
import GoogleMaps
import SVProgressHUD
@available(iOS 16.0, *)
class ReUploadDocSearchNeighouhoodVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate, ReloadLocationDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCurrentLocationDataShow: UILabel!
    @IBOutlet weak var getCurrentLocation: UIView!
    var city: String?
    var state: String?
    var zipcode: String?
    var selectedLocation: String?
    var selectedLatitude: Double?
    var selectedLongitude: Double?
//    var savedProfileData: ProfileModel?
    var savedUploadedDocuments: UploadedDocumentsModel?
    var isFromProfile: Bool?
    var lat: Double?
    var long: Double?
    let locationManager = CLLocationManager()
    var autocompleteResults: [GMSAutocompletePrediction] = []
    var currentLocation: String? // Current location ka data yahan store karenge
    var searchedLocation: String? // Searched location ka data yahan store karenge
    var isSearchInProgress = false
    var isSearchLocation = false
    var isNavigated = false
    var activityIndicator: UIActivityIndicatorView!
    var profileData: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        print("isFromProfile: \(self.isFromProfile ?? false)")
        // Start loader when view is loading
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        // Set delegates for search bar and table view
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // Set location manager delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        // Start fetching location immediately when view loads
        activityIndicator.startAnimating() // Start loader when trying to get location
        locationManager.requestLocation()
        callUserProfileWebService{ [self] in
            SVProgressHUD.dismiss()
        }
        
        LocationPermissionManager.shared.checkPermission(from: self) { granted in
            if granted {
                print("✅ Location access granted, start location work here.")
                self.locationManager.startUpdatingLocation()
            } else {
                print("❌ Location access denied.")
            }
        }
    }
    
    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            autocompleteResults.removeAll()
            tableView.reloadData()
        } else {
            activityIndicator.startAnimating() // Start loader for search
            isSearchInProgress = true // Flag set
            fetchAutocompleteSuggestions(query: searchText)
            
            // Current location ko update mat karo jab search chal rahi ho
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    func fetchAutocompleteSuggestions(query: String) {
        let placesClient = GMSPlacesClient.shared()
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        placesClient.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { (predictions, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print("Error fetching autocomplete: \(error.localizedDescription)")
                return
            }
            if let predictions = predictions {
                self.autocompleteResults = predictions
                self.tableView.reloadData()
            }
        }
    }
    
    
    // TableView Delegate & DataSource to display results
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateTableViewCell", for: indexPath)
        let prediction = autocompleteResults[indexPath.row]
        cell.textLabel?.text = prediction.attributedFullText.string
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let prediction = autocompleteResults[indexPath.row]
//        
//        // Update the label with the selected location
//        lblCurrentLocationDataShow.text = ": \(prediction.attributedFullText.string)"
//        selectedLocation = prediction.attributedFullText.string // Store the selected location
//        
//        // Fetch full address details for the selected location
//        fetchAddressDetails(for: selectedLocation ?? "")
//        
//        // Reset the flag after selecting the location
//        isSearchInProgress = false
//        
//        // Store latitude and longitude when an address is selected
//        if let lat = self.selectedLatitude, let lon = self.selectedLongitude {
//            print("Selected Latitude: \(lat), Longitude: \(lon)")
//        }
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prediction = autocompleteResults[indexPath.row]
        let placeID = prediction.placeID

        let placesClient = GMSPlacesClient.shared()
        placesClient.fetchPlace(
            fromPlaceID: placeID,
            placeFields: [.name, .coordinate, .addressComponents],
            sessionToken: nil
        ) { [weak self] (place, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching place details: \(error.localizedDescription)")
                return
            }
            guard let place = place else {
                print("No place details found.")
                return
            }

            let mainText = prediction.attributedPrimaryText.string
            self.selectedLocation = mainText
            self.lblCurrentLocationDataShow.text = mainText

            // Lat/Lng
            let coordinate = place.coordinate
            self.selectedLatitude = coordinate.latitude
            self.selectedLongitude = coordinate.longitude

            // Extract city, state, and pin from addressComponents
            var foundCity: String?
            var foundState: String?
            var foundZip: String?
            if let components = place.addressComponents {
                for comp in components {
                    if comp.types.contains("locality") { foundCity = comp.name }
                    else if comp.types.contains("administrative_area_level_1") { foundState = comp.name }
                    else if comp.types.contains("postal_code") { foundZip = comp.name }
                }
            }
            self.city = foundCity
            self.state = foundState

            if let postcode = foundZip {
                // Postal code Google se mil gaya
                self.zipcode = postcode
                self.isSearchLocation = true
                self.navigateToRegisterSecondVC()
            } else {
                // Postal code Google Place se nahi mila, to Apple se reverse-geocode karo
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
                    guard let self = self else { return }
                    if let pin = placemarks?.first?.postalCode {
                        self.zipcode = pin
                        print("Reverse geocoded pin: \(pin)")
                    } else {
                        self.zipcode = nil
                        print("No pin even with Apple geocoder!")
                    }
                    self.isSearchLocation = true
                    self.navigateToRegisterSecondVC()
                }
                // Yahan return karo — taki aage method na chale jab tak reverse complete na ho
                return
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


    @IBAction func actionBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReUploadDocumentsVC") as! ReUploadDocumentsVC
        self.navigationController?.popViewController(animated: true)
        //        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    // Get current location and update the label
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        LocationPermissionManager.shared.checkPermission(from: self) { granted in
               if granted {
                   print("✅ Location access granted, start location work here.")
                   
                   self.activityIndicator.startAnimating() // Start loader
                   print("📍 Requesting current location: \(self.locationManager)")
                   
                   self.locationManager.requestLocation()
                   
                   // Optional: You can wait for actual location update before navigating,
                   // or set a delay if needed.
                   DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                       self.activityIndicator.stopAnimating()
                       self.navigateToRegisterSecondVC()
                   }

               } else {
                   print("❌ Location access denied.")
                   // Optional: Show alert if not shown by LocationPermissionManager
               }
           }
       }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isSearchInProgress {
            // Agar search ho rahi hai, to location update ko ignore karo
            return
        }
        
        activityIndicator.stopAnimating() // Stop loader
        
        if let location = locations.first {
            // Fetch the latitude and longitude
            selectedLatitude = location.coordinate.latitude
            selectedLongitude = location.coordinate.longitude
            
            print("Latitude: \(selectedLatitude!), Longitude: \(selectedLongitude!)") // Debugging print
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    self.lblCurrentLocationDataShow.text = "Failed to fetch address"
                    self.retryLocationFetch(withDelay: 1)
                    return
                }
                
                if let placemark = placemarks?.first {
                    self.city = placemark.locality
                    self.state = placemark.administrativeArea
                    self.zipcode = placemark.postalCode
                    
                    let address = [
                        placemark.name,
                        placemark.subLocality,
                        self.city,
                        self.state,
                        self.zipcode,
                        placemark.country
                    ].compactMap { $0 }.joined(separator: ", ")
                    
                    self.lblCurrentLocationDataShow.text = address
                    self.selectedLocation = address
                    self.isSearchLocation = false
                    
                    print("Current Location Address: \(address)") // Debugging print
                    
                    if self.selectedLatitude == 0.0 || self.selectedLongitude == 0.0 {
                        print("Warning: Latitude and longitude are 0.0, fetching again.")
                        self.retryLocationFetch(withDelay: 0.0)
                    }
                }
            }
        } else {
            print("No location found") // Debugging print
            lblCurrentLocationDataShow.text = "Location not available"
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        activityIndicator.stopAnimating() // Stop loader
        print("Failed to get location: \(error.localizedDescription)")
        lblCurrentLocationDataShow.text = "Failed to fetch location"
    }
    
    
    func navigateToRegisterSecondVC() {
        if let registerSecondVC = storyboard?.instantiateViewController(withIdentifier: "ReUploadDocumentsVC") as? ReUploadDocumentsVC {
            // Pass location data along with latitude and longitude
//            registerSecondVC.selectedLocation = selectedLocation
//            registerSecondVC.cityL = self.city
//            registerSecondVC.stateL = self.state
//            registerSecondVC.zipcodeL = self.zipcode ?? ""
//            // Pass latitude and longitude
//            registerSecondVC.latitudeS = self.selectedLatitude ?? 0.0
//            registerSecondVC.longitudeS = self.selectedLongitude ?? 0.0
//            registerSecondVC.isFromProfile = true
//            
//            // Debugging to ensure the data being passed
//            print("Passing latitude: \(registerSecondVC.latitudeS), longitude: \(registerSecondVC.longitudeS)")
//            
//            // Check kis tarah ka location data pass ho raha hai
//            if isSearchLocation {
//                print("Passing Search Location Data")
//            } else {
//                print("Passing Current Location Data")
//            }
//            
//            // Debugging prints to check values
//            print("Location Data: \(selectedLocation ?? "No location")")
//            print("City: \(self.city ?? "No city")")
//            print("State: \(self.state ?? "No state")")
//            print("Zipcode: \(self.zipcode ?? "No zipcode")")
//            print("Latitude: \(self.selectedLatitude ?? 0.0)")
//            print("Longitude: \(self.selectedLongitude ?? 0.0)")
//            registerSecondVC.uploadedDocuments = self.savedUploadedDocuments
////            registerSecondVC.profileData = self.savedProfileData
//            registerSecondVC.profileData = profileData
//            
//            navigationController?.pushViewController(registerSecondVC, animated: true)
//        }
//    }
//    
//    
    
            
            // Pass location data along with latitude and longitude
            registerSecondVC.selectedLocation = selectedLocation
            registerSecondVC.cityL = self.city
            registerSecondVC.stateL = self.state
            registerSecondVC.zipcodeL = self.zipcode ?? ""
            // Pass latitude and longitude
            registerSecondVC.latitudeS = self.selectedLatitude ?? 0.0
            registerSecondVC.longitudeS = self.selectedLongitude ?? 0.0
            registerSecondVC.isFromProfile = true
//            registerSecondVC.isComingFromSearchVC = true
            registerSecondVC.profileData = profileData
            registerSecondVC.uploadedDocuments = self.savedUploadedDocuments
            // Debugging to ensure the data being passed
            print("Passing latitude: \(registerSecondVC.latitudeS), longitude: \(registerSecondVC.longitudeS)")
            // Check kis tarah ka location data pass ho raha hai
            if isSearchLocation {
                print("Passing Search Location Data")
            } else {
                print("Passing Current Location Data")
            }
            
            // Debugging prints to check values
            print("Location Data: \(selectedLocation ?? "No location")")
            print("City: \(self.city ?? "No city")")
            print("State: \(self.state ?? "No state")")
            print("Zipcode: \(self.zipcode ?? "No zipcode")")
            print("Latitude: \(self.selectedLatitude ?? 0.0)")
            print("Longitude: \(self.selectedLongitude ?? 0.0)")
            
            navigationController?.pushViewController(registerSecondVC, animated: true)
        }
    }
    
    
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "idOther")
        var dictParams: [String: Any] = [:]
        dictParams = [
            "userid": id ?? "",
            "loggeduser": id ?? ""
        ]
        
        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
            self.profileData = data
            print("Abdul data is : \(self.profileData ?? data)")
            
            UserDefaults.standard.set(self.profileData?.id, forKey: "idOther")
            UserDefaults.standard.set(self.profileData?.emerPhone, forKey: "emer_phone")
            UserDefaults.standard.set(self.profileData?.userpic, forKey: "profileImage")
            completionClosure()
        }
    }
    
    
    
    
    
    // Delegate method to receive location data
    func didSelectLocation(_ location: String) {
        // Handle location selection, you can update UI or pass data around as needed
        print("Location received: \(location)")
    }
    
    // Method to handle address fetching for selected location
    func fetchAddressDetails(for location: String) {
        activityIndicator.startAnimating()
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            
            if let error = error {
                print("Error in geocoding address: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                self.city = placemark.locality
                self.state = placemark.administrativeArea
                self.zipcode = placemark.postalCode
                
                // Fetch the locality (subLocality) here
                let locality = placemark.subLocality ?? "N/A"
                
                let address = [
                    placemark.name,
                    locality, // Include locality
                    self.city,
                    self.state,
                    self.zipcode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                
                self.lblCurrentLocationDataShow.text = address
                self.selectedLocation = address
                self.isSearchLocation = true
                
                // Get latitude and longitude
                if let location = placemark.location {
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    print("Latitude: \(latitude), Longitude: \(longitude)")
                    
                    // Store latitude and longitude
                    self.selectedLatitude = latitude
                    self.selectedLongitude = longitude
                }
                
                if !self.isNavigated {
                    self.isNavigated = true
                    DispatchQueue.main.async {
                        self.navigateToRegisterSecondVC()
                    }
                }
            }
        }
    }
    // Retry fetching location after a delay if it fails
    func retryLocationFetch(withDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.locationManager.requestLocation()
        }
    }
    
    
}
