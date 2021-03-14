//
//  NoteHeadAligner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteHeadAligner {
    
    static func xOffset(forNoteHead noteHead: NoteHead, glyphs: GlyphStore) -> Double {
        
        guard let glyph = glyphs.glyph(forNoteHeadStyle: noteHead.style) else {
            return 0
        }
        
        switch noteHead.alignment {
        case .center:
            return 0
        case .leftOfStem:
            return -(glyph.width + glyphs.metrics.stemThickness)
        case .rightOfStem:
            return glyph.width + glyphs.metrics.stemThickness
        }
    }
}
