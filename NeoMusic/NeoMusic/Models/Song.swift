//
//  Song.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/13/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import MediaPlayer
import WidgetKit

struct Song: TimelineEntry, Identifiable, Equatable {
    var date: Date {
        Date()
    }
    
    let artist: String
    let artwork: UIImage
    let title: String
    var lyrics: Lyrics?
    let duration: TimeInterval
    let media: MPMediaItem?
    var isFavorite: Bool?
    var isExplicit: Bool
    
    var id: String {
        "\(artist) - \(title)\(isExplicit ? " - Explicit" : "")"
    }
    
    init(song: Any?) {
        let defaultImage = UIImage.placeholder
        let defaultArtist = "Artist"
        let defaultTitle = "No Song Selected"
        
        if let song = song as? MPMediaItem {
            artist = song.artist ?? defaultArtist
            artwork = song.artwork?.image(at: CGSize(width: 500, height: 500)) ?? defaultImage
            title = song.title ?? defaultTitle
            duration = song.playbackDuration
            isExplicit = song.isExplicitItem
            media = song
            lyrics = Lyrics(text: song.lyrics)
        } else { // TODO: - Check for spotify media item
            artist = defaultArtist
            artwork = defaultImage
            title = defaultTitle
            duration = 0
            media = nil
            isExplicit = false
        }
    }
    
    static var noSong = Song(song: nil)
}

struct Lyrics: Equatable {
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

enum SongCategory: String, CaseIterable {
    case downloaded = "Downloaded"
    case favorite = "Favorites"
    case all = "All Music"
}

enum SongType: String, CaseIterable {
    case spotify = "logo-spotify"
    case appleMusic = "logo-apple-music"
    
    func name() -> String {
        if self == .appleMusic {
            return "Apple Music"
        } else if self == .spotify {
            return "Spotify"
        }
        
        return "Unknown"
    }
}
