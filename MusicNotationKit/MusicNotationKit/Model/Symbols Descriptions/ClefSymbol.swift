//
//  ClefSymbol.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 18/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class ClefSymbol: HorizontalLayoutItem {
    
    enum SymbolType {
        case gClef
        case fClef
    }
    
    var symbolType = SymbolType.gClef
    var staveOffset = Double(0)
    
    // HorizontalLayoutItem
    var layoutDuration: Time? { nil }
    var leadingLayoutItems: [AdjacentLayoutItem] { [] }
    var trailingLayoutItems: [AdjacentLayoutItem] { [] }
    var horizontalLayoutWidth: HorizontalLayoutWidthType {
        .centered(width: 7)
    }
    var xPosition: Double = 0
}
