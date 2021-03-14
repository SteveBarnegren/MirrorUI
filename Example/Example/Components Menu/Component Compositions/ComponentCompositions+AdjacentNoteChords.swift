//
//  File.swift
//  Example
//
//  Created by Steve Barnegren on 10/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var adjacentNoteChords: Composition {
        
        let stave = Stave()
    
        // Adjacent note intervals (crotchets and minims)
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .minim, pitches: [.f3, .g3]))
            sequence.add(note: Note(value: .crotchet, pitches: [.g3, .a4]))
            sequence.add(note: Note(value: .minim, pitches: [.b4, .c4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.e4, .f4]))
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        // Adjacent note intervals (quavers)
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .quaver, pitches: [.c4, .d4]))
            sequence.add(note: Note(value: .quaver, pitches: [.e4, .f4]))
            sequence.add(note: Note(value: .quaver, pitches: [.c4, .d4]))
            sequence.add(note: Note(value: .quaver, pitches: [.e4, .f4]))
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        // Odd number of adjacent notes, the majority fall on the 'correct' side of the stem
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .minim, pitches: [.f3, .g3, .a4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.e3, .f3, .g3, .a4, .b4, .c4, .d4]))
            sequence.add(note: Note(value: .minim, pitches: [.c4, .d4, .e4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.d4, .e4, .f4, .g4, .a5]))
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        // Even number of adjacent notes, the lowest note always goes the left side of the stem
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .minim, pitches: [.f3, .g3, .a4, .b4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.e3, .f3, .g3, .a4, .b4, .c4, .d4, .e4]))
            sequence.add(note: Note(value: .minim, pitches: [.c4, .d4, .e4, .f4]))
            sequence.add(note: Note(value: .crotchet, pitches: [.d4, .e4, .f4, .g4, .a5, .b5]))
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        // Multiple adjacent note clusters
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .minim, pitches: [.f3, .g3, .a4, .c4, .d4, .e4]))
            sequence.add(note: Note(value: .minim, pitches: [.c3, .f3, .g3, .a4, .c4]))
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        let composition = Composition()
        composition.add(stave: stave)
        return composition
    }
}
