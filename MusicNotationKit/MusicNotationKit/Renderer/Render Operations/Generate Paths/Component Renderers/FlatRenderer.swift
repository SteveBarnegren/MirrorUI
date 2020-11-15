//
//  FlatRendereer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class FlatRenderer {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func paths(forFlatAtX x: Double, y: Double) -> [Path] {
        
        let glyph = glyphs.accidentalFlat
        var path = glyph.path.translated(x: x - glyph.width/2,
                                         y: y)
        path.drawStyle = .fill
        return [path]
    }
}
