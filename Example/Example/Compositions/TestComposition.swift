//
//  TestComposition.swift
//  Example
//
//  Created by Steve Barnegren on 06/10/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation
import MusicNotationKit

extension ExampleCompositions {
    static let test = makeTestComposition()
}

private func makeTestComposition() -> Composition {
    
    let composition = Composition()
    composition.add(bar: makeBar1())
    composition.add(bar: makeBar2())
    composition.add(bar: makeBar3())
    composition.add(bar: makeBar4())
    composition.add(bar: makeBar5())
    composition.add(bar: makeBar6())
    composition.add(bar: makeBar7())
    return composition
}

private func makeBar1() -> Bar {
    
    let sequence = NoteSequence()
    sequence.add(rest: Rest(value: 8))
    sequence.add(note: Note(value: 8, pitch: .d4).natural())
    
    sequence.add(note: Note(value: .dottedQuaver, pitch: .b4))
    sequence.add(note: Note(value: 16, pitch: .a4))
    
    sequence.add(note: Note(value: 16, pitch: .b4))
    sequence.add(note: Note(value: 16, pitch: .a4))
    sequence.add(note: Note(value: 16, pitch: .b4))
    sequence.add(note: Note(value: 16, pitch: .a4))
    
    sequence.add(note: Note(value: 8, pitch: .b4))
    sequence.add(note: Note(value: 16, pitch: .b4))
    sequence.add(note: Note(value: 16, pitch: .a4))
    
    let bar = Bar()
    bar.timeSignature = .fourFour
    bar.add(sequence: sequence)
    return bar
}

private func makeBar2() -> Bar {
    
    let sequence = NoteSequence()
    
    sequence.add(note: Note(value: 16, pitch: .b4))
    sequence.add(note: Note(value: 16, pitch: .a4))
    sequence.add(note: Note(value: 16, pitch: .b4))
    sequence.add(note: Note(value: 16, pitch: .a4))
    
    sequence.add(note: Note(value: 8, pitch: .b4))
    sequence.add(note: Note(value: 16, pitch: .d4).sharp())
    sequence.add(note: Note(value: 16, pitch: .a4))

    sequence.add(note: Note(value: 4, pitch: .a4))

    sequence.add(rest: Rest(value: 4))
    
    let bar = Bar()
    bar.timeSignature = .fourFour
    bar.add(sequence: sequence)
    return bar
}

private func makeBar3() -> Bar {
    
    let top = NoteSequence()
    
    top.add(note: Note(value: 16, pitch: .b4))
    top.add(note: Note(value: 16, pitch: .a4))
    top.add(note: Note(value: 16, pitch: .b4))
    top.add(note: Note(value: 16, pitch: .a4))
    
    top.add(note: Note(value: 8, pitch: .b4))
    top.add(note: Note(value: 16, pitch: .d4).sharp())
    top.add(note: Note(value: 16, pitch: .a4))

    top.add(note: Note(value: 4, pitch: .a4))

    top.add(rest: Rest(value: 4))
    
    let bottom = NoteSequence()
    
    bottom.add(note: Note(value: 4, pitch: .e3))

    bottom.add(note: Note(value: .dottedQuaver, pitch: .e3))
    bottom.add(note: Note(value: 16, pitch: .d3))
    bottom.add(note: Note(value: 2, pitch: .d3))
    
    let bar = Bar()
    bar.timeSignature = .fourFour
    bar.add(sequence: top)
    bar.add(sequence: bottom)
    return bar
}

func makeBar4() -> Bar {
    let sequenceOne = NoteSequence()
    
    sequenceOne.add(note: Note(value: NoteValue(division: 8), pitch: .c4).natural())
    sequenceOne.add(note: Note(value: NoteValue(division: 8), pitch: .g4))
    sequenceOne.add(note: Note(value: NoteValue(division: 8), pitch: .e4))
    
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .g4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .c4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .a4).flat())
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .g4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .c4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .a4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .g4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .c4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .a4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .g4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .c4))
    sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .a4))
    
    let bar = Bar()
    bar.add(sequence: sequenceOne)
    bar.timeSignature = .sixEight
    
    return bar
}

func makeBar5() -> Bar {
    
    let sequence = NoteSequence()
    
    sequence.add(note: Note(value: .eighth, pitch: .c4))
    sequence.add(note: Note(value: .sixteenth, pitch: .b4))
    sequence.add(note: Note(value: .sixteenth, pitch: .a4))
    
    sequence.add(note: Note(value: .dottedQuaver, pitch: .e4))
    sequence.add(note: Note(value: .sixteenth, pitch: .c4))
    
    sequence.add(note: Note(value: .eighth, pitch: .a4))
    sequence.add(note: Note(value: .sixteenth, pitch: .g3))
    sequence.add(note: Note(value: .sixteenth, pitch: .f3))
    
    sequence.add(note: Note(value: .sixteenth, pitch: .f3))
    sequence.add(note: Note(value: .eighth, pitch: .g3))
    sequence.add(note: Note(value: .sixteenth, pitch: .a4).sharp())
    
    let bar = Bar()
    bar.timeSignature = .fourFour
    bar.add(sequence: sequence)
    
    return bar
}

private func makeBar6() -> Bar {
    
    let sequence = NoteSequence()
    sequence.add(note: Note(value: 8, pitch: .g3))
    sequence.add(note: Note(value: 8, pitch: .e3))
    sequence.add(note: Note(value: 8, pitch: .b3))
    sequence.add(note: Note(value: 8, pitch: .c3))
    
    sequence.add(note: Note(value: 8, pitch: .g3))
    sequence.add(note: Note(value: 8, pitch: .e3))
    sequence.add(note: Note(value: 8, pitch: .b3))
    sequence.add(note: Note(value: 8, pitch: .c3))
    
    let bar = Bar()
    bar.timeSignature = .fourFour
    bar.add(sequence: sequence)
    return bar
}

private func makeBar7() -> Bar {
    
    let sequence = NoteSequence()
    sequence.add(note: Note(value: 16, pitch: .g3))
    sequence.add(note: Note(value: 16, pitch: .e3))
    sequence.add(note: Note(value: 16, pitch: .b3))
    sequence.add(note: Note(value: 16, pitch: .c3))
    
    sequence.add(note: Note(value: 16, pitch: .g3))
    sequence.add(note: Note(value: 16, pitch: .e3))
    sequence.add(note: Note(value: 16, pitch: .b3))
    sequence.add(note: Note(value: 16, pitch: .c3))
    
    sequence.add(note: Note(value: 4, pitch: .e4))

    sequence.add(note: Note(value: 4, pitch: .f3))
    
    let bar = Bar()
    bar.timeSignature = .fourFour
    bar.add(sequence: sequence)
    return bar
}
