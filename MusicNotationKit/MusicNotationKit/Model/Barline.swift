import Foundation

class Barline: HorizontalLayoutItem {
    
    // HorizontalLayoutItem
    let layoutDuration: Time? = nil
    let leadingChildItems = [AdjacentLayoutItem]()
    let trailingChildItems = [AdjacentLayoutItem]()
    lazy var horizontalLayoutWidth = HorizontalLayoutWidthType.centeredOnGlyph(glyph)
    
    // HorizontallyPositionable
    var xPosition = Double(0)
}

// MARK: - SingleGlyphRenderable

extension Barline: SingleGlyphRenderable {

    var glyph: GlyphType {
        return .barlineSingle
    }
}
