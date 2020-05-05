//
//  TieRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class TieRenderer {
    
    func paths(forTie tie: Tie, noteHead: NoteHeadDescription, note: Note) -> [Path] {
        
        guard let endNote = tie.toNote else {
            print("Error - tie had no end note")
            return []
        }
        
        guard let endNoteHead = tie.toNoteHead else {
            print("Error - tie had no end note head")
            return []
        }
                
        let startY = yPosition(fromTiePosition: tie.startPosition) + yOffset(forEndAlignment: tie.endAlignment)
        let start = Point(xPosition(forNote: note, noteHead: noteHead),
                          startY)
        let end = Point(xPosition(forNote: endNote, noteHead: endNoteHead),
                        startY)
        let mid = Point((start.x + end.x) / 2,
                        yPosition(fromTiePosition: tie.middlePosition))
        
        var path = Path(commands: [
            .move(start),
            .line(mid),
            .line(end)
        ])
        
        path.drawStyle = .stroke
        
        return [path]
    }
    
    private func xPosition(forNote note: Note, noteHead: NoteHeadDescription) -> Double {
        return note.xPosition + NoteHeadAligner.xOffset(forAlignment: noteHead.alignment)
    }
    
    private func yPosition(fromTiePosition tiePosition: TiePosition) -> Double {
        let stavePosition = tiePosition.space.stavePosition
        let staveOffset = StavePositionUtils.staveYOffset(forStavePostion: stavePosition)
        return staveOffset
    }
    
    private func yOffset(forEndAlignment alignment: TieEndAlignment) -> Double {
        switch alignment {
        case .middleOfSpace:
            return 0
        case .sittingAboveNoteHead:
            return 0.25
        case .hangingBelowNoteHead:
            return -0.25
        }
    }
}

extension Int {
    
    var isPositive: Bool {
        return self >= 0
    }
    
    var isNegative: Bool {
        return !self.isPositive
    }
}
