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
        .centeredOnGlyph(glyph)
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
