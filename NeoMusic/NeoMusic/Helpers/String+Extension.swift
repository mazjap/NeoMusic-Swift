//
//  String+Extension.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 7/7/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

extension String {
    func size(in font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [.font: font])
    }
}
