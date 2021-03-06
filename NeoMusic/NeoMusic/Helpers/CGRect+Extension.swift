//
//  CGRect+Extension.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/31/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import CoreGraphics

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    
    init(center: CGPoint, size: CGSize) {
        let translationY = size.height / 2
        let translationX = size.width / 2
        
        self.init(origin: CGPoint(x: center.x - translationX, y: center.y - translationY), size: size)
    }
    
    init(x: CGFloat, centerY: CGFloat, size: CGSize) {
        self.init(center: CGPoint(x: x + size.width / 2, y: centerY), size: size)
    }
    
    func size(multiplier: CGFloat) -> CGSize {
        return CGSize(width: width * multiplier, height: height * multiplier)
    }
    
    func size(multiplierX: CGFloat, multiplierY: CGFloat) -> CGSize {
        return CGSize(width: width * multiplierX, height: height * multiplierY)
    }
    
    func changeSize(mult: CGFloat = 1, const: CGFloat = 0) -> CGRect {
        let offset = 1 - ((height - const) / height)
        return CGRect(center: center, size: size(multiplier: mult - offset))
    }
    
    func changeSize(_ newSize: CGSize) -> CGRect {
        return CGRect(origin: origin, size: newSize)
    }
}
