//
//  NeighbrhoodTblViewCell.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 04/08/25.
//

import UIKit

protocol NeighbourhoodNewDataShowTableViewCellDelegate: AnyObject {
    func didTapCheckbox(at indexPath: IndexPath)
}

class NeighbrhoodTblViewCell: UITableViewCell {
    
    @IBOutlet weak var lblNeighbrhood: UILabel!
    @IBOutlet weak var checkboxButtonNei: UIButton!

    var isCheckedNeig: Bool = false
    weak var delegate: NeighbourhoodNewDataShowTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonAppearanceN()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
            self.addGestureRecognizer(tapGesture)

    }
    
    func updateButtonAppearanceN() {
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let selectedImage = UIImage(systemName: "largecircle.fill.circle", withConfiguration: config)
        let unselectedImage = UIImage(systemName: "circle", withConfiguration: config)
        
        checkboxButtonNei.setImage(isCheckedNeig ? selectedImage : unselectedImage, for: .normal)
        checkboxButtonNei.tintColor = isCheckedNeig ? UIColor(red: 0, green: 100/255.0, blue: 0, alpha: 1) : .black
    }
    
    
@objc func cellTapped() {
    if let indexPath = indexPath {
        delegate?.didTapCheckbox(at: indexPath) // Same as checkbox tap
    }
}

    @IBAction func checkboxTappedN(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.didTapCheckbox(at: indexPath)
        }
    }
    
   

}
