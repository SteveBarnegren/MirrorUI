import Foundation

public class Composition {
    
    var isPreprocessed = false
    
    var staves = [Stave]()
    var barSlices = [BarSlice]()
    
    var notes: [Note] {
        return staves.map { $0.bars }.joined()
            .map { $0.sequences }.joined()
            .map { $0.notes }.joined().toArray()
    }
    
    var numberOfBars: Int {
        return staves.map { $0.bars.count }.max() ?? 0
    }
    
    var duration: Time {
        return staves.map { $0.duration }.max() ?? .zero
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Add staves
    
    public func add(stave: Stave) {
        self.staves.append(stave)
    }
    
    // MARK: - Enumeration conviniences
    
    func forEachNote(_ handler: (Note) -> Void) {
        
        for stave in staves {
            for bar in stave.bars {
                for noteSequence in bar.sequences {
                    for note in noteSequence.notes {
                        handler(note)
                    }
                }
            }
        }
    }
    
    func forEachRest(_ handler: (Rest) -> Void) {
        
        for stave in staves {
            for bar in stave.bars {
                for noteSequence in bar.sequences {
                    for rest in noteSequence.rests {
                        handler(rest)
                    }
                }
            }
        }
    }
    
    func forEachNoteSequence(_ handler: (NoteSequence) -> Void) {
        
        for stave in staves {
            for bar in stave.bars {            
                for noteSequence in bar.sequences {
                    handler(noteSequence)
                }
            }
        }
    }
    
    func forEachBar(_ handler: (Bar) -> Void) {
        for stave in staves {
            for bar in stave.bars {            
                handler(bar)
            }
        }
    }
}
