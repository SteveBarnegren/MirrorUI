//
//  Tokenizer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

enum Token {
    case barline
    case semibreve(Pitch)
    case crotchet(Pitch)
    case minim(Pitch)
}

class Tokenizer {
    
    func tokenize(composition: Composition) -> [Token] {
        
        var tokens = [Token]()
        
        tokens.append(.barline)
        
        for item in composition.items {
            switch item {
            case .note(let note):
                tokens += makeTokens(forNote: note)
            case .barline:
                tokens.append(.barline)
            }
        }
        
        tokens.append(.barline)
        
        return tokens
    }
    
    private func makeTokens(forNote note: Note) -> [Token] {
        
        switch note.value {
        case .whole:
            return [.semibreve(note.pitch)]
        case .half:
            return [.minim(note.pitch)]
        case .quarter:
            return [.crotchet(note.pitch)]
        }
    }

}
