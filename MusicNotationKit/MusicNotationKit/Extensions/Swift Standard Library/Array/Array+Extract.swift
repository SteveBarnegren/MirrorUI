//
//  Array+Extract.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 22/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func extract<T: Comparable>(minimumBy transform: (Element) -> T) -> Element? {
        var minValue: Element?
        var indexToRemove = 0
        
        for (index, item) in self.enumerated() {
            if let existing = minValue {
                if transform(item) < transform(existing) {
                    minValue = item
                    indexToRemove = index
                }
            } else {
                minValue = item
                indexToRemove = index
            }
        }
        
        if minValue != nil {
            self.remove(at: indexToRemove)
        }
        return minValue
    }
    
    mutating func extract<T: Comparable>(maximumBy transform: (Element) -> T) -> Element? {
        var maxValue: Element?
        var indexToRemove = 0
        
        for (index, item) in self.enumerated() {
            if let existing = maxValue {
                if transform(item) > transform(existing) {
                    maxValue = item
                    indexToRemove = index
                }
            } else {
                maxValue = item
                indexToRemove = index
            }
        }
        
        if maxValue != nil {
            self.remove(at: indexToRemove)
        }
        return maxValue
    }
    
    public mutating func extract(isIncluded: (Element) -> Bool) -> [Element] {
        
        let extractedItems = self.filter { isIncluded($0) }
        self = self.filter { isIncluded($0) == false }
        return extractedItems
    }
    
}
