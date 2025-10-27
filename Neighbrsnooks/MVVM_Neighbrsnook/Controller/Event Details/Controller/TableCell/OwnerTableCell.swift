//
//  OwnerTableCell.swift
//  EventDeatilDemo
//
//  Created by Abdul Aleem on 29/09/25.
//

import UIKit
import Kingfisher

class OwnerTableCell: UITableViewCell {

    @IBOutlet weak var ownerCollectionView: UICollectionView!
    @IBOutlet weak var ownerCollectionViewHeight: NSLayoutConstraint!
    
    var onDeleteImageTapped: (() -> Void)?
    var onImageTapped: ((EventImage, [EventImage]) -> Void)?
    
    private var images: [EventImage] = [] {
        didSet {
            ownerCollectionView.reloadData()
            updateCollectionHeight()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ownerCollectionView.delegate = self
        ownerCollectionView.dataSource = self
        ownerCollectionView.register(UINib(nibName: "ImageOwnerCVCell", bundle: nil), forCellWithReuseIdentifier: "ImageOwnerCVCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionHeight()
    }
    
    private func updateCollectionHeight() {
        let itemCount = images.count
        guard itemCount > 0 else {
            ownerCollectionViewHeight.constant = 0
            return
        }
        
        let width = ownerCollectionView.frame.width
        guard width > 0 else { return }
        
        let spacing: CGFloat = 5
        let itemsPerRow: CGFloat = 3
        
        let totalSpacing = spacing * (itemsPerRow - 1)
        let itemWidth = (width - totalSpacing) / itemsPerRow
        let itemHeight = itemWidth
        
        let numberOfRows = ceil(Double(itemCount) / Double(itemsPerRow))
        
        let totalHeight = CGFloat(numberOfRows) * itemHeight + CGFloat(numberOfRows - 1) * spacing
        ownerCollectionViewHeight.constant = totalHeight
        self.layoutIfNeeded()
    }
    
    func setImages(_ eventImages: [EventImage]) {
        self.images = eventImages.filter { $0.type.lowercased() == "owner" }
        print("Owner images count: \(images.count)")
        DispatchQueue.main.async { [weak self] in
            self?.ownerCollectionView.reloadData()
            self?.updateCollectionHeight()
        }
    }
    
    @objc func btnDeleteImageTapped(sender: UIButton) {
        var view = sender.superview
        while view != nil && !(view is UICollectionViewCell) {
            view = view?.superview
        }
        
        guard let collectionViewCell = view as? UICollectionViewCell,
              let collectionView = collectionViewCell.superview as? UICollectionView else {
            return
        }
        if let indexPath = collectionView.indexPath(for: collectionViewCell) {
            print("CollectionView item index:", indexPath.item)
        }
        var parentView: UIView? = self
        while parentView != nil && !(parentView is UITableView) {
            parentView = parentView?.superview
        }
        if let tableView = parentView as? UITableView,
           let tableIndexPath = tableView.indexPath(for: self) {
            print("TableView row index:", tableIndexPath.row)
        }
        onDeleteImageTapped?()
    }
}

extension OwnerTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageOwnerCVCell", for: indexPath) as! ImageOwnerCVCell
        let imgData = images[indexPath.item]
        cell.configure(with: imgData)
        cell.btnDeleteImage.tag = indexPath.item
        cell.btnDeleteImage.addTarget(self, action: #selector(btnDeleteImageTapped(sender:)), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 5
        let itemsPerRow: CGFloat = 3
        let totalSpacing = spacing * (itemsPerRow - 1)
        let width = collectionView.bounds.width
        let itemWidth = (width - totalSpacing) / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imgData = images[indexPath.item]
        onImageTapped?(imgData, images)
    }
}
