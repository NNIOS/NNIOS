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
        tableView.dataSource = self
 
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
        
        // Update the label with the selected location
        lblCurrentLocationDataShow.text = ": \(prediction.attributedFullText.string)"
        selectedLocation = prediction.attributedFullText.string // Store the selected location
        
        // Fetch full address details for the selected location
        fetchAddressDetails(for: selectedLocation ?? "")
        
        
        
        // Store latitude and longitude when an address is selected
        if let lat = self.selectedLatitude, let lon = self.selectedLongitude {
            print("Selected Latitude: \(lat), Longitude: \(lon)")
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

  
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Get current location and update the label
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        activityIndicator.startAnimating() // Start loader
        print("tab Current button\(locationManager)")
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate methods
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
                    print("Abdul Latitude: \(self.selectedLatitude!), Abdul Longitude: \(self.selectedLongitude!)")

                    if !self.isNavigated {
                        self.isNavigated = true
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
