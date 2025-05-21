//
//  MessageChatTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 02/05/24.
//

import UIKit

class MessageChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var viewNotification: UIView!
    
    @IBOutlet weak var yourViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var yourViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ReciverImgView: UIImageView!
    
  //  @IBOutlet weak var viewNotificationWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblMessage.numberOfLines = 0  // Allow multiple lines
            lblMessage.lineBreakMode = .byWordWrapping
        
       
            lblMessage.setContentHuggingPriority(.required, for: .vertical)
            lblMessage.setContentCompressionResistancePriority(.required, for: .vertical)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLeadingConstraint(newConstant: CGFloat) {
           yourViewLeadingConstraint.constant = newConstant
           self.layoutIfNeeded()  // Apply changes immediately
       }

       // Update Trailing Constraint
       func updateTrailingConstraint(newConstant: CGFloat) {
           yourViewTrailingConstraint.constant = newConstant
           self.layoutIfNeeded()  // Apply changes immediately
       }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        // Reapply the chat bubble style to ensure proper layout
//        let isSender = viewNotification.backgroundColor == #colorLiteral(red: 0.862745098, green: 0.9294117647, blue: 0.7882352941, alpha: 1)
//        applyChatBubbleStyle(isSender: isSender)
//    }

    
    func applyChatBubbleStyle(isSender: Bool) {
        let path = UIBezierPath()
        let width = viewNotification.bounds.width
        let height = viewNotification.bounds.height
        let arrowWidth: CGFloat = 10
        let arrowHeight: CGFloat = 10

        if isSender {
            // Sender bubble with a sharper arrow on the upper-right
            path.move(to: CGPoint(x: 0, y: 0)) // Top-left
            path.addLine(to: CGPoint(x: width - arrowWidth, y: 0)) // Before arrow
            path.addLine(to: CGPoint(x: width, y: arrowHeight / 2)) // Arrow tip (sharper)
            path.addLine(to: CGPoint(x: width - arrowWidth, y: arrowHeight)) // After arrow
            path.addLine(to: CGPoint(x: width - arrowWidth, y: height)) // Down right edge
            path.addLine(to: CGPoint(x: 0, y: height)) // Bottom-left
            path.close()
        } else {
            // Receiver bubble with arrow on the upper-left
            path.move(to: CGPoint(x: arrowWidth, y: 0)) // Top-left before arrow
            path.addLine(to: CGPoint(x: 0, y: arrowHeight / 2)) // Arrow tip (sharper)
            path.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight)) // After arrow
            path.addLine(to: CGPoint(x: arrowWidth, y: height)) // Down left edge
            path.addLine(to: CGPoint(x: width, y: height)) // Bottom-right
            path.addLine(to: CGPoint(x: width, y: 0)) // Top-right
            path.close()
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        viewNotification.layer.mask = shapeLayer
    }


}
