//
//  AttendeeCell.swift
//  EventDeatilDemo
//
//  Created by Abdul Aleem on 27/09/25.
//

import UIKit
import Kingfisher

class AttendeeCell: UITableViewCell {
    
    @IBOutlet weak var AttendeesCollectionView: UICollectionView!
    @IBOutlet weak var attendeesCollectionViewHeight: NSLayoutConstraint!
    
    var onDeleteImageTapped: (() -> Void)?
    var onImageTapped: ((EventImage, [EventImage]) -> Void)?
    
    private var images: [EventImage] = [] {
        didSet {
            AttendeesCollectionView.reloadData()
            updateCollectionViewHeight()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AttendeesCollectionView.delegate = self
        AttendeesCollectionView.dataSource = self
        AttendeesCollectionView.register(UINib(nibName: "AttendeesImageCell", bundle: nil), forCellWithReuseIdentifier: "AttendeesImageCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }
    
    func updateCollectionViewHeight() {
        let itemCount = images.count
        guard itemCount > 0 else {
            attendeesCollectionViewHeight.constant = 0
            return
        }
        
        let width = AttendeesCollectionView.frame.width
        guard width > 0 else { return } // avoid zero width
        
        let spacing: CGFloat = 5
        let itemsPerRow: CGFloat = 3
        
        let totalSpacing = spacing * (itemsPerRow - 1)
        let itemWidth = (width - totalSpacing) / itemsPerRow
        let itemHeight = itemWidth
        
        let numberOfRows = ceil(Double(itemCount) / Double(itemsPerRow))
        
        let totalHeight = CGFloat(numberOfRows) * itemHeight + CGFloat(numberOfRows - 1) * spacing
        attendeesCollectionViewHeight.constant = totalHeight
        self.layoutIfNeeded()
    }

    
    func setImages(_ eventImages: [EventImage]) {
        self.images = eventImages.filter { $0.type.lowercased() == "joinee" }
        print("Owner images count: \(images.count)")
        DispatchQueue.main.async { [weak self] in
            self?.AttendeesCollectionView.reloadData()
            self?.updateCollectionViewHeight()
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

extension AttendeeCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttendeesImageCell", for: indexPath) as! AttendeesImageCell
        let imgData = images[indexPath.item]
        cell.configure(with: imgData)
        cell.mainView.layer.cornerRadius = 5
        cell.btnImgDelete.tag = indexPath.item
        cell.btnImgDelete.addTarget(self, action: #selector(btnDeleteImageTapped(sender:)), for: .touchUpInside)
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
        onImageTapped?(imgData, images)  // ✅ Pass selected + all images
    }
}
