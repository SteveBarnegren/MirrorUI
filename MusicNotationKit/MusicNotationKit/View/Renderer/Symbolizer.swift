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
    
    var time = Time.zero
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
        
        for note in bar.notes {
            symbols += makeSymbols(forNote: note)
        }
        
        symbols = addTimeInformation(toSymbols: symbols)
        
        symbols.processNoteSymbols {
            return self.applyNoteBeams(toSymbols: $0)
        }
        
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
                                    position: .zero,
                                    time: .zero)
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
                                    position: .zero,
                                    time: .zero)
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
                                    position: .zero,
                                    time: .zero)
            lastSymbolCanConnectBeams = false
            return [.note(symbol)]
        case .eighth:
            let symbol = NoteSymbol(headStyle: .filled,
                                    pitch: note.pitch,
                                    duration: 0.125,
                                    t_duration: Time(quavers: 1),
                                    numberOfBeams: 1,
                                    hasStem: true,
                                    connectBeamsToPreviousNote: false,
                                    position: .zero,
                                    time: .zero)
            lastSymbolCanConnectBeams = true
            return [.note(symbol)]
        case .sixteenth:
            let symbol = NoteSymbol(headStyle: .filled,
                                    pitch: note.pitch,
                                    duration: 1.0 / 16,
                                    t_duration: Time(semiquavers: 1),
                                    numberOfBeams: 2,
                                    hasStem: true,
                                    connectBeamsToPreviousNote: false,
                                    position: .zero,
                                    time: .zero)
            lastSymbolCanConnectBeams = true
            return [.note(symbol)]
        }
    }
    
    // MARK: - Time Information
    
    private func addTimeInformation(toSymbols symbols: [Symbol]) -> [Symbol] {
        
        var time = Time.zero
        
        var processedSymbols = [Symbol]()
        
        for symbol in symbols {
            switch symbol {
            case .note(var noteSymbol):
                noteSymbol.time = time
                time += noteSymbol.t_duration
                processedSymbols.append(.note(noteSymbol))
            case .barline:
                break
            }
        }
        
        return processedSymbols
    }
    
    // MARK: - Beaming
    
    func applyNoteBeams(toSymbols noteSymbols: [NoteSymbol]) -> [NoteSymbol] {
        // THIS METHOD ASSUMES 4/4 TIME!
        
        var lastBeat = -1
        var processedNotes = [NoteSymbol]()
        
        for note in noteSymbols {
            var note = note
            let beat = note.time.convertedTruncating(toDivision: 4).value
            note.connectBeamsToPreviousNote = beat == lastBeat
            lastBeat = beat
            processedNotes.append(note)
        }
        
        return processedNotes
    }
}

// MARK: - Array Extensions

extension Array where Element == Symbol {
    
    mutating func processNoteSymbols(process: ([NoteSymbol]) -> [NoteSymbol]) {
        
        var noteSymbols = [NoteSymbol]()
        var noteIndexes = [Int]()
        
        for (index, symbol) in self.enumerated() {
            switch symbol {
            case .note(let noteSymbol):
                noteSymbols.append(noteSymbol)
                noteIndexes.append(index)
            default:
                break
            }
        }
        
        let processedNoteSymbols = process(noteSymbols)
        precondition(processedNoteSymbols.count == noteIndexes.count)
        
        for (newNoteSymbol, index) in zip(processedNoteSymbols, noteIndexes) {
            self[index] = .note(newNoteSymbol)
        }
    }
}
