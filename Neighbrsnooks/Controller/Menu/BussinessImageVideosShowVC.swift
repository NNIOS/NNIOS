//
//  BussinessImageVideosShowVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 30/10/24.
//

import UIKit

class BussinessImageVideosShowVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var selectedData: String? // Pass ki gayi data ko store karne ke liye
       @IBOutlet weak var bussImgVidCollView: UICollectionView!
    
    
    var bussData = [ImageBussi]()
    var thisWidth:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        bussImgVidCollView.delegate = self
        bussImgVidCollView.dataSource = self
        bussImgVidCollView.reloadData()
        


        // Do any additional setup after loading the view.
    }
    
    @IBAction func acionBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    // Delegate method to receive selected item
       func didSelectItem(with data: ImageBussi) {
           self.bussData = [data] // Selected item ko array me add karna
           bussImgVidCollView.reloadData()
       }
    
    // CollectionView delegate and datasource methods
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return bussData.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BussinessImageVideosShowColleViewCell", for: indexPath) as! BussinessImageVideosShowColleViewCell
            let item = bussData[indexPath.row]
                    cell.configure(with: item)
            return cell
        }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//           // Collection view cell ka size set karein jo screen ke width ke hisaab se ho
//           let width = collectionView.bounds.width
//           let height = collectionView.bounds.height
//           return CGSize(width: width, height: height)
//       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.bussImgVidCollView.width) / 1
        return CGSize(width: thisWidth, height: 639)
    }

    
    
    
}
