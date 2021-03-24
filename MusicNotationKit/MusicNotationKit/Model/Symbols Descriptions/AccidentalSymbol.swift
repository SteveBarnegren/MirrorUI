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
    var horizontalLayoutWidth = HorizontalLayoutWidthType.centered(width: 1.0)
    var hoizontalLayoutDistanceFromParentItem: Double = 0.2
    
    // Positionable
    var position = Vector2D.zero
    
    let type: SymbolType
    var stavePosition = StavePosition.zero
    
    init(type: SymbolType, stavePosition: StavePosition) {
        self.type = type
        self.stavePosition = stavePosition
    }
}
