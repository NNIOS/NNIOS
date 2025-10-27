//
//  EventCell.swift
//  EventDeatilDemo
//
//  Created by Abdul Aleem on 27/09/25.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblNeighrHood: UILabel!
    @IBOutlet weak var btnDot: UIButton!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblEventDetails: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnUnjoin: UIButton!
    @IBOutlet weak var btnJoin: UIButton!
    
    var onTapViewAtIndex: ((Int) -> Void)?
    private var tappableViews: [UIView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tappableViews = [lblUsername, lblNeighrHood, userImage]
        for (index, view) in tappableViews.enumerated() {
            view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tap.view?.tag = index
            view.tag = index
            view.addGestureRecognizer(tap)
        }
    }
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let tappedIndex = gesture.view?.tag else { return }
            onTapViewAtIndex?(tappedIndex)
        }
}

extension UILabel {
    func setAttributedText(prefix: String, value: String, prefixColor: UIColor, valueColor: UIColor) {
        let fullText = "\(prefix) \(value)"
        let attributedString = NSMutableAttributedString(string: fullText)

        // Range for prefix (e.g. "Start Date:")
        let prefixRange = (fullText as NSString).range(of: prefix)
        attributedString.addAttribute(.foregroundColor, value: prefixColor, range: prefixRange)

        // Range for value (e.g. "27-09-2025")
        let valueRange = (fullText as NSString).range(of: value)
        attributedString.addAttribute(.foregroundColor, value: valueColor, range: valueRange)

        self.attributedText = attributedString
    }
}
