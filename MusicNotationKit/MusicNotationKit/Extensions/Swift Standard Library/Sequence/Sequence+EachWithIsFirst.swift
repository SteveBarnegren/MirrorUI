//
//  EachWithIsFirstBirdirectionalCollection.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

struct EachWithIsFirstCollection<Base> where Base: Collection {

    let base: Base

    init(_ baseSequence: Base) {
        self.base = baseSequence
    }
}

extension EachWithIsFirstCollection: Collection {
    
    subscript(position: Base.Index) -> (Base.Element, Bool) {
        return (base[position], position == startIndex)
    }
    
    var startIndex: Base.Index {
        return base.startIndex
    }
    
    var endIndex: Base.Index {
        return base.endIndex
    }
    
    func index(after i: Base.Index) -> Base.Index {
        return base.index(after: i)
    }
    
    func index(before i: Base.Index) -> Base.Index {
        return base.index(after: i)
    }
}

extension Collection {
    
    func eachWithIsFirst() -> EachWithIsFirstCollection<Self> {
        return EachWithIsFirstCollection(self)
    }
}
