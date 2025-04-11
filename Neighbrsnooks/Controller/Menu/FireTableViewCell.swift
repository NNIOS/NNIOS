//
//  FireTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/10/24.
//

import UIKit

class FireTableViewCell: UITableViewCell {
    
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var AddLbl: UILabel!
    @IBOutlet weak var Number1Lbl: UILabel!
    @IBOutlet weak var Number2Lbl: UILabel!
    @IBOutlet weak var WebLbl: UILabel!
    @IBOutlet weak var Number1Btn: UIButton!
    @IBOutlet weak var Number2Btn: UIButton!
    @IBOutlet weak var MapButton: UIButton!

    @IBOutlet weak var Number2View: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var arrowImageView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
