//
//  AnnouncementTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 08/11/24.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgAnnouncement: UIImageView!
    @IBOutlet weak var viewAnnouncement: UIView!
    private var gradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgAnnouncement.layer.cornerRadius = imgAnnouncement.frame.height / 2
        imgAnnouncement.clipsToBounds = true

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
     
    override func layoutSubviews() {
           super.layoutSubviews()
        viewAnnouncement.layer.backgroundColor = UIColor.red.cgColor
       }

       func applyGradientToAnnouncement() {
           // Remove previous gradient layer if it exists
           gradientLayer?.removeFromSuperlayer()

           // Create a new gradient layer
           let newGradient = CAGradientLayer()
           newGradient.frame = viewAnnouncement.bounds // uses size from storyboard constraints
           newGradient.colors = [
               UIColor(hexString: "#AA4A44").cgColor,
               UIColor(hexString: "#E0817B").cgColor
           ]
           newGradient.startPoint = CGPoint(x: 0, y: 0)
           newGradient.endPoint = CGPoint(x: 1, y: 0)
           newGradient.cornerRadius = viewAnnouncement.layer.cornerRadius

           // Insert gradient as the background of viewAnnouncement
           viewAnnouncement.layer.insertSublayer(newGradient, at: 0)

           // Save reference to avoid stacking gradients
           gradientLayer = newGradient
       }


}
