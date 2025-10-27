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
    private var isLiked: Bool = false
    var likeButtonTapped: ((_ newIsLiked: Bool) -> Void)?
     
    
    var profileTapHandler: ((_ section: Int) -> Void)?
    var sectionForTap: Int = 0
    
    //    var toggleLikeAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        replyButton.addTarget(self, action: #selector(replyButtonTappedAction), for: .touchUpInside)
        btnHideShow.addTarget(self, action: #selector(hideShowButtonTappedAction), for: .touchUpInside)
        emojiHart.setImage(UIImage(named: "heartBlack"), for: .normal)
        self.lblName.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        profileImgView.isUserInteractionEnabled = true
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(profileImgTapped))
        profileImgView.addGestureRecognizer(imgTap)
        
        lblName.isUserInteractionEnabled = true
        let lblTap = UITapGestureRecognizer(target: self, action: #selector(lblNameTapped))
        lblName.addGestureRecognizer(lblTap)
        
       
    }
    
    func configureCell(for section: Int) {
        self.sectionForTap = section
    }
    
    @objc private func profileImgTapped() {
        print("profileImgTapped: CELL KE ANDER AA GAYA")
        profileTapHandler?(sectionForTap)
    }
    @objc private func lblNameTapped() {
        print("lblNameTapped: CELL KE ANDER AA GAYA")
        profileTapHandler?(sectionForTap)
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
        isLiked.toggle()
        
        // Set icon instantly
        let imageName = isLiked ? "heartRed" : "heartBlack"
        emojiHart.setImage(UIImage(named: imageName), for: .normal)
        
        // Tell controller
        likeButtonTapped?(isLiked)
    }
    
    
    
    
    
}
