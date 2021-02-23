//
//  MirrorUI+Float.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 11/01/2021.
//

import Foundation

extension MirrorUI where T: FloatingPoint {
    
    public var range: ClosedRange<T>? {
        set { properties.set(range: newValue) }
        get { properties.getRange() }
    }
    
    public init(wrappedValue: T, range: ClosedRange<T>) {
        self.init(wrappedValue: wrappedValue)
        self.range = range
    }
}
