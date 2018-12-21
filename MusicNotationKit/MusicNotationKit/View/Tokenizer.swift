//
//  Tokenizer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

enum Token {
    case semibreve
    case crotchet
    case minim
}

class Tokenizer {
    
    func tokenize(composition: Composition) -> [Token] {
        
        var tokens = [Token]()
        
        for note in composition.notes {
            
            switch note.value {
            case .whole:
                tokens.append(.semibreve)
            case .half:
                tokens.append(.minim)
            case .quarter:
                tokens.append(.crotchet)
            }
        }
        
        return tokens
    }

}
