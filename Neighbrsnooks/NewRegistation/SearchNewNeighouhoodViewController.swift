//
//  SearchNewNeighouhoodViewController.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 04/08/25.
//

import UIKit
import CoreLocation
import GooglePlaces
import Network
import GoogleMaps

class SearchNewNeighouhoodViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate, LocationDelegate{
    
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
    var isFromProfile: Bool?
    var lat: Double?
    var long: Double?
    let locationManager = CLLocationManager()
    var autocompleteResults: [GMSAutocompletePrediction] = []
    var currentLocation: String? // Current location ka data yahan store karenge
    var searchedLocation: String? // Searched location ka data yahan store karenge
    var isSearchLocation = false
    var isNavigated = false
    var activityIndicator: UIActivityIndicatorView!
    var shouldNavigateAfterLocationFetch = false
    var fullAddress: String?
    var profileData: ProfileModel?
    var sourceScreen: String? // profile or FirstSteep
    var backsourceScreen: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        NetworkMonitor.shared.startMonitoring()
        print("isFromProfile: \(self.isFromProfile ?? false)")
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        searchBar.delegate = self
        tableView.delegate = self
        searchBar.placeholder = "Search your area location"

        tableView.dataSource = self
        fetchCurrentLocationOnStart()
        
//        LocationPermissionManager.shared.checkPermission(from: self) { granted in
//            if granted {
//                print("✅ Location access granted, start location work here.")
//                self.locationManager.startUpdatingLocation()
//            } else {
//                print("❌ Location access denied.")
//            }
//        }
        
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
            fetchAutocompleteSuggestions(query: searchText)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchNeighourhoodTblViewCell", for: indexPath)
        let prediction = autocompleteResults[indexPath.row]
        cell.textLabel?.text = prediction.attributedFullText.string
        return cell
    }
    

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
            
            let areaName = prediction.attributedPrimaryText.string
            var foundCity: String?
            var foundState: String?
            var foundZip: String?
            
            if let components = place.addressComponents {
                for comp in components {
                    if comp.types.contains("locality") {
                        foundCity = comp.name
                    } else if comp.types.contains("administrative_area_level_1") {
                        foundState = comp.name
                    } else if comp.types.contains("postal_code") {
                        foundZip = comp.name
                    }
                }
            }
            
            // 🌐 If postal code not found, fallback using CLGeocoder
            if foundZip == nil {
                let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let postalCode = placemarks?.first?.postalCode {
                        foundZip = postalCode
                    }

                    // Now proceed to store and navigate
                    self.saveSelectedPlaceDetails(
                        areaName: areaName,
                        city: foundCity,
                        state: foundState,
                        zip: foundZip,
                        coordinate: place.coordinate
                    )
                }
            } else {
                // Proceed without fallback
                self.saveSelectedPlaceDetails(
                    areaName: areaName,
                    city: foundCity,
                    state: foundState,
                    zip: foundZip,
                    coordinate: place.coordinate
                )
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

       

    func saveSelectedPlaceDetails(areaName: String, city: String?, state: String?, zip: String?, coordinate: CLLocationCoordinate2D) {
        var addressParts = [String]()
        if !areaName.isEmpty { addressParts.append(areaName) }
        if let city = city, !city.isEmpty { addressParts.append(city) }
        if let state = state, !state.isEmpty { addressParts.append(state) }
        if let zip = zip, !zip.isEmpty { addressParts.append(zip) }

        let fullAddress = addressParts.joined(separator: ", ")

        self.fullAddress = fullAddress
        self.selectedLocation = areaName
        self.city = city
        self.state = state
        self.zipcode = zip
        self.selectedLatitude = coordinate.latitude
        self.selectedLongitude = coordinate.longitude
        self.isSearchLocation = true
        if let targetVC = self.navigationController?.viewControllers.first(where: { $0 is NewRegistationSecondStepVC }) as? NewRegistationSecondStepVC {
                targetVC.shouldUpdateUIOnAppear = false
            }
        self.navigateToRegisterSecondVC()
    }


    
    @IBAction func actionBack(_ sender: Any) {
        // ✅ Find the existing previous VC in the navigation stack
        if let previousVC = self.navigationController?.viewControllers.first(where: { $0 is NewRegistationSecondStepVC }) as? NewRegistationSecondStepVC {
            previousVC.shouldUpdateUIOnAppear = false // ✅ Update the real instance
        }
        // ✅ Pop back
        self.navigationController?.popViewController(animated: true)
    }


    
    
    // Get current location and update the label
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        shouldNavigateAfterLocationFetch = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
            activityIndicator.startAnimating()
            locationManager.requestLocation()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            activityIndicator.startAnimating()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        } else {
            // Permission Denied or Restricted
            LocationPermissionManager.shared.checkPermission(from: self) { granted in
                if granted {
                    print("✅ Location access granted, start location work here.")
                    self.locationManager.startUpdatingLocation()
                } else {
                    print("❌ Location access denied.")
                }
            }
        }
    }
    
    
    func fetchCurrentLocationOnStart() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            // First time: ask for permission
