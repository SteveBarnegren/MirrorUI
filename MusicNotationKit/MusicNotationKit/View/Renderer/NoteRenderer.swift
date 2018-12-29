//
//  NoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 23/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteRenderer {
    
//    static func paths(forNoteToken noteToken: NoteToken, centerY: Double) -> [Path] {
//
//        var paths = [Path]()
//
//        paths.append(makeHeadPath(forToken: noteToken))
//
//        if noteToken.hasStem {
//            paths.append(makeStemPath())
//        }
//
//        return paths.map { $0.translated(x: 0, y: centerY + Double(noteToken.pitch.staveOffset)/2 - 0.5) }
//    }
    
    static func paths(forPositionedTokens positionedTokens: [PositionedItem<NoteToken>], centerY: Double) -> [Path] {
        
        var paths = [Path]()
        
        var noteCluster = [PositionedItem<NoteToken>]()
        
        func renderNoteCluster() {
            for positionedNote in noteCluster {
                
                var notePaths = [Path]()
                
                notePaths.append(
                    makeHeadPath(forToken: positionedNote.item)
                )
                if let stemPath = makeStemPath(forToken: positionedNote.item) {
                    notePaths.append(stemPath)
                }
                paths += notePaths.map { $0.translated(x: positionedNote.xPos, y: centerY + Double(positionedNote.item.pitch.staveOffset)/2 - 0.5) }
            }
            noteCluster.removeAll()
        }
        
        for positionedNote in positionedTokens {
            if positionedNote.item.connectBeamsToPreviousNote {
                noteCluster.append(positionedNote)
            } else {
                renderNoteCluster()
                noteCluster.append(positionedNote)
            }
        }
        renderNoteCluster()
        
        return paths
    }
    
    static private func makeHeadPath(forToken token: NoteToken) -> Path {
        
        let path: Path
        
        switch token.headStyle {
        case .semibreve:
            path = SymbolPaths.semibreve
        case .open:
            path = SymbolPaths.openNoteHead
        case .filled:
            path = SymbolPaths.filledNoteHead
        }
        
        return path
    }
    
    static private func makeStemPath(forToken token: NoteToken) -> Path? {
        
        if token.hasStem == false {
            return nil
        }
        
        let stemWidth = 0.1
        let stemHeight = 3.0
        
        let stemX = 1.25
        let stemY = 0.6
        
        let stemRect = Rect(x: stemX,
                            y: stemY,
                            width: stemWidth,
                            height: stemHeight)
        
        var stemPath = Path()
        stemPath.addRect(stemRect)
        stemPath.drawStyle = .fill
        return stemPath
    }
}
