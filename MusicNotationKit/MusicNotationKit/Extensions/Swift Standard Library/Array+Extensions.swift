//
//  Array+Extensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 30/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func append(maybe element: Element?) {
        if let element = element {
            append(element)
        }
    }
}

extension Array {
    
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
