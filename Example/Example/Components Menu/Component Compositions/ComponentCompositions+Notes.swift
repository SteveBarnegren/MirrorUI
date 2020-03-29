//
//  ComponentCompositions+Notes.swift
//  Example
//
//  Created by Steve Barnegren on 29/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var notes: Composition {
        
        let compostion = Composition()
        
        func addNote(value: NoteValue, hasStem: Bool) {
            
            let pitches: [Pitch] = hasStem ? [.a4, .c4] : [.c4]
            
            for pitch in pitches {
                let bar = Bar()
                let sequence = NoteSequence()
                let note = Note(value: value, pitch: pitch)
                sequence.add(note: note)
                bar.add(sequence: sequence)
                compostion.add(bar: bar)
            }
        }
        
        addNote(value: .semibreve, hasStem: false)
        addNote(value: .minim, hasStem: true)
        addNote(value: .crotchet, hasStem: true)
        addNote(value: .quaver, hasStem: true)
        addNote(value: .semiquaver, hasStem: true)
        addNote(value: 32, hasStem: true)
        addNote(value: 64, hasStem: true)
        addNote(value: 128, hasStem: true)
        addNote(value: 256, hasStem: true)
        addNote(value: 512, hasStem: true)
        addNote(value: 1024, hasStem: true)
        
        return compostion
    }
}
