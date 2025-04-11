//
//  FavouriteImageEnlargementViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 01/08/24.
//

import UIKit

class FavouriteImageEnlargementViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
   
    var newStoryBoard:  UIStoryboard!
    var newNavigationController:  UINavigationController!
    var PostListData : PostListModel?
    var imgDataF = [PostImageF]()
   // var imgData: [UIImage] = []
    var thisWidth:CGFloat = 0
    var UserName = ""
    
    var FullImgCallback : ((UIButton) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
    //    lblName.text = UserDefaults.standard.object(forKey: "username") as? String
        self.newNavigationController =  self.navigationController
        lblName.text = UserName
                    collectionViewBanner.reloadData()
                
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
      //  lblName.text = UserName
        
       
        
        
       
    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgDataF.count ?? 0
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostBannerCollectionViewCell", for: indexPath) as! PostBannerCollectionViewCell
        
        let url = URL(string: (imgDataF[indexPath.row].img ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
     //   cell.profileImgView.image = image.fixOrientationNew()
        

//
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  thisWidth = CGFloat(self.collectionViewBanner.width) / 1
                  return CGSize(width: thisWidth, height: 639)
              }
    
}






