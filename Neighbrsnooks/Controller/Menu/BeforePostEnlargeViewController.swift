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
        collectionView.clipsToBounds = true
        view.clipsToBounds = true
        self.view.backgroundColor = .black
        collectionView.backgroundColor = .clear
        btnCross.layer.cornerRadius = btnCross.frame.height/2
        btnCross.clipsToBounds = true
        btnCross.layer.borderWidth = 1
        btnCross.layer.borderColor = UIColor.darkGray.cgColor
         let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
         collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    
    @IBAction func BackButtionAction(_ sender: UIButton){
        if let updateVC = self.navigationController?.viewControllers.first(where: { $0 is UpdateBusinessViewController }) as? UpdateBusinessViewController {
            updateVC.shouldCallAPI = false
        }
        self.navigationController?.popViewController(animated: false)
    }

//    func didTapDeleteButton(in cell: PostBannerCollectionViewCell) {
//        guard let indexPath = collectionView.indexPath(for: cell) else { return }
//
//        if indexPath.row < imageArray.count {
//            imageArray.remove(at: indexPath.row)
//        } else {
//            let videoIndex = indexPath.row - imageArray.count
//            videoArray.remove(at: videoIndex)
//        }
//
//        collectionView.reloadData()
//        countDelegate?.didUpdateMedia(imageArray: imageArray, videoArray: videoArray)
//
//        if imageArray.isEmpty && videoArray.isEmpty {
//            if let updateVC = self.navigationController?.viewControllers.first(where: { $0 is UpdateBusinessViewController }) as? UpdateBusinessViewController {
//                updateVC.shouldCallAPI = false
//            }
//            navigationController?.popViewController(animated: true)
//        }
//    }

    
    func fetchDataFromAPI() {
        APIManager.shared.fetchData { images, videos in
            self.imageArray = images
            self.videoArray = videos
            self.collectionView.reloadData()
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
             return CGSize(width: width, height: 620)
        } else {
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

        if imageArray.isEmpty && videoArray.isEmpty {
            if let updateVC = self.navigationController?.viewControllers.first(where: { $0 is UpdateBusinessViewController }) as? UpdateBusinessViewController {
                updateVC.shouldCallAPI = false
            }
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
