//
//  DirectMessageTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 30/04/24.
//

import UIKit

class DirectMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    var MessageCallback : ((UIButton) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func btnMessage(_ sender: UIButton) {
            MessageCallback?(sender)
        }
    
}
