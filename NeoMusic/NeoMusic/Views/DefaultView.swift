//
//  DefaultView.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/31/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultView: UIView {
    let shadowView = UIView()
    let backgroundGradient = CAGradientLayer()
    var secondaryFrame: CGRect
    var colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor] {
        didSet {
            updateGradient()
        }
    }
    
    var startPoint = CGPoint()
    var endPoint = CGPoint()
    
    override init(frame: CGRect) {
        secondaryFrame = CGRect()
        super.init(frame: frame)

        updateViews()
    }
    
    required init?(coder: NSCoder) {
        secondaryFrame = CGRect()
        super.init(coder: coder)
        
        updateViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tintColor = .buttonColor
        layer.cornerRadius = frame.height / 2
    }
    
    
    internal func setupGradient() {
        layer.insertSublayer(backgroundGradient, at: 0)
        updateGradient()
    }
    
    internal func updateGradient() {
        backgroundGradient.colors = colors
        backgroundGradient.frame = bounds
        backgroundGradient.cornerRadius = frame.height / 2
        backgroundGradient.startPoint = startPoint
        backgroundGradient.endPoint = endPoint
    }
    
    internal func setupShadows() {
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: -frame.height / 20, height: -frame.height / 20)
        layer.shadowRadius = 14
        
        insertSubview(shadowView, belowSubview: self)
        shadowView.frame = bounds
        shadowView.layer.cornerRadius = frame.height / 2
        shadowView.layer.shadowOpacity = 0.9
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: bounds.height / 20, height: bounds.height / 20)
        shadowView.layer.shadowRadius = 14
    }
    
    internal func updateColors() {
        updateGradient()
    }
    
    internal func updateViews() {
        secondaryFrame = CGRect(center: bounds.center, size: bounds.size(multiplier: 0.95))
        startPoint = CGPoint(x: bounds.minX, y: bounds.minY)
        endPoint = CGPoint(x: bounds.maxX, y: bounds.maxY)
        
        setupGradient()
        setupShadows()
        backgroundColor = .clear
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateColors()
    }
}
