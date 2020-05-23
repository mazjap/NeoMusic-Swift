//
//  SongImageView.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/22/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class SongImageView: UIImageView, JigglerDelegate {
    var jiggler: UIImpactFeedbackGenerator?
    var lastRotation: CGFloat = 0
    var vc: SongViewController? {
        didSet {
            updateViews()
        }
    }
    var shadowView = UIView()
    var ringView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        addGestureRecognizer(rotateGesture)
    }
    
    private func updateViews() {
        if let vc = vc {
            vc.view.insertSubview(ringView, at: 1)
            let newFrame = CGRect(x: frame.minX - frame.width * 0.025, y: frame.minY + frame.width * 0.0375, width: frame.width * 1.05, height: frame.height * 1.05)
            let ringBackgroundGrad = CAGradientLayer()
            ringBackgroundGrad.colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor]
            ringBackgroundGrad.frame = newFrame
            ringBackgroundGrad.cornerRadius = newFrame.height / 2
            ringView.layer.insertSublayer(ringBackgroundGrad, at: 0)
            ringView.backgroundColor = .clear
            
            vc.view.insertSubview(shadowView, at: 1)
            layer.shadowOpacity = 0.2
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOffset = CGSize(width: -frame.height / 10, height: -frame.height / 10)
            layer.shadowRadius = 14
            
            shadowView.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            shadowView.backgroundColor = .black
            shadowView.layer.cornerRadius = shadowView.frame.height / 2
            shadowView.transform = CGAffineTransform(translationX: 0, y: 20)
            shadowView.layer.shadowOpacity = 0.3
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: frame.height / 10, height: frame.height / 10)
            shadowView.layer.shadowRadius = 14
        }
    }
    
    @objc
    private func handleRotation(sender: UIRotationGestureRecognizer) {
        guard let senderView = sender.view else { return }
        if sender.state == .began || sender.state == .changed {
            senderView.transform = senderView.transform.rotated(by: sender.rotation)
            lastRotation = sender.rotation
            sender.rotation = 0
        }
    }
    
    func tap() {
        guard let jiggler = jiggler else { return }
        jiggler.impactOccurred()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tap()
    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let position = touch.location(in: self)
//        let target = self.center
//        let angle = atan2(target.y-position.y, target.x-position.x)
//        transform = CGAffineTransform(rotationAngle: angle)
//    }
    
}
