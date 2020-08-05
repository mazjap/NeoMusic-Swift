//
//  AppleMusicPlayer.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 7/21/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation
import MediaPlayer

class AppleMusicPlayer: MusicPlayer {
    let player: MPMusicPlayerController
    var lyricsController: LyricsController?
    var currentSong: Song {
        return Song(song: player.nowPlayingItem)
    }
    
    var isPlaying: Bool {
        player.playbackState == .playing
    }
    
    var currentPlaybackTime: TimeInterval {
        player.currentPlaybackTime
    }
    
    var totalPlaybackTime: TimeInterval {
        return currentSong.duration
    }
    
    let library = MPMediaLibrary()
    
    weak var delegate: MusicPlayerDelegate?
    
    init(lyricsController: LyricsController? = nil, usesApplicationPlayer: Bool = false) {
        player = usesApplicationPlayer ? MPMusicPlayerController.applicationMusicPlayer : MPMusicPlayerController.systemMusicPlayer
        
        NotificationCenter.default.addObserver(self, selector: #selector(songChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(playerStateChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: player)
        
        player.beginGeneratingPlaybackNotifications()
        
        self.lyricsController = lyricsController
        
        prepareToPlay()
    }
    
    deinit {
        player.endGeneratingPlaybackNotifications()
    }
    
    func prepareToPlay() {
        player.prepareToPlay()
    }
    
    func pause() {
        player.pause()
    }
    
    func play() {
        player.play()
        
        if currentSong == .noSong {
            DispatchQueue.global(qos: .userInitiated).async {
                self.setQueue(songs: self.getSongs().filter({ Song(song: $0) != .noSong }).map({ Song(song: $0) }))
            }
        }
    }
    
    func getSongs() -> [MPMediaItem] {
        var songs = [MPMediaItem]()
        
        if let collections = MPMediaQuery.songs().collections {
            for collection in collections {
                songs.append(contentsOf: collection.items)
            }
        }
        
        return songs
    }
    
    func setQueue(songs: [Song]) {
        player.setQueue(with: MPMediaItemCollection(items: songs.filter({ $0.media != nil }).map({ $0.media! })))
        player.prepareToPlay()
    }
    
    func set(time: TimeInterval) {
        player.currentPlaybackTime = time
    }
    
    func toggle() {
        isPlaying ? pause() : play()
    }
    
    func skipToPreviousItem() {
        self.player.skipToPreviousItem()
    }
    
    func skipToNextItem() {
        self.player.skipToNextItem()
    }
    
    @objc
    func songChanged() {
        delegate?.songChanged(song: currentSong)
    }
    
    @objc
    func playerStateChanged() {
        delegate?.playerStateChanged(isPlaying: isPlaying)
    }
}
