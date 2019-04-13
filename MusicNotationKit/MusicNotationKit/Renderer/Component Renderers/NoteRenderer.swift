//
//  NoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteRenderer {
    
    private let preferredStemHeight = 3.5
    private let stemXOffet = 0.55
    private let stemWidth = 0.1
    private let beamWidth = 0.3
    private let noteHeadWidth = 1.4
    
    func paths(forNotes notes: [Note]) -> [Path] {
        
        var paths = [Path]()
        
        var noteCluster = [Note]()
        
        func renderNoteCluster() {
            
            guard noteCluster.isEmpty == false else {
                return
            }
            
            paths += makePaths(forNoteCluster: noteCluster)
            noteCluster.removeAll()
        }
        
        var lastNoteWasConnected = false
        for note in notes {
            // Is is the first note of the cluster?
            if note.symbolDescription.numberOfForwardBeamConnections > 0 && lastNoteWasConnected == false {
                renderNoteCluster()
                noteCluster.append(note)
            }
                // Is it the middle of the cluster?
            else if note.symbolDescription.numberOfForwardBeamConnections > 0 && lastNoteWasConnected == true {
                noteCluster.append(note)
            }
                // Is the end of the cluster?
            else if note.symbolDescription.numberOfForwardBeamConnections == 0 && lastNoteWasConnected == true {
                noteCluster.append(note)
                renderNoteCluster()
            }
                // Otherwise it's an unconnected note
            else {
                paths += makePaths(forNote: note)
            }
            lastNoteWasConnected = note.symbolDescription.numberOfForwardBeamConnections > 0
        }
        renderNoteCluster()
        
        return paths
    }
    
    // MARK: - Isolated Notes
    
    private func makePaths(forNote note: Note) -> [Path] {
        
        var paths = [Path]()
        paths.append(maybe: makeHeadPath(forNote: note))
        paths.append(maybe: makeStemPath(forNote: note, to: note.position.y + preferredStemHeight))
        
        if note.symbolDescription.numberOfBeams == 1 {
            var noteTailPath = Path(commands: makeQuaverTailCommands()).translated(x: note.xPosition + stemXOffet, y: note.yPosition + 1.75)
            noteTailPath.drawStyle = .fill
            paths.append(noteTailPath)
        }
      
        return paths
    }
    
    private func makeQuaverTailCommands() -> [Path.Command] {
        // A note tail, anchored to the left
        let commands: [Path.Command] = [
            .move(Point(0.028177234195949308, 0.22361714423650725)),
            .curve(Point(0.1796576688116412, -0.26326044118239594), c1: Point(0.36589881412387104, 0.13806570405953167), c2: Point(0.21003653045372273, -0.15850308628952214)),
            .curve(Point(0.028177234195949308, 0.5), c1: Point(0.4571075440584742, 0.11569020480229597), c2: Point(0.03196085061274678, 0.27025900632689404)),
            .close,
        ].scaled(3.5)
        return commands
    }
    
    // MARK: - Note Clusters (connected with beams)
    
    private func makePaths(forNoteCluster notes: [Note]) -> [Path] {
        
        var paths = [Path]()
        
        // Work out the beam height
        let beamY = notes.map { $0.position.y }.max().orZero() + preferredStemHeight
        
        var previousNote: Note?
        
        // Draw notes with stems
        for note in notes {
            var notePaths = [Path]()
            
            notePaths.append(maybe: makeHeadPath(forNote: note))
            notePaths.append(maybe: makeStemPath(forNote: note, to: beamY))
            
            // Draw beam connections from the previous note
            if let previousNote = previousNote {
                for beam in previousNote.symbolDescription.beams where beam.style == .connectedToNext {
                    notePaths.append(makeBeamPath(fromNote: previousNote, toNote: note, beamYPosition: beamY, beamIndex: beam.index))
                }
            }
            
            // Draw cutoff beam connections
            for beam in note.symbolDescription.beams where beam.style == .cutOffLeft {
                notePaths.append(makeCutOffBeamPath(forNote: note, beamYPosition: beamY, beamIndex: beam.index, rightSide: false))
            }
            for beam in note.symbolDescription.beams where beam.style == .cutOffRight {
                notePaths.append(makeCutOffBeamPath(forNote: note, beamYPosition: beamY, beamIndex: beam.index, rightSide: true))
            }
            
            paths += notePaths
            
            previousNote = note
        }
        
        return paths
    }
    
    private func makeBeamPath(fromNote: Note, toNote: Note, beamYPosition: Double, beamIndex: Int) -> Path {
        
        let beamSeparation = 0.4
        
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
    
    private func makeCutOffBeamPath(forNote note: Note, beamYPosition: Double, beamIndex: Int, rightSide: Bool) -> Path {
        
        let beamSeparation = 0.4
        
        let x: Double
        if rightSide {
            x = note.position.x + stemXOffet + stemWidth
        } else {
            x = note.position.x + stemXOffet - 1
        }
        
        let beamRect = Rect(x: x,
                            y: beamYPosition - (Double(beamIndex) * (beamSeparation + beamWidth)),
                            width: 1,
                            height: -beamWidth)
        
        var path = Path()
        path.addRect(beamRect)
        path.drawStyle = .fill
        return path
    }
    
    // MARK: - Components
    
    private func makeHeadPath(forNote note: Note) -> Path? {
        
        let path: Path
        
        switch note.symbolDescription.headStyle {
        case .semibreve:
            path = SymbolPaths.semibreve
        case .open:
            path = SymbolPaths.openNoteHead
        case .filled:
            path = SymbolPaths.filledNoteHead
        case .none:
            return nil
        }
        
        return path.translated(x: note.position.x - noteHeadWidth/2, y: note.position.y)
    }
    
    private func makeStemPath(forNote note: Note, to stemEndY: Double) -> Path? {
        
        if note.symbolDescription.hasStem == false {
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
    
    private func stemRect(fromNote note: Note, to stemEndY: Double) -> Rect? {
        
        if note.symbolDescription.hasStem == false {
            return nil
        }
        
        let stemYOffset = 0.6
        
        return Rect(x: note.position.x + stemXOffet,
                    y: note.position.y + stemYOffset,
                    width: stemWidth,
                    height: stemEndY - note.position.y - stemYOffset)
    }
    
}
