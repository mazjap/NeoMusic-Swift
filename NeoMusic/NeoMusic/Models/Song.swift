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
    let duration: TimeInterval
    let media: MPMediaItem
    var lyrics: Lyrics
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
