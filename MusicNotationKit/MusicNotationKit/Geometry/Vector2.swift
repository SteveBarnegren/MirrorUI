//
//  Vector2.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 20/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

typealias Vector2D = Vector2<Double>

struct Vector2<T> {
    
    var firstValue: T
    var secondValue: T
    
    init(_ firstValue: T, _ secondValue: T) {
        self.firstValue = firstValue
        self.secondValue = secondValue
    }
    
    var x: T {
        get { return firstValue }
        set { firstValue = newValue }    }
    
    var y: T {
        get { return secondValue }
        set { secondValue = newValue }
    }
    
    var width: T {
        get { return firstValue }
        set { firstValue = newValue }
    }
    
    var height: T {
        get { return secondValue }
        set { secondValue = newValue }
    }
}

extension Vector2: Equatable where T: Equatable {
    static func == (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
