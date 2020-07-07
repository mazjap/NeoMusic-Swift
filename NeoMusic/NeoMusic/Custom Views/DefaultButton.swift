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
    
    @IBInspectable
    var buttonTintColor: UIColor = .gray {
        didSet {
            button.tintColor = buttonTintColor
        }
    }
    
    let button = UIButton()
    let buttonBackgroundGrad = CAGradientLayer()
    var action: () -> Void = {}
    
    // MARK: - Superclass Functions
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let secondaryFrame = rect.changeSize(mult: 0.95)
        
        guard let context = UIGraphicsGetCurrentContext(),
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.reversed() as CFArray, locations: [0.0, 1.0])
            else { return }
        
        UIBezierPath(roundedRect: secondaryFrame, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: secondaryFrame.width / 2, height: secondaryFrame.height / 2)).addClip()
        
        let buttonGradientStartPoint = CGPoint(x: secondaryFrame.minX, y: secondaryFrame.minY)
        let buttonGradientEndPoint = CGPoint(x: secondaryFrame.maxX, y: secondaryFrame.maxY)
        
        context.drawLinearGradient(gradient, start: buttonGradientStartPoint, end: buttonGradientEndPoint, options: [])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func updateViews() {
        super.updateViews()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(performAction(_:)))
        tap.numberOfTapsRequired = 1
        button.addGestureRecognizer(tap)
        
        insertSubview(button, aboveSubview: self)
        
        addConstraints([NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0), NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0), NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0), NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)])
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
