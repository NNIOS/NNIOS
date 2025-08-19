//
//  LocationPermissionPopupVC.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 19/06/25.
//

import UIKit

class LocationPermissionPopupVC: UIViewController {
    @IBOutlet weak var enableLocationButton: UIButton!
    @IBOutlet weak var enterLocationButton: UIButton!
    
    @IBOutlet weak var popupView: UIView!
    var onManualLocation: (() -> Void)?
    var onEnableLocation: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        popupView.layer.cornerRadius = 10
        popupView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func enableLocationTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.onEnableLocation?()  // ✅ Trigger callback
        }
    }
    
    @IBAction func enterLocationTapped(_ sender: UIButton) {
        
        dismiss(animated: true) {
//            self.onManualLocation?()  // Callback to push from parent VC
        }
        
    }
    
    
}
