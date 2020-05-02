//
//  Collection+EachWithRemaining.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension Collection {
    func eachWithRemaining() -> EachWithRemainingSequence<Self> {
        return EachWithRemainingSequence(collection: self)
    }
}

struct EachWithRemainingSequence<WrappedCollection: Collection>: Sequence, IteratorProtocol {
    
    typealias Element = (WrappedCollection.Element, WrappedCollection.SubSequence)
    
    private let wrappedCollection: WrappedCollection
    private var currentIndex: WrappedCollection.Index
    
    init(collection: WrappedCollection) {
        self.wrappedCollection = collection
        currentIndex = wrappedCollection.startIndex
    }
    
    mutating func next() -> Element? {
        
        if currentIndex >= wrappedCollection.endIndex {
            return nil
        }
        
        let value = wrappedCollection[currentIndex]
        
        let nextIndex = wrappedCollection.index(after: currentIndex)
        let remianing = wrappedCollection.suffix(from: nextIndex)
        
        currentIndex = nextIndex
        return (value, remianing)
    }
}
