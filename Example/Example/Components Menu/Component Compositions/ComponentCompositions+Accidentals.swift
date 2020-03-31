//
//  ComponentCompositions+Accidentals.swift
//  Example
//
//  Created by Steve Barnegren on 31/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension ComponentCompositions {
    
    static var accidentals: Composition {

        let allPitches: [Pitch] = makeAllPitches()
        
        let composition = Composition()
        allPitches.chunked(into: 8).forEach { pitches in
            let bar = Bar()
            let sequence = NoteSequence()
            pitches.forEach { pitch in
                sequence.add(note: Note(value: .crotchet, pitch: pitch))
            }
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        return composition
    }
    
    static func makeAllPitches() -> [Pitch] {
        let pitches: [Pitch] = [
            // 2
            .a2,
            .aSharp2,
            .bFlat2,
            .b2,
            .c2,
            .cSharp2,
            .dFlat2,
            .d2,
            .dSharp2,
            .e2,
            .f2,
            .fSharp2,
            .gFlat2,
            .g2,
            // 3
            .a3,
            .aSharp3,
            .bFlat3,
            .b3,
            .c3,
            .cSharp3,
            .dFlat3,
            .d3,
            .dSharp3,
            .e3,
            .f3,
            .fSharp3,
            .gFlat3,
            .g3,
            // 4
            .a4,
            .aSharp4,
            .bFlat4,
            .b4,
            .c4,
            .cSharp4,
            .dFlat4,
            .d4,
            .dSharp4,
            .e4,
            .f4,
            .fSharp4,
            .gFlat4,
            .g4,
            // 5
            .a5,
            .aSharp5,
            .bFlat5,
            .b5,
            .c5,
            .cSharp5,
            .dFlat5,
            .d5,
            .dSharp5,
            .e5,
            .f5,
            .fSharp5,
            .gFlat5,
            .g5
        ]
        
        return pitches
    }
}
