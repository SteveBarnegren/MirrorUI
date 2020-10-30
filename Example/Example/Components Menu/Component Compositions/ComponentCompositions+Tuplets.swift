//
//  ComponentCompositions+Triplets.swift
//  Example
//
//  Created by Steve Barnegren on 30/10/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var tuplets: Composition {
        
        let composition = Composition()
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitch: .c4))
            
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            
            sequence.startTuplet(TupletTime(value: 2, over: 3))// triplet
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.endTuplet()

            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            
            bar.add(sequence: sequence)
            composition.add(bar: bar)
        }
        
        return composition
       
    }
    
}
