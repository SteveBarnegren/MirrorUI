import Foundation
import MusicNotationKit

extension ComponentCompositions {

    static var barlines: Composition {

        let composition = Composition()
        let stave = Stave()
        composition.add(stave: stave)

        func addBar(options: BarlineOptions) {
            let bar = Bar(timeSignature: .twoFour)
            bar.set(barlineOptions: options)
            let sequence = NoteSequence()
            sequence.add(note: Note(value: .crotchet, pitch: .c4))
            sequence.add(note: Note(value: .crotchet, pitch: .c4))
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }

        addBar(options: [])
        addBar(options: [])
        addBar(options: [.double])
        return composition
    }
}
