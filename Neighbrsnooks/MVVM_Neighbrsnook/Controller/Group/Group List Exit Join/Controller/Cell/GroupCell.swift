//
//  GroupCell.swift
//  MarketVC
//
//  Created by Abdul Aleem on 11/09/25.
//

import UIKit

class GroupCell: UITableViewCell {
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblGroupType: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNeighbrhood: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblMemeberCount: UILabel!
    @IBOutlet weak var memberView: UIView!
    @IBOutlet weak var imgGroup: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(with item: GroupItem) {
           let imageURL = item.group_image ?? ""
           lblUserName.text = item.username
           lblGroupName.text = item.group_name
           lblGroupType.text = item.group_type
           lblNeighbrhood.text = item.neighborhood
           lblCount.text = item.pendingRequestCount
           lblMemeberCount.text = "\(item.membercount ?? 0)"
           ImageLoader.shared.setImage(on: imgGroup, urlString: imageURL.isEmpty ? nil : imageURL, placeholder: "groupImg")
           countView.isHidden = true
           lblCount.isHidden = true
           if let userId = UserDefaults.standard.value(forKey: "userid") as? Int {
               if userId == item.userid {
                   if item.pendingRequestCount == "0" {
                       btnRequest.setTitle("Owner", for: .normal)
                       btnRequest.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
                   }
                   else if item.getjoin == "Owner" {
                       btnRequest.setTitle("Owner", for: .normal)
                       btnRequest.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
                   }    else {
                       btnRequest.setTitle("Request Pending", for: .normal)
                       btnRequest.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0, blue: 0.5019607843, alpha: 1)
                       countView.isHidden = false
                       lblCount.isHidden = false
                       countView.layer.borderWidth = 1
                       countView.layer.borderColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
                   }
               } else {
                   if item.getjoin == "pending" {
                       btnRequest.setTitle("Approval Pending", for: .normal)
                       btnRequest.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0, blue: 0.5019607843, alpha: 1)
                   } else if item.getjoin == "join" {
                       btnRequest.setTitle("join", for: .normal)
                       btnRequest.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
                   } else if item.getjoin == "joined" {
                       btnRequest.setTitle("Exit", for: .normal)
                       btnRequest.backgroundColor = .systemRed
                   }
               }
           } else {
               print("No userId found in UserDefaults")
           }
       }
}
