//
//  Queue.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/17/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

struct Queue<Element> {
    var storage = [Element]()
    
    mutating func push(_ el: Element) {
        storage.append(el)
    }
    
    mutating func push(_ els: [Element]) {
        storage.append(contentsOf: els)
    }
    
    @discardableResult mutating func pop() -> Element? {
        if storage.count >= 1 {
            return storage.removeFirst()
        }
        
        return nil
    }
    
    mutating func pushToFront(_ el: Element) {
        storage = [el] + storage
    }
}
