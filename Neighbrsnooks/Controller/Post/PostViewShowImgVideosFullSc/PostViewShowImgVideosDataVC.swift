//
//  PostViewShowImgVideosDataVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 19/10/24.
//

import UIKit

import AVKit

@available(iOS 16.0, *)
class PostViewShowImgVideosDataVC: UIViewController {
    
    @IBOutlet weak var colleviewShowImgVideos: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    
    var selectedImage: String?
    var selectedVideo: String?
    var PostListData: PostListModel?
    var imgData = [PostImage]()
    var imgDataF = [PostImageF]()
    var bussdata = [BusinessImage]()
     
    var imageUrls: [ImageBd] = []
    var allMediaData: [PostImageD] = []
    var selectedIndex: Int = 0
    var selectedMediaDetailsUrl: String?
    var mediaArrayMarketDetails: [String] = []
    var thisWidth: CGFloat = 0
    var UserName = ""
    //New add Irshad
    var imgDataAll: [PostDetailsMedia] = []


       override func viewDidLoad() {
           super.viewDidLoad()

           setupCollectionView()
           lblName.text = UserName
           btnCross.layer.cornerRadius = btnCross.frame.height / 2
           btnCross.clipsToBounds = true

           colleviewShowImgVideos.reloadData()
           stopVisibleVideoCells()
       }

       func setupCollectionView() {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           layout.minimumLineSpacing = 0
           colleviewShowImgVideos.collectionViewLayout = layout
           colleviewShowImgVideos.isPagingEnabled = false
           colleviewShowImgVideos.decelerationRate = .fast
           colleviewShowImgVideos.showsHorizontalScrollIndicator = false

           colleviewShowImgVideos.delegate = self
           colleviewShowImgVideos.dataSource = self
       }

       func stopVisibleVideoCells() {
           for cell in colleviewShowImgVideos.visibleCells {
               if let videoCell = cell as? PostViewShowImgVideosColleViewCell {
                   videoCell.stopVideo()
               }
           }
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           self.tabBarController?.tabBar.isHidden = false
           stopVisibleVideoCells()
       }

       @IBAction func action_CrossImgVideo(_ sender: Any) {
           navigationController?.popViewController(animated: true)
       }
   }

   @available(iOS 16.0, *)
   extension PostViewShowImgVideosDataVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return imgDataAll.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostViewShowImgVideosColleViewCell", for: indexPath) as! PostViewShowImgVideosColleViewCell
           let postImage = imgDataAll[indexPath.row]
           cell.configure(with: postImage)
           cell.isUserInteractionEnabled = true
           return cell
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let screenWidth = UIScreen.main.bounds.width
           let screenHeight = UIScreen.main.bounds.height
           return CGSize(width: screenWidth, height: screenHeight) // Full screen for each media
       }

       func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           if let videoCell = cell as? PostViewShowImgVideosColleViewCell {
               videoCell.stopVideo() // Pause or reset video when cell scrolls out
           }
       }

       // Snapping logic to snap at nearest item when scrolling ends smoothly
       func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
           let cellWidthIncludingSpacing = colleviewShowImgVideos.frame.width
           let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
           let index: CGFloat
           if velocity.x > 0 {
               index = ceil(estimatedIndex)
           } else if velocity.x < 0 {
               index = floor(estimatedIndex)
           } else {
               index = round(estimatedIndex)
           }
           targetContentOffset.pointee = CGPoint(x: index * cellWidthIncludingSpacing, y: 0)
       }
   }
