//
//  Symbolizer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteSymbolDescriber {
    
    func symbolDescription(forNote note: Note) -> NoteSymbolDescription {
        
        let description: NoteSymbolDescription
        
        let division = note.value.division
        switch division {
        case 1:
            description = NoteSymbolDescription(headStyle: .semibreve, hasStem: false, numberOfBeams: 0)
        case 2:
            description = NoteSymbolDescription(headStyle: .open, hasStem: true, numberOfBeams: 0)
        case 4:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: 0)
        default:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: numberOfBeams(forDivision: division))
        }
        
        description.trailingSymbols = trailingDotSymbols(forNote: note)
        
        return description
    }
    
    private func numberOfBeams(forDivision division: Int) -> Int {
        
        switch division {
        case 1: return 0
        case 2: return 0
        case 4: return 0
        case 8: return 1
        case 16: return 2
        case 32: return 3
        case 64: return 4
        case 128: return 5
        case 256: return 6
        case 512: return 7
        case 1024: return 8
        case 2048: return 9
        case 4096: return 10
        case 8192: return 11
        default:
            fatalError("division \(division) not supported!")
        }
    }
    
    private func trailingDotSymbols(forNote note: Note) -> [HorizontallyPlacedSymbol] {
        
        let numberOfDots: Int
        
        switch note.value.dots {
        case .none: numberOfDots = 0
        case .dotted: numberOfDots = 1
        case .doubleDotted: numberOfDots = 2
        }
        
        return Array(repeating: DotSymbol(), count: numberOfDots)
    }
}
