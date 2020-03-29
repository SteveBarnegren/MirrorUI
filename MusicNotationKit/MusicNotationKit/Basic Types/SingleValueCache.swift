//
//  SingleValueCache.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

public class SingleValueCache<T> {
    
    private let getValue: () -> T
    private var cachedValue: T?
        
    public init(calculate: @escaping () -> (T)) {
        self.getValue = calculate
    }
    
    public var value: T {
        if let existingValue = cachedValue {
            return existingValue
        } else {
            let value = getValue()
            cachedValue = value
            return value
        }
    }
    
    func invalidate() {
        cachedValue = nil
    }
}
