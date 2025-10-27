//
//  HomeBusinessTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 08/01/25.
//

import UIKit
protocol HomeBusinessCellDelegate: AnyObject {
    func didTapBusinessItem(_ businessID: String)
}


class HomeBusinessTableViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblHealth: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var BussinessStatusView: UIView!
    @IBOutlet weak var lblApproval: UILabel!
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var userId: String?
    weak var delegate: ProfileTapDelegate?
    weak var delegateH: BussinessTableViewCellDelegate?
    var thisWidth:CGFloat = 0
    var BusimgData = ProfileTapDelegate?.self
    var DetailsCallback : ((UIButton) -> Void)?
    var DotCallback : ((UIButton) -> Void)?
   
    var businessMedia: [HomeBusinessMedia] = []
    
    weak var businessDelegate: HomeBusinessCellDelegate?
    var businessID: String? // Pass this from controller while setting up cell

    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewEvent.delegate = self
        collectionViewEvent.dataSource = self
        addTapGestureToProfile()
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        
//        collectionViewEvent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap)))

    }
    
//    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
//        let location = gesture.location(in: collectionViewEvent)
//        if let indexPath = collectionViewEvent.indexPathForItem(at: location) {
//            let selectedData = BusimgData[indexPath.row]
//            print("Selected data: \(selectedData)")
/////businessDelegate?.didSelectItem(with: selectedData, username: UserName,)
//        }
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Check if any image or video is available
//        let hasValidItem = BusimgData.contains { item in
//            let hasImage = !(item.img?.isEmpty ?? true)
//            let hasVideo = !(item.video?.isEmpty ?? true)
//            return hasImage || hasVideo
//        }
//
//        // Set height constraint accordingly
//        collectionViewHeightConstraint.constant = hasValidItem ? 500 : -20
//        collectionViewEvent.layoutIfNeeded()
//    }
    func configure(with item: HomeBusinessItem) {
        lblUserName.text = item.username
        lblSector.text = item.neighborhoodName
        lblProduct.text = item.businessTitle
        
        // Profile Image Kingfisher se load karo
        if let url = URL(string: item.userpic) {
            profileImgView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "defaultProfile"),
                options: [.transition(.fade(0.3))]
            )
        } else {
            profileImgView.image = UIImage(named: "defaultProfile")
        }
        
        // Media set karna
        self.businessMedia = item.businessMedia
        collectionViewEvent.reloadData()
    }
    
   
    
    private func addTapGestureToProfile() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileImgView.isUserInteractionEnabled = true
        profileImgView.addGestureRecognizer(tapGesture)
        
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        lblUserName.isUserInteractionEnabled = true
        lblUserName.addGestureRecognizer(nameTapGesture)
    }
    
    @objc private func profileTapped() {
        if let userId = userId {
            delegate?.didTapProfile(userId: userId)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset the collection view's data to avoid displaying incorrect images
        collectionViewEvent.reloadData()
    }
    
    
    
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }
    
    @IBAction func btnDotbussiness(_ sender: UIButton) {
        DotCallback?(sender)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return businessMedia.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBusinessCollectionViewCell", for: indexPath) as! HomeBusinessCollectionViewCell

           let item = businessMedia[indexPath.row]

           if let imageUrl = item.img, !imageUrl.isEmpty {
               let url = URL(string: imageUrl)
               cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
               cell.pauseButton.isHidden = true
               cell.muteButton.isHidden = true
               cell.removeVideoPlayer()
           } else if let videoUrl = item.video, !videoUrl.isEmpty {
               let url = URL(string: videoUrl)!
               cell.configureVideoPlayer(with: url)
               cell.pauseButton.isHidden = false
               cell.muteButton.isHidden = false
           }

           cell.numberLabel.text = "\(indexPath.item + 1)"
           cell.totalImagesLabel.text = "/ \(businessMedia.count)"

           return cell
       }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("TabDidSelect")
            if let businessID = businessID {
                    businessDelegate?.didTapBusinessItem(businessID)
                }
                
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.row < businessMedia.count else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }

        let mediaItem = businessMedia[indexPath.row]
        let isImageEmpty = mediaItem.img?.isEmpty ?? true
        let isVideoEmpty = mediaItem.video?.isEmpty ?? true

        if isImageEmpty && isVideoEmpty {
            return CGSize(width: collectionView.frame.width, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 500)
        }
    }


    
}
