//
//  PostDetailsTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/06/24.
//

import UIKit

class PostDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var emojiHart: UIButton!
    
//    outlet for hide show mess
    
    @IBOutlet weak var lblReplyMessCount: UILabel!
    @IBOutlet weak var btnHideShow: UIButton!
    @IBOutlet weak var lblHideShow: UILabel!
    var DotCallback: ((String?) -> Void)?
    var toggleReplyCellAction: (() -> Void)?
    var replyButtonTapped: (() -> Void)? // Closure to handle button tap
    
    var isLiked: Bool = false // Track the liked state
//    var toggleLikeAction: (() -> Void)?
        override func awakeFromNib() {
            super.awakeFromNib()
            profileImgView.layer.cornerRadius = profileImgView.frame.height/2
            replyButton.addTarget(self, action: #selector(replyButtonTappedAction), for: .touchUpInside)
            btnHideShow.addTarget(self, action: #selector(hideShowButtonTappedAction), for: .touchUpInside)
            emojiHart.setImage(UIImage(named: "heartBlack"), for: .normal)
            
            
        }

        @objc func replyButtonTappedAction() {
            // Call the closure when reply button is tapped
            
            replyButtonTapped?()
            
        }
    
    @objc func hideShowButtonTappedAction() {
        // Call the closure when reply button is tapped
        
        toggleReplyCellAction?()
        
    }

    func configure(with isLiked: Bool) {
           self.isLiked = isLiked
           let imageName = isLiked ? "heartRed" : "heartBlack"
           emojiHart.setImage(UIImage(named: imageName), for: .normal)
       }
    
    @IBAction func emojiHartTapped(_ sender: UIButton) {
        // Toggle the like state
               isLiked.toggle() // Flip the isLiked state each time button is clicked
               
               // Change the icon based on the isLiked state
               let imageName = isLiked ? "heartRed" : "heartBlack" // Toggle between heartRed and heartBlack
               emojiHart.setImage(UIImage(named: imageName), for: .normal)
               
               // Debugging - Check state
               print("Is Liked: \(isLiked ? "Liked" : "Unliked")")
           }
    
    
}
