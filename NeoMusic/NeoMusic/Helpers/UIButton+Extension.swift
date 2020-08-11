//
//  EmbeddedButton.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/11/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

extension UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 0, blue: 0, alpha: 0.2) : .clear
        }
    }
    
    func roundCorners() {
        layer.cornerRadius = frame.height / 2
    }
}
