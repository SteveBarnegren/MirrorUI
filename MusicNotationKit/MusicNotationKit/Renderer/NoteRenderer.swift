//
//  NoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteRenderer {
    
    func paths(forNotes notes: [Note]) -> [Path] {
        
        var paths = [Path]()
        
        for note in notes {
            paths.append(maybe: makeHeadPath(forNote: note))
        }
        
        return paths
    }
    
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
        
        return path.translated(x: note.position.x, y: note.position.y)
    }
}
