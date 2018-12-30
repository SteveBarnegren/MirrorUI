//
//  NoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 23/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteRenderer {
    
    static let preferredStemHeight = 3.5
    static let stemXOffet = 1.25
    static let stemWidth = 0.1
    static let beamWidth = 0.3

    static func paths(forNotes notes: [NoteSymbol]) -> [Path] {
        
        var paths = [Path]()
        
        var noteCluster = [NoteSymbol]()
        
        func renderNoteCluster() {
            
            guard noteCluster.isEmpty == false else {
                return
            }
            
            paths += makePaths(forNoteCluster: noteCluster)
            noteCluster.removeAll()
        }
        
        for note in notes {
            if note.numberOfBeams > 0 && note.connectBeamsToPreviousNote {
                noteCluster.append(note)
            } else {
                renderNoteCluster()
                noteCluster.append(note)
            }
        }
        renderNoteCluster()
        
        return paths
    }
    
    static private func makePaths(forNote note: NoteSymbol) -> [Path] {
        
        var paths = [Path]()
        
        let headPath = makeHeadPath(forNote: note)
        paths.append(headPath)
        
        if let stemPath = makeStemPath(fromNote: note, to: note.position.y + preferredStemHeight) {
            paths.append(stemPath)
        }
        
        return paths
    }
    
    static private func makePaths(forNoteCluster notes: [NoteSymbol]) -> [Path] {
        
        var paths = [Path]()
        
        // Work out the beam height
        let beamY = notes.map { $0.position.y }.max().orZero() + preferredStemHeight
        
        // Draw notes with stems
        for note in notes {
            var notePaths = [Path]()
            
            let headPath = makeHeadPath(forNote: note)
            notePaths.append(headPath)
            
            let stemPath = makeStemPath(fromNote: note, to: beamY)
            notePaths.append(maybe: stemPath)

            paths += notePaths
        }
        
        // Draw the beams
        let maximumNumberOfBeams = notes.map { $0.numberOfBeams }.max().orOne()
        
        for beamIndex in 0..<maximumNumberOfBeams {
            
            var beamedNotes = [NoteSymbol]()
            
            func renderBeamedNotes() {
                if beamedNotes.count >= 2 {
                    paths.append(makeBeamPath(fromNote: beamedNotes.first!, toNote: beamedNotes.last!, beamYPosition: beamY, beamIndex: beamIndex))
                } else if beamedNotes.isEmpty == false {
                    fatalError("Single beamed notes are not supported")
                }
            }
            
            for note in notes {
                if note.numberOfBeams > beamIndex {
                    beamedNotes.append(note)
                } else {
                    renderBeamedNotes()
                }
            }
            renderBeamedNotes()
        }
        
        return paths
    }
    
    static private func makeHeadPath(forNote note: NoteSymbol) -> Path {
        
        let path: Path
        
        switch note.headStyle {
        case .semibreve:
            path = SymbolPaths.semibreve
        case .open:
            path = SymbolPaths.openNoteHead
        case .filled:
            path = SymbolPaths.filledNoteHead
        }
        
        return path.translated(x: note.position.x, y: note.position.y)
    }
    
    static private func makeStemPath(fromNote note: NoteSymbol, to stemEndY: Double) -> Path? {
        
        if note.hasStem == false {
            return nil
        }
        
        guard let stemRect = self.stemRect(fromNote: note, to: stemEndY) else {
            return nil
        }
        
        var stemPath = Path()
        stemPath.addRect(stemRect)
        stemPath.drawStyle = .fill
        return stemPath
    }
    
    static private func stemRect(fromNote note: NoteSymbol, to stemEndY: Double) -> Rect? {
        
        if note.hasStem == false {
            return nil
        }
        
        let stemYOffset = 0.6
        
        return Rect(x: note.position.x + stemXOffet,
                    y: note.position.y + stemYOffset,
                    width: stemWidth,
                    height: stemEndY - note.position.y - stemYOffset)
    }
    
    static private func makeBeamPath(fromNote: NoteSymbol, toNote: NoteSymbol, beamYPosition: Double, beamIndex: Int) -> Path {
        
        let beamSeparation = 0.5
        
        let beamStartX = fromNote.position.x + stemXOffet
        let beamEndX = toNote.position.x + stemXOffet + stemWidth
        let beamRect = Rect(x: beamStartX,
                            y: beamYPosition - (Double(beamIndex) * (beamSeparation + beamWidth)),
                            width: beamEndX - beamStartX,
                            height: -beamWidth)
        
        var path = Path()
        path.addRect(beamRect)
        path.drawStyle = .fill
        return path
    }
}