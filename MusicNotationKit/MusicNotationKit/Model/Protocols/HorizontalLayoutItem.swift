//
//  HorizontalLayoutItem.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

enum HorizontalLayoutWidthType {
    /// Centered layout, where 'x anchor' of the item is in the center of it's width
    case centered(width: Double)
    /// Offset layout, where the 'x anchor' of the item is offset. A leading and trailing with to the anchor can be specified.
    case offset(leading: Double, trailing: Double)
    /// Centered on glyph
    case centeredOnGlyph(GlyphType)
}

protocol HorizontalLayoutItemBase: class, HorizontallyPositionable {
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
