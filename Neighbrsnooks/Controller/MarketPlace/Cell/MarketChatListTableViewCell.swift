//
//  MarketChatListTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 11/09/24.
//

import UIKit

class MarketChatListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
