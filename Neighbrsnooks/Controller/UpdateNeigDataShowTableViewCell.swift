//
//  UpdateNeigDataShowTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 23/01/25.
//

import UIKit

class UpdateNeigDataShowTableViewCell: UITableViewCell {

    var isCheckedNeig: Bool = false
    weak var delegate: NeighbourhoodDataShowTableViewCellDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet weak var checkboxButtonNei: UIButton!
    
    func updateButtonAppearanceN() {
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let selectedImage = UIImage(systemName: "largecircle.fill.circle", withConfiguration: config)
        let unselectedImage = UIImage(systemName: "circle", withConfiguration: config)
        
        checkboxButtonNei.setImage(isCheckedNeig ? selectedImage : unselectedImage, for: .normal)
        checkboxButtonNei.tintColor = isCheckedNeig ? UIColor(red: 0, green: 100/255.0, blue: 0, alpha: 1) : .black
    }
    
    @IBAction func checkboxTappedN(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.didTapCheckbox(at: indexPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonAppearanceN()
    }
}
