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
    
    init(song: MPMediaItem) {
        artist = song.artist
        artwork = song.artwork?.image(at: CGSize(width: 500, height: 500))
        title = song.title
        duration = song.playbackDuration
        media = song
    }
}
