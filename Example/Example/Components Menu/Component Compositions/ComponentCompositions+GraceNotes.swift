//
//  ComponentCompositions+GraceNotes.swift
//  Example
//
//  Created by Steven Barnegren on 01/05/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var graceNotes: Composition {
        
        let stave = Stave()
        let bar = Bar()
        stave.add(bar: bar)
        
        let sequence = NoteSequence()
        
        do {
            let note = Note(value: .crotchet, pitch: .c4)
            note.addGraceNotes([GraceNote(pitch: .c4)])
            sequence.add(note: note)
        }
        
        do {
            let note = Note(value: .crotchet, pitch: .c4)
            note.addGraceNotes([GraceNote(pitch: .c4), GraceNote(pitch: .c4)])
            sequence.add(note: note)
        }

        do {
            let note = Note(value: .crotchet, pitch: .c4)
            note.addGraceNotes([GraceNote(pitch: .a4), GraceNote(pitch: .b4)])
            sequence.add(note: note)
        }

        do {
            let note = Note(value: .crotchet, pitch: .a4)
            note.addGraceNotes([GraceNote(pitch: .e4), GraceNote(pitch: .c4), GraceNote(pitch: .b4)])
            sequence.add(note: note)
        }
        
        bar.add(sequence: sequence)
        
        let composition = Composition()
        composition.add(stave: stave)
        return composition
    }
}
