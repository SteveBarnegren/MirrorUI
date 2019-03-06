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
        
        switch note.value {
        case .whole:
            description = NoteSymbolDescription(headStyle: .semibreve, hasStem: false, numberOfBeams: 0)
        case .half:
            description = NoteSymbolDescription(headStyle: .open, hasStem: true, numberOfBeams: 0)
        case .quarter:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: 0)
        case .eighth:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: 1)
        case .sixteenth:
            description = NoteSymbolDescription(headStyle: .filled, hasStem: true, numberOfBeams: 2)
        }
        
        return description
    }
}
