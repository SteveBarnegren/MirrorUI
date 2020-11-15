//
//  SharpRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class SharpRenderer {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func paths(forSharpAtX x: Double, y: Double) -> [Path] {
        
        let glyph = glyphs.accidentalSharp
        var path = glyph.path.translated(x: x - glyph.width/2,
                                         y: y)
        path.drawStyle = .fill
        return [path]
    }
}
