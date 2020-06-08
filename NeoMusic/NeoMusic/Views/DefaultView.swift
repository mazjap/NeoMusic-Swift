//
//  DefaultView.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/31/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultView: UIView {
    
    // MARK: - Variables
    
    let shadowView = UIView()
    let backgroundGradient = CAGradientLayer()
    var secondaryFrame: CGRect
    var shouldUpdate = false
    var colors = [UIColor.bottomGradientColor.cgColor, UIColor.topGradientColor.cgColor] {
        didSet {
            shouldUpdate = true
            updateGradient()
        }
    }
    
    var startPoint = CGPoint()
    var endPoint = CGPoint()
    
    // MARK: - Initializers
    
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
    
    // MARK: - Superclass Functions
 
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Create path to be drawn in (circle)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: bounds.width / 2, height: bounds.height / 2))
        path.addClip()
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations) else { return }
        context.drawLinearGradient(gradient, start: CGPoint(x: bounds.minX, y: bounds.minY), end: CGPoint(x: bounds.maxX, y: bounds.maxY), options: CGGradientDrawingOptions(rawValue: UInt32(0))) // Create and draw gradient from top right to bottom left with colors array
        context.restoreGState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tintColor = .buttonColor
        backgroundColor = .clear
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: - Internal Functions
    
    internal func setupGradient() {
        draw(frame)
        updateGradient()
    }
    
    internal func updateGradient() {
        if shouldUpdate {
            draw(frame)
            shouldUpdate = false
        }
    }
    
    internal func setupShadows() {
        let difference: Float
        if let windowHeight = window?.frame.height {
            difference = Float(frame.origin.y / windowHeight)
        } else {
            difference = 0.5
        }
        
        layer.shadowOpacity = difference * 0.5
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: -frame.height / 20, height: -frame.height / 20)
        layer.shadowRadius = 14
        
        insertSubview(shadowView, at: 0)
        shadowView.frame = CGRect(center: bounds.center, size: bounds.size)
        shadowView.backgroundColor = .clear
        shadowView.layer.cornerRadius = frame.height / 2
        shadowView.layer.shadowOpacity = 1 - difference
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: frame.height / 20, height: frame.height / 20)
        shadowView.layer.shadowRadius = 20
    }
    
    internal func updateColors() {
        updateGradient()
    }
    
    internal func updateViews() {
        secondaryFrame = CGRect(center: bounds.center, size: bounds.size(multiplier: 0.95))
        startPoint = CGPoint(x: frame.minX, y: frame.maxY)
        endPoint = CGPoint(x: frame.maxX, y: frame.minY)
        
        setupGradient()
        setupShadows()
        backgroundColor = .clear
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateColors()
    }
}
