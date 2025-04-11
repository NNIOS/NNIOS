//
//  PostCommentPopupVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 21/03/25.
//

import UIKit

class PostCommentPopupVC: UIViewController {
    var isFromReplyCell: Bool = false
    
    @IBOutlet weak var containerView: UIView!   
       @IBOutlet weak var imgReply: UIImageView!
       @IBOutlet weak var likeImg: UIImageView!
       @IBOutlet weak var lblLike: UILabel!
       @IBOutlet weak var lblReply: UILabel!
       @IBOutlet weak var imgDelete: UIImageView!
       @IBOutlet weak var lblDelete: UILabel!
       
       override func viewDidLoad() {
           super.viewDidLoad()
           containerView.layer.cornerRadius = 20  // Radius adjust karein
              containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Sirf top corners ke liye
              containerView.clipsToBounds = true 
           self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
           // Initially popup ko neeche hide rakhein
           containerView.transform = CGAffineTransform(translationX: 0, y: 200)
           UIView.animate(withDuration: 0.3) {
               self.containerView.transform = .identity  // Smooth animation ke saath neeche se aaye
           }
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
           self.view.addGestureRecognizer(tapGesture)
       }
       @objc func dismissPopup() {
           UIView.animate(withDuration: 0.3, animations: {
               self.containerView.transform = CGAffineTransform(translationX: 0, y: 200)
           }) { _ in
               self.dismiss(animated: false, completion: nil)
           }
       }
   }
