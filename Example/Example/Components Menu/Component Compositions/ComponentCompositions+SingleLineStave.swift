//
//  ComponentCompositions+SingleLineStave.swift
//  Example
//
//  Created by Steven Barnegren on 03/08/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {

    static var singleLineStave: Composition {

        let stave = Stave()
        stave.style = .singleLine

        do {
            let bar = Bar()
            let sequence = NoteSequence()

            sequence.add(note: Note(unpitched: .crotchet).accent())
            sequence.add(note: Note(unpitched: .crotchet).accent())

            sequence.add(note: Note(unpitched: .quaver).accent())
            sequence.add(note: Note(unpitched: .quaver).accent())
            sequence.add(note: Note(unpitched: .quaver).accent())
            sequence.add(note: Note(unpitched: .quaver).accent())

            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }

        let composition = Composition()
        composition.add(stave: stave)
        return composition
    }
}
