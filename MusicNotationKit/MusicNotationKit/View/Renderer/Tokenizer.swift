//
//  Tokenizer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

struct NoteToken {
    
    enum HeadStyle {
        case semibreve
        case open
        case filled
    }
    
    let headStyle: HeadStyle
    let pitch: Pitch
    let duration: Double
    let numberOfBeams: Int
    let hasStem: Bool
    let connectBeamsToPreviousNote: Bool
}

enum Token {
    case barline
    case note(NoteToken)
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
            let token = NoteToken(headStyle: .semibreve,
                                  pitch: note.pitch,
                                  duration: 1,
                                  numberOfBeams: 0,
                                  hasStem: false,
                                  connectBeamsToPreviousNote: false)
            return [.note(token)]
        case .half:
            let token = NoteToken(headStyle: .open,
                                  pitch: note.pitch,
                                  duration: 0.5,
                                  numberOfBeams: 0,
                                  hasStem: true,
                                  connectBeamsToPreviousNote: false)
            return [.note(token)]
        case .quarter:
            let token = NoteToken(headStyle: .filled,
                                  pitch: note.pitch,
                                  duration: 0.25,
                                  numberOfBeams: 0,
                                  hasStem: true,
                                  connectBeamsToPreviousNote: false)
            return [.note(token)]
        }
    }
    
}
