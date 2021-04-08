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
        
        let glyph = self.glyph(forType: clefSymbol.symbolType)
        var path = glyph.path.translated(x: clefSymbol.xPosition - glyph.width/2,
                                         y: clefSymbol.yPosition)
        path.drawStyle = .fill
        return [path]
    }
    
    private func glyph(forType type: ClefSymbol.SymbolType) -> Glyph {
        
        switch type {
        case .gClef:
            return glyphs.glyph(forType: .gClef)
        case .fClef:
            return glyphs.glyph(forType: .fClef)
        }
    }
}
