//
//  SongImageView.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/22/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class SongImageView: DefaultView {
    var jiggler: UIImpactFeedbackGenerator?
    var lastRotation: CGFloat = 0
    var imageView = UIImageView()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func updateViews() {
        super.updateViews()
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        addGestureRecognizer(rotateGesture)
        
//        let rotationGesture = UITapGestureRecognizer(target: self, action: #selector(handlingRotation(sender:)))
//        rotationGesture.numberOfTapsRequired = 1
//        addGestureRecognizer(rotationGesture)
        
        insertSubview(imageView, aboveSubview: self)
        imageView.frame = secondaryFrame
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = frame.height / 2 - frame.height * 0.025
        
    }
    
    func tap() {
        guard let jiggler = jiggler else { return }
        jiggler.impactOccurred()
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }

    @objc
    private func handleRotation(sender: UIRotationGestureRecognizer) {
        guard let senderView = sender.view else { return }
        if sender.state == .began || sender.state == .changed {
            senderView.transform = senderView.transform.rotated(by: sender.rotation)
            lastRotation = sender.rotation
            sender.rotation = 0
        } else if sender.state == .ended {
            tap()
        }
    }

//    @objc
//    private func handlingRotation(sender: UITapGestureRecognizer) {
//        guard let senderView = sender.view as? SongImageView else { return }
//        if sender.state == .began || sender.state == .changed {
//            let p2 = senderView.center
//            let p1 = CGPoint(x: p2.x, y: senderView.frame.height / 2)
//            let p3 = sender.location(in: senderView)
//            let degrees = CGFloat(atan2(p3.y - p1.y, p3.x - p1.x) - atan2(p2.y - p1.y, p2.x - p1.x))
//
//            senderView.transform = senderView.transform.rotated(by: degrees)
//            lastRotation = degrees
//        }
//    }
}
