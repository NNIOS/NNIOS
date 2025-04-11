//
//  PollTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 14/10/24.
//

import UIKit

class PollTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrcntg: UILabel!
    @IBOutlet weak var customBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
