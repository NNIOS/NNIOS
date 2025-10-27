//
//  AttendingtCell.swift
//  EventDeatilDemo
//
//  Created by Abdul Aleem on 27/09/25.
//

import UIKit

class AttendingtCell: UITableViewCell {
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var lblAttending: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDefaultState()
        
    }
    
    private func setupDefaultState() {
            btnYes.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            btnNo.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            btnYes.setTitleColor(.black, for: .normal)
            btnNo.setTitleColor(.black, for: .normal)
            btnYes.layer.cornerRadius = 8
            btnNo.layer.cornerRadius = 8
            btnYes.clipsToBounds = true
            btnNo.clipsToBounds = true
        }
}
