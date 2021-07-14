import Foundation
import MusicNotationKit

extension ComponentCompositions {

    static var rolls: Composition {

        let stave = Stave()
        let bar = Bar()
        let sequence = NoteSequence()

        sequence.add(note: Note(value: .crotchet, pitch: .c4))
        sequence.add(note: Note(value: .crotchet, pitch: .c4))
        sequence.add(note: Note(value: .crotchet, pitch: .c4))
        sequence.add(note: Note(value: .crotchet, pitch: .c4))

        bar.add(sequence: sequence)
        stave.add(bar: bar)

        let composition = Composition()
        composition.add(stave: stave)
        return composition
    }
}

