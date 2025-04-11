//
//  ReceiverTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 06/05/24.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var lblSubject: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
