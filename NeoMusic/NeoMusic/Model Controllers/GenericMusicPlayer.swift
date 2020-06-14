//
//  GenericMusicPlayer.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/10/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation


protocol GenericMusicPlayer: AnyObject {
    associatedtype Media
    associatedtype Player
    
    var queue: Queue<Song> { get set }
    var player: Player { get }
    var songMedia: Media? { get }
    var song: Song? { get }
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }
    
    func getSongs(_ type: SongType, isShuffled: Bool) -> [Media]
    func pause()
    func play()
    func set(time: TimeInterval)
    func toggle()
    func skipBack()
    func skipForward()
    
}
