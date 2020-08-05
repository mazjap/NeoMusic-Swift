//
//  GenericMusicPlayer.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 7/21/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

protocol MusicPlayerDelegate: AnyObject {
    func songChanged(song: Song)
    func playerStateChanged(isPlaying: Bool)
}

protocol MusicPlayer: AnyObject {
    var currentSong: Song { get }
    var isPlaying: Bool { get }
    var currentPlaybackTime: TimeInterval { get }
    var totalPlaybackTime: TimeInterval { get }
    var lyricsController: LyricsController? { get set }
    var delegate: MusicPlayerDelegate? { get set }
    
    func prepareToPlay()
    func pause()
    func play()
    func setQueue(songs: [Song])
    func set(time: TimeInterval)
    func toggle()
    func skipToPreviousItem()
    func skipToNextItem()
    
    func songChanged()
    func playerStateChanged()
}
