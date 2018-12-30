//
//  NoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 23/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteRenderer {
    
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
        
        if let stemPath = makeStemPath(forNote: note) {
            paths.append(stemPath)
        }
        
        return paths
    }
    
    static private func makePaths(forNoteCluster notes: [NoteSymbol]) -> [Path] {
        
        var paths = [Path]()
        
        for note in notes {
            var notePaths = [Path]()
            
            let headPath = makeHeadPath(forNote: note)
            notePaths.append(headPath)
            
            if let stemPath = makeStemPath(forNote: note) {
                notePaths.append(stemPath)
            }
            
            paths += notePaths
        }
        
        let stemRects = notes
            .compactMap { self.stemRect(forNote: $0) }

        var beamPath = Path()
        beamPath.move(to: stemRects.first!.topLeft)
        stemRects.dropFirst().forEach { beamPath.addLine(to: $0.topLeft) }
        paths.append(beamPath)
        
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
    
    static private func makeStemPath(forNote note: NoteSymbol) -> Path? {
        
        if note.hasStem == false {
            return nil
        }
        
        guard let stemRect = self.stemRect(forNote: note) else {
            return nil
        }
        
        var stemPath = Path()
        stemPath.addRect(stemRect)
        stemPath.drawStyle = .fill
        return stemPath
    }
    
    static private func stemRect(forNote note: NoteSymbol) -> Rect? {
        
        if note.hasStem == false {
            return nil
        }
        
        let stemWidth = 0.1
        let stemHeight = 3.0
        
        let stemX = 1.25
        let stemY = 0.6
        
        return Rect(x: stemX,
                    y: stemY,
                    width: stemWidth,
                    height: stemHeight)
            .translated(x: note.position.x, y: note.position.y)
    }
}
