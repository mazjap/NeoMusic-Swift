//
//  SettingsController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/2/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class SettingsController {
    static let shared = SettingsController()
    
    private let userDefaults = UserDefaults.standard
    private let appleMusicKey = "com.mazjap.NeoMusic.SettingsController.AppleMusicStatus"
    private let spotifyKey = "com.mazjap.NeoMusic.SettingsController.SpotifyStatus"
    private let angleKey = "com.mazjap.NeoMusic.SettingsController.Angle"
    private let backgroundColorKey = "com.mazjap.NeoMusic.BackgroundColor"
    private let buttonColorKey = "com.mazjap.NeoMusic.ButtonColor"
    
    var imageAngle: CGFloat {
        fetchAngle()
    }
    
    var backgroundGradient: (UIColor, UIColor) {
        fetchBackgroundGradient()
    }
    
    var buttonGradient: (UIColor, UIColor) {
        fetchButtonGradient()
    }
    
    private init() {}
    
    func status(of type: SongType) -> Bool {
        switch type {
        case .appleMusic:
            return fetchAppleMusicStatus()
        case .spotify:
            return fetchSpotifyStatus()
        default:
            NSLog("Selection is invalid or isn't supported")
            return false
        }
    }
    
    private func fetchAppleMusicStatus() -> Bool {
        let bool = userDefaults.bool(forKey: appleMusicKey)
        return bool
    }
    
    private func fetchSpotifyStatus() -> Bool {
        let bool = userDefaults.bool(forKey: spotifyKey)
        return bool
    }
    
    private func fetchAngle() -> CGFloat {
        let val = userDefaults.float(forKey: angleKey)
        return CGFloat(val)
    }
    
    private func fetchBackgroundGradient() -> (UIColor, UIColor) {
        let color1R = CGFloat(userDefaults.double(forKey: backgroundColorKey + "r1"))
        let color1G = CGFloat(userDefaults.double(forKey: backgroundColorKey + "g1"))
        let color1B = CGFloat(userDefaults.double(forKey: backgroundColorKey + "b1"))
        let color1A = CGFloat(userDefaults.double(forKey: backgroundColorKey + "a1"))
        
        let color2R = CGFloat(userDefaults.double(forKey: backgroundColorKey + "r2"))
        let color2G = CGFloat(userDefaults.double(forKey: backgroundColorKey + "g2"))
        let color2B = CGFloat(userDefaults.double(forKey: backgroundColorKey + "b2"))
        let color2A = CGFloat(userDefaults.double(forKey: backgroundColorKey + "a2"))
        
        if (color1R == 0 && color1G == 0 && color1B == 0 && color1A == 0) ||
           (color2R == 0 && color2G == 0 && color2B == 0 && color2A == 0) {
            return (UIColor.topGradientColor, UIColor.bottomGradientColor)
        }
        
        return (UIColor(red: color1R, green: color1G, blue: color1B, alpha: color1A), UIColor(red: color2R, green: color2G, blue: color2B, alpha: color2A))
    }
    
    private func fetchButtonGradient() -> (UIColor, UIColor) {
        let color1R = CGFloat(userDefaults.double(forKey: buttonColorKey + "r1"))
        let color1G = CGFloat(userDefaults.double(forKey: buttonColorKey + "g1"))
        let color1B = CGFloat(userDefaults.double(forKey: buttonColorKey + "b1"))
        let color1A = CGFloat(userDefaults.double(forKey: buttonColorKey + "a1"))
        
        let color2R = CGFloat(userDefaults.double(forKey: buttonColorKey + "r2"))
        let color2G = CGFloat(userDefaults.double(forKey: buttonColorKey + "g2"))
        let color2B = CGFloat(userDefaults.double(forKey: buttonColorKey + "b2"))
        let color2A = CGFloat(userDefaults.double(forKey: buttonColorKey + "a2"))
        
        if (color1R == 0 && color1G == 0 && color1B == 0 && color1A == 0) ||
           (color2R == 0 && color2G == 0 && color2B == 0 && color2A == 0) {
            return (UIColor.bottomGradientColor, UIColor.topGradientColor)
        }
        
        return (UIColor(red: color1R, green: color1G, blue: color1B, alpha: color1A), UIColor(red: color2R, green: color2G, blue: color2B, alpha: color2A))
    }
    
    func setAppleMusicStatus(_ bool: Bool) {
        userDefaults.set(bool, forKey: appleMusicKey)
    }
    
    func setSpotifyStatus(_ bool: Bool) {
        userDefaults.set(bool, forKey: spotifyKey)
    }
    
    func setAngle(_ num: CGFloat) {
        userDefaults.set(Float(num), forKey: angleKey)
    }
    
    func setBackgroundGradient(with colors: (UIColor, UIColor)) {
        let rgba1 = colors.0.rgba
        let rgba2 = colors.1.rgba
        
        userDefaults.set(Double(rgba1.red  ), forKey: backgroundColorKey + "r1")
        userDefaults.set(Double(rgba1.green), forKey: backgroundColorKey + "g1")
        userDefaults.set(Double(rgba1.blue ), forKey: backgroundColorKey + "b1")
        userDefaults.set(Double(rgba1.alpha), forKey: backgroundColorKey + "a1")
        
        userDefaults.set(Double(rgba2.red  ), forKey: backgroundColorKey + "r2")
        userDefaults.set(Double(rgba2.green), forKey: backgroundColorKey + "g2")
        userDefaults.set(Double(rgba2.blue ), forKey: backgroundColorKey + "b2")
        userDefaults.set(Double(rgba2.alpha), forKey: backgroundColorKey + "a2")
    }
    
    func setButtonGradient(with colors: (UIColor, UIColor)) {
        let rgba1 = colors.0.rgba
        let rgba2 = colors.1.rgba
        
        userDefaults.set(Double(rgba1.red  ), forKey: buttonColorKey + "r1")
        userDefaults.set(Double(rgba1.green), forKey: buttonColorKey + "g1")
        userDefaults.set(Double(rgba1.blue ), forKey: buttonColorKey + "b1")
        userDefaults.set(Double(rgba1.alpha), forKey: buttonColorKey + "a1")
        
        userDefaults.set(Double(rgba2.red  ), forKey: buttonColorKey + "r2")
        userDefaults.set(Double(rgba2.green), forKey: buttonColorKey + "g2")
        userDefaults.set(Double(rgba2.blue ), forKey: buttonColorKey + "b2")
        userDefaults.set(Double(rgba2.alpha), forKey: buttonColorKey + "a2")
    }
}
