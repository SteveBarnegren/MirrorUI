//
//  CaclulateNoteWidthsProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateNoteWidthsProcessingOperation: CompositionProcessingOperation {
    
    private let noteWidthCalculator: NoteWidthCalculator
    
    init(glyphs: GlyphStore) {
        noteWidthCalculator = NoteWidthCalculator(glyphs: glyphs)
    }
    
    func process(composition: Composition) {
        composition.enumerateNotes {
            let result = self.noteWidthCalculator.width(forNote: $0)
            $0.horizontalLayoutWidth = .offset(leading: result.leading, trailing: result.trailing)
        }
    }
}
