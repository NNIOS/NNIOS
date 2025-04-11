//
//  Terms&ConditionsViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 29/12/24.
//

import UIKit
import WebKit
class Terms_ConditionsViewController: UIViewController {

    @IBOutlet weak var viewWeb: UIView!
    var webView: WKWebView!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Initialize WKWebView
            webView = WKWebView(frame: viewWeb.bounds)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            webView.navigationDelegate = self
            viewWeb.addSubview(webView)
            
            // Load the URL
            if let url = URL(string: "https://neighbrsnook.com/terms-conditions/") {
                let request = URLRequest(url: url)
                webView.load(request)
            } else {
                print("Invalid URL")
            }
        }
        
        @IBAction func actionBack(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    extension Terms_ConditionsViewController: WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Failed to load with error: \(error.localizedDescription)")
        }
    }
