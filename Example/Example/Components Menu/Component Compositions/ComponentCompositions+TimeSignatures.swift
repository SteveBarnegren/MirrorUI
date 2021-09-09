//
//  ComponentCompositions+TimeSignatures.swift
//  Example
//
//  Created by Steven Barnegren on 15/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {

    static var timeSignatures: Composition {

        let stave = Stave()

        func add(_ timeSignature: TimeSignature, _ noteValues: [NoteValue]) {
            let bar = Bar(timeSignature: timeSignature)
            let sequence = NoteSequence()
            noteValues.forEach {
                let note = Note(value: $0, pitch: .c4)
                sequence.add(note: note)
            }
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }

        // 2/4
        add(.twoFour, [.crotchet,
                       .quaver, .quaver])
        // 3/4
        add(.threeFour, [.crotchet,
                         .quaver, .quaver,
                         .crotchet])
        // 4/4
        add(.fourFour, [.crotchet,
                        .quaver, .quaver,
                        .crotchet,
                        .quaver, .quaver])
        // 5/4
        add(.fiveFour, [.crotchet,
                        .quaver, .quaver,
                        .quaver, .quaver,
                        .crotchet,
                        .quaver, .quaver])

        // 6/4
        add(.sixFour, [.crotchet,
                       .quaver, .quaver,
                       .crotchet,
                       .crotchet,
                       .quaver, .quaver,
                       .quaver, .quaver])

        // 7/4
        add(.sevenFour, [.crotchet,
                         .quaver, .quaver,
                         .crotchet,
                         .crotchet,
                         .quaver, .quaver,
                         .crotchet,
                         .quaver, .quaver])

        // 5/8
        add(.fiveEight, [.quaver,
                         .quaver,
                         .quaver,
                         .quaver,
                         .quaver])

        // 6/8
        add(.sixEight, [.quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver])

        // 7/8
        add(.sevenEight, [.quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver])

        // 9/8
        add(.nineEight, [.quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver,
                        .quaver])

        // 11/8
        add(.elevenEight, .init(repeating: .quaver, count: 11))

        // 12/8
        add(.twelveEight, .init(repeating: .quaver, count: 12))

        let composition = Composition()
        composition.add(stave: stave)
        return composition
    }
}
