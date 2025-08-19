//
//  LocationPermissionManager.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 02/06/25.
//

import CoreLocation
import UIKit

class LocationPermissionManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationPermissionManager()
    
    private var locationManager = CLLocationManager()
    private var completionHandler: ((Bool) -> Void)?
    private weak var presentingViewController: UIViewController?
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func checkPermission(from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        self.completionHandler = completion
        self.presentingViewController = viewController
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            completion(true)
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            showLocationPermissionAlert()
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
    
  
    
    private func showLocationPermissionAlert() {
        guard let viewController = presentingViewController else { return }
        
        let alert = UIAlertController(
            title: "Location Permission Required",
            message: "The app needs your location permission to assign you a neighbourhood.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }))
        
        viewController.present(alert, animated: true)
    }
    
    // To handle authorization status change
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            completionHandler?(true)
        } else if status == .denied || status == .restricted {
            completionHandler?(false)
        }
    }
}
