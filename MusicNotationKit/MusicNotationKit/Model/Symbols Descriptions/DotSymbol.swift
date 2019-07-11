//
//  DotSymbol.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class DotSymbol: AdjacentLayoutItem, Positionable {
    
    // AdjacentLayoutItem
    var horizontalLayoutWidth: Double = 0.5
    var hoizontalLayoutDistanceFromParentItem: Double = 0.1
    
    // Positionable
    var position: Point = .zero
    var pitch = Pitch.c4
}