//            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Already allowed: proceed directly
            activityIndicator.startAnimating()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        } else {
            // Denied or restricted: show message or alert
            lblCurrentLocationDataShow.text = "No data"
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Now you can fetch location
            manager.requestLocation()
        }
    }

    
    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            activityIndicator.stopAnimating()
            print("Error: Could not retrieve current location.")
            return
        }
        locationManager.stopUpdatingLocation()
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            let cityNameMap: [String: String] = [
                "bombay": "Mumbai",
                "madras": "Chennai",
                "calcutta": "Kolkata",
                "bangalore": "Bengaluru",
                "cochin": "Kochi",
                "trivandrum": "Thiruvananthapuram",
                "poona": "Pune",
                "baroda": "Vadodara",
                "mangalore": "Mangaluru",
                "mysore": "Mysuru",
                "cawnpore": "Kanpur",
                "quilon": "Kollam",
                "calicut": "Kozhikode",
                "palghat": "Palakkad",
                "trichur": "Thrissur",
                "pondicherry": "Puducherry",
                "gurgaon": "Gurugram",
                "allahabad": "Prayagraj"
                // ...aur bhi jitne chahe add kar lo
            ]

            func normalizeCityName(_ city: String) -> String {
                let lower = city.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                return cityNameMap[lower] ?? city
            }
            
            if let placemark = placemarks?.first {
                // ⭐️ YEH BLOCK MAIN LAGAO:
                let areaName = placemark.subLocality ?? placemark.name ?? ""
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let zip = placemark.postalCode ?? ""
                let country = placemark.country ?? ""

                // Full address (helpful for showing in label)
                var addressParts = [String]()
                if !areaName.isEmpty { addressParts.append(areaName) }
                if !city.isEmpty { addressParts.append(city) }
                if !state.isEmpty { addressParts.append(state) }
                if !zip.isEmpty { addressParts.append(zip) }
                if !country.isEmpty { addressParts.append(country) }
                let fullAddress = addressParts.joined(separator: ", ")

                // 👇 Sab fields alag store karo!
                self.selectedLocation = areaName      // ONLY area/locality
                self.fullAddress = fullAddress        // Pura address line
                self.city = city
                self.state = state
                self.zipcode = zip
                self.selectedLatitude = currentLocation.coordinate.latitude
                self.selectedLongitude = currentLocation.coordinate.longitude

                // OPTIONAL: show full address for user
                self.lblCurrentLocationDataShow.text = fullAddress

                // abhi navigation karo (jaise aap already kar rahe ho)
                if self.shouldNavigateAfterLocationFetch && !self.isNavigated {
                    self.isNavigated = true
                    self.shouldNavigateAfterLocationFetch = false
                    DispatchQueue.main.async {
                        self.navigateToRegisterSecondVC()
                    }
                }
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        activityIndicator.stopAnimating() // Stop loader
        print("Failed to get location: \(error.localizedDescription)")
        lblCurrentLocationDataShow.text = "Failed to fetch location"
    }
    
    func navigateToRegisterSecondVC() {
        if let registerSecondVC = storyboard?.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
            
            // Pass location data along with latitude and longitude
            registerSecondVC.selectedLocation = selectedLocation
            registerSecondVC.city = self.city
            registerSecondVC.state = self.state
            registerSecondVC.zipcode = self.zipcode ?? ""
            // Pass latitude and longitude
            registerSecondVC.latitudeS = self.selectedLatitude ?? 0.0
            registerSecondVC.longitudeS = self.selectedLongitude ?? 0.0
            registerSecondVC.isFromProfile = true
            registerSecondVC.isComingFromSearchVC = true
            registerSecondVC.fullAddress = fullAddress
            registerSecondVC.profileData = profileData
            // ✅ Set sourceScreen based on previous screen
//            if sourceScreen == "FirstSteep" {
//                registerSecondVC.sourceScreen = "FirstSteep"
//                
//            } else {
//                registerSecondVC.sourceScreen = "profile"
//                registerSecondVC.sourceScreen = "home"
//                registerSecondVC.isFromProfile = true
//            }
            
            if sourceScreen == "FirstSteep" {
                       registerSecondVC.sourceScreen = "FirstSteep"
                   } else if sourceScreen == "profile" {
                       registerSecondVC.sourceScreen = "profile"
                       registerSecondVC.isFromProfile = true
                   } else if sourceScreen == "home" {
                       registerSecondVC.sourceScreen = "home"
                   } else {
                       registerSecondVC.sourceScreen = "home" // Default fallback
                   }

            
            
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
            registerSecondVC.shouldUpdateUIOnAppear = false
            
            navigationController?.pushViewController(registerSecondVC, animated: true)
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
                let name = placemark.name ?? ""
                let subLocality = placemark.subLocality ?? ""
                let locality = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let postalCode = placemark.postalCode ?? ""
                let country = placemark.country ?? ""
                
                var uniqueComponents: [String] = []
                
                // Add 'name' if it's not same as 'subLocality'
                if !name.isEmpty && name != subLocality {
                    uniqueComponents.append(name)
                }
                
                // Add subLocality only if not already in array
                if !subLocality.isEmpty && !uniqueComponents.contains(subLocality) {
                    uniqueComponents.append(subLocality)
                }
                
                // Add remaining parts
                if !locality.isEmpty && !uniqueComponents.contains(locality) {
                    uniqueComponents.append(locality)
                }
                if !state.isEmpty {
                    uniqueComponents.append(state)
                }
                if !postalCode.isEmpty {
                    uniqueComponents.append(postalCode)
                }
                if !country.isEmpty {
                    uniqueComponents.append(country)
                }
                
                let address = uniqueComponents.joined(separator: ", ")
                
                self.lblCurrentLocationDataShow.text = address
                self.selectedLocation = address
                self.city = locality
                self.state = state
                self.zipcode = postalCode
                self.isSearchLocation = true
                
                if let coordinate = placemark.location?.coordinate {
                    self.selectedLatitude = coordinate.latitude
                    self.selectedLongitude = coordinate.longitude
                }
                
                if !self.isNavigated {
                    self.isNavigated = true
                    DispatchQueue.main.async {
                        self.navigateToRegisterSecondVC()
                    }
                }
            } else {
                print("No placemark found.")
            }
        }
    }
    
    
    
    // Retry fetching location after a delay if it fails
    func retryLocationFetch(withDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.locationManager.requestLocation()
        }
    }
    
    func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let address = [
                    placemark.name,
                    placemark.subLocality,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                
                self.lblCurrentLocationDataShow.text = address
                self.selectedLocation = address
                self.city = placemark.locality
                self.state = placemark.administrativeArea
                self.zipcode = placemark.postalCode
                
                if !self.isNavigated {
                    self.isNavigated = true
                    DispatchQueue.main.async {
                        self.navigateToRegisterSecondVC()
                    }
                }
            }
        }
    }

    
}
