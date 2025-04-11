//
//  PostViewShowImgVideosDataVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 19/10/24.
//

import UIKit

import AVKit

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
    var imgDataAll = [postImagesN]()
    var imageUrls: [ImageBd] = []
    var allMediaData: [PostImageD] = []  // Pura array yahan store hoga
    var selectedIndex: Int = 0  // Ye batayega ki kaunsa item select hua hai

    
    var selectedMediaDetailsUrl: String?
    var mediaArrayMarketDetails: [String] = []
    
    
    
    var thisWidth: CGFloat = 0
    var UserName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0 // Space between items should be 0
        colleviewShowImgVideos.collectionViewLayout = layout
        colleviewShowImgVideos.isPagingEnabled = false // We'll handle custom snapping
        colleviewShowImgVideos.decelerationRate = .fast // Fast scrolling stop
        colleviewShowImgVideos.showsHorizontalScrollIndicator = false
        colleviewShowImgVideos.delegate = self
        colleviewShowImgVideos.dataSource = self
        lblName.text = UserName  // Ensure UserName is set before this line
        colleviewShowImgVideos.reloadData()
        print("Data in imgData: \(imgDataAll.count)")
        btnCross.layer.cornerRadius = btnCross.frame.height/2
        btnCross.clipsToBounds = true
        
        //           MARK: -
        // ✅ imgData ko imgDataAll me convert karke add karo
        imgDataAll.append(contentsOf: imgData.map { postImagesN(img: $0.img, video: $0.video) })
        
        // ✅ imgDataF ko imgDataAll me convert karke add karo
        imgDataAll.append(contentsOf: imgDataF.map { postImagesN(img: $0.img, video: $0.video) })
        
        // ✅ bussdata ko imgDataAll me convert karke add karo
        imgDataAll.append(contentsOf: bussdata.map { postImagesN(img: $0.img, video: $0.video) })
        imgDataAll.append(contentsOf: imageUrls.map { postImagesN(img: $0.img, video: $0.video) })
        imgDataAll.append(contentsOf: allMediaData.map { postImagesN(img: $0.img, video: $0.video) })

        imgDataAll.append(contentsOf: mediaArrayMarketDetails.map { urlString in
            if urlString.lowercased().hasSuffix(".mp4") || urlString.lowercased().hasSuffix(".mov") {
                return postImagesN(img: nil, video: urlString) // Video mila
            } else {
                return postImagesN(img: urlString, video: nil) // Image mila
            }
        })
        
        
        
        
        
        
        
        colleviewShowImgVideos.reloadData()
        
        
        
        
        // CollectionView ke visible cells le lo
        for cell in colleviewShowImgVideos.visibleCells {
            if let videoCell = cell as? PostViewShowImgVideosColleViewCell {
                videoCell.stopVideo() // 🎯 Stop Video Function Call Karein
            }
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // CollectionView ke visible cells le lo
        for cell in colleviewShowImgVideos.visibleCells {
            if let videoCell = cell as? PostViewShowImgVideosColleViewCell {
                videoCell.stopVideo() // 🎯 Stop Video Function Call Karein
            }
        }
    }
    
    
    
    @IBAction func action_CrossImgVideo(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension PostViewShowImgVideosDataVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgDataAll.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostViewShowImgVideosColleViewCell", for: indexPath) as! PostViewShowImgVideosColleViewCell
        cell.isUserInteractionEnabled = true
        let postImage = imgDataAll[indexPath.row]
        cell.configure(with: postImage)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: screenWidth, height: screenHeight) // Full-screen size
    }
    
    
    // Snapping effect to stop at the nearest item
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = colleviewShowImgVideos.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = colleviewShowImgVideos.frame.width // Full screen width
        
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
