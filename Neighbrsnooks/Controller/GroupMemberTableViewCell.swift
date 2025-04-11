//
//  GroupMemberTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/06/24.
//

import UIKit

class GroupMemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    
    @IBOutlet weak var profileImgView : UIImageView!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    var ProfileDetailCallback : ((UIButton) -> Void)?
    
    var AcceptCallback : ((UIButton) -> Void)?
    var DeclineCallback : ((UIButton) -> Void)?
    var DelUserCallback : ((UIButton) -> Void)?
    var account = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAccept(_ sender: UIButton) {
        AcceptCallback?(sender)
        account = "1"
    }
    @IBAction func btnDecline(_ sender: UIButton) {
        DeclineCallback?(sender)
        account = "2"
    }
    
    @IBAction func btnDelUser(_ sender: UIButton) {
        DelUserCallback?(sender)
        
    }
    @IBAction func btnProfileDetail(_ sender: UIButton) {
        ProfileDetailCallback?(sender)
    }
}
