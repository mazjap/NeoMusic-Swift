//
//  SpotifyMusicPlayer.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/10/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

class SpotifyMusicPlayer: MusicPlayer {
    let player = 1
    var lyricsController: LyricsController?
    var currentSong: Song {
        .noSong
    }
    
    var isPlaying: Bool {
        false
    }
    
    var currentPlaybackTime: TimeInterval {
        0.00
    }
    
    var totalPlaybackTime: TimeInterval {
        0.00
    }
    
    weak var delegate: MusicPlayerDelegate?
    
    init(lyricsController: LyricsController) {
        self.lyricsController = lyricsController
    }
    
    func prepareToPlay() {
        
    }
    
    func pause() {
        
    }
    
    func play() {
        
    }
    
    func setQueue(songs: [Song]) {
        
    }
    
    func set(time: TimeInterval) {
        
    }
    
    func toggle() {
        isPlaying ? pause() : play()
    }
    
    func skipToPreviousItem() {
        
    }
    
    func skipToNextItem() {
        
    }
    
    func songChanged() {}
    func playerStateChanged() {}
}
