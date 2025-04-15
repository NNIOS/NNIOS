//
//  FAQTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 01/10/24.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var arrowImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors()
        // Initialization code
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            lblAnswer.textColor = .white
            lblQuestion.textColor = .white
            arrowImageView.tintColor = .white
            
            // lblMember.textColor = .white
            //  lblMemberText.textColor = .white
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            lblAnswer.textColor = UIColor.secondaryLabel
            lblQuestion.textColor = .black
            arrowImageView.tintColor = .black
            
            
        }
        
        func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        
    }
}
