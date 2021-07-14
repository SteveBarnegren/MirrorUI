import Foundation
import MusicNotationKit

extension ComponentCompositions {

    static var rolls: Composition {

        let stave = Stave()
        let bar = Bar(timeSignature: .fiveFour)
        let sequence = NoteSequence()

        sequence.add(note: Note(value: .crotchet, pitch: .c4).stemAugmentation(.tremolo1))
        sequence.add(note: Note(value: .crotchet, pitch: .c4).stemAugmentation(.tremolo2))
        sequence.add(note: Note(value: .crotchet, pitch: .c4).stemAugmentation(.tremolo3))
        sequence.add(note: Note(value: .crotchet, pitch: .a4).stemAugmentation(.tremolo3))
        sequence.add(note: Note(value: .crotchet, pitch: .a4).stemAugmentation(.tremolo3))

        bar.add(sequence: sequence)
        stave.add(bar: bar)

        let composition = Composition()
        composition.add(stave: stave)
        return composition
    }
}

