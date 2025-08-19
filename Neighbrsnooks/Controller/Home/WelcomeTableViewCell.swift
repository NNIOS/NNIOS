//
//  WelcomeTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 01/03/24.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblWelcmMsg: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblWelcmCount: UILabel!
    @IBOutlet weak var lblBookaCount: UILabel!
    @IBOutlet weak var WelcomeView: UIView!
    @IBOutlet weak var CongratulationView: UIView!
    @IBOutlet weak var welcomeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnFlower: UIButton!
    
    var likeStatus: Int = 0
     var bokayStatus: Int = 0
     var welUserID: String = ""
     var onLikeTapped: ((String) -> Void)?
     var onBokayTapped: ((String) -> Void)?
    private var defaultTextColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnWelcm(_ sender: UIButton) {
           if likeStatus == 0 && bokayStatus == 0 {
               onLikeTapped?(welUserID)
           }
       }

       @IBAction func btnBookay(_ sender: UIButton) {
           if likeStatus == 0 && bokayStatus == 0 {
               onBokayTapped?(welUserID)
           }
       }
}
