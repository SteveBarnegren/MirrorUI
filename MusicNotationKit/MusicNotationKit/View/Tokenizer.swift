//
//  Tokenizer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

enum Token {
    case semibreve(Pitch)
    case crotchet(Pitch)
    case minim(Pitch)
}

class Tokenizer {
    
    func tokenize(composition: Composition) -> [Token] {
        
        var tokens = [Token]()
        
        for note in composition.notes {
            
            switch note.value {
            case .whole:
                tokens.append(.semibreve(note.pitch))
            case .half:
                tokens.append(.minim(note.pitch))
            case .quarter:
                tokens.append(.crotchet(note.pitch))
            }
        }
        
        return tokens
    }

}
