//
//  Lazy.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

public class Lazy<T> {
    
    private indirect enum State<T> {
        case closure( () -> (T) )
        case value(T)
    }
    
    private var state: State<T>
    
    public init(calculate: @escaping () -> (T)) {
        self.state = .closure(calculate)
    }
    
    public var value: T {
        switch state {
        case .value(let value):
            return value
        case .closure(let closure):
            let result = closure()
            self.state = .value(result)
            return result
        }
    }
}
