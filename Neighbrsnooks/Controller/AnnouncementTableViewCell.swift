//
//  AnnouncementTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 08/11/24.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgAnnouncement: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgAnnouncement.layer.cornerRadius = imgAnnouncement.frame.height / 2
        imgAnnouncement.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
