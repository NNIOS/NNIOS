//
//  RegisterThirdImageShowPopupVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 10/09/24.
//

import UIKit

class RegisterThirdImageShowPopupVC: UIViewController {
    var AdressProofDataPopup : AdressProofModel?
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var imageShowPopup: UIImageView!
    @IBOutlet weak var deleteButton: UIButton! // UIButton to delete the image
    var onDeleteImage: (() -> Void)? // Callback to notify the source view controller about the deletion
    var selectedImage: UIImage?
  
    @IBOutlet weak var crossButton: UIButton!
    
    
    var imagePass : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkMonitor.shared.startMonitoring()
        cropView.layer.cornerRadius = 10
        cropView.clipsToBounds = true
        imageShowPopup.layer.cornerRadius = 15
        imageShowPopup.clipsToBounds = true
        crossButton.layer.cornerRadius = crossButton.height/2
        deleteButton.layer.cornerRadius = crossButton.height/2
        deleteButton.clipsToBounds = true
        cropView.clipsToBounds = false
        self.view.bringSubviewToFront(imageShowPopup)
        self.view.bringSubviewToFront(deleteButton)
        
        
        // Set the passed image to imageShowPopup
                if let imageToShow = selectedImage {
                    imageShowPopup.image = imageToShow
                } else if let passedImage = imagePass {
                    imageShowPopup.image = passedImage
                }
                
                // Set the background to semi-transparent black
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent black
        self.view.isOpaque = false
        
    }
    deinit {
            // Stop monitoring when the view controller is deallocated
            NetworkMonitor.shared.stopMonitoring()
        }
    
    @IBAction func closePopupTapped(_ sender: UIButton) {
        // Notify the parent view controller about the image deletion
               onDeleteImage?()
               
               // Clear the image from the UIImageView
               imageShowPopup.image = nil
               
               // Optionally, you can dismiss the popup after deletion
               self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func crossTapImage(_ sender: UIButton){
        imageShowPopup.image = nil
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
