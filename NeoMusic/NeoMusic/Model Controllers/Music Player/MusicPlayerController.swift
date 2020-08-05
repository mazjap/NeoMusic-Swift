//
//  MusicPlayerController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 7/21/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicPlayerController {
    var queue = Queue<Song>()
    var lyricsController: LyricsController
    
    var allowsAppleMusic = false
    var allowsSpotify = false
    
    var appleMusicPlayer: MusicPlayer?
    var spotifyMusicPlayer: MusicPlayer?
    
    var player: MusicPlayer? {
        if allowsSpotify && allowsAppleMusic {
            if appleMusicPlayer?.isPlaying ?? false {
                return appleMusicPlayer
            } else if spotifyMusicPlayer?.isPlaying ?? false {
                return spotifyMusicPlayer
            } else {
                return appleMusicPlayer
            }
        } else if allowsAppleMusic {
            return appleMusicPlayer
        } else if allowsSpotify {
            return spotifyMusicPlayer
        }
        
        return nil
    }
    
    var playerList: [MusicPlayer?] {
        [appleMusicPlayer, spotifyMusicPlayer]
    }
    
    var song: Song {
        if allowsAppleMusic, let amp = appleMusicPlayer, amp.isPlaying {
            return amp.currentSong
        } else if allowsSpotify, let smp = spotifyMusicPlayer, smp.isPlaying {
            return smp.currentSong
        }
        
        return .noSong
    }
    
    var isPlaying: Bool {
        if (allowsAppleMusic && appleMusicPlayer?.isPlaying ?? false) || (allowsSpotify && spotifyMusicPlayer?.isPlaying ?? false) {
            return true
        }
        
        return false
    }
    
    var currentPlaybackTime: TimeInterval {
        player?.currentPlaybackTime ?? 0.00
    }
    
    var totalPlaybackTime: TimeInterval {
        player?.totalPlaybackTime ?? 0.00
    }
    
    init() {
        self.lyricsController = LyricsController()
        setSongList()
        player?.prepareToPlay()
    }
    
    var currentTime: TimeInterval {
        player?.currentPlaybackTime ?? 0.00
    }
    
    func setSongList(_ type: SongCategory = .all, isShuffled: Bool = true) {
        let songs = getSongs(type, isShuffled: isShuffled)
        player?.setQueue(songs: songs)
        player?.prepareToPlay()
    }
    
    internal func getSongs(_ type: SongCategory, isShuffled: Bool) -> [Song] {
        var songs: [Song] = []
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
                    let song = Song(song: item)
                    if song != Song.noSong {
                        songs.append(song)
                    }
                }
            }
            
        case .favorite:
            for collection in collections {
                _ = (collection.items as [MPMediaItem]).map {
                    let song = Song(song: $0)
                    if song.isFavorite ?? false {
                        songs.append(song)
                    }
                }
            }
            
        default:
            for collection in collections {
                _ = (collection.items as [MPMediaItem]).map { songs.append(Song(song: $0)) }
            }
        }
        
        return isShuffled ? songs.shuffled() : songs
    }
    
    func pause() {
        player?.pause()
    }
    
    func play() {
        player?.play()
    }
    
    func set(time: TimeInterval) {
        player?.set(time: time)
    }
    
    func toggle() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func skipBack() {
        guard let player = player else { return }
        if player.currentPlaybackTime < 10 {
            player.skipToPreviousItem()
        } else {
            player.set(time: 0)
        }
    }
    
    func skipForward() {
        DispatchQueue.main.async {
            self.player?.skipToNextItem()
        }
    }
    
    func setupService(_ service: SongType) {
        let newPlayer: MusicPlayer
        
        switch service {
        case .spotify:
            newPlayer = SpotifyMusicPlayer(lyricsController: lyricsController)
            spotifyMusicPlayer = newPlayer
            allowsSpotify = true
        case .appleMusic:
            newPlayer = AppleMusicPlayer(lyricsController: lyricsController)
            appleMusicPlayer = newPlayer
            allowsAppleMusic = true
        default:
            NSLog("Service \(service.name()) is invalid or isn't supported")
        }
        
        newPlayer.prepareToPlay()
    }
}
