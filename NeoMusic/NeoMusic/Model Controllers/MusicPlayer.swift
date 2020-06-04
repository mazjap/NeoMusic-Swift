//
//  MusicPlayer.swift
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


class MusicPlayer: NSObject {
    weak var delegate: MusicPlayerDelegate?
    var queue = Queue<Song>()
    var lyricsController: LyricsController?
    
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
        let songsArr = getSongs()
        lyricsController = LyricsController(songs: songsArr)
        lyricsController?.getLyrics(for: Song(song: songsArr.first ?? MPMediaItem()), completion: { result in
            switch result {
            case .success(let lyric):
                print(lyric)
            case .failure(_):
                print("error")
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(songChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: self.player)
        NotificationCenter.default.addObserver(self, selector: #selector(stateChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: self.player)
        
        player.setQueue(with: MPMediaItemCollection(items: getSongs()))
        player.prepareToPlay()
    }
    
    var currentTime: TimeInterval {
        player.currentPlaybackTime
    }
    
    func getSongs() -> [MPMediaItem] {
        let albumsQuery = MPMediaQuery.albums()
        guard let albumItems: [MPMediaItemCollection] = albumsQuery.collections else { return [] }
        var songs: [MPMediaItem] = []

        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            songs += albumItems
        }
        return songs.shuffled()
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
        if player.currentPlaybackTime < 10 {
            player.skipToPreviousItem()
        } else {
            player.currentPlaybackTime = 0
        }
    }
    
    func skipForward() {
        player.skipToNextItem()
    }
    
    @objc
    func songChanged() {
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
    
//    @objc
//    func updateTime() {
//        if let delegate = delegate {
//            delegate.currentTimeUpdated(time: player.currentPlaybackTime.stringTime)
//        }
//    }
    
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
