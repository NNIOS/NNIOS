//
//  SearchNeighouhoodViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 06/11/24.
//

import UIKit
import CoreLocation
import GooglePlaces
import Network
import GoogleMaps

@available(iOS 16.0, *)
class SearchNeighouhoodViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate, LocationDelegate{
    
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
            placeFields: [.name, .coordinate, .addressComponents], // ⭐️ Required for city/state
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

            // ⭐️ Area (UI selection)
            let mainText = prediction.attributedPrimaryText.string      // "Hauz Khas"
            self.selectedLocation = mainText
            self.lblCurrentLocationDataShow.text = mainText

            // ⭐️ Lat/Long
            self.selectedLatitude = place.coordinate.latitude
            self.selectedLongitude = place.coordinate.longitude

            // ⭐️ Google se city/state bhi nikaalo:
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
            self.zipcode = foundZip

            self.isSearchLocation = true
            self.navigateToRegisterSecondVC()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }



    
    @IBAction func actionBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterSecondViewController") as! RegisterSecondViewController
        self.navigationController?.popViewController(animated: true)
        //        self.dismiss(animated: true, completion: nil)
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
    
    
    
    
    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            activityIndicator.stopAnimating()
            print("Error: Could not retrieve current location.")
            return
        }
        
        // Stop updating location (for a single fetch)
        locationManager.stopUpdatingLocation()
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                self.city = placemark.locality
                self.state = placemark.administrativeArea
                self.zipcode = placemark.postalCode
                
                let locality = placemark.subLocality ?? "N/A"
                
                let address = [
                    placemark.name,
                    locality,
                    self.city,
                    self.state,
                    self.zipcode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                self.lblCurrentLocationDataShow.text = address
                self.selectedLocation = address
                self.isSearchLocation = true
                // Store latitude and longitude
                self.selectedLatitude = currentLocation.coordinate.latitude
                self.selectedLongitude = currentLocation.coordinate.longitude
                
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
        if let registerSecondVC = storyboard?.instantiateViewController(withIdentifier: "RegisterSecondViewController") as? RegisterSecondViewController {
            
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
