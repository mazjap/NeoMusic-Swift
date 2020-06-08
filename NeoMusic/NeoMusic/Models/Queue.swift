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
    
    @discardableResult mutating func pop(amount num: Int) -> [Element] {
        if storage.count >= num {
            var popped = [Element]()
            for i in 0..<num {
                popped.append(storage.remove(at: i))
            }
            return popped
        }
        
        return []
    }
    
    mutating func pushToFront(_ el: Element) {
        storage = [el] + storage
    }
}
