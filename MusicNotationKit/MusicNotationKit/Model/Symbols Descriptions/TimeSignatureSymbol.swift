//
//  TimeSignatureSymbol.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 09/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class TimeSignatureSymbol: HorizontalLayoutItem, Positionable {

    var topNumber = 0
    var bottomNumber = 0

    init(timeSignature: TimeSignature) {
        self.topNumber = timeSignature.value
        self.bottomNumber = timeSignature.division
    }

    // HorizontalLayoutItem
    var layoutDuration: Time? { nil }
    var leadingChildItems: [AdjacentLayoutItem] { [] }
    var trailingChildItems: [AdjacentLayoutItem] { [] }
    var horizontalLayoutWidth: HorizontalLayoutWidthType {
        let top = topNumber
        let bottom = bottomNumber
        return .custom { glyphs in
            let layout = TimeSignatureGlyphLayout(top: top,
                                                  bottom: bottom,
                                                  glyphStore: glyphs)
            let width = layout.width
            return (width/2, width/2)
        }
    }

    // Positionable
    var position = Vector2D.zero
}

class TimeSignatureGlyphLayout {

    private let topGlyphs: [Glyph]
    private let bottomGlyphs: [Glyph]

    var topWidth: Double {
        return topGlyphs.sum(\.width)
    }

    var bottomWidth: Double {
        return bottomGlyphs.sum(\.width)
    }

    var width: Double {
        return max(topWidth, bottomWidth)
    }

    var topHeight: Double {
        return topGlyphs.map { $0.height }.max() ?? 0
    }

    var bottomHeight: Double {
        return bottomGlyphs.map { $0.height }.max() ?? 0
    }

    init(top: Int, bottom: Int, glyphStore: GlyphStore) {
        topGlyphs = Self.glyphs(forNumber: top).map(glyphStore.glyph)
        bottomGlyphs = Self.glyphs(forNumber: bottom).map(glyphStore.glyph)
    }

    func visitGlyphsWithPosition(visit: (Glyph, Vector2D) -> Void) {
        do {
            var xPos = -topWidth/2
            let yPos = topHeight/2
            for glyph in topGlyphs {
                visit(glyph, Vector2D(xPos, yPos))
                xPos += glyph.width
            }
        }
        do {
            var xPos = -bottomWidth/2
            let yPos = -bottomHeight/2
            for glyph in bottomGlyphs {
                visit(glyph, Vector2D(xPos, yPos))
                xPos += glyph.width
            }
        }
    }

    // MARK: - Create Glyphs

    private static func glyphs(forNumber number: Int) -> [GlyphType] {
        let digits = String(number).compactMap { $0.wholeNumberValue }
        return digits.map(glyph(forDigit:))
    }

    private static func glyph(forDigit digit: Int) -> GlyphType {
        switch digit {
            case 0: return .timeSig0
            case 1: return .timeSig1
            case 2: return .timeSig2
            case 3: return .timeSig3
            case 4: return .timeSig4
            case 5: return .timeSig5
            case 6: return .timeSig6
            case 7: return .timeSig7
            case 8: return .timeSig8
            case 9: return .timeSig9
            default:
                fatalError("Unknown digit: \(digit)")
        }
    }
}
