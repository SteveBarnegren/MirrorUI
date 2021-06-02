//
//  CalculateStemPositionsProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 14/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

private let graceNoteScale = 0.5

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
        note.stemWidth = glyphs.metrics.stemThickness
    }

    private func process(graceNote: GraceNote) {

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
