//
//  ComponentCompositions+MultipleVoices.swift
//  Example
//
//  Created by Steve Barnegren on 14/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var multipleVoices: Composition {
        let composition = Composition()
        composition.add(stave: makeFirstStave())
        composition.add(stave: makeSecondStave())
        return composition
    }
    
    private static func makeFirstStave() -> Stave {
        
        let stave = Stave()
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))

            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))

            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        return stave
    }
    
    private static func makeSecondStave() -> Stave {
        
        let stave = Stave()
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))
            sequence.add(note: Note(value: .minim, pitches: [.c4]))

            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .minim, pitches: [.c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c4]))

            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        return stave
    }
    
    /*
    private static func makeFirstStave() -> Stave {
        
        let stave = Stave()
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(rest: Rest(value: .dottedQuaver))
            sequence.add(note: Note(value: .semibreve, pitches: [.g3, .b4]).tied())
            sequence.add(note: Note(value: .crotchet, pitches: [.g3, .b4]))
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
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
            stave.add(bar: bar)
        }
        
        do {
            
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitch: .e4).tied().accent())
            sequence.add(note: Note(value: .crotchet, pitch: .e4).accent())
            sequence.add(note: Note(value: .crotchet, pitch: .d4).tied().accent())
            sequence.add(note: Note(value: .crotchet, pitch: .d4).accent())
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        return stave
    }
    
    private static func makeSecondStave() -> Stave {
        
        let stave = Stave()
        
        do {
            let bar = Bar()
            
            let topSequence = NoteSequence()
            topSequence.add(note: Note(value: .quaver, pitch: .g4).tied())
            topSequence.add(note: Note(value: .quaver, pitch: .a4))
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
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            
            let sequence = NoteSequence()
            sequence.add(rest: Rest(value: .dottedQuaver))
            sequence.add(note: Note(value: .semiquaver, pitch: .d4).tied())
            sequence.add(note: Note(value: .semiquaver, pitch: .a5).tied())
            sequence.add(note: Note(value: .semiquaver, pitch: .b4).tied())
            sequence.add(note: Note(value: .semiquaver, pitch: .f3).tied())
            sequence.add(note: Note(value: .semiquaver, pitch: .g3).tied())
            sequence.add(note: Note(value: .crotchet, pitches: [.d4, .a5, .b4, .f3, .g3]))
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .quaver, pitches: [.f3]))
            sequence.add(note: Note(value: .quaver, pitches: [.d4]).tied())
            sequence.add(note: Note(value: .crotchet, pitch: .d4))
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }

        return stave
    }
    */
}
