//
//  Rect.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

struct Rect {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
    
    var maxY: Double {
        y + height
    }
    
    var minY: Double {
        return y
    }
    
    var bottomLeft: Point {
        return Point(x, y)
    }
    
    var bottomRight: Point {
        return Point(x + width, y)
    }
    
    var topLeft: Point {
        return Point(x, y + height)
    }
    
    var topRight: Point {
        return Point(x + width, y + height)
    }
    
    var center: Point {
        return Point(x + width/2, y + height/2)
    }
    
    func translated(x: Double, y: Double) -> Rect {
        return Rect(x: self.x + x, y: self.y + y, width: width, height: height)
    }
}
