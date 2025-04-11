//
//  PostEnlargeImageViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 27/06/24.
//

import UIKit
import AVFoundation


import AVKit



class PostEnlargeImageViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    var selectedImage: String? // Change type as needed
    var selectedVideo: String? // If applicable
    var newStoryBoard:  UIStoryboard!
    var newNavigationController:  UINavigationController!
    var PostListData : PostListModel?
    var imgData = [PostImage]()
    var imgDataAll = [postImagesN]()
    // var imgData: [UIImage] = []
    var thisWidth:CGFloat = 0
    var UserName =  ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
        //    lblName.text = UserDefaults.standard.object(forKey: "username") as? String
        self.newNavigationController =  self.navigationController
        collectionViewBanner.reloadData()
        
        lblName.text = UserName  // Ensure UserName is set before this line
        
        collectionViewBanner.reloadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        //  lblName.text = UserName
        
        
        
        
        
    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return selectedImage != nil || selectedVideo != nil ? 1 : 0 // Only one item
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostBannerCollectionViewCell", for: indexPath) as! PostBannerCollectionViewCell
          
          if let imageUrl = selectedImage {
              let url = URL(string: imageUrl)
              cell.profileImgView.kf.setImage(with: url)
              cell.profileImgView.isHidden = false
          } else if let videoUrl = selectedVideo {
              // Optionally, set up video thumbnail or other properties
              cell.profileImgView.isHidden = true
          }
          
          return cell
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          if let videoUrl = selectedVideo {
              // Play the video
              let player = AVPlayer(url: URL(string: videoUrl)!)
              let playerViewController = AVPlayerViewController()
              playerViewController.player = player
              
              present(playerViewController, animated: true) {
                  player.play()
              }
          } else if let imageUrl = selectedImage {
              // Handle image selection (if needed)
          }
      }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collectionViewBanner.width) / 1
        return CGSize(width: thisWidth, height: 600)
    }
    
    
    

    
    
}





