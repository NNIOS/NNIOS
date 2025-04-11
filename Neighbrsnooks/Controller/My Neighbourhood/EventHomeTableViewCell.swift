//
//  EventHomeTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 31/08/24.
//

import UIKit

protocol EventHomeTableViewCellDelegate: AnyObject {
    func didTapProfile(userId: String)
}



class EventHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var BannerImgView : UIImageView!
    @IBOutlet weak var ProfileImgView : UIImageView!
   
    @IBOutlet weak var lblCreateOn: UILabel!
    
    
    weak var delegateFav: ProfileFavTapDelegate?

    var eventCallAction : ((UIButton) -> Void)?
    var DotCallback : ((UIButton) -> Void)?
    var DotFCallback : ((UIButton) -> Void)?
    var userId: String? // 🟢 Yeh userId store karega
    weak var delegate: EventHomeTableViewCellDelegate? // 🟢 Delegate Reference

    
    override func awakeFromNib() {
        super.awakeFromNib()
        ProfileImgView.layer.cornerRadius = ProfileImgView.frame.height/2
        addTapGestureToProfile()
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func eventAction(_ sender: Any) {
        eventCallAction?(sender as! UIButton)
    }
    
    @IBAction func actionFavEvent(_ sender: Any) {
        eventCallAction?(sender as! UIButton)
    }
    
    
    @IBAction func btnDotPost(_ sender: UIButton) {
        DotCallback?(sender)
    }
    
    
    @IBAction func actionDot(_ sender: Any) {
        DotFCallback?(sender as! UIButton)
    }
    
    private func addTapGestureToProfile() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
           ProfileImgView.isUserInteractionEnabled = true
           ProfileImgView.addGestureRecognizer(tapGesture)

           let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
           lblName.isUserInteractionEnabled = true
           lblName.addGestureRecognizer(nameTapGesture)
        
        
        
        
        let secTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        lblSector.isUserInteractionEnabled = true
        lblSector.addGestureRecognizer(secTapGesture)
        
        
       }

       @objc private func profileTapped() {
           if let userId = userId {
               delegate?.didTapProfile(userId: userId) // 🔴 Delegate Call
               delegateFav?.didTapProfile(userId: userId)
           }
       }
    
    
    
    
    
}
