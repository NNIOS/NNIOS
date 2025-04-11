//
//  BeforePostEventCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/03/25.
//

import UIKit
import UIKit
import AVKit


protocol EventBannerCollectionViewCellDelegate: AnyObject {
    func didTapActionButton(cell: PostBannerCollectionViewCell)
}

class BeforePostEventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

   
    
    
    var imgDataF = [PostImageF]()
    var PostListData : PostListModel?
    var imgData = [PostImage]()
    var DetailsCallback : ((UIButton) -> Void)?
    
    @IBOutlet weak var deleteNewButton: UIButton!
      
      var DeleteNewCallback: ((Int) -> Void)?

      @IBAction func deleteNewButtonAction(_ sender: UIButton) {
          DeleteNewCallback?(sender.tag)
      }
    
    override func awakeFromNib() {
            super.awakeFromNib()
//        cratePostMuteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)  // Mute icon
//               cratePostplayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)  // Play icon
           }
    
    
    
   
   
    }
    
    
    
    

