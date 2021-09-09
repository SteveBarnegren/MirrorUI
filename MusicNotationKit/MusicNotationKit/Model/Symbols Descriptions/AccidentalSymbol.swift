import Foundation

class AccidentalSymbol: AdjacentLayoutItem, Positionable {
    
    enum SymbolType {
        case sharp
        case flat
        case natural
    }
    
    // AdjacentLayoutItem
    var horizontalLayoutWidth: HorizontalLayoutWidthType { .centeredOnGlyph(glyph) }
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

// MARK: - Single Glyph Renderable

extension AccidentalSymbol: SingleGlyphRenderable {
    
    var glyph: GlyphType {
        switch self.type {
        case .sharp: return .accidentalSharp
        case .flat: return .accidentalFlat
        case .natural: return .accidentalNatural
        }
    }
}
