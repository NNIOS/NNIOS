//
//  BussFavTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 05/12/24.
//

import UIKit

protocol BussFavDelegate: AnyObject {
    func didSelectItem(with bussImage: BusinessImage)
}




class BussFavTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colleViewBusFav : UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblHealth: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    
 
    
    @IBOutlet weak var BannerImgView : UIImageView!
    @IBOutlet weak var BussinessImgView : UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    
    var thisWidth:CGFloat = 0
    var bussCollectionData: [String] = []
    var imgAray = ["NewBusiness","NewBusiness"]
    
    //   var BusimgData = [image]()
    // var BusimgData = [image].self
    //    var BusimgData = [ImageBussi]()
    var DetailsCallback : ((UIButton) -> Void)?
    var DotCallback : ((UIButton) -> Void)?
    var BusinessListData : BussinessListModel?
    var bussData = [ImageBussi]()
    var FavoriteListData = [BusinessImage]()
    var delegate: BussFavDelegate?
    
    var userId: String?
    weak var delegateFav: ProfileFavTapDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        colleViewBusFav.delegate = self
        colleViewBusFav.dataSource = self
        // Initialization code
        addTapGestureToProfile()
    }
    
    
    private func addTapGestureToProfile() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileImgView.isUserInteractionEnabled = true
        profileImgView.addGestureRecognizer(tapGesture)
        
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        lblUserName.isUserInteractionEnabled = true
        lblUserName.addGestureRecognizer(nameTapGesture)
        
        let secTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        lblSector.isUserInteractionEnabled = true
        lblSector.addGestureRecognizer(nameTapGesture)
        
        
        
    }
    
    @objc private func profileTapped() {
        if let userId = userId {
            delegateFav?.didTapProfile(userId: userId)
        }
    }
    
    
    override func prepareForReuse() {
            super.prepareForReuse()
            // Reset the collection view's data to avoid displaying incorrect images
        colleViewBusFav.reloadData()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionDot(_ sender: Any) {
        DotCallback?(sender as! UIButton)
    }
    
}


extension BussFavTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return FavoriteListData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavBussinessDataCollectionViewCell", for: indexPath) as! FavBussinessDataCollectionViewCell
            collectionView.allowsSelection = true
            cell.isUserInteractionEnabled = true
        
            let item = FavoriteListData[indexPath.row]
            cell.configure(with: item)
        
            cell.numberLabel.text = "\(indexPath.item + 1)"
            let totalNumberOfImages = bussData.count
            cell.totalImagesLabel.text = "/ \(totalNumberOfImages)"
            cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.profileImgView.layer.cornerRadius = 10
            cell.profileImgView.clipsToBounds = true
//            cell.countlblView.layer.cornerRadius = 10
//            cell.countlblView.clipsToBounds = true
            return cell
      
                   
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pauseAllVideosInVisibleCells()
        let selectedPostImage = FavoriteListData[indexPath.row]
            delegate?.didSelectItem(with: selectedPostImage)
       }

   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == colleViewBusFav {
            pauseAllVideosInVisibleCells()
        }
    }

    func pauseAllVideosInVisibleCells() {
        let visibleCells = colleViewBusFav.visibleCells.compactMap { $0 as? FavoriteCollectionViewCell }

        // Visible cells mein sabhi videos pause karein
        visibleCells.forEach { cell in
            if let player = cell.player {
                player.pause()
                cell.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal) // Button ko update karein
            }
        }
    }
 
   


    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.colleViewBusFav.width) / 1
        return CGSize(width: thisWidth, height: 500)
    }
}

