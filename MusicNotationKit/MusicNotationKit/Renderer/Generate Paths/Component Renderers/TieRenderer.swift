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
        
        let startY = yPosition(fromTiePosition: tie.startPosition)
        let start = Point(note.xPosition, startY)
        let end = Point(endNote.xPosition, startY)
        let mid = Point((endNote.xPosition + note.xPosition) / 2,
                        yPosition(fromTiePosition: tie.middlePosition))
        
        var path = Path(commands: [
            .move(start),
            .line(mid),
            .line(end)
        ])
        
        path.drawStyle = .stroke
        
        return [path]
    }
    
    private func yPosition(fromTiePosition tiePosition: TiePosition) -> Double {
        let stavePosition = tiePosition.lineNumber * 2
        let staveOffset = StavePositionUtils.staveYOffset(forStavePostion: stavePosition)
        return (staveOffset + tiePosition.spaceQuartile.value) * Double(tiePosition.sign.sign)
    }
}
