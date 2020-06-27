//
//  Song.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/13/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import MediaPlayer

struct Song {
    let artist: String?
    let artwork: UIImage?
    let title: String?
    var lyrics: Lyrics?
    let duration: TimeInterval
    let media: MPMediaItem
    var isExplicit: Bool
    
    init?(song: Any) {
        if let song = song as? MPMediaItem {
            artist = song.artist
            artwork = song.artwork?.image(at: CGSize(width: 500, height: 500))
            title = song.title
            duration = song.playbackDuration
            isExplicit = song.isExplicitItem
            media = song
            lyrics = Lyrics(text: song.lyrics)
        } else if let song = song as? UIView { // TODO: - Change to spotify media item
            return nil
        } else {
            return nil
        }
    }
    
    private init(artist: String?, artwork: UIImage?, title: String?, duration: TimeInterval?, media: MPMediaItem?, lyrics: Lyrics?, isExplicit: Bool?) {
        self.artist = artist
        self.lyrics = lyrics
        
        
        if let artwork = artwork {
            self.artwork = artwork
        } else {
            self.artwork = UIImage(named: "Placeholder")
        }
        
        if let title = title {
            self.title = title
        } else {
            self.title = "No Song Selected"
        }
        
        if let duration = duration {
            self.duration = duration
        } else {
            self.duration = 0.01
        }
        
        if let media = media {
            self.media = media
        } else {
            self.media = MPMediaItem()
        }
        
        if let isExplicit = isExplicit {
            self.isExplicit = isExplicit
        } else {
            self.isExplicit = false
        }
    }
    
    static var noSong = Song(artist: nil, artwork: nil, title: nil, duration: nil, media: nil, lyrics: nil, isExplicit: nil)
}

struct Lyrics {
    let text: String?
    var hasCheckedAPI = false
    
    init(text: String? = nil) {
        self.text = text
    }
    
    init(coder: NSCoder) {
        text = nil // TODO: - decode and get lyrics from lyrics API
        hasCheckedAPI = true
    }
}

enum SongType: String, CaseIterable {
    case downloaded = "Downloaded"
    case favorite = "Favorites"
    case all = "All Music"
}
