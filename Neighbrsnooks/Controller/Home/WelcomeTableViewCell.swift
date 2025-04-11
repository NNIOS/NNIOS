//
//  WelcomeTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 01/03/24.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblWelcmMsg: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblWelcmCount: UILabel!
    @IBOutlet weak var lblBookaCount: UILabel!
    
    var WelLikeCallback : ((UIButton) -> Void)?
    var bookayCallback : ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnWelcm(_ sender: UIButton) {
        WelLikeCallback?(sender)
    }
    
    @IBAction func btnBookay(_ sender: UIButton) {
        bookayCallback?(sender)
    }
}
