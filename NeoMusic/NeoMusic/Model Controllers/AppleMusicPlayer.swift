//
//  AppleMusicPlayer.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/13/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation
import MediaPlayer

protocol MusicPlayerDelegate: AnyObject {
    func songUpdated(song: Song?)
    func playerStatusUpdated(isPlaying: Bool)
}


class AppleMusicPlayer: NSObject, GenericMusicPlayer {
    weak var delegate: MusicPlayerDelegate?
    var queue = Queue<Song>()
    var lyricsController: LyricsController?
    var totalSkips = 0
    
    let player = MPMusicPlayerController.applicationMusicPlayer
    
    var songMedia: MPMediaItem? {
        self.player.nowPlayingItem
    }
    
    var song: Song? {
        if let media = songMedia {
            return Song(song: media)
        }
        return nil
    }
    
    var isPlaying: Bool {
        self.player.playbackState == .playing
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(songChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: self.player)
        NotificationCenter.default.addObserver(self, selector: #selector(stateChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: self.player)
        
        setSongList()
        player.prepareToPlay()
    }
    
    var currentTime: TimeInterval {
        player.currentPlaybackTime
    }
    
    func setSongList(_ type: SongType = .all, isShuffled: Bool = true) {
        let songs = getSongs(type, isShuffled: isShuffled)
        
        player.setQueue(with: MPMediaItemCollection(items: songs))
    }
    
    internal func getSongs(_ type: SongType, isShuffled: Bool) -> [MPMediaItem] {
        var songs: [MPMediaItem] = []
        let query = MPMediaQuery.songs()
        guard let collections: [MPMediaItemCollection] = query.collections else { return [] }
        
        switch type {
        case .downloaded:
            var temp = [MPMediaItem]()
            
            for collection in collections {
                let items: [MPMediaItem] = collection.items as [MPMediaItem]
                temp += items
            }
            
            for item in temp {
                if !item.isCloudItem {
                    songs.append(item)
                }
            }
            
        case .favorite:
            for collection in collections {
                let items: [MPMediaItem] = collection.items as [MPMediaItem]
                songs += items
            }
            
        default:
            for collection in collections {
                let items: [MPMediaItem] = collection.items as [MPMediaItem]
                songs += items
            }
        }
        
        return isShuffled ? songs.shuffled() : songs
    }
    
    func pause() {
        player.pause()
    }
    
    func play() {
        player.play()
    }
    
    func set(time: TimeInterval) {
        player.currentPlaybackTime = time
    }
    
    func toggle() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func skipBack() {
        totalSkips -= 1
        if player.currentPlaybackTime < 10 {
            player.skipToPreviousItem()
        } else {
            player.currentPlaybackTime = 0
        }
    }
    
    func skipForward() {
        totalSkips += 1
        player.skipToNextItem()
        
        if totalSkips >= 1 {
            skipForward()
        }
    }
    
    @objc
    func songChanged() {
        totalSkips -= 1
        if let delegate = delegate {
            let song: Song?
            if let media = player.nowPlayingItem {
                song = Song(song: media)
            } else {
                song = nil
            }
            
            delegate.songUpdated(song: song)
        }
    }
    
    @objc
    func stateChanged() {
        if let delegate = delegate {
            let bool: Bool
            if player.playbackState == .interrupted || player.playbackState == .playing {
                bool = true
            } else {
                bool = false
            }
            delegate.playerStatusUpdated(isPlaying: bool)
        }
    }
}
