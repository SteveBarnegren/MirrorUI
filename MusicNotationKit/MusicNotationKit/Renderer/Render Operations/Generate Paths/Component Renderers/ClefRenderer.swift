//
//  ClefRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 18/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class ClefRenderer {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func paths(forClef clefSymbol: ClefSymbol) -> [Path] {
        
        let glyph = glyphs.gClef
        var path = glyph.path.translated(x: clefSymbol.xPosition - glyph.width/2,
                                         y: -1) // to sit the gClef clef on the g line
        path.drawStyle = .fill
        return [path]
    }
}
