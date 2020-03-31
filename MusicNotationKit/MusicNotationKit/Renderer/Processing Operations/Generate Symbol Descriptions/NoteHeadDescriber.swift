//
//  NoteHeadDescriber.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteHeadDescriber {
    
    func noteHeadDescriptions(forNote note: Note) -> [NoteHeadDescription] {
        
        let headStyle = self.headStyle(forNote: note)
        
        var noteHeadDescriptions = [NoteHeadDescription]()
        for pitch in note.pitches {
            let description = NoteHeadDescription(style: headStyle)
            description.staveOffset = pitch.staveOffset
            description.leadingLayoutItems = leadingLayoutItems(forNote: note, pitch: pitch)
            description.trailingLayoutItems = trailingLayoutItems(forNote: note, pitch: pitch)
            noteHeadDescriptions.append(description)
        }
        
        return noteHeadDescriptions
    }
    
    private func headStyle(forNote note: Note) -> NoteHeadDescription.Style {
        
        if note.noteHeadType == .cross {
            return .cross
        }
        
        switch note.value.division {
        case 1: return .semibreve
        case 2: return .open
        default: return .filled
        }
    }
    
    private func leadingLayoutItems(forNote note: Note, pitch: Pitch) -> [AdjacentLayoutItem] {
        
        guard let accidental = pitch.accidental else {
            return []
        }
                
        switch accidental {
        case .sharp:
            return [SharpSymbol(stavePosition: pitch.stavePosition, staveOffset: pitch.staveOffset)]
        case .flat:
            return [FlatSymbol(stavePosition: pitch.stavePosition, staveOffset: pitch.staveOffset)]
        case .natural:
            return [NaturalSymbol(stavePosition: pitch.stavePosition, staveOffset: pitch.staveOffset)]
        }
    }
    
    private func trailingLayoutItems(forNote note: Note, pitch: Pitch) -> [AdjacentLayoutItem] {
        
        func makeDotSymbol(forNote note: Note) -> DotSymbol {
            let symbol = DotSymbol()
            symbol.pitch = note.highestPitch
            return symbol
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
