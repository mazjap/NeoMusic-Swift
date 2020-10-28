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
    
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return (h, s, b, a)
    }
    
    var color: Color {
        Color(self)
    }
    
    // Credit to Darel Rex Finley: http://alienryderflex.com/hsp.html
    var perceivedBrightness: CGFloat {
        let vals = rgba
        
        // brightness = sqrt(r^2 * 0.299 + g^2 * 0.587 + b^2 * 0.114)
        return sqrt(vals.red * vals.red * 0.299 + vals.green * vals.green * 0.587 + vals.blue * vals.blue * 0.114)
    }
    
    func average(to color: UIColor, at percent: CGFloat = 0.5) -> UIColor {
        let c1 = hsba
        let c2 = color.hsba
        
        let hue = percent * c1.hue + (1 - percent) * c2.hue
        let saturation = percent * c1.saturation + (1 - percent) * c2.saturation
        let brightness = percent * c1.brightness + (1 - percent) * c2.brightness
        let alpha = percent * c1.alpha + (1 - percent) * c2.alpha
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    var offsetColors: [UIColor] {
        let vals = hsba
        
        return [
            UIColor(hue: vals.hue, saturation: vals.saturation, brightness: max(0, vals.brightness - 0.1), alpha: vals.alpha),
            UIColor(hue: vals.hue, saturation: vals.saturation, brightness: min(1, vals.brightness + 0.1), alpha: vals.alpha)
        ]
    }
}
