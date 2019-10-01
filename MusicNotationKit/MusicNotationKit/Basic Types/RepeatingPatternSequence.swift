//
//  RepeatingPatternSequence.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

struct RepeatingPatternSequence<T>: Sequence, IteratorProtocol {
    
    private var index: Int = -1
    private let pattern: [T]
    
    init(pattern: [T]) {
        self.pattern = pattern
    }
    
    mutating func next() -> T? {
        
        if pattern.isEmpty {
            return nil
        }
        
        index += 1
        if index >= pattern.count {
            index = 0
        }
        
        return pattern[index]
    }
}
