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
    
    let firstValue: T
    let secondValue: T
    
    init(_ firstValue: T, _ secondValue: T) {
        self.firstValue = firstValue
        self.secondValue = secondValue
    }
    
    var x: T {
        return firstValue
    }
    
    var y: T {
        return secondValue
    }
    
    var width: T {
        return firstValue
    }
    
    var height: T {
        return secondValue
    }
}
