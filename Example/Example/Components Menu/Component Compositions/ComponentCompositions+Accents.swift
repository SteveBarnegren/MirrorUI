//
//  ComponentCompositions+Accents.swift
//  Example
//
//  Created by Steve Barnegren on 26/10/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var accents: Composition {
        
        let stave = Stave()
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitch: .c4).accent())
            sequence.add(note: Note(value: .crotchet, pitch: .a4).accent())

            sequence.add(note: Note(value: .quaver, pitch: .f3).accent())
            sequence.add(note: Note(value: .quaver, pitch: .a4).accent())
            sequence.add(note: Note(value: .quaver, pitch: .c4).accent())
            sequence.add(note: Note(value: .quaver, pitch: .e4).accent())
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .semiquaver, pitch: .e4).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .e4).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .e4).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .e4).accent())

            sequence.add(note: Note(value: .semiquaver, pitch: .g4).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .f3).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .g3).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .f3).accent())
            
            sequence.add(note: Note(value: .quaver, pitch: .f3).accent())
            sequence.add(note: Note(value: .quaver, pitch: .e3).accent())
            sequence.add(note: Note(value: .crotchet, pitch: .d3).accent())
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .semiquaver, pitch: .b3).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .c3).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .d3).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .e3).accent())
            
            sequence.add(note: Note(value: .semiquaver, pitch: .f3).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .g3).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .a4).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .b4).accent())

            sequence.add(note: Note(value: .semiquaver, pitch: .c4).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .d4).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .e4).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .f4).accent())
            
            sequence.add(note: Note(value: .semiquaver, pitch: .g4).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .a5).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .b5).accent())
            sequence.add(note: Note(value: .semiquaver, pitch: .c5).accent())
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        let composition = Composition()
        composition.add(stave: stave)
        return composition
       
    }
    
}
