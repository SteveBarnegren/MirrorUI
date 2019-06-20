//
//  Array+Chunked.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 20/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public extension Array {
    
    /// Returns `[[Element]]` where each new inner array begins when the result of
    /// `key(element)` changes
    ///
    ///     [4, 4, 9, 2, 2, 2, 7, 7].chunked(atChangeTo: { $0 })
    ///     // [[4, 4], [9], [2, 2, 2], [7, 7]]
    ///
    /// - Parameter key: Closure to transform `Element` to `Equatable`
    /// - Returns: Array of `[Element]`
    func chunked<T: Equatable>(atChangeTo key: (Element) -> T) -> [[Element]] {
        
        var groups = [[Element]]()
        
        func addGroup(_ groupToAdd: [Element]) {
            if groupToAdd.isEmpty == false {
                groups.append(groupToAdd)
            }
        }
        
        var lastKey: T?
        var currentGroup = [Element]()
        
        for item in self {
            let itemKey = key(item)
            if itemKey == lastKey {
                currentGroup.append(item)
            } else {
                addGroup(currentGroup)
                currentGroup.removeAll()
                currentGroup.append(item)
            }
            lastKey = itemKey
        }
        
        addGroup(currentGroup)
        return groups
    }
}
