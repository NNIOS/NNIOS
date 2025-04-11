//
//  BusinessEnlargmentViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 12/08/24.
//

import UIKit

class BusinessEnlargmentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
       
       var imageUrls: [ImageBd] = []  // ImageData is a model representing your image object
       var selectedImageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
               collectionView.dataSource = self
        let indexPath = IndexPath(item: selectedImageIndex, section: 0)
               collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !imageUrls.isEmpty {
            let indexPath = IndexPath(item: selectedImageIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }

    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return imageUrls.count
       }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostBannerCollectionViewCell", for: indexPath) as! PostBannerCollectionViewCell
        
        let mediaItem = imageUrls[indexPath.row]
        
        if let videoUrlString = mediaItem.video, let videoUrl = URL(string: videoUrlString) {
            cell.configureVideo(with: videoUrl)  // ✅ Agar video available hai toh yeh method call hoga
            cell.imageView.isHidden = true  // ❌ Image hide karenge agar video available hai
        } else if let imgUrlString = mediaItem.img, let imageUrl = URL(string: imgUrlString) {
            cell.imageView.kf.setImage(with: imageUrl)  // ✅ Agar sirf image hai toh set karo
            cell.imageView.isHidden = false
        } else {
            cell.imageView.image = UIImage(named: "placeholder") // Default image agar dono nil hain
            cell.imageView.isHidden = false
        }

        return cell
    }

  

}
