//
//  DefaultLabel.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 8/5/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultLabel: UILabel {
    
    var initialFrame: CGRect = .zero
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        
        self.text = text
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func layoutSubviews() {
        
    }
    
    
    private func setup() {
        initialFrame = frame
        textAlignment = .center
    }
}
