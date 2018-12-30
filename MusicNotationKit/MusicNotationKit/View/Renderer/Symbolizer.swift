//
//  Symbolizer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

struct NoteSymbol {
    
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
    var position: Point
}

struct BarlineSymbol {
    var xPosition: Double
}

enum Symbol {
    case barline(BarlineSymbol)
    case note(NoteSymbol)
}

class Symbolizer {
    
    var lastSymbolCanConnectBeams = false
    
    func symbolize(composition: Composition) -> [Symbol] {
        
        lastSymbolCanConnectBeams = false
        
        var symbols = [Symbol]()
        
        symbols.append(.barline(makeBarlineSymbol()))
        
        for item in composition.items {
            switch item {
            case .note(let note):
                symbols += makeSymbols(forNote: note)
            case .barline:
                symbols.append(.barline(makeBarlineSymbol()))
            }
        }
        
        symbols.append(.barline(makeBarlineSymbol()))

        return symbols
    }
    
    private func makeBarlineSymbol() -> BarlineSymbol {
        return BarlineSymbol(xPosition: 0)
    }
    
    private func makeSymbols(forNote note: Note) -> [Symbol] {
        
        switch note.value {
        case .whole:
            let symbol = NoteSymbol(headStyle: .semibreve,
                                    pitch: note.pitch,
                                    duration: 1,
                                    numberOfBeams: 0,
                                    hasStem: false,
                                    connectBeamsToPreviousNote: false,
                                    position: .zero)
            lastSymbolCanConnectBeams = false
            return [.note(symbol)]
        case .half:
            let symbol = NoteSymbol(headStyle: .open,
                                    pitch: note.pitch,
                                    duration: 0.5,
                                    numberOfBeams: 0,
                                    hasStem: true,
                                    connectBeamsToPreviousNote: false,
                                    position: .zero)
            lastSymbolCanConnectBeams = false
            return [.note(symbol)]
        case .quarter:
            let symbol = NoteSymbol(headStyle: .filled,
                                    pitch: note.pitch,
                                    duration: 0.25,
                                    numberOfBeams: 0,
                                    hasStem: true,
                                    connectBeamsToPreviousNote: false,
                                    position: .zero)
            lastSymbolCanConnectBeams = false
            return [.note(symbol)]
        case .eighth:
            let symbol = NoteSymbol(headStyle: .filled,
                                    pitch: note.pitch,
                                    duration: 0.125,
                                    numberOfBeams: 1,
                                    hasStem: true,
                                    connectBeamsToPreviousNote: lastSymbolCanConnectBeams,
                                    position: .zero)
            lastSymbolCanConnectBeams = true
            return [.note(symbol)]
        }
    }
    
}
