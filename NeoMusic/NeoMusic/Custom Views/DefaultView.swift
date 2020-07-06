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
    var colors = [UIColor.bottomGradientColor.cgColor, UIColor.topGradientColor.cgColor] {
        didSet {
            updateGradient()
        }
    }
    
    var startPoint = CGPoint()
    var endPoint = CGPoint()
    
    override var isHidden: Bool {
        didSet {
            shadowView.isHidden = isHidden
        }
    }
    
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
        shadowView.frame = CGRect(origin: frame.origin, size: rect.size)
        
        super.draw(rect)
        // Create path to be drawn in (circle)
        UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: bounds.width / 2, height: bounds.height / 2)).addClip()

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
        setNeedsDisplay()
    }
    
    internal func setupShadows() {
        let difference: Float
        if let windowHeight = window?.frame.height {
            difference = Float(frame.origin.y / windowHeight)
        } else {
            difference = 0.5
        }
        
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: -frame.height / 20, height: -frame.height / 20)
        layer.shadowRadius = 14
        
        shadowView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        shadowView.layer.cornerRadius = frame.height / 2
        shadowView.layer.shadowOpacity = difference
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: frame.height / 20, height: frame.height / 20)
        shadowView.layer.shadowRadius = 20
    }
    
    internal func updateColors() {
        updateGradient()
    }
    
    internal func updateViews() {
        startPoint = CGPoint(x: frame.minX, y: frame.maxY)
        endPoint = CGPoint(x: frame.maxX, y: frame.minY)
        
        setupGradient()
        backgroundColor = .clear
        
        secondaryFrame = bounds.changeSize(const: 5)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateColors()
    }
}


