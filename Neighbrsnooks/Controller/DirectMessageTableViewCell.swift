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
    
    @IBOutlet weak var BgView: UIView!
    
    var MessageCallback : ((UIButton) -> Void)?
    private var defaultTextColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Store the storyboard default color before anything else
           defaultTextColor = lblName.textColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnMessage(_ sender: UIButton) {
        MessageCallback?(sender)
    }
    

}
