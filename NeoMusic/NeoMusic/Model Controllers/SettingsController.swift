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
    private let color1Key = "com.mazjap.NeoMusic.Color.1"
    private let color2Key = "com.mazjap.NeoMusic.Color.2"
    
    var imageAngle: CGFloat {
        fetchAngle()
    }
    
    var gradient: (UIColor, UIColor) {
        fetchGradient()
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
    
    private func fetchGradient() -> (UIColor, UIColor) {
        let color1R = CGFloat(userDefaults.double(forKey: color1Key + "r"))
        let color1G = CGFloat(userDefaults.double(forKey: color1Key + "g"))
        let color1B = CGFloat(userDefaults.double(forKey: color1Key + "b"))
        let color1A = CGFloat(userDefaults.double(forKey: color1Key + "a"))
        
        let color2R = CGFloat(userDefaults.double(forKey: color2Key + "r"))
        let color2G = CGFloat(userDefaults.double(forKey: color2Key + "g"))
        let color2B = CGFloat(userDefaults.double(forKey: color2Key + "b"))
        let color2A = CGFloat(userDefaults.double(forKey: color2Key + "a"))
        
        if (color1R == 0 && color1G == 0 && color1B == 0 && color1A == 0) ||
           (color2R == 0 && color2G == 0 && color2B == 0 && color2A == 0) {
            return (UIColor.topGradientColor, UIColor.bottomGradientColor)
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
    
    func setGradient(with colors: (UIColor, UIColor)) {
        let rgba1 = colors.0.rgba
        let rgba2 = colors.1.rgba
        
        userDefaults.set(Double(rgba1.red), forKey: color1Key + "r")
        userDefaults.set(Double(rgba1.green), forKey: color1Key + "g")
        userDefaults.set(Double(rgba1.blue), forKey: color1Key + "b")
        userDefaults.set(Double(rgba1.alpha), forKey: color1Key + "a")
        
        userDefaults.set(Double(rgba2.red), forKey: color2Key + "r")
        userDefaults.set(Double(rgba2.green), forKey: color2Key + "g")
        userDefaults.set(Double(rgba2.blue), forKey: color2Key + "b")
        userDefaults.set(Double(rgba2.alpha), forKey: color2Key + "a")
    }
}
