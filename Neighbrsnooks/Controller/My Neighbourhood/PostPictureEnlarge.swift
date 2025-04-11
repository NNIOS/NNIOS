//
//  PostPictureEnlarge.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 24/06/24.
//

import UIKit

protocol EnlargeDelegate {
  func tapConfirm() -> Void
}

class PostPictureEnlarge: UIViewController {
    
    var delegate: EnlargeDelegate?
    var image: UIImage?
    var imgData = [PostImage]()
    @IBOutlet weak var imageView: UIImageView!
    
   // @IBOutlet weak var imageView: UIImageView!
      
    var selectedImge: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImge
        
//        imageView = UIImageView(frame: self.view.bounds)
//                imageView.contentMode = .scaleAspectFit
//                imageView.image = image
//                imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                
//                self.view.addSubview(imageView)
//                
//                // Add tap gesture to dismiss the full screen view
//                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreen))
//                self.view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    

    @objc func dismissFullScreen() {
           self.dismiss(animated: true, completion: nil)
       }

}
