//
//  DefaultButton.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/13/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultButton: DefaultView {
    @IBInspectable var imageName: String = "" {
        didSet {
            button.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    let button = UIButton()
    let buttonBackgroundGrad = CAGradientLayer()
    var action: () -> Void = {}

    override func layoutSubviews() {
        super.layoutSubviews()
        button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
    }

    override func updateViews() {
        super.updateViews()

        let tap = UITapGestureRecognizer(target: self, action: #selector(performAction(_:)))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
        button.addGestureRecognizer(tap)
        
        button.frame = secondaryFrame
        insertSubview(button, aboveSubview: self)
        updateGradient()
    }
    
    override func setupGradient() {
        button.layer.insertSublayer(buttonBackgroundGrad, at: 0)
        
        super.setupGradient()
        
        if let imageView = button.imageView {
            button.bringSubviewToFront(imageView)
        }
        
        button.backgroundColor = .clear
    }
    
    override func updateGradient() {
        super.updateGradient()
        
        buttonBackgroundGrad.colors = colors.reversed()
        buttonBackgroundGrad.frame = button.bounds
        buttonBackgroundGrad.cornerRadius = buttonBackgroundGrad.bounds.height / 2
    }


    func setImage(_ image: UIImage?, for state: UIControl.State) {
        button.setImage(image, for: .normal)
    }

    @objc
    func performAction(_ sender: UITapGestureRecognizer) {
        action()
    }
}
