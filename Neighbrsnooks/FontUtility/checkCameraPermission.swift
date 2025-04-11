//
//  checkCameraPermission.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 27/02/25.
//

import Foundation
import AVFoundation
import UIKit
func checkCameraPermission(completion: @escaping (Bool) -> Void) {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    
    switch status {
    case .authorized:
        // ✅ Permission already granted
        completion(true)
        
    case .notDetermined:
        // 🔄 First time asking for permission
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
        
    case .denied, .restricted:
        // ❌ Permission denied or restricted, show alert and don't proceed
        DispatchQueue.main.async {
            showCameraPermissionAlert(completion: completion)
        }
        
    @unknown default:
        completion(false)
    }
}

func showCameraPermissionAlert(completion: @escaping (Bool) -> Void) {
    guard let topVC = UIApplication.shared.windows.first?.rootViewController else { return }
    
    let alert = UIAlertController(
        title: "Camera Permission Needed",
        message: "Please allow camera access in Settings to continue.",
        preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        completion(false) // ❌ User cancelled, so don't proceed
    }))
    
    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
        completion(false) // ❌ Don't proceed until user enables permission
    }))
    
    topVC.present(alert, animated: true, completion: nil)
}


class ActivityIndicatorManager {
    static let shared = ActivityIndicatorManager()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private init() {}  // Isse koi instance baar-baar create nahi kar sakta

    func start(in view: UIView) {
        if activityIndicator.superview == nil {
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
        }
        activityIndicator.startAnimating()
    }
    
    func stop() {
        activityIndicator.stopAnimating()
    }
}


class APIManager {
    static let shared = APIManager()

    private init() {}

    func fetchData(completion: @escaping ([UIImage], [URL]) -> Void) {
        // Simulating API Call (Ye actual API Call bhi ho sakti hai)
        DispatchQueue.global(qos: .background).async {
            sleep(2) // API Response ka wait karne ka simulation

            // Dummy Images aur Videos ka Array
            let dummyImages: [UIImage] = [UIImage(named: "sample1")!, UIImage(named: "sample2")!]
            let dummyVideos: [URL] = [URL(string: "https://www.example.com/video1.mp4")!]

            DispatchQueue.main.async {
                completion(dummyImages, dummyVideos)
            }
        }
    }
}



class OrientationManager {
    static let shared = OrientationManager()
    var shouldSupportAllOrientations = false {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("UpdateOrientation"), object: nil)
        }
    }
    
    private init() {}
}
