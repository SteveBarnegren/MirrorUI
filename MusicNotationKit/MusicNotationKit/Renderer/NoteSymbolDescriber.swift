//
//  Symbolizer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteSymbolDescriber {
    
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
        
        let description: NoteSymbolDescription
        
        switch note.value {
        case .whole:
            description = NoteSymbolDescription(headStyle: .semibreve, hasStem: false, numberOfBeams: 0)
        case .half:
            description = NoteSymbolDescription(headStyle: .open, hasStem: true, numberOfBeams: 0)
        case .quarter:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: 0)
        case .eighth:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: 1)
        case .sixteenth:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: 2)
        }
        
        note.symbolDescription = description
    }
}
