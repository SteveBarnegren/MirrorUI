//
//  ExampleCompositions.swift
//  Example
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

struct ExampleCompositions {
    static let randomComposition = makeRandomComposition()
}

private func makeRandomComposition() -> Composition {
    
    let segmentGenerators: [() -> [Note]] = [makeBarSegment1,
                                             makeBarSegment2,
                                             makeBarSegment3,
                                             makeBarSegment4,
                                             makeBarSegment5,
                                             makeBarSegment6,
                                             makeBarSegment7]
    
    let numberOfBars = 20
    
    let composition = Composition()
    
    for _ in 0..<numberOfBars {
    
        let sequence = NoteSequence()
        for _ in 0..<4 {
            let notes = segmentGenerators.randomElement()!()
            notes.forEach(sequence.add)
        }
        
        let bar = Bar()
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    return composition
}

private func makeBarSegment1() -> [Note] {
    return [Note(value: .crotchet, pitch: .c4)]
}

private func makeBarSegment2() -> [Note] {
    return [Note(value: .quaver, pitch: .c4), Note(value: .quaver, pitch: .c4)]
}

private func makeBarSegment3() -> [Note] {
    return [Note(value: .semiquaver, pitch: .c4),
            Note(value: .semiquaver, pitch: .c4),
            Note(value: .semiquaver, pitch: .c4),
            Note(value: .semiquaver, pitch: .c4)]
}

private func makeBarSegment4() -> [Note] {
    return [Note(value: 32, pitch: .c4),
            Note(value: 32, pitch: .c4),
            Note(value: 32, pitch: .c4),
            Note(value: 32, pitch: .c4),
            Note(value: 32, pitch: .c4),
            Note(value: 32, pitch: .c4),
            Note(value: 32, pitch: .c4),
            Note(value: 32, pitch: .c4)]
}

private func makeBarSegment5() -> [Note] {
    return [Note(value: .quaver, pitch: .c4),
            Note(value: .semiquaver, pitch: .c4),
            Note(value: .semiquaver, pitch: .c4)]
}

private func makeBarSegment6() -> [Note] {
    return [Note(value: .semiquaver, pitch: .c4),
            Note(value: .quaver, pitch: .c4),
            Note(value: .semiquaver, pitch: .c4)]
}

private func makeBarSegment7() -> [Note] {
    return [Note(value: .quaver, pitch: .c4),
            Note(value: .semiquaver, pitch: .c4),
            Note(value: .semiquaver, pitch: .c4)]
}
