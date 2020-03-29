//
//  Point.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

struct Point {
    var x: Double
    var y: Double
    
    static let zero = Point(0, 0)
    
    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    
    // Adding / Subtracting
    
    func adding(x: Double, y: Double) -> Point {
        return Point(self.x + x, self.y + y)
    }
    
    func adding(x: Double) -> Point {
        return Point(self.x + x, self.y)
    }
    
    func adding(y: Double) -> Point {
        return Point(self.x, self.y + y)
    }
    
    func subtracting(x: Double, y: Double) -> Point {
        return Point(self.x - x, self.y - y)
    }
    
    func subtracting(x: Double) -> Point {
        return Point(self.x - x, self.y)
    }
    
    func subtracting(y: Double) -> Point {
        return Point(self.x, self.y - y)
    }
}
