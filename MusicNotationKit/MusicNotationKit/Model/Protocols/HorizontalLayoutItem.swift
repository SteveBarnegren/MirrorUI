import Foundation

enum HorizontalLayoutWidthType {
    /// Centered layout, where 'x anchor' of the item is in the center of it's width
    case centered(width: Double)
    /// Offset layout, where the 'x anchor' of the item is offset. A leading and trailing with to the anchor can be specified.
    case offset(leading: Double, trailing: Double)
    /// Centered on glyph
    case centeredOnGlyph(GlyphType)
    /// Custom
    case custom((GlyphStore) -> (leading: Double, trailing: Double))
}

protocol HorizontalLayoutItemBase: AnyObject, HorizontallyPositionable {
    var horizontalLayoutWidth: HorizontalLayoutWidthType { get }
}

extension HorizontalLayoutItemBase {
    func leadingWidth(glyphs: GlyphStore) -> Double {
        switch horizontalLayoutWidth {
            case .centered(let width):
                return width/2
            case .offset(let leading, _):
                return leading
            case .centeredOnGlyph(let glyphType):
                return glyphs.glyph(forType: glyphType).width/2
            case .custom(let custom):
                return custom(glyphs).leading
        }
    }
    
    func trailingWidth(glyphs: GlyphStore) -> Double {
        switch horizontalLayoutWidth {
            case .centered(let width):
                return width/2
            case .offset(_, let trailing):
                return trailing
            case .centeredOnGlyph(let glyphType):
                return glyphs.glyph(forType: glyphType).width/2
            case .custom(let custom):
                return custom(glyphs).trailing
        }
    }
}
 
protocol HorizontalLayoutItem: HorizontalLayoutItemBase {
    var layoutDuration: Time? { get }
    var leadingChildItems: [AdjacentLayoutItem] { get }
    var trailingChildItems: [AdjacentLayoutItem] { get }
}

protocol AdjacentLayoutItem: HorizontalLayoutItemBase {
    var hoizontalLayoutDistanceFromParentItem: Double { get }
}
