//
//  WebViewControllerViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 20/02/24.
//

import UIKit
import WebKit

class WebViewControllerViewController: UIViewController, WKNavigationDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblHeading: UILabel!
    
    var urlString : String?
    var heading = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        let url = URL (string: urlString ?? "")
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true

        lblHeading.text = heading
        

        // Do any additional setup after loading the view.
    }
    deinit {
            // Stop monitoring when the view controller is deallocated
            NetworkMonitor.shared.stopMonitoring()
        }
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    

}
