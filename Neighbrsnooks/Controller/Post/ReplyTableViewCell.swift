//
//  ReplyTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 26/12/24.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var lblneighbrhood: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var actionReply: UIButton!
    @IBOutlet weak var lblReplyUserName : UILabel!
    //    var profileTapHandler: ((_ section: Int) -> Void)?
    //    var sectionForTap: Int = 0
    //    var replyButtonTapped: (() -> Void)? // Closure to handle button tap
    
    
    var sectionForTap: Int = 0
    var replyButtonTapped: (() -> Void)?
    var profileTapHandler: ((_ reply: Postlistdatum, _ section: Int) -> Void)?
    var replyObjForTap: Postlistdatum?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPicImageView.layer.cornerRadius = userPicImageView.frame.height/2
        actionReply.addTarget(self, action: #selector(replyButtonTappedAction), for: .touchUpInside)
        self.userNameLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        
        userPicImageView.isUserInteractionEnabled = true
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(profileImgTapped))
        userPicImageView.addGestureRecognizer(imgTap)
        userNameLabel.isUserInteractionEnabled = true
        let lblTap = UITapGestureRecognizer(target: self, action: #selector(lblNameTapped))
        userNameLabel.addGestureRecognizer(lblTap)
        
    }
    
    @objc func replyButtonTappedAction() {
        // Call the closure when reply button is tapped
        replyButtonTapped?()
    }
    
    func configureCell(for section: Int, reply: Postlistdatum) {
        self.sectionForTap = section
        self.replyObjForTap = reply
    }
    
    @objc private func profileImgTapped() {
        if let reply = replyObjForTap {
            profileTapHandler?(reply, sectionForTap)
        }
    }
    
    @objc private func lblNameTapped() {
        if let reply = replyObjForTap {
            profileTapHandler?(reply, sectionForTap)
        }
    }
}
