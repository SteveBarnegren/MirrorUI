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
        case 8:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: 1)
        case 16:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: 2)
        default:
            fatalError("Unsupported division: \(division)")
        }
        
        return description
    }
}
