//
//  SettingsController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/2/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

class SettingsController {
    private let userDefaults = UserDefaults.standard
    private let appleMusicKey = "com.mazjap.NeoMusic.SettingsController.AppleMusicStatus"
    private let spotifyKey = "com.mazjap.NeoMusic.SettingsController.SpotifyStatus"
    private let angleKey = "com.mazjap.NeoMusic.SettingsController.Angle"
    
    var imageAngle: CGFloat {
        fetchAngle()
    }
    
    static var shared = SettingsController()
    
    private init() {}
    
    func status(of type: SongType) -> Bool {
        switch type {
        case .appleMusic:
            return fetchAppleMusicStatus()
        case .spotify:
            return fetchSpotifyStatus()
        @unknown default:
            fatalError("Selection is invalid or isn't supported. THIS IS A BUG! Please report it if found.")
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
    
    func setAppleMusicStatus(_ bool: Bool) {
        userDefaults.set(bool, forKey: appleMusicKey)
    }
    
    func allowAppleMusic() {
        
    }
    
    func setSpotifyStatus(_ bool: Bool) {
        userDefaults.set(bool, forKey: spotifyKey)
    }
    
    func setAngle(_ num: CGFloat) {
        userDefaults.set(Float(num), forKey: angleKey)
    }
}
