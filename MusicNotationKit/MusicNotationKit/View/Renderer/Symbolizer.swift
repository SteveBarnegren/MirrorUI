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
    
    enum BeamStyle {
        case connectedToNext
        case cutOffLeft
        case cutOffRight
    }
    
    struct Beam {
        let index: Int
        let style: BeamStyle
    }
    
    let headStyle: HeadStyle
    let pitch: Pitch
    let duration: Time
    let hasStem: Bool
    let numberOfBeams: Int
    
    var position = Point.zero
    var time = Time.zero
    var beams = [Beam]()
    
    var numberOfForwardBeamConnections: Int {
        
        var num = 0
        
        for beam in beams {
            if beam.style == .connectedToNext {
                num += 1
            }
        }
        
        return num
    }
    
    init(headStyle: HeadStyle, pitch: Pitch, duration: Time, hasStem: Bool, numberOfBeams: Int) {
        self.headStyle = headStyle
        self.pitch = pitch
        self.duration = duration
        self.hasStem = hasStem
        self.numberOfBeams = numberOfBeams
    }
    
}

struct BarlineSymbol {
    var xPosition: Double
}

enum Symbol {
    case barline(BarlineSymbol)
    case note(NoteSymbol)
}

class Symbolizer {
    
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
                                    duration: Time(crotchets: 4),
                                    hasStem: false,
                                    numberOfBeams: 0)
            return [.note(symbol)]
        case .half:
            let symbol = NoteSymbol(headStyle: .open,
                                    pitch: note.pitch,
                                    duration: Time(crotchets: 2),
                                    hasStem: true,
                                    numberOfBeams: 0)
            return [.note(symbol)]
        case .quarter:
            let symbol = NoteSymbol(headStyle: .filled,
                                    pitch: note.pitch,
                                    duration: Time(crotchets: 1),
                                    hasStem: true,
                                    numberOfBeams: 0)
            return [.note(symbol)]
        case .eighth:
            let symbol = NoteSymbol(headStyle: .filled,
                                    pitch: note.pitch,
                                    duration: Time(quavers: 1),
                                    hasStem: true,
                                    numberOfBeams: 1)
            return [.note(symbol)]
        case .sixteenth:
            let symbol = NoteSymbol(headStyle: .filled,
                                    pitch: note.pitch,
                                    duration: Time(semiquavers: 1),
                                    hasStem: true,
                                    numberOfBeams: 2)
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
                time += noteSymbol.duration
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
        
        let notesByBeat = noteSymbols.chunked(atChangeTo: { $0.time.convertedTruncating(toDivision: 4).value })
        return Array(notesByBeat.map { applyBeams(toNoteCluster: $0) }.joined())
    }
    
    func applyBeams(toNoteCluster noteCluster: [NoteSymbol]) -> [NoteSymbol] {
        
        print("\n\n*********************\n\n")
        dump(noteCluster)
        
        var processedNotes = [NoteSymbol]()
     
        var lastNumberOfForwardConnections = 0
        
        for (index, note) in noteCluster.enumerated() {
            var note = note            
            var beamsLeft = note.numberOfBeams
            
            // forward beam connections
            var numberOfForwardBeams = 0
            if let next = noteCluster[maybe: index+1] {
                numberOfForwardBeams = min(note.numberOfBeams, next.numberOfBeams)
            }
            
            note.beams = (0..<numberOfForwardBeams).map { NoteSymbol.Beam(index: $0, style: .connectedToNext) }

            // Remove accounted for beams by forward or backward connections
            beamsLeft -= max(lastNumberOfForwardConnections, numberOfForwardBeams)
            
            // Add remaining beams as cut-offs
            while beamsLeft > 0 {
                let beamStyle: NoteSymbol.BeamStyle = (index == noteCluster.count - 1) ? .cutOffLeft : .cutOffRight
                let beam = NoteSymbol.Beam(index: note.numberOfBeams - beamsLeft, style: beamStyle)
                note.beams.append(beam)
                beamsLeft -= 1
            }
            
            lastNumberOfForwardConnections = note.numberOfForwardBeamConnections
            processedNotes.append(note)
        }
        
        //print("\n\n*********************\n\n")
        //dump(processedNotes)
        
        return processedNotes
    }
    
//    func applyNoteBeams(toSymbols noteSymbols: [NoteSymbol]) -> [NoteSymbol] {
//        // THIS METHOD ASSUMES 4/4 TIME!
//
//        var lastBeat = -1
//        var processedNotes = [NoteSymbol]()
//
//        for note in noteSymbols {
//            var note = note
//            let beat = note.time.convertedTruncating(toDivision: 4).value
//            note.connectBeamsToPreviousNote = beat == lastBeat
//            lastBeat = beat
//            processedNotes.append(note)
//        }
//
//        return processedNotes
//    }
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

struct BeamingRule {
    let chunkSize: Time
    let minimumNoteDuration: Time
}
