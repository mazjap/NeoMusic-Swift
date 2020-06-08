//
//  FloatingPoint+Extension.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/7/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
