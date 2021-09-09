import Foundation

class CalculateStemPositionsProcessingOperation: CompositionProcessingOperation {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func process(composition: Composition) {
        composition.notes.forEach(process)
        composition.notes.forEach {
            $0.graceNotes.forEach(process)
        }
    }
    
    private func process(note: Note) {
        
        if note.hasStem == false {
            return
        }
        
        guard let glyph = glyphs.glyph(forNoteHeadStyle: note.stemConnectingNoteHead.style) else {
            return
        }
                
        let anchor: Vector2D
        
        switch note.stemDirection {
        case .up:
            anchor = glyph.stemUpSE
        case .down:
            anchor = glyph.stemDownNW
        }
                
        note.stemConnectionPoint = Vector2D(-glyph.width/2 + anchor.x,
                                            anchor.y)
    }

    private func process(graceNote: GraceNote) {

        let graceNoteScale = glyphs.metrics.graceNoteScale

        let anchor: Vector2D

        let glyph = glyphs.glyph(forType: .noteheadBlack)

        switch graceNote.stemDirection {
        case .up:
            anchor = glyph.stemUpSE * graceNoteScale
        case .down:
            anchor = glyph.stemDownNW * graceNoteScale
        }

        let glyphWidth = (glyph.width * graceNoteScale)
        graceNote.stemConnectionPoint = Vector2D(-glyphWidth/2 + anchor.x,
                                                 anchor.y)
    }
}
