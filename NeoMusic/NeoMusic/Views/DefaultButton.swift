//
//  DefaultButton.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/13/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultButton: DefaultView {
    
    // MARK: - Variables
    
    @IBInspectable
    var imageName: String = "" {
        didSet {
            button.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    let drawPattern: CGPatternDrawPatternCallback? = nil
    let button = UIButton()
    let buttonBackgroundGrad = CAGradientLayer()
    var action: () -> Void = {}
    
    // MARK: - Superclass Functions
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let newRect = rect.changeSize(const: 5)
        if let context = UIGraphicsGetCurrentContext() {
            _ = UIBezierPath(roundedRect: newRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: newRect.height / 2, height: newRect.height / 2)).addClip()
            let buttonGradientStartPoint = CGPoint(x: newRect.minX, y: newRect.minY)
            let buttonGradientEndPoint = CGPoint(x: newRect.maxX, y: newRect.maxY)
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorLocations: [CGFloat] = [0.0, 1.0]
            
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors.reversed() as CFArray, locations: colorLocations) {
                context.drawLinearGradient(gradient, start: buttonGradientStartPoint, end: buttonGradientEndPoint, options: [])
            }
        }
        
        UIGraphicsEndImageContext()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
    }

    override func updateViews() {
        secondaryFrame = bounds.changeSize(const: 5)
        
        super.updateViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(performAction(_:)))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
        button.addGestureRecognizer(tap)
        
        button.frame = secondaryFrame
        insertSubview(button, aboveSubview: self)
    }
    
    override func setupGradient() {
        super.setupGradient()
        
        button.backgroundColor = .clear
        
        if let imageView = button.imageView {
            button.bringSubviewToFront(imageView)
        }
    }
    
    override func updateGradient() {
        super.updateGradient()
//        drawButtonGradient(secondaryFrame)
        
        buttonBackgroundGrad.colors = colors.reversed()
        buttonBackgroundGrad.frame = button.bounds
        buttonBackgroundGrad.cornerRadius = buttonBackgroundGrad.bounds.height / 2
    }
    
    // MARK: - Functions

    func setImage(_ image: UIImage?, for state: UIControl.State) {
        button.setImage(image, for: .normal)
    }
    
    // MARK: - Objective-C Functions

    @objc
    private func performAction(_ sender: UITapGestureRecognizer) {
        action()
    }
}
