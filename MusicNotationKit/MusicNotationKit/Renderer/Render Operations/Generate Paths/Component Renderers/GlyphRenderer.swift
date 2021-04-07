//
//  GlyphRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 07/04/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

/// A type that is renderable with a single glyph
protocol SingleGlyphRenderable: Positionable {
//    var glyph: Glyph { get }
    
    func glyph(fromStore store: GlyphStore) -> Glyph
}

class GlyphRenderer {
    
    private let glyphStore: GlyphStore
    
    init(glyphStore: GlyphStore) {
        self.glyphStore = glyphStore
    }
    
    func paths(forRenderable renderable: SingleGlyphRenderable) -> [Path] {
        
        let glyph = renderable.glyph(fromStore: glyphStore)
        var path = glyph.path.translated(x: renderable.xPosition - glyph.width/2,
                                         y: renderable.yPosition)
        path.drawStyle = .fill
        return [path]
    }
}
