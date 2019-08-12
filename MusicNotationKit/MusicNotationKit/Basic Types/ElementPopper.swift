//
//  ElementPopper.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/08/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

struct ElementPopper<T> {
    var index = 0
    let array: [T]
    
    init(array: [T]) {
        self.array = array
    }
    
    mutating func next() -> T? {
        if index < array.count {
            let item = array[index]
            print("next: item")
            return item
        } else {
            print("next: nil")
            return nil
        }
    }
    
    @discardableResult mutating func popNext() -> T? {
        if index < array.count {
            let item = array[index]
            index += 1
            print("Pop next: item")
            return item
        } else {
            print("Pop next: nil")
            return nil
        }
    }
}
