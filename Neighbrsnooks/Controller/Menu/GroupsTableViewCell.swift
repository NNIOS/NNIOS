//
//  GroupsTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 07/03/24.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblPrivate: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var UserImgView : UIImageView!
    @IBOutlet weak var lblMemberText: UILabel!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblPendingCount: UILabel!
    @IBOutlet weak var viewPendingCount: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewOwner: UIView!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnReqPending: UIButton!
    @IBOutlet weak var btnDetails: UIButton!
    
    var ExitCallback : ((UIButton) -> Void)?
    var JoinCallback : ((UIButton) -> Void)?
    var DetailsCallback : ((UIButton) -> Void)?
    var DotCallback : ((UIButton) -> Void)?
    
    var userId: String?
    weak var delegate: ProfileTapDelegate?

    
    weak var delegateFav: ProfileFavTapDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserImgView != nil{
            addTapGestureToProfile()
        }
        
    }
    
    private func addTapGestureToProfile() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        UserImgView.isUserInteractionEnabled = true
        UserImgView.addGestureRecognizer(tapGesture)
        
        
        let tapGesturSece = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        lblSec.isUserInteractionEnabled = true
        lblSec.addGestureRecognizer(tapGesturSece)
        
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        lblName.isUserInteractionEnabled = true
        lblName.addGestureRecognizer(nameTapGesture)
    }
    
    @objc private func profileTapped() {
        if let userId = userId {
            delegate?.didTapProfile(userId: userId)
            delegateFav?.didTapProfile(userId: userId)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionThreedotCell(_ sender: Any) {
        DotCallback?(sender as! UIButton)
    }
    
    
    @IBAction func btnExit(_ sender: UIButton) {
        ExitCallback?(sender)
    }
    @IBAction func btnJoin(_ sender: UIButton) {
        JoinCallback?(sender)
    }
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }
    
    @IBAction func actionDot(_ sender: Any) {
        DotCallback?(sender as! UIButton)
    }
    
}
