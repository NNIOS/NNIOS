//
//  FavouriteDetailsImageEnlargementCollectionViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 01/08/24.
//

import UIKit

class FavouriteDetailsImageEnlargementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var viewCard: UIView!
    
    var FullImgCallback : ((UIButton) -> Void)?
   
    var imgDataF = [PostImageF]()
    var PostListData : PostListModel?
    var imgData = [PostImage]()
    var DetailsCallback : ((UIButton) -> Void)?

//        @IBAction func actionButtonTapped(_ sender: UIButton) {
//            delegate?.didTapActionButton(cell: self)
//        }
    
//    @IBAction func buttonTapped(_ sender: UIButton) {
//           // Handle button tap action, e.g., navigate to another screen
//           let storyboard = UIStoryboard(name: "Main", bundle: nil)
//           if let viewController = storyboard.instantiateViewController(withIdentifier: "PostPictureEnlarge") as? PostPictureEnlarge {
//               // Assuming you have a navigation controller, push the view controller
//               if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
//
//                 //  viewController.imgData = PostListData?.listdata?.postImages ?? []
//                   navigationController.pushViewController(viewController, animated: true)
//               }
//           }
//       }
//
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }

    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
}

    

