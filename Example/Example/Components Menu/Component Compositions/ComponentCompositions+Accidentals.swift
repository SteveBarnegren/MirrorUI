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
        
        let stave = Stave()
        allPitches.chunked(into: 8).forEach { pitches in
            let bar = Bar()
            let sequence = NoteSequence()
            pitches.forEach { pitch in
                sequence.add(note: Note(value: .crotchet, pitch: pitch))
            }
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        let composition = Composition()
        composition.add(stave: stave)
        return composition
    }
    
    static func makeAllPitches() -> [Pitch] {
        let pitches: [Pitch] = [
            // 2
            Pitch(.a2, .natural),
            .aSharp2,
            .bFlat2,
            Pitch(.b2, .natural),
            Pitch(.c2, .natural),
            .cSharp2,
            .dFlat2,
            Pitch(.d2, .natural),
            .dSharp2,
            Pitch(.e2, .natural),
            Pitch(.f2, .natural),
            .fSharp2,
            .gFlat2,
            Pitch(.g2, .natural),
            // 3
            Pitch(.a3, .natural),
            .aSharp3,
            .bFlat3,
            Pitch(.b3, .natural),
            Pitch(.c3, .natural),
            .cSharp3,
            .dFlat3,
            Pitch(.d3, .natural),
            .dSharp3,
            Pitch(.e3, .natural),
            Pitch(.f3, .natural),
            .fSharp3,
            .gFlat3,
            Pitch(.g3, .natural),
            // 4
            Pitch(.a4, .natural),
            .aSharp4,
            .bFlat4,
            Pitch(.b4, .natural),
            Pitch(.c4, .natural),
            .cSharp4,
            .dFlat4,
            Pitch(.d4, .natural),
            .dSharp4,
            Pitch(.e4, .natural),
            Pitch(.f4, .natural),
            .fSharp4,
            .gFlat4,
            Pitch(.g4, .natural),
            // 5
            Pitch(.a5, .natural),
            .aSharp5,
            .bFlat5,
            Pitch(.b5, .natural),
            Pitch(.c5, .natural),
            .cSharp5,
            .dFlat5,
            Pitch(.d5, .natural),
            .dSharp5,
            Pitch(.e5, .natural),
            Pitch(.f5, .natural),
            .fSharp5,
            .gFlat5,
            Pitch(.g5, .natural)
        ]
        
        return pitches
    }
}
