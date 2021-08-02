//
//  ComponentCompositions+FloatingTextArticulation.swift
//  Example
//
//  Created by Steven Barnegren on 17/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {

    static var floatingTextArticulation: Composition {

        let stave = Stave()

        // Paradiddle
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .quaver, pitch: .c4).floatingTextArticulation("R"))
            sequence.add(note: Note(value: .quaver, pitch: .c4).floatingTextArticulation("L"))
            sequence.add(note: Note(value: .quaver, pitch: .c4).floatingTextArticulation("R"))
            sequence.add(note: Note(value: .quaver, pitch: .c4).floatingTextArticulation("R"))
            sequence.add(note: Note(value: .quaver, pitch: .c4).floatingTextArticulation("L"))
            sequence.add(note: Note(value: .quaver, pitch: .c4).floatingTextArticulation("R"))
            sequence.add(note: Note(value: .quaver, pitch: .c4).floatingTextArticulation("L"))
            sequence.add(note: Note(value: .quaver, pitch: .c4).floatingTextArticulation("L"))
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }

        // Flam / Drag / Ruff
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitch: .c4)
                            .addGraceNotes([GraceNote(pitch: .c4).textArticulation("L")])
                            .floatingTextArticulation("R"))

            sequence.add(note: Note(value: .crotchet, pitch: .c4)
                            .addGraceNotes([GraceNote(pitch: .c4).textArticulation("L"),
                                            GraceNote(pitch: .c4).textArticulation("L")])
                            .floatingTextArticulation("R"))

            sequence.add(note: Note(value: .crotchet, pitch: .c4)
                            .addGraceNotes([GraceNote(pitch: .c4).textArticulation("L"),
                                            GraceNote(pitch: .c4).textArticulation("R"),
                                            GraceNote(pitch: .c4).textArticulation("L")])
                            .floatingTextArticulation("R"))

            sequence.add(note: Note(value: .quaver, pitch: .c4)
                            .addGraceNotes([GraceNote(pitch: .c4).textArticulation("R"),
                                            GraceNote(pitch: .c4).textArticulation("L"),
                                            GraceNote(pitch: .c4).textArticulation("R")])
                            .floatingTextArticulation("L"))

            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }

        let composition = Composition()
        composition.add(stave: stave)
        return composition
    }
}
