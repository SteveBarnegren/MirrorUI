//
//  FlatSymbol.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class FlatSymbol: AdjacentLayoutItem, Positionable {
    
    // AdjacentLayoutItem
    let horizontalLayoutWidth: Double = 1
    var hoizontalLayoutDistanceFromParentItem: Double = 0.1
    
    // Positionable
    var position = Point.zero
    
    let stavePosition: Int
    let staveOffset: Double
    
    init(stavePosition: Int, staveOffset: Double) {
        self.stavePosition = stavePosition
        self.staveOffset = staveOffset
    }
}
