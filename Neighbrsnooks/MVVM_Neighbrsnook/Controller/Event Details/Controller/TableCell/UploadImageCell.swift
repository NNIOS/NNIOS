//
//  UploadImageCell.swift
//  EventDeatilDemo
//
//  Created by Abdul Aleem on 27/09/25.
//

import UIKit

class UploadImageCell: UITableViewCell {
    @IBOutlet weak var btnUplaodImage: UIButton!
    @IBOutlet weak var lblUploadImage: UILabel!
    @IBOutlet weak var lblPreviewImage: UIButton!
    @IBOutlet weak var lblMaxLimit: UILabel!
    @IBOutlet weak var btnPostImage: UIButton!
    @IBOutlet weak var btnPostHeightConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
