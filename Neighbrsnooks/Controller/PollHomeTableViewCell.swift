//
//  PollHomeTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 19/10/24.
//

import UIKit
protocol ProfileTapDelegate: AnyObject {
    func didTapProfile(userId: String)
}


class PollHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblstartdate: UILabel!
    @IBOutlet weak var lblEnddate: UILabel!
    @IBOutlet weak var lblVote: UILabel!
    @IBOutlet weak var ProfileImgView : UIImageView!
    @IBOutlet weak var VoteBtn: UIButton!
    
    var userId: String?
    weak var delegate: ProfileTapDelegate?
    
    var DetailsCallback : ((UIButton) -> Void)?
    var DotCallback : ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureToProfile()
    }
    
    private func addTapGestureToProfile() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        ProfileImgView.isUserInteractionEnabled = true
        ProfileImgView.addGestureRecognizer(tapGesture)
        
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        lblName.isUserInteractionEnabled = true
        lblName.addGestureRecognizer(nameTapGesture)
    }
    
    @objc private func profileTapped() {
        if let userId = userId {
            delegate?.didTapProfile(userId: userId)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }

    
    @IBAction func btnDotPoll(_ sender: UIButton) {
            DotCallback?(sender)
        }
    
    
}
