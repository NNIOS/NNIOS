//
//  LikeListTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 18/06/24.
//

import UIKit

class LikeListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var reactionButton: UIButton!
    
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
