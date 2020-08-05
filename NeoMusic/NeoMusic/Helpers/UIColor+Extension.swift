//
//  Colors.swift
//  SwiftUI-MusicPlayer
//
//  Created by Jordan Christensen on 4/3/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
    static let topGradientColor = UIColor(named: "BackgroundGradientTop")!
    static let bottomGradientColor = UIColor(named: "BackgroundGradientBottom")!
    static let buttonColor = UIColor(named: "Button")!
    static let buttonBackgroundColor = UIColor(named: "ButtonBackground")!
    static let playButtonLightColor = UIColor(named: "PlayLight")!
    static let playButtonDarkColor = UIColor(named: "PlayDark")!
    static let pauseButtonLightColor = UIColor(named: "PauseLight")!
    static let pauseButtonDarkColor = UIColor(named: "PauseDark")!
    static let trackYellowColor = UIColor(named: "TrackYellow")!
    static let spotify = UIColor(named: "Spotify")!
    static let appleMusic = UIColor.white
    
    var textColor: UIColor {
        if rgba.red + rgba.green + rgba.blue > 555 { // 255 * 3 (r, g, b) - 210, 70 each (if it's too bright, make text black)
            return UIColor.black
        }
        
        return UIColor.white
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red * 255, green * 255, blue * 255, alpha * 255)
    }
    
    var color: Color {
        Color(self)
    }
}
