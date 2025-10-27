//
//  SidebarTableViewCell.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 12/05/25.
//

import UIKit

class SidebarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblItmeName : UILabel!
    @IBOutlet weak var imgItme: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblItmeName.font = UIFont.preferredFont(forTextStyle: .body)

//        imgItme.layer.cornerRadius = imgItme.frame.width/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
