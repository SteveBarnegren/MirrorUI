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
        
        let lowestPitch = Pitch.c2
        let highestPitch = Pitch.c5
        let allPitches: [Pitch] = (lowestPitch.rawValue...highestPitch.rawValue).compactMap(Pitch.init)
        
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
}
