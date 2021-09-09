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
            return -(glyph.width)
        case .rightOfStem:
            return glyph.width
        }
    }
}
