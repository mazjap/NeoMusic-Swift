//
//  DefaultButton.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/13/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultButton: UIButton {
    var shadowView = CALayer()
    var ring = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        tintColor = .buttonColor
        
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [UIColor.bottomGradientColor.cgColor, UIColor.topGradientColor.cgColor]
        backgroundGradient.frame = bounds
        backgroundGradient.cornerRadius = frame.height / 2
        
        let ringBackgroundGrad = CAGradientLayer()
        ringBackgroundGrad.colors = backgroundGradient.colors?.reversed()
        ringBackgroundGrad.frame = bounds
        ringBackgroundGrad.cornerRadius = frame.height / 2
        
        layer.insertSublayer(backgroundGradient, at: 0)
        layer.insertSublayer(shadowView, at: 0)
        layer.shadowOpacity = 0.3
        layer.cornerRadius = frame.height / 2
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: -frame.height / 15, height: -frame.height / 15)
        layer.shadowRadius = 1.5
        
        shadowView.frame = self.bounds
        shadowView.masksToBounds = false
        shadowView.shadowOpacity = 0.3
        shadowView.cornerRadius = frame.height / 2
        shadowView.shadowColor = UIColor.black.cgColor
        shadowView.shadowOffset = CGSize(width: frame.height / 15, height: frame.height / 15)
        shadowView.shadowRadius = 1.5
        
    }
}
