//
//  BussinessTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 07/03/24.
//

import UIKit
import Kingfisher
import AVKit
import AVFoundation

protocol BussinessTableViewCellDelegate: AnyObject {
    func didTapOnCollectionViewItem(data: ImageBussi, businessData: BusinessListData)
}



class BussinessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var  collecViewBuss: UICollectionView!
    var thisWidth:CGFloat = 0
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblHealth: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    
    @IBOutlet weak var BannerImgView : UIImageView!
    @IBOutlet weak var BussinessImgView : UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var bussinessImg: UIImageView!
    @IBOutlet weak var btnDotsImg : UIButton!

    weak var delegate: BussinessTableViewCellDelegate?
    var bussCollectionData: [String] = []
    var imgAray = ["NewBusiness","NewBusiness"]
    private var defaultTextColor: UIColor?
    
    //   var BusimgData = [image]()
    // var BusimgData = [image].self
    //    var BusimgData = [ImageBussi]()
    var DetailsCallback : ((UIButton) -> Void)?
    var BusinessListData : BussinessListModel?
    var bussData = [ImageBussi]()
    var FavoriteListData = [BusinessImage]()
    var BusimgData = [BusinessImageH]()
    var businessData: BusinessListData?
    var DotCallback : ((UIButton) -> Void)?
    
    var image: UIImage?
    var images: [UIImage] = []
    var imageArray = [UIImage]()
    var videoArray: [URL] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        defaultTextColor = lblUserName.textColor
        updateColors()
        collecViewBuss.delegate = self
        collecViewBuss.dataSource = self
        collecViewBuss.reloadData()
        bussCollectionData = []
        collecViewBuss.isPagingEnabled = true
        collecViewBuss.delaysContentTouches = true
        collecViewBuss.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap)))
        // Horizontal scrolling enable karein
        if let layout = collecViewBuss.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        self.profileImgView.layer.cornerRadius = profileImgView.frame.height/2
 
    }
 
    
    @objc private func handleCollectionViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collecViewBuss)
        if let indexPath = collecViewBuss.indexPathForItem(at: location) { // Use collecViewBuss here
            pauseAllVideosInVisibleCells()
            
            // Get selected image or video
            let selectedData = bussData[indexPath.row]
            
            // Ensure `businessData` is available
            if let businessData = self.businessData {
                delegate?.didTapOnCollectionViewItem(data: selectedData, businessData: businessData) // Pass both data and businessData
            } else {
                print("businessData is nil, unable to proceed.")
            }
        }
    }

    func configureCell(with data: [ImageBussi]) {
        self.bussData = data
        collecViewBuss.reloadData()
       
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            lblUserName.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblSector.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblProduct.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            lblHealth.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1) //
            btnDotsImg.tintColor = .white
            bussinessImg.tintColor = .white
            
        } else {
            // Light mode
            lblUserName.textColor = defaultTextColor
            lblSector.textColor = UIColor.secondaryLabel
            lblProduct.textColor = UIColor.secondaryLabel
            lblHealth.textColor = UIColor.secondaryLabel
            btnDotsImg.tintColor = .black
            bussinessImg.tintColor = .black
            
        }
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    
    
    @IBAction func btnThreeDotbussiness(_ sender: UIButton) {
            DotCallback?(sender)
        }
    
    
    
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bussCollectionData = [] // Clear old data on reuse
        collecViewBuss.reloadData()
     
    }
    
    func pauseAllVideosInVisibleCells() {
        let visibleCells = collecViewBuss.visibleCells.compactMap { $0 as? BussinessDataCollectionViewCell }
        
        // Visible cells mein sabhi videos pause karein
        visibleCells.forEach { cell in
            if let player = cell.player {
                player.pause()
                cell.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal) // Button ko update karein
            }
        }
    }
    
    
   
    
}


extension BussinessTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return bussData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BussinessDataCollectionViewCell", for: indexPath) as! BussinessDataCollectionViewCell
            collectionView.allowsSelection = true
            cell.isUserInteractionEnabled = true
            let item = bussData[indexPath.row]
            cell.configure(with: item)
            cell.numberLabel.text = "\(indexPath.item + 1)"
            let totalNumberOfImages = bussData.count
            cell.totalImagesLabel.text = "/ \(totalNumberOfImages)"
            cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.profileImage.layer.cornerRadius = 10
            cell.profileImage.clipsToBounds = true
            cell.countlblView.layer.cornerRadius = 10
            cell.countlblView.clipsToBounds = true
        
            return cell
      
                   
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let businessData = businessData else {
            print("Business data not found.")
            return
        }
        let selectedImageBussi = bussData[indexPath.row]
        print("Selected Business ID: \(businessData.id ?? "No ID")") // Business ID ko print karein

        // Check if businessData is available
        if let businessID = businessData.id {
            print("Business ID is: \(businessID)")
            delegate?.didTapOnCollectionViewItem(data: selectedImageBussi, businessData: businessData)
        } else {
            print("No business ID available")
        }
    }




    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collecViewBuss.width) / 1
        return CGSize(width: thisWidth, height: 530)
    }
}






