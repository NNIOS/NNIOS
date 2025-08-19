//
//  WishListCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 09/09/24.
//

import UIKit

class WishListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewItems: UIView!
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var rsLbl: UILabel!
    @IBOutlet weak var secttLbl: UILabel!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var btnWishlist: UIImageView!
    
    @IBOutlet weak var SoldImgView : UIImageView!
    
    override func prepareForReuse() {
           super.prepareForReuse()
           self.profileImgView.image = nil // Clear the old image
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        updateColors() // Call updateColors when the cell is loaded
    }
    
    var DetailCallback : ((UIButton) -> Void)?
    @IBAction func btnEventDetail(_ sender: UIButton) {
        DetailCallback?(sender)
    }
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            
            
            viewItems.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            
            viewItems.layer.borderWidth = 1.0
            
            EventLbl.textColor = .white
            rsLbl.textColor = .white
            secttLbl.textColor = .white
           
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          //  questionView.textColor = UIColor.secondaryLabel
            
            viewItems.layer.borderWidth = 0
            EventLbl.textColor = UIColor.secondaryLabel
            rsLbl.textColor = UIColor.secondaryLabel
            secttLbl.textColor = UIColor.secondaryLabel
            
            
            
            
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            updateColors()
        }
    }
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)
