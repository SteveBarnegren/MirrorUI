//
//  AccidentalSymbol.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class AccidentalSymbol: AdjacentLayoutItem, Positionable {
    
    enum SymbolType {
        case sharp
        case flat
        case natural
    }
    
    // AdjacentLayoutItem
    let horizontalLayoutWidth: Double = 1
    var hoizontalLayoutDistanceFromParentItem: Double = 0.1
    
    // Positionable
    var position = Point.zero
    
    let type: SymbolType
    let stavePosition: Int
    
    init(type: SymbolType, stavePosition: Int) {
        self.type = type
        self.stavePosition = stavePosition
    }
}
