//
//  Sequence+Sum.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 27/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

extension Sequence {
    
    public func sum<T: Numeric>(of transform: (Element) -> T) -> T {
        return self.reduce(0, { $0 + transform($1) })
    }
    
    public func sum<T: Numeric>(_ keyPath: KeyPath<Element, T>) -> T {
        return self.reduce(0, { $0 + $1[keyPath: keyPath] })
    }
}
