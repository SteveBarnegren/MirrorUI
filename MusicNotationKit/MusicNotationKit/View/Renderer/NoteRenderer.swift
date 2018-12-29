//
//  NoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 23/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteRenderer {
    
    static func paths(forPositionedSymbols positionedSymbols: [PositionedItem<NoteSymbol>]) -> [Path] {
        
        var paths = [Path]()
        
        var noteCluster = [PositionedItem<NoteSymbol>]()
        
        func renderNoteCluster() {
            
            guard noteCluster.isEmpty == false else {
                return
            }
            
            paths += makePaths(forNoteCluster: noteCluster)
            noteCluster.removeAll()
        }
        
        for positionedNote in positionedSymbols {
            if positionedNote.item.numberOfBeams > 0 && positionedNote.item.connectBeamsToPreviousNote {
                noteCluster.append(positionedNote)
            } else {
                renderNoteCluster()
                noteCluster.append(positionedNote)
            }
        }
        renderNoteCluster()
        
        return paths
    }
    
    static private func makePaths(forNote item: PositionedItem<NoteSymbol>) -> [Path] {
        
        var paths = [Path]()
        
        let headPath = makeHeadPath(forNote: item)
        paths.append(headPath)
        
        if let stemPath = makeStemPath(forNote: item) {
            paths.append(stemPath)
        }
        
        return paths
    }
    
    static private func makePaths(forNoteCluster items: [PositionedItem<NoteSymbol>]) -> [Path] {
        
        var paths = [Path]()
        
        for item in items {
            var notePaths = [Path]()
            
            let headPath = makeHeadPath(forNote: item)
            notePaths.append(headPath)
            
            if let stemPath = makeStemPath(forNote: item) {
                notePaths.append(stemPath)
            }
            
            paths += notePaths
        }
        
        let stemRects = items
            .compactMap { self.stemRect(forNote: $0) }

        var beamPath = Path()
        beamPath.move(to: stemRects.first!.topLeft)
        stemRects.dropFirst().forEach { beamPath.addLine(to: $0.topLeft) }
        paths.append(beamPath)
        
        return paths
    }
    
    static private func makeHeadPath(forNote note: PositionedItem<NoteSymbol>) -> Path {
        
        let path: Path
        
        switch note.item.headStyle {
        case .semibreve:
            path = SymbolPaths.semibreve
        case .open:
            path = SymbolPaths.openNoteHead
        case .filled:
            path = SymbolPaths.filledNoteHead
        }
        
        return path.translated(x: note.position.x, y: note.position.y)
    }
    
    static private func makeStemPath(forNote note: PositionedItem<NoteSymbol>) -> Path? {
        
        if note.item.hasStem == false {
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
    
    static private func stemRect(forNote note: PositionedItem<NoteSymbol>) -> Rect? {
        
        if note.item.hasStem == false {
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
