//
//  HorizontalConstraintsCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class WidthConstraintsCalculator {
    
    func process(composition: Composition) {
        for bar in composition.bars {
            process(bar: bar)
        }
    }
    
    private func process(bar: Bar) {
        for noteSequence in bar.sequences {
            process(noteSequence: noteSequence)
        }
    }
    
    private func process(noteSequence: NoteSequence) {
        for note in noteSequence.notes {
            process(note: note)
        }
    }
    
    private func process(note: Note) {
        
        // Leading - 0.5 for the note head
        var leadingWidth = Double(0)
        leadingWidth += 0.7
    
        // Trailing - 0.5 for the note head
        var trailingWidth = Double(0)
        trailingWidth += 0.7
    
        note.leadingWidth = leadingWidth
        note.trailingWidth = trailingWidth
    }
}
