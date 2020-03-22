//
//  Sequence+MaxAndMin.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 22/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension Sequence {
    
    func max<T: Comparable>(byKey key: KeyPath<Element, T>) -> Element? {
        return self.max { (first, second) -> Bool in
            return second[keyPath: key] > first[keyPath: key]
        }
    }
    
    func min<T: Comparable>(byKey key: KeyPath<Element, T>) -> Element? {
        return self.min { (first, second) -> Bool in
            return second[keyPath: key] > first[keyPath: key]
        }
    }
}
