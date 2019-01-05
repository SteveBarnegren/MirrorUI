//
//  Composition.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public class Composition {
    
    var bars = [Bar]()
    
    var duration: Time {
        return bars.reduce(Time.zero) { $0 + $1.duration }
    }
    
    public init() {}
    
    public func add(bar: Bar) {
        self.bars.append(bar)
    }
}
