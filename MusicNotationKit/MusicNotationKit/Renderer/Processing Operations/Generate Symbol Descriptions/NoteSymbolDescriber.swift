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
        
        var headStyle: NoteSymbolDescription.HeadStyle
        let hasStem: Bool
        let numberOfTails: Int
        
        switch note.value.division {
        case 1:
            headStyle = .semibreve
            hasStem = false
            numberOfTails = 0
        case 2:
            headStyle = .open
            hasStem = true
            numberOfTails = 0
        case 4:
            headStyle = .filled
            hasStem = true
            numberOfTails = 0
        default:
            headStyle = .filled
            hasStem = true
            numberOfTails = self.numberOfTails(forDivision: note.value.division)
        }
        
        if note.noteHeadType == .cross {
            headStyle = .cross
        }
        
        let description = NoteSymbolDescription(headStyle: headStyle,
                                                hasStem: hasStem,
                                                numberOfTails: numberOfTails)
        
        description.trailingLayoutItems = trailingLayoutItems(forNote: note)
        description.leadingLayoutItems = leadingLayoutItems(forNote: note)
        
        return description
    }
    
    private func numberOfTails(forDivision division: Int) -> Int {
        
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
    
    private func leadingLayoutItems(forNote note: Note) -> [AdjacentLayoutItem] {
        
        var items = [AdjacentLayoutItem]()
        
        switch note.accidental {
        case .none:
            break
        case .sharp:
            items.append(SharpSymbol())
        case .flat:
            items.append(FlatSymbol())
        case .natural:
            items.append(NaturalSymbol())
        }
        
        return items
    }
    
    private func trailingLayoutItems(forNote note: Note) -> [AdjacentLayoutItem] {
        
        func makeDotSymbol(forNote note: Note) -> DotSymbol {
            let symbol = DotSymbol()
            symbol.pitch = note.pitch
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
