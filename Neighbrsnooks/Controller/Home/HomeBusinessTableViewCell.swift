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
    @IBOutlet weak var BannerImgView : UIImageView!
    // @IBOutlet weak var BussinessImgView : UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var BussinessStatusView: UIView!
    @IBOutlet weak var lblApproval: UILabel!
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    var userId: String?
    weak var delegate: ProfileTapDelegate?
    weak var delegateH: BussinessTableViewCellDelegate?
    var thisWidth:CGFloat = 0
    //   var BusimgData = [image]()
    // var BusimgData = [image].self
    //  var BusimgData = [ImageBussi]()
    var BusimgData = [BusinessImageH]()
    var DetailsCallback : ((UIButton) -> Void)?
    var DotCallback : ((UIButton) -> Void)?
    // var BusimgData = [image]
    
    weak var businessDelegate: HomeBusinessCellDelegate?
    var businessID: String? // Pass this from controller while setting up cell

    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewEvent.delegate = self
        collectionViewEvent.dataSource = self
        addTapGestureToProfile()
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        
        collectionViewEvent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap)))

    }
    
    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionViewEvent)
        if let indexPath = collectionViewEvent.indexPathForItem(at: location) {
            let selectedData = BusimgData[indexPath.row]
            print("Selected data: \(selectedData)")
///businessDelegate?.didSelectItem(with: selectedData, username: UserName,)
        }
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
        
        return BusimgData.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBusinessCollectionViewCell", for: indexPath) as! HomeBusinessCollectionViewCell
        // Check if the index is valid
        guard indexPath.row < BusimgData.count else {
            print("Index out of bounds for BusimgData at row: \(indexPath.row)")
            return cell // Return an empty cell if the index is invalid
        }
        
        let item = BusimgData[indexPath.row]
        // If it's an image
        if let imageUrl = item.img, !imageUrl.isEmpty {
            let url = URL(string: imageUrl)
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "NewEvents"))
            
            // Hide video controls for images
            cell.pauseButton.isHidden = true
            cell.muteButton.isHidden = true
            cell.removeVideoPlayer()
        }
        // If it's a video
        else if let videoUrl = item.video, !videoUrl.isEmpty {
            let url = URL(string: videoUrl)!
            cell.configureVideoPlayer(with: url)
            
            // Show video controls
            cell.pauseButton.isHidden = false
            cell.muteButton.isHidden = false
        }
        
        
         cell.numberLabel.text = "\(indexPath.item + 1)"
        cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        let totalNumberOfImages = BusimgData.count
        cell.totalImagesLabel.text =  "/ \(totalNumberOfImages)"
        
        return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("TabDidSelect")
            if let businessID = businessID {
                    businessDelegate?.didTapBusinessItem(businessID)
                }
                
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collectionViewEvent.width) / 1
        return CGSize(width: thisWidth, height: 500)
    }
    
}
