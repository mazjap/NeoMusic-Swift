//
//  SongImageView.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/22/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultImageView: DefaultView {
    
    // MARK: - Variables
    
    private var rotation: CGFloat = 0
    private let rotateAnimation = CABasicAnimation()
    private var totalRotation: CGFloat = 0
    private var prevRotation: CGFloat = 0
    private var startRotationAngle: CGFloat = 0
    private var imageView = UIImageView()
    
    var jiggler: UIImpactFeedbackGenerator?
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        updateViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateViews()
    }
    
    // MARK: - Superclass Functions

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func updateViews() {
        super.updateViews()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleRotation)))
        
        insertSubview(imageView, aboveSubview: self)
        
        
        addConstraints([NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0), NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0), NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.96, constant: 0), NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.96, constant: 0)])
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = frame.height / 2 - frame.height * 0.025
    }
    
    // MARK: - Functions
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func setAngle(_ angle: CGFloat) {
        rotate(to: angle)
    }
    
    // MARK: - Private Functions
    
    private func tap() {
        guard let jiggler = jiggler else { return }
        jiggler.impactOccurred()
    }
    
    private func rotate(to: CGFloat, duration: Double = 0) {
        rotateAnimation.fromValue = to
        rotateAnimation.toValue = to
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = 0
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        imageView.layer.add(rotateAnimation, forKey: "transform.rotation.z")
    }
    
    private func angle(from location: CGPoint) -> CGFloat {
        let deltaY = location.y - imageView.center.y
        let deltaX = location.x - imageView.center.x
        let angle = atan2(deltaY, deltaX) * 180 / .pi
        return angle < 0 ? abs(angle) : 360 - angle
    }
    
    private func clipToAngle(gestureRotation: CGFloat) {
        let num = evenOut(gestureRotation)
        let distance: CGFloat = .pi / 10
        if num > (.pi * 2) - distance || num < distance {
            rotate(to: 0)
            rotation = 0
        }
    }
    
    private func evenOut(_ val: CGFloat) -> CGFloat {
        var rotation = val
        if rotation > .pi * 2 {
            rotation -= .pi * 2
            return evenOut(rotation)
        } else if rotation < 0 {
            rotation += .pi * 2
            return evenOut(rotation)
        }
        return rotation
    }
    
    // MARK: - Objective-C Functions

    @objc
    private func handleRotation(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: imageView)
        let gestureRotation = CGFloat(angle(from: location)) - startRotationAngle
        
        switch sender.state {
        case .began:
            startRotationAngle = angle(from: location)
            tap()
        case .changed:
            rotate(to: rotation - gestureRotation.degreesToRadians)
        case .ended:
            rotation -= gestureRotation.degreesToRadians
            clipToAngle(gestureRotation: rotation - gestureRotation.degreesToRadians)
            tap()
        default:
            break
        }
    }
}
