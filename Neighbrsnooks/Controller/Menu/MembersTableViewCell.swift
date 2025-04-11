//
//  MembersTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 04/04/24.
//

import UIKit

class MembersTableViewCell: UITableViewCell {
    
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
    
    @IBOutlet weak var btnOtherProfile: UIButton!

}
