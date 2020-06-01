//
//  LyricsController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/22/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation
import MediaPlayer

class LyricsController {
    let baseURL = URL(string: "https://api.musixmatch.com/ws/1.1/")!
    let cache = Cache<String, String>()
    
    init(songs: [MPMediaItem]) {
        for media in songs {
            if let title = media.title, let lyrics = media.lyrics {
                cache.store(value: lyrics, for: title)
            }
        }
    }
    
    func getLyrics(for song: Song, completion: @escaping (Result<String, Error>) -> Void) {
        guard let title = song.title else {
            completion(.failure(NSError()))
            return
        }
        
        if let lyrics = cache.fetch(key: title) {
            completion(.success(lyrics))
            return
        }
        
        let url = baseURL.appendingPathComponent("track.search")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let artist = song.artist, let title = song.title {
            components.queryItems = [URLQueryItem(name: "q_artist", value: artist), URLQueryItem(name: "q_track", value: title)]
        }
        
        URLSession.shared.dataTask(with: components.url!) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            
            if let lyrics = String(data: data, encoding: .utf8) {
                self.cache.store(value: title, for: lyrics)
                completion(.success(lyrics))
            } else {
                
            }
        }.resume()
    }
}
