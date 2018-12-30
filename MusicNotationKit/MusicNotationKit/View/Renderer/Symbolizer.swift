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
    let t_duration: Time
    let numberOfBeams: Int
    let hasStem: Bool
    var connectBeamsToPreviousNote: Bool
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
        
        for bar in composition.bars {
            symbols.append(.barline(makeBarlineSymbol()))
            symbols += makeSymbols(forBar: bar)
        }
        
        symbols.append(.barline(makeBarlineSymbol()))

        return symbols
    }
    
    private func makeBarlineSymbol() -> BarlineSymbol {
        return BarlineSymbol(xPosition: 0)
    }
    
    private func makeSymbols(forBar bar: Bar) -> [Symbol] {
        
        var symbols = [Symbol]()
        lastSymbolCanConnectBeams = false
        
        for note in bar.notes {
            symbols += makeSymbols(forNote: note)
        }
        
        symbols = breakIllegalNoteBeams(inBarSymbols: symbols)
        
        return symbols
    }
    
    private func makeSymbols(forNote note: Note) -> [Symbol] {
        
        switch note.value {
        case .whole:
            let symbol = NoteSymbol(headStyle: .semibreve,
                                    pitch: note.pitch,
                                    duration: 1,
                                    t_duration: Time(crotchets: 4),
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
                                    t_duration: Time(crotchets: 2),
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
                                    t_duration: Time(crotchets: 1),
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
                                    t_duration: Time(quavers: 1),
                                    numberOfBeams: 1,
                                    hasStem: true,
                                    connectBeamsToPreviousNote: lastSymbolCanConnectBeams,
                                    position: .zero)
            lastSymbolCanConnectBeams = true
            return [.note(symbol)]
        case .sixteenth:
            let symbol = NoteSymbol(headStyle: .filled,
                                    pitch: note.pitch,
                                    duration: 1.0 / 16,
                                    t_duration: Time(semiquavers: 1),
                                    numberOfBeams: 2,
                                    hasStem: true,
                                    connectBeamsToPreviousNote: lastSymbolCanConnectBeams,
                                    position: .zero)
            lastSymbolCanConnectBeams = true
            return [.note(symbol)]
        }
    }
    
    private func breakIllegalNoteBeams(inBarSymbols symbols: [Symbol]) -> [Symbol] {
        
        // THIS METHOD CURRENTLY ASSUMES 4/4 TIME!
        
        var symbols = symbols
        
        // Break quavers at the middle
        symbols = breakNoteBeams(inBarSymbols: symbols,
                                 withDuration: Time(quavers: 1),
                                 every: 2)
        
        // Break semiquavers on the beat
        symbols = breakNoteBeams(inBarSymbols: symbols,
                                 withDuration: Time(semiquavers: 1),
                                 every: 1)
        
        // Break quavers where there are semiquavers on either side

        return symbols
    }
    
    func breakNoteBeams(inBarSymbols symbols: [Symbol],
                        withDuration targetDuration: Time,
                        every breakDivision: Int) -> [Symbol] {
        
        var newSymbols = [Symbol]()
        
        var lastBreakIndex = -1
        
        var currentTime = Time.zero
        
        for symbol in symbols {
            switch symbol {
            case .note(var noteSymbol):
                let nextBreakIndex = currentTime.convertedTruncating(toDivision: breakDivision).value
                if noteSymbol.t_duration <= targetDuration && nextBreakIndex != lastBreakIndex {
                    lastBreakIndex = nextBreakIndex
                    noteSymbol.connectBeamsToPreviousNote = false
                }
                currentTime += noteSymbol.t_duration
                newSymbols.append(.note(noteSymbol))
            default:
                newSymbols.append(symbol)
            }
        }
        
        return newSymbols
    }
    
}
