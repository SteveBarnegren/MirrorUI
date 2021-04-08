//
//  ClefSymbol.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 18/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class ClefSymbol: HorizontalLayoutItem, Positionable {    
    
    enum SymbolType {
        case gClef
        case fClef
    }
    
    var symbolType = SymbolType.gClef
    
    // HorizontalLayoutItem
    var layoutDuration: Time? { nil }
    var leadingChildItems: [AdjacentLayoutItem] { [] }
    var trailingChildItems: [AdjacentLayoutItem] { [] }
    var horizontalLayoutWidth: HorizontalLayoutWidthType {
        .centered(width: 7)
    }
    
    // Positionable
    var position = Vector2D.zero
}

// MARK: - SingleGlyphRenderable

extension ClefSymbol: SingleGlyphRenderable {
    
    var glyph: GlyphType {
        
        switch self.symbolType {
        case .gClef:
            return .gClef
        case .fClef:
            return .fClef
        }
    }
}
