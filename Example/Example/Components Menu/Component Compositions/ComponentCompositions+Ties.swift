//
//  ComponentCompositions+Ties.swift
//  Example
//
//  Created by Steve Barnegren on 30/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var ties: Composition {
        
        let compostion = Composition()
  
        // Tied crotchets
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitch: .g3).tied())
            sequence.add(note: Note(value: .crotchet, pitch: .g3))
            
            sequence.add(note: Note(value: .crotchet, pitch: .c4).tied())
            sequence.add(note: Note(value: .crotchet, pitch: .c4))
            
            bar.add(sequence: sequence)
            compostion.add(bar: bar)
        }
        
        // Various
        do {
            do {
                let bar = Bar()
                let sequence = NoteSequence()
                
                sequence.add(rest: Rest(value: .dottedQuaver))
                sequence.add(note: Note(value: .semibreve, pitches: [.g3, .b4]).tied())
                sequence.add(note: Note(value: .crotchet, pitches: [.g3, .b4]))
                
                bar.add(sequence: sequence)
                compostion.add(bar: bar)
            }
            
            do {
                let bar = Bar()
                
                let topSequence = NoteSequence()
                topSequence.add(note: Note(value: .quaver, pitch: .g4))
                topSequence.add(note: Note(value: .quaver, pitch: .f4))
                topSequence.add(note: Note(value: .crotchet, pitch: .g4))
                
                let middleSequence = NoteSequence()
                middleSequence.add(note: Note(value: .crotchet, pitch: .c4).tied())
                middleSequence.add(note: Note(value: .semiquaver, pitch: .c4))
                middleSequence.add(rest: Rest(value: .semiquaver))
                middleSequence.add(rest: Rest(value: .quaver))
                
                let bottomSequence = NoteSequence()
                bottomSequence.add(note: Note(value: .minim, pitch: .f3))
                
                bar.add(sequence: topSequence)
                bar.add(sequence: middleSequence)
                bar.add(sequence: bottomSequence)
                compostion.add(bar: bar)
            }
            
            do {
                let bar = Bar()
                
                let sequence = NoteSequence()
                sequence.add(rest: Rest(value: .dottedQuaver))
                sequence.add(note: Note(value: .semiquaver, pitch: .d4).tied())
                sequence.add(note: Note(value: .semiquaver, pitch: .g4).tied())
                sequence.add(note: Note(value: .semiquaver, pitch: .b4).tied())
                sequence.add(note: Note(value: .semiquaver, pitch: .f3).tied())
                sequence.add(note: Note(value: .semiquaver, pitch: .g3).tied())
                sequence.add(note: Note(value: .crotchet, pitches: [.d4, .g4, .b4, .f3, .g3]))
                
                bar.add(sequence: sequence)
                compostion.add(bar: bar)
            }
        }
        
        return compostion
    }
}