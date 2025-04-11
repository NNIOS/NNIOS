//
//  MarketChatTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 12/09/24.
//

import UIKit

class MarketChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var UserprofileImgView: UIImageView!
    
    @IBOutlet weak var yourViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var yourViewTrailingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force Auto Layout to recalculate heights dynamically
        contentView.layoutIfNeeded()
        
        // Ensure viewNotification resizes based on lblMessage height
        let messageSize = lblMessage.sizeThatFits(CGSize(width: lblMessage.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = messageSize.height + 20 // Add padding
        
        viewNotification.frame.size.height = newHeight
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateLeadingConstraint(newConstant: CGFloat) {
           yourViewLeadingConstraint.constant = newConstant
           // You might need to call layoutIfNeeded() to make the change immediate
           // self.layoutIfNeeded()
       }
    func updateTrailingConstraint(newConstant: CGFloat) {
        yourViewTrailingConstraint.constant = newConstant
           // You might need to call layoutIfNeeded() to make the change immediate
           // self.layoutIfNeeded()
       }
    
    func applyChatBubbleStyle(isSender: Bool) {
        let path = UIBezierPath()
        let width = viewNotification.bounds.width
        let height = viewNotification.bounds.height
        let arrowSize: CGFloat = 10 // Size of the arrow
        let arrowOffset: CGFloat = 10 // How far the arrow bulges out
        
        

        if isSender {
            // Sender chat bubble with arrow on the upper-right
            path.move(to: CGPoint(x: 0, y: 0)) // Top-left
            path.addLine(to: CGPoint(x: width - arrowSize, y: 0)) // Top-right (before arrow)
            path.addLine(to: CGPoint(x: width + arrowOffset, y: arrowSize / 2)) // Arrow outward
            path.addLine(to: CGPoint(x: width - arrowSize, y: arrowSize)) // Arrow back
            path.addLine(to: CGPoint(x: width - arrowSize, y: height)) // Bottom-right
            path.addLine(to: CGPoint(x: 0, y: height)) // Bottom-left
            path.close()
        } else {
            // Receiver chat bubble with arrow on the upper-left
            path.move(to: CGPoint(x: 0, y: 0)) // Top-left start
            path.addLine(to: CGPoint(x: -arrowOffset, y: arrowSize / 2)) // Arrow outward
            path.addLine(to: CGPoint(x: arrowSize, y: arrowSize)) // Arrow back
            path.addLine(to: CGPoint(x: arrowSize, y: height)) // Bottom-left
            path.addLine(to: CGPoint(x: width, y: height)) // Bottom-right
            path.addLine(to: CGPoint(x: width, y: 0)) // Top-right
            path.close()
        }


        // Apply the custom path as a mask
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        viewNotification.layer.mask = shapeLayer
    }
}
