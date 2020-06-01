//
//  Cache.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/22/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key : Hashable {
    private let queue = DispatchQueue(label: "com.mazjap.NeoMusic.cachequeue")
    
    var dict = [Key: Value]()
    
    func store(value: Value, for key: Key) {
        queue.async {
            self.dict[key] = value
        }
    }
    
    func fetch(key: Key) -> Value? {
        return queue.sync {
            dict[key]
        }
    }
}
