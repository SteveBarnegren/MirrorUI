//
//  DotRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class DotRenderer {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func paths(forDot dot: DotSymbol) -> [Path] {
        
        let glyph = glyphs.augmentationDot
        var path = glyph.path.translated(x: dot.xPosition - glyph.width/2,
                                         y: dot.yPosition)
        path.drawStyle = .fill
        return [path]
    }
}
