import Foundation

public class Bar {
    
    var barNumber = 0
    var clef: Clef = .treble
    var clefSymbol = ClefSymbol()
    var isFirstBarInLine = false
    var sequences = [NoteSequence]()
    let leadingBarline = Barline()
    var trailingBarline: Barline?
    public var timeSignature: TimeSignature
    var timeSignatureSymbol: TimeSignatureSymbol?
    
    
    var trailingTies: [Tie] {
        return sequences
            .map { $0.notes }.joined()
            .map { $0.noteHeads }.joined()
            .compactMap { $0.tie?.chosenVariation }
    }
    
    var duration: Time {
        return sequences.map { $0.duration }.max() ?? .zero
    }
    
    public init(timeSignature: TimeSignature = .fourFour) {
        self.timeSignature = timeSignature
    }
    
    public func add(sequence: NoteSequence) {
        self.sequences.append(sequence)
    }
}

extension Bar {
    
    func forEachNote(_ handler: (Note) -> Void) {
        for sequence in self.sequences {
            for note in sequence.notes {
                handler(note)
            }
        }
    }
    
    func forEachRest(_ handler: (Rest) -> Void) {
        for sequence in self.sequences {
            for rest in sequence.rests {
                handler(rest)
            }
        }
    }
}

extension Array where Element == Bar {
    
    func forEachNote(_ handler: (Note) -> Void) {
        
        for bar in self {
            bar.forEachNote(handler)
        }
    }
}
