//
//  GroupMeTableViewCell.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 22/07/25.
//

import UIKit

class GroupMeTableViewCell: UITableViewCell {

    let messageBackgroundView = UIView()
    let lblMessage = UILabel()
    let lblTime = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        lblMessage.preferredMaxLayoutWidth = 280  // 250 - 12 - 12 padding
    }

    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(messageBackgroundView)
        messageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageBackgroundView.backgroundColor = UIColor(hex: "#e6e3d3")
        messageBackgroundView.layer.cornerRadius = 12
        messageBackgroundView.clipsToBounds = true

        lblMessage.numberOfLines = 0
        lblMessage.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblMessage.textColor = .black
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        messageBackgroundView.addSubview(lblMessage)

        lblTime.font = UIFont(name: "Montserrat-Regular", size: 10)
        lblTime.textColor = .darkGray
        lblTime.textAlignment = .right
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        messageBackgroundView.addSubview(lblTime)

        NSLayoutConstraint.activate([
            // 🟩 messageBackgroundView
            messageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            messageBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: 300), // ⬅️ fixed max width

            // 🟦 lblMessage
            lblMessage.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 10),
            lblMessage.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 12),
            lblMessage.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -12),

            // 🟨 lblTime
            lblTime.topAnchor.constraint(equalTo: lblMessage.bottomAnchor, constant: 4),
            lblTime.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 12),
            lblTime.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -12),
            lblTime.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -8)
        ])
    }
}
