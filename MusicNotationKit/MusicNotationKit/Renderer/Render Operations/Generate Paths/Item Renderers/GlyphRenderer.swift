//
//  GlyphRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 07/04/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

/// A type that is renderable with a single glyph
protocol SingleGlyphRenderable {
    var glyph: GlyphType { get }
    var position: Vector2D { get }
}

extension SingleGlyphRenderable where Self: HorizontallyPositionable {
    var position: Vector2D {
        return Vector2D(xPosition, 0)
    }
}

class GlyphRenderer {
    
    private let glyphStore: GlyphStore
    
    init(glyphStore: GlyphStore) {
        self.glyphStore = glyphStore
    }
    
    func paths(forRenderable renderable: SingleGlyphRenderable) -> [Path] {

        let glyph = glyphStore.glyph(forType: renderable.glyph)
        var path = glyph.path.translated(x: renderable.position.x - glyph.width/2,
                                         y: renderable.position.y)
        path.drawStyle = .fill
        return [path]
    }

    func paths(forGlyph glyphType: GlyphType, position: Vector2D) -> [Path] {

        let glyph = glyphStore.glyph(forType: glyphType)
        var path = glyph.path.translated(x: position.x, y: position.y)
        path.drawStyle = .fill
        return [path]
    }
}
