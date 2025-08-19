//
//  EventEnlargementViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 30/08/24.
//

import UIKit

class EventEnlargementViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    var url: URL?
        var otherImages: [String] = [] // You can pass other image URLs as well

        @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.clipsToBounds = true
            view.clipsToBounds = true
            self.view.backgroundColor = .black
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            collectionView.dataSource = self
//            if let url = url?.absoluteString {
//                otherImages.insert(url, at: 0)
//            }
        }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return otherImages.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventEnlargementCollectionViewCell", for: indexPath) as! EventEnlargementCollectionViewCell
           let imageUrlString = otherImages[indexPath.row]
           if let imageUrl = URL(string: imageUrlString) {
               cell.imageView.kf.setImage(with: imageUrl)
           }
           return cell
       }

       // MARK: - UICollectionViewDelegateFlowLayout

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
       }
  

}
