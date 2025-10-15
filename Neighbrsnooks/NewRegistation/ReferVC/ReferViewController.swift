//
//  ReferViewController.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 13/10/25.
//

import UIKit

class ReferViewController: UIViewController {

    @IBOutlet weak var lblNeighborhood: UILabel!
    @IBOutlet weak var viewNeighborhood: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtReferName: UITextField!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var btnRefer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRefer.layer.cornerRadius = 12
        btnRefer.clipsToBounds = true
        viewName.layer.cornerRadius = 12
        viewName.clipsToBounds = true
        viewPhone.layer.cornerRadius = 12
        viewPhone.clipsToBounds = true
        viewNeighborhood.layer.cornerRadius = 12
        viewNeighborhood.clipsToBounds = true
        // Add tap gesture to viewNeighborhood
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(neighborhoodTapped))
        viewNeighborhood.isUserInteractionEnabled = true
        viewNeighborhood.addGestureRecognizer(tapGesture)
     }
    
    @objc func neighborhoodTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ReferListNeighbourhoodViewController") as? ReferListNeighbourhoodViewController {
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }

    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
     

    @IBAction func actionRefer(_ sender: Any) {
        let textToShare = "https://apps.apple.com/in/app/neighbrsnook/id6746369263"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        // For iPad compatibility (popover presentation)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            if let button = sender as? UIView {
                popoverController.sourceRect = button.frame
            }
        }

        self.present(activityViewController, animated: true, completion: nil)
    }

    
}



extension ReferViewController: ReferListNeighbourhoodDelegate {
    func didSelectNeighbourhood(name: String) {
        lblNeighborhood.text = name
    }
}
