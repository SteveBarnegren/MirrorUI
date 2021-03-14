//
//  ComponentCompositions+Rests.swift
//  Example
//
//  Created by Steve Barnegren on 29/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var rests: Composition {
        
        let composition = Composition()
        let stave = Stave()
        
        func add(value: NoteValue, number: Int) {
            let bar = Bar()
            let sequence = NoteSequence()
            
            repeated(times: number) {
                sequence.add(rest: Rest(value: value))
            }
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        add(value: .semibreve, number: 1)
        add(value: .minim, number: 2)
        add(value: .crotchet, number: 4)
        add(value: .quaver, number: 8)
        add(value: .semiquaver, number: 16)
      
        // Add faster values as one rest each in a single bar
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(rest: Rest(value: 32))
        sequence.add(rest: Rest(value: 64))
        sequence.add(rest: Rest(value: 128))
        sequence.add(rest: Rest(value: 256))
        sequence.add(rest: Rest(value: 512))
        sequence.add(rest: Rest(value: 1024))
        bar.add(sequence: sequence)
        stave.add(bar: bar)

        composition.add(stave: stave)
        return composition
    }
}
