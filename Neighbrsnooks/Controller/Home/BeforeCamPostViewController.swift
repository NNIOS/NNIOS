//
//  BeforeCamPostViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 19/07/24.
//

import UIKit
import AVKit
import AVFoundation


protocol ImageCollectionViewControllerDelegate: AnyObject {
    func didTapDeleteButton(at index: Int)
}

class BeforeCamPostViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var image: UIImage?
    var images: [UIImage] = []
    var videoURLs: [URL] = []
    var selectedImage: UIImage?
    // var imageArray = [UIImage]()
    weak var delegate: ImageCollectionViewControllerDelegate?
    var selectedIndex: Int = 0
    var imageArray = [UIImage]()
    var videoArray: [URL] = []
    // var selectedImage: UIImage?
    var receivedImages: [UIImage] = []
    var thisWidth:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Received Images: \(imageArray.count)")
        print("Received Videos: \(videoArray.count)")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
        
        
        //           if let selectedImage = image {
        //               images.append(selectedImage)
        //           }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - UICollectionViewDelegate & UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + videoURLs.count // Return total count of images and videos
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostBannerCollectionViewCell", for: indexPath) as! PostBannerCollectionViewCell
        
        // Check if the index corresponds to an image or a video
        if indexPath.item < images.count {
            // Display the image
            cell.profileImgView.image = images[indexPath.item]
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            
            // Set the delete callback
            // Set up delete action
            //               cell.DeleteCallback = { [weak self] index in
            //                   self?.didDeleteImage(at: index) // Safely call the delete function
            //               }
            
        } else {
            // Display the video thumbnail
            let videoIndex = indexPath.item - images.count
            let videoURL = videoURLs[videoIndex]
            cell.profileImgView.image = getVideoThumbnail(url: videoURL) // Function to get video thumbnail
            // You can add play button functionality here if required
        }
        
        
        return cell
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag // Get the index from the button's tag
        didDeleteImage(at: index) // Call the deletion function
    }
    
    // Method to delete image or video
    func didDeleteImage(at index: Int) {
        // Delete image or video from the appropriate array
        if index < images.count {
            images.remove(at: index) // Image deletion
        } else {
            let videoIndex = index - images.count
            videoURLs.remove(at: videoIndex) // Video deletion
        }
        
        // Refresh the collection view after deletion
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collectionView.width) / 1
        return CGSize(width: thisWidth, height: 639)
    }
    
    
}
// emojiContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,constant: 80),

// Function to get video thumbnail
func getVideoThumbnail(url: URL) -> UIImage? {
    let asset = AVAsset(url: url)
    let assetImageGenerator = AVAssetImageGenerator(asset: asset)
    assetImageGenerator.appliesPreferredTrackTransform = true
    var thumbnail: UIImage?
    do {
        let time = CMTimeMake(value: 1, timescale: 2)
        let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
        thumbnail = UIImage(cgImage: cgImage)
    } catch {
        print("Error generating thumbnail: \(error.localizedDescription)")
    }
    return thumbnail
}

