//
//  ShinyBackgroundView.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 24/06/24.
//

import UIKit

class ShinyBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.applyShinyGradient()
        self.applyBlurEffect()
    }
}

extension UIView {
    func applyShinyGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds

        // Create a shiny effect using a gradient
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(white: 1.0, alpha: 0.8).cgColor,
            UIColor.white.cgColor
        ]
        
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(blurEffectView)
    }
}
