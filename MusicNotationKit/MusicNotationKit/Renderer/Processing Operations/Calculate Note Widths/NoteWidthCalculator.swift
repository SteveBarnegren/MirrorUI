//
//  NoteWidthCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

// Can eventually calulate this from the path
private let noteHeadWidth = 1.2

// Should be sinlge source of truth for this
private let stemThickness = 0.1

class NoteWidthCalculator {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func width(forNote note: Note) -> (leading: Double, trailing: Double) {
        
        var centeredNotesWidth = 0.0
        var leftOfStemNotesWidth = 0.0
        var rightOfStemNotesWidth = 0.0
        
        for description in note.noteHeadDescriptions {
            
            guard let glyph = glyphs.glyph(forNoteHeadStyle: description.style) else {
                continue
            }
                        
            switch description.alignment {
            case .center:
                centeredNotesWidth = max(centeredNotesWidth, glyph.size.width)
            case .leftOfStem:
                leftOfStemNotesWidth = max(leftOfStemNotesWidth, glyph.size.width)
            case .rightOfStem:
                rightOfStemNotesWidth = max(rightOfStemNotesWidth, glyph.size.width)
            }
        }
        
        let leading = centeredNotesWidth/2 + leftOfStemNotesWidth
        let trailing = centeredNotesWidth/2 + rightOfStemNotesWidth
        
        return (leading, trailing)
    }
}
