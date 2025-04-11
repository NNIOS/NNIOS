//
//  PostDetailsShowDataViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 19/11/24.
//

import UIKit

@available(iOS 16.0, *)
class PostDetailsShowDataViewController: UIViewController {
    var thisWidth:CGFloat = 0
    @IBOutlet weak var postDataShow: UICollectionView!
    var imgData: [PostImage] = []  // To hold the image data
        var videoData: [PostImage] = []  // To hold the video data

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the collection view's layout
                if let layout = postDataShow.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal  // Vertical scrolling
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    layout.itemSize = CGSize(width: self.view.frame.width, height: 639)  // Full width, custom height
                    layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)  // Full screen item size
                
                }
        postDataShow.delegate = self
        postDataShow.dataSource = self
        postDataShow.reloadData()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backAction(_ sender: Any) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        self.navigationController?.popViewController(animated: true)
    }
    

}

@available(iOS 16.0, *)
extension PostDetailsShowDataViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgData.count + videoData.count
        print(imgData.count + videoData.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostDetailsShowDataCollectionViewCell", for: indexPath) as! PostDetailsShowDataCollectionViewCell
        if indexPath.row < imgData.count {
                    let currentImage = imgData[indexPath.row]
                    cell.configureCell(mediaURL: currentImage.img, isVideo: false)  // Image configuration
                } else {
                    let videoIndex = indexPath.row - imgData.count
                    let currentVideo = videoData[videoIndex]
                    cell.configureCell(mediaURL: currentVideo.video, isVideo: true)  // Video configuration
                }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           // You can also compute the height dynamically if needed, otherwise just set the constant height here
           return CGSize(width: self.view.frame.width, height: 639)
       }
    
}
