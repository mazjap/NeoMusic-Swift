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
    
    var rotation: CGFloat = 0
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
    
    // MARK: - Superclass Functions

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func updateViews() {
        super.updateViews()
        
        secondaryFrame = CGRect(center: bounds.center, size: bounds.size(multiplier: 0.96))
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        imageView.contentMode = .scaleAspectFill
        
        let rotationGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        imageView.addGestureRecognizer(rotationGesture)
        
        insertSubview(imageView, aboveSubview: self)
        imageView.frame = secondaryFrame
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
    private func handleRotation(sender: UIPanGestureRecognizer) {
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
