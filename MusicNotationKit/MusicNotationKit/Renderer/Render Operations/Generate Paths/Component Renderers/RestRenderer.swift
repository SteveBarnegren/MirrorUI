//
//  RestRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class RestRenderer {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func paths(forRests rests: [Rest]) -> [Path] {
        return rests.compactMap(path(forRest:))
    }
    
    private func path(forRest rest: Rest) -> Path? {
        
        if let glyph = glyphs.glyph(forRestStyle: rest.symbolDescription.style) {
            return glyph.path.translated(x: rest.xPosition - glyph.width/2,
                                         y: rest.yPosition)
        } else {
            return nil
        }
    }
}
