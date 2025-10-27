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
    @IBOutlet weak var btnDotsImg : UIButton!
    @IBOutlet weak var lblStartPoll: UILabel!
    @IBOutlet weak var lblEndPoll: UILabel!

    var userId: String?
    weak var delegate: ProfileTapDelegate?
    
    var DetailsCallback : ((UIButton) -> Void)?
    var DotCallback : ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
 
        addTapGestureToProfile()
        ProfileImgView.layer.cornerRadius = ProfileImgView.frame.height/2
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
    
    func configure(with item: HomePollItem) {
           lblName.text = item.username
           lblSector.text = item.neighborhoodName
           lblTime.text = item.pollCreatedOn
           lblAddress.text = item.pollTitle
           lblstartdate.text = "Start: \(item.pollStartDate)"
           lblEnddate.text = "End: \(item.pollEndDate)"
           lblVote.text = "\(item.pollTotalVote) Votes"

           // Profile image
           if let url = URL(string: item.userpic), !item.userpic.isEmpty {
               ProfileImgView.kf.indicatorType = .activity
               ProfileImgView.kf.setImage(with: url, placeholder: UIImage(named: "default_user"))
           } else {
               ProfileImgView.image = UIImage(named: "default_user")
           }
       }
    
    
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }

    
    @IBAction func btnDotPoll(_ sender: UIButton) {
            DotCallback?(sender)
        }
    
    
}
