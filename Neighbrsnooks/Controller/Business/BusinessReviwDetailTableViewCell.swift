//
//  BusinessReviwDetailTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 06/08/24.
//

import UIKit

class BusinessReviwDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblDSec: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var lblAttendes: UILabel!
    @IBOutlet weak var lblNonAttendes: UILabel!
    @IBOutlet weak var lblLikelist: UILabel!
    var CommentCallback : ((UIButton) -> Void)?
    
    var ProfileCallback : ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnComment(_ sender: UIButton) {
        CommentCallback?(sender)
    }
    
    @IBAction func btnProfileDetail(_ sender: UIButton) {
        ProfileCallback?(sender)
    }
}
