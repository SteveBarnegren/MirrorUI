import Foundation

class NoteHeadDescriber {
    
    func noteHeadDescriptions(forNote note: Note, clef: Clef) -> [NoteHead] {
        
        let headStyle = self.headStyle(forNote: note)
        
        var noteHeadDescriptions = [NoteHead]()

        if note.unpitched {
            let stavePosition = StavePosition.zero

            let description = NoteHead(style: headStyle)
            description.stavePosition = stavePosition
            description.trailingLayoutItems = trailingLayoutItems(forNote: note, stavePosition: stavePosition)
            noteHeadDescriptions.append(description)
        } else {
            for pitch in note.pitches {
                let stavePosition = pitch.stavePosition(forClef: clef)

                let description = NoteHead(style: headStyle)
                description.stavePosition = stavePosition
                description.leadingLayoutItems = leadingLayoutItems(forNote: note, pitch: pitch, clef: clef)
                description.trailingLayoutItems = trailingLayoutItems(forNote: note,
                                                                      stavePosition: stavePosition)
                noteHeadDescriptions.append(description)
            }
        }
        
        return noteHeadDescriptions
    }
    
    private func headStyle(forNote note: Note) -> NoteHead.Style {
        
        if note.noteHeadType == .cross {
            return .cross
        }
        
        switch note.value.division {
        case 1: return .semibreve
        case 2: return .open
        default: return .filled
        }
    }
    
    private func leadingLayoutItems(forNote note: Note, pitch: Pitch, clef: Clef) -> [AdjacentLayoutItem] {
        
        guard let accidental = pitch.accidental else {
            return []
        }
        
        let symbolType: AccidentalSymbol.SymbolType
                
        switch accidental {
        case .sharp:
            symbolType = .sharp
        case .flat:
            symbolType = .flat
        case .natural:
            symbolType = .natural
        }
        
        let stavePosition = pitch.stavePosition(forClef: clef)
        let item = AccidentalSymbol(type: symbolType, stavePosition: stavePosition)
        return [item]
    }
    
    private func trailingLayoutItems(forNote note: Note, stavePosition: StavePosition) -> [AdjacentLayoutItem] {
        
        func makeDotSymbol(forNote note: Note) -> DotSymbol {
            let dot = DotSymbol()
            dot.stavePosition = stavePosition
            return dot
        }
        
        let numberOfDots: Int
        
        switch note.value.dots {
        case .none: numberOfDots = 0
        case .dotted: numberOfDots = 1
        case .doubleDotted: numberOfDots = 2
        }
        
        var dots = [DotSymbol]()
        
        repeated(times: numberOfDots) {
            dots.append(makeDotSymbol(forNote: note))
        }
        
        return dots
    }
}
