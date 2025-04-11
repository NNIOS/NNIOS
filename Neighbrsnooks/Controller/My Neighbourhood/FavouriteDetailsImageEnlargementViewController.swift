//
//  FavouriteDetailsImageEnlargementViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 01/08/24.
//

import UIKit

class FavouriteDetailsImageEnlargementViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imgDataF = [PostImageF]()
    var thisWidth:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return imgDataF.count
       }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostBannerCollectionViewCell", for: indexPath) as! PostBannerCollectionViewCell
        let url = URL(string: (imgDataF[indexPath.row].img ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
      // cell.profileImgView.image = imageArray
      //  cell.profileImgView.image = imgDataF[indexPath.item]
//        cell.deleteButton.tag = indexPath.item
//                cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
//        
        return cell
        

        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  thisWidth = CGFloat(self.collectionView.width) / 1
                  return CGSize(width: thisWidth, height: 639)
              }
}
