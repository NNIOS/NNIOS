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
    
    // Start monitoring network changes
    func startMonitoring() {
        if !isMonitoring {
            let queue = DispatchQueue(label: "NetworkMonitorQueue")
            monitor.pathUpdateHandler = { path in
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
        
        let alert = UIAlertController(title: "No Internet Connection",
                                      message: "Please check your Wi-Fi or mobile data.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        rootVC.present(alert, animated: true, completion: nil)
    }
}
