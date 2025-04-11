//
//  BeforePostEnlargeViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/07/24.
//

import UIKit
import AVFoundation

protocol ImageCollectionGalViewControllerDelegate: AnyObject {
    func didDeleteImage(at index: Int)
}
protocol MediaCountUpdateDelegate: AnyObject {
    func didUpdateMedia(imageArray: [UIImage], videoArray: [URL])
}


class BeforePostEnlargeViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, PostBannerCollectionViewCellDelegate {
    
    // var image: UIImage?
    
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var image: UIImage?
    var images: [UIImage] = []
    var selectedImage: UIImage?
    weak var delegate: ImageCollectionGalViewControllerDelegate?
    weak var  countDelegate: MediaCountUpdateDelegate?
    var imageArray = [UIImage]()
    var videoArray: [URL] = []
    // var selectedImage: UIImage?
    var receivedImages: [UIImage] = []
    var thisWidth:CGFloat = 0
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        btnCross.layer.cornerRadius = btnCross.frame.height/2
        btnCross.clipsToBounds = true
        btnCross.layer.borderWidth = 1
        btnCross.layer.borderColor = UIColor.darkGray.cgColor
         let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0 // Space between items should be 0
         collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = false // We'll handle custom snapping
        collectionView.decelerationRate = .fast // Fast scrolling stop
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout.invalidateLayout()
        
        // Activity Indicator Setup
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)

            // Loader start karein
            activityIndicator.startAnimating()

        loadData()
        
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        _ = navigationController?.popViewController(animated: true)
    }
    
    
   
    func loadData() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Simulating Data Fetch (Ye API Call ya database fetch ho sakta hai)
            sleep(2) // 2 second ka delay (Example ke liye)

            DispatchQueue.main.async {
                // Data Load Hone Ke Baad
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating() // Loader Band Karein
            }
        }
    }

    
    func fetchDataFromAPI() {
        activityIndicator.startAnimating() // Loader Start
        
        APIManager.shared.fetchData { images, videos in
            self.imageArray = images
            self.videoArray = videos
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating() // Loader Stop
        }
        
    }
    
    // MARK: - UICollectionViewDelegate & UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count + videoArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostBannerCollectionViewCell", for: indexPath) as! PostBannerCollectionViewCell
        if indexPath.row < imageArray.count {
            // Display image
            cell.configureImage(with: imageArray[indexPath.row])
            
        } else {
            // Display video and set up the video player
            let videoIndex = indexPath.row - imageArray.count
            let videoURL = videoArray[videoIndex]
            cell.configureVideo(with: videoURL)
        }
        cell.delegate = self
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if indexPath.row < imageArray.count {
            // Image ke liye height 500
            return CGSize(width: width, height: 620)
        } else {
            // Video ke liye height 400
            return CGSize(width: width, height: 620)
        }
    }

    
    
    // 🛠 Delegate Method Implement Karein
    func didTapDeleteButton(in cell: PostBannerCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        if indexPath.row < imageArray.count {
            imageArray.remove(at: indexPath.row)
        } else {
            let videoIndex = indexPath.row - imageArray.count
            videoArray.remove(at: videoIndex)
        }
        
        collectionView.reloadData()
        countDelegate?.didUpdateMedia(imageArray: imageArray, videoArray: videoArray)
        
        // ✅ Check karein agar sab delete ho gaya to back chalein
        if imageArray.isEmpty && videoArray.isEmpty {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
     
    
    func getVideoThumbnail(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 1) // Get a thumbnail from the start of the video
        
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: img)
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    // Snapping effect to stop at the nearest item
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = collectionView.frame.width // Full screen width
        
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





