//
//  SongImageView.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/22/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class SongImageView: UIImageView {
    
    var lastRotation: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        addGestureRecognizer(rotateGesture)
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
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let position = touch.location(in: self)
//        let target = self.center
//        let angle = atan2(target.y-position.y, target.x-position.x)
//        transform = CGAffineTransform(rotationAngle: angle)
//    }
}
