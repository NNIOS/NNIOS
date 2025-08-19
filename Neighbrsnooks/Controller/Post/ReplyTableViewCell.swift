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
    
    
    var replyButtonTapped: (() -> Void)? // Closure to handle button tap
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPicImageView.layer.cornerRadius = userPicImageView.frame.height/2
        actionReply.addTarget(self, action: #selector(replyButtonTappedAction), for: .touchUpInside)
        self.userNameLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
    }
    
    @objc func replyButtonTappedAction() {
        // Call the closure when reply button is tapped
        replyButtonTapped?()
    }
}
