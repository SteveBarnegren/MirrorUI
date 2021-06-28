//
//  ComponentCompositions+TextArticulation.swift
//  Example
//
//  Created by Steven Barnegren on 17/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {

    static var textArticulation: Composition {

        let stave = Stave()
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .quaver, pitch: .c4).textArticulation("R"))
        sequence.add(note: Note(value: .quaver, pitch: .c4).textArticulation("L"))
        sequence.add(note: Note(value: .quaver, pitch: .c4).textArticulation("R"))
        sequence.add(note: Note(value: .quaver, pitch: .c4).textArticulation("R"))
        sequence.add(note: Note(value: .quaver, pitch: .c4).textArticulation("L"))
        sequence.add(note: Note(value: .quaver, pitch: .c4).textArticulation("R"))
        sequence.add(note: Note(value: .quaver, pitch: .c4).textArticulation("L"))
        sequence.add(note: Note(value: .quaver, pitch: .c4).textArticulation("L"))
        bar.add(sequence: sequence)
        stave.add(bar: bar)
        let composition = Composition()
        composition.add(stave: stave)
        return composition
    }
}
