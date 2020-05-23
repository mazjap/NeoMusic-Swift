//
//  DefaultButton.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/13/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultButton: UIButton {
    var shadowView = UIView()
    var ringView = UIView()
    var vc: SongViewController? {
        didSet {
            layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        tintColor = .buttonColor
        
        if let vc = vc {
            let backgroundGradient = CAGradientLayer()
            backgroundGradient.colors = [UIColor.bottomGradientColor.cgColor, UIColor.topGradientColor.cgColor]
            backgroundGradient.frame = bounds
            backgroundGradient.cornerRadius = frame.height / 2
            layer.cornerRadius = frame.height / 2
            
            layer.insertSublayer(backgroundGradient, at: 0)
            
//            let change: Double = 0.125
            vc.view.insertSubview(ringView, at: 1)
            let newFrame = CGRect(x: frame.minX - (frame.width * 0.125 / 2), y: frame.minY - (frame.height * 0.125 / 2), width: frame.width + (frame.width * 0.125), height: frame.height + (frame.height * 0.125))
            let ringBackgroundGrad = CAGradientLayer()
            ringBackgroundGrad.colors = backgroundGradient.colors?.reversed()
            ringBackgroundGrad.frame = newFrame
            ringBackgroundGrad.cornerRadius = newFrame.height / 2
            ringView.layer.insertSublayer(ringBackgroundGrad, at: 0)
            ringView.backgroundColor = .clear
            
            vc.view.insertSubview(shadowView, at: 1)
            layer.shadowOpacity = 0.2
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOffset = CGSize(width: -frame.height / 15, height: -frame.height / 15)
            layer.shadowRadius = 14
            
            shadowView.frame = frame
            shadowView.backgroundColor = .red
            shadowView.layer.cornerRadius = frame.height / 2
            shadowView.layer.shadowOpacity = 0.3
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: frame.height / 15, height: frame.height / 15)
            shadowView.layer.shadowRadius = 14
        }
    }
}
