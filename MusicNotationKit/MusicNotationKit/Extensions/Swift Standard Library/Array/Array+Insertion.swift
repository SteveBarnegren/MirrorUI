//
//  Array+Insertion.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

extension Array {
    
    public mutating func prepend(_ item: Element) {
        insert(item, at: 0)
    }
    
    public mutating func prepend<C>(contentsOf newElements: C) where C: Collection, Element == C.Element {
        insert(contentsOf: newElements, at: 0)
    }
    
    public func prepending(_ item: Element) -> [Element] {
        var newArray = self
        newArray.insert(item, at: 0)
        return newArray
    }
    
    public func prepending<C>(contentsOf newElements: C) -> [Element] where C: Collection, Element == C.Element {
        var newArray = self
        newArray.insert(contentsOf: newElements, at: 0)
        return newArray
    }
    
    public func appending(_ item: Element) -> [Element] {
        var newArray = self
        newArray.append(item)
        return newArray
    }
}
