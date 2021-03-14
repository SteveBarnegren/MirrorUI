//
//  CaclulateNoteWidthsProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculatePlayableItemWidthsProcessingOperation: CompositionProcessingOperation {
    
    private let glyphs: GlyphStore
    private let noteWidthCalculator: NoteWidthCalculator
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
        noteWidthCalculator = NoteWidthCalculator(glyphs: glyphs)
    }
    
    func process(composition: Composition) {
        
        // Calculate note widths
        composition.forEachNote {
            let result = self.noteWidthCalculator.width(forNote: $0)
            $0.horizontalLayoutWidth = .offset(leading: result.leading, trailing: result.trailing)
        }
        
        // Calculate rest widths
        composition.forEachRest(applyWidth)
    }
    
    // MARK: - Calculate rest widths
    
    private func applyWidth(forRest rest: Rest) {
        
        var width: Double = 1.0
        
        if let glyph = glyphs.glyph(forRestStyle: rest.symbolDescription.style) {
            width = glyph.width
        }
        
        rest.horizontalLayoutWidth = .centered(width: width)
    }
}
