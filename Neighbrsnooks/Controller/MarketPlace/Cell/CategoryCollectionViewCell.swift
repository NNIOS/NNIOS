//
//  CategoryCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 09/09/24.
//

import UIKit
//import sdweb

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewItems: UIView!
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors() // Call updateColors when the cell is loaded
    }
   
//    func configure(with category: Category) {
//        EventLbl.text = category.catTitle
//        if let url = URL(string: category.catImage!) {
//                // Load image from URL asynchronously (using a library like SDWebImage)
//               // profileImgView.sd_setImage(with: url)
//            profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
//            }
//        }
    
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
            
           
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          //  questionView.textColor = UIColor.secondaryLabel
            
            viewItems.layer.borderWidth = 0
            EventLbl.textColor = UIColor.secondaryLabel
            
            
            
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
}
