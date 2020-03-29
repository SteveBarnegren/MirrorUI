//
//  ComponentComposition+IntervalsAndChords.swift
//  Example
//
//  Created by Steve Barnegren on 29/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var intervalsAndChords: Composition {
        
        let composition = Composition()
        
        repeated(times: 20) {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // Intervals
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitches: [.c4, .g3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.d4, .a4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.d4, .f3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.e4, .g3]))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // Intervals (wider)
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitches: [.e4, .e3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.f4, .f3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.d3, .f4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.f2, .c5]))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // Connected intervals
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .quaver, pitches: [.f3, .a4]))
            sequence.add(note: Note(value: .quaver, pitches: [.d4, .f4]))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // Connected intervals
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .quaver, pitches: [.c3, .g3]))
            sequence.add(note: Note(value: .quaver, pitches: [.e4, .g4]))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // Equidistant intervals
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitches: [.c4, .a4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.d4, .g3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.e4, .f3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.f4, .e3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.g4, .d3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.a5, .c3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.b5, .b3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c5, .a3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.d5, .g4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.e5, .f4]))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // Chords
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitches: [.a5, .a4, .f3, .d3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.e4, .c4, .d3]))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // Chords
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitches: [.e4, .c4, .f3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.g4, .d4, .b4, .d3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.a5, .e3, .c3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.e3, .a4, .f4]))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // Chords - Equidistant notes from center
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitches: [.f3, .a4, .c4, .e4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.d3, .b4, .g4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.c3, .g3, .d4, .a5]))
            sequence.add(note: Note(value: .minim, pitches: [.e3, .g3, .d4, .f4]))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // Chords - Equidistant notes from center
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .quaver, pitches: [.a4, .c4, .e4]))
            sequence.add(note: Note(value: .quaver, pitches: [.f3, .a4, .c4]))
            sequence.add(note: Note(value: .quaver, pitches: [.g3, .b4, .d4]))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        // TEST
        
        repeated(times: 20) {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        repeated(times: 20) {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitch: .f5))
            sequence.add(note: Note(value: .crotchet, pitch: .f5))
            sequence.add(note: Note(value: .crotchet, pitch: .f5))
            sequence.add(note: Note(value: .crotchet, pitch: .f5))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        repeated(times: 20) {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitch: .a2))
            sequence.add(note: Note(value: .crotchet, pitch: .a2))
            sequence.add(note: Note(value: .crotchet, pitch: .a2))
            sequence.add(note: Note(value: .crotchet, pitch: .a2))
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        return composition
    }
}
