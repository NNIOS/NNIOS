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
}
