//
//  NotificationTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 02/03/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var viewNotification: UIView!
    var DetailsCallback : ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }

}
