import UIKit

protocol BottomPanelDelegate: AnyObject {
    func didTapButton(at index: Int)
}

class BottomPanelView: UIView {
    weak var delegate: BottomPanelDelegate?

    private let buttonTitles = ["Home", "DM", "Favorites", "Notification", "Market"]
    private let buttonIcons = ["homekit", "message.badge.rtl", "star", "bell", "bag"] // SF Symbols
    
    
    private lazy var buttons: [UIButton] = {
        return buttonTitles.enumerated().map { index, title in
            let button = UIButton(type: .system)
            button.tag = index
            
            // Set attributed title for the button
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10), // Smaller font size
                .foregroundColor: UIColor.gray // Title color
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            button.setAttributedTitle(attributedTitle, for: .normal)
            
            // Set button icon with appropriate size
            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
            let largeIcon = UIImage(systemName: buttonIcons[index], withConfiguration: config)
            button.setImage(largeIcon, for: .normal)
            button.tintColor = .darkGray
            
            // Adjust icon and title positioning
            button.imageView?.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .center
            
            // Calculate dynamic insets
            let spacing: CGFloat = 5 // Spacing between icon and title
            if let imageSize = largeIcon?.size, let font = attributes[.font] as? UIFont {
                let titleSize = (title as NSString).size(withAttributes: [.font: font])
                
                let totalHeight = imageSize.height + titleSize.height + spacing
                let imageVerticalOffset = -(totalHeight / 2 - imageSize.height / 2)
                let titleVerticalOffset = totalHeight / 2 - titleSize.height / 2
                
                button.imageEdgeInsets = UIEdgeInsets(
                    top: imageVerticalOffset,
                    left: 0,
                    bottom: -imageVerticalOffset,
                    right: -titleSize.width
                )
                button.titleEdgeInsets = UIEdgeInsets(
                    top: titleVerticalOffset,
                    left: -imageSize.width,
                    bottom: -titleVerticalOffset,
                    right: 0
                )
            }
            
            // Add button action
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            return button
        }
    }()


    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        for button in buttons {
            stackView.addArrangedSubview(button)
        }
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        updateTabAppearance(selectedIndex: selectedIndex) // Update appearance
        delegate?.didTapButton(at: selectedIndex)         // Notify delegate about the tap
    }
    
    func updateTabAppearance(selectedIndex: Int) {
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.setTitleColor(#colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1), for: .normal)
                button.tintColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
            } else {
                button.setTitleColor(.darkGray, for: .normal)
                button.tintColor = .darkGray
            }
        }
    }
}
