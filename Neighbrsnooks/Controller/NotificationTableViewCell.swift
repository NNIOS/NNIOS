//
//  NotificationTableViewCell.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 02/03/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewNotification: UIView!
     var DetailsCallback : ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        lblSec.numberOfLines = 0 // Important for multiline text
        // Shadow / spacing look
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        // Corner and padding holder
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        bgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bgView)
        contentView.sendSubviewToBack(bgView)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           viewNotification.roundCorners([.topLeft, .bottomLeft], radius: 25)
       }
    
    
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }
    
    private func updateColors() {
          if traitCollection.userInterfaceStyle == .dark {
               lblName.textColor = .white
              lblSec.textColor = .white
              lblDate.textColor = .white
          } else {
                lblName.textColor = .label
              lblSec.textColor = .secondaryLabel
              lblDate.textColor = .secondaryLabel
          }
      }

      override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
          super.traitCollectionDidChange(previousTraitCollection)
          if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
              // updateColors()
          }
      }
}
