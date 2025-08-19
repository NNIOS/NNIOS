//
//  ReceivedMessageCell.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 21/07/25.
// dcedc9

import UIKit

class ReceivedMessageCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let messageBackgroundView = UIView()
    let lblMessage = UILabel()
    let lblTime = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        lblMessage.preferredMaxLayoutWidth = 280  // Match your max width constraint
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lblMessage.setContentCompressionResistancePriority(.required, for: .horizontal)

    }
    
 

    private func setupUI() {
        // Add your UI setup code here

        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.numberOfLines = 0
        lblMessage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lblMessage.setContentCompressionResistancePriority(.required, for: .horizontal)

        messageBackgroundView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageBackgroundView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }


    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "defaultProfile")
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        contentView.addSubview(profileImageView)

        messageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageBackgroundView.backgroundColor = UIColor(hex: "#dcedc9")
        messageBackgroundView.layer.cornerRadius = 12
        messageBackgroundView.clipsToBounds = true
        contentView.addSubview(messageBackgroundView)

        messageBackgroundView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageBackgroundView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        lblMessage.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblMessage.numberOfLines = 0
        lblMessage.textColor = .black
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        lblMessage.setContentHuggingPriority(.required, for: .horizontal)
        lblMessage.setContentCompressionResistancePriority(.required, for: .horizontal)
        messageBackgroundView.addSubview(lblMessage)

        lblTime.font = UIFont(name: "Montserrat-SemiBold", size: 10)
        lblTime.textColor = .darkGray
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        messageBackgroundView.addSubview(lblTime)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.heightAnchor.constraint(equalToConstant: 32),

            messageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageBackgroundView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            messageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            // 👇 Set max width AND allow label to expand up to it
            messageBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            messageBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            lblMessage.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 10),
            lblMessage.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 12),
            lblMessage.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -12),

            lblTime.topAnchor.constraint(equalTo: lblMessage.bottomAnchor, constant: 4),
            lblTime.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 12),
            lblTime.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -12),
            lblTime.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -8)
        ])

    }
}
