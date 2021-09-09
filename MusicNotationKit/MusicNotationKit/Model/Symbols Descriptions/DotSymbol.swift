import Foundation

class DotSymbol: AdjacentLayoutItem, Positionable {
        
    // AdjacentLayoutItem
    var horizontalLayoutWidth: HorizontalLayoutWidthType { .centeredOnGlyph(self.glyph) }
    var hoizontalLayoutDistanceFromParentItem: Double = 0.2
    
    // Positionable
    var position: Vector2D = .zero
    
    var stavePosition = StavePosition.zero
}

// MARK: - Single Glyph Renderable

extension DotSymbol: SingleGlyphRenderable {
    
    var glyph: GlyphType {
        .augmentationDot
    }
}
