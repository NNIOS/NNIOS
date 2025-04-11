//
//  MarketEnlargmentViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 21/09/24.
//

import UIKit
import AVFoundation

class MarketEnlargmentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var images: [ProductImage] = [] // Assuming ProductImage is your model for images
       var selectedIndex: Int = 0
    var thisWidth:CGFloat = 0
    
       @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
               collectionView.dataSource = self
               
               // Scroll to the selected image
//               let indexPath = IndexPath(item: selectedIndex, section: 0)
//               collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumLineSpacing = 0 // No space between images
                layout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            }

            collectionView.isPagingEnabled = true // Enable paging

            // Scroll to the selected image
            let indexPath = IndexPath(item: selectedIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return images.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketEnlargmentCollectionViewCell", for: indexPath) as! MarketEnlargmentCollectionViewCell

           if let imageUrlString = images[indexPath.row].img,
              let url = URL(string: imageUrlString) {
               cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
           }

           return cell
       }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  thisWidth = CGFloat(self.collectionView.width) / 1
                  return CGSize(width: thisWidth, height: 639)
              }
}
