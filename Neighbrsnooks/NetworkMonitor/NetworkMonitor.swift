//
//  NetworkMonitor.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 09/12/24.
//

import Foundation
import Network
import UIKit

 
class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private var isMonitoring = false
    
    // MARK: - Public connectivity status
    private(set) var isConnected: Bool = true
    
    // Start monitoring network changes
    func startMonitoring() {
        if !isMonitoring {
            let queue = DispatchQueue(label: "NetworkMonitorQueue")
            monitor.pathUpdateHandler = { path in
                self.isConnected = path.status == .satisfied
                
                if path.status == .unsatisfied {
                    // No internet connection
                    DispatchQueue.main.async {
                        self.showNoConnectionAlert()
                    }
                }
            }
            monitor.start(queue: queue)
            isMonitoring = true
        }
    }
    
    // Stop monitoring network changes
    func stopMonitoring() {
        if isMonitoring {
            monitor.cancel()
            isMonitoring = false
        }
    }
    
    // Show alert when there is no internet connection
    private func showNoConnectionAlert() {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
                if rootVC.presentedViewController is UIAlertController { return }
                
                let alert = UIAlertController(
                    title: "No Internet Connection",
                    message: "Please check your Wi-Fi or mobile data.",
                    preferredStyle: .alert
                )
                let attributedMessage = NSAttributedString(
                    string: "Please check your Wi-Fi or mobile data.",
                    attributes: [
                        .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                        .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                    ]
                )
                alert.setValue(attributedMessage, forKey: "attributedMessage")
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
                alert.addAction(okAction)
                
                rootVC.present(alert, animated: true, completion: nil) 
    }
}
