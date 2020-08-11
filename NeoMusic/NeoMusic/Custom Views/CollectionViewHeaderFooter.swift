//
//  CollectionViewHeaderFooter.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 8/10/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class CollectionViewHeaderFooter: UIView {
    static let reuseIdentifier = "CollectionViewHeaderFooterClass"
    
    init(width: CGFloat = 20, height: CGFloat = 64) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 64)))
    }
}
