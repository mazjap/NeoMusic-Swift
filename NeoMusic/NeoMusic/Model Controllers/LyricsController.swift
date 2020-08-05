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
    
    func getLyrics(for song: Song, completion: @escaping (Result<String, Error>) -> Void) {
        guard song.title != Song.noSong.title else {
            completion(.failure(NSError()))
            return
        }
        
        if let lyrics = cache.fetch(key: song.title) {
            completion(.success(lyrics))
            return
        }
        
        let url = baseURL.appendingPathComponent("track.search")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if song.artist != Song.noSong.artist && song.title != Song.noSong.title {
            components.queryItems = [URLQueryItem(name: "q_artist", value: song.artist), URLQueryItem(name: "q_track", value: song.title)]
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
                self.cache.store(value: song.title, for: lyrics)
                completion(.success(lyrics))
            } else {
                
            }
        }.resume()
    }
}
