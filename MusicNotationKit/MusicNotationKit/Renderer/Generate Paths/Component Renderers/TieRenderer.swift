//
//  TieRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class TieRenderer {
    
    func paths(forTie tie: Tie,
               noteHead: NoteHeadDescription,
               note: Note,
               inBarRange barRange: ClosedRange<Int>,
               canvasWidth: Double) -> [Path] {
        
        guard let endNote = tie.toNote else {
            print("Error - tie had no end note")
            return []
        }
        
        guard let endNoteHead = tie.toNoteHead else {
            print("Error - tie had no end note head")
            return []
        }
        
        let orientationOffset = xOffset(forOrientation: tie.orientation)
                
        let startY = yPosition(fromTiePosition: tie.startPosition) + yOffset(forEndAlignment: tie.endAlignment)
        let start = Point(xPosition(forNote: note, noteHead: noteHead) + orientationOffset,
                          startY)
        
        var path: Path
        if barRange.contains(tie.endNoteTime.bar) {
            let end = Point(xPosition(forNote: endNote, noteHead: endNoteHead) - orientationOffset,
                            startY)
            let mid = Point((start.x + end.x) / 2,
                            yPosition(fromTiePosition: tie.middlePosition) + yOffset(forMiddleAlignment: tie.middleAlignment))
            
            path = Path(commands: [
                .move(start),
                .line(mid),
                .line(end)
            ])
        } else {
            let mid = Point(canvasWidth,
                            yPosition(fromTiePosition: tie.middlePosition) + yOffset(forMiddleAlignment: tie.middleAlignment))
            
            path = Path(commands: [
                .move(start),
                .line(mid)
            ])
        }
        
        path.drawStyle = .stroke
        
        return [path]
    }
    
    func paths(forLeadingTie tie: Tie) -> [Path] {
        
        guard let endNote = tie.toNote else {
            print("Error - Tie end note not set")
            return []
        }
        
        guard let endNoteHead = tie.toNoteHead else {
            print("Error - Tie end note head not set")
            return []
        }
        
        let midX = 0.0
        let midY = yPosition(fromTiePosition: tie.middlePosition) + yOffset(forMiddleAlignment: tie.middleAlignment)
        
        let endX = xPosition(forNote: endNote, noteHead: endNoteHead) - xOffset(forOrientation: tie.orientation)
        let endY = yPosition(fromTiePosition: tie.startPosition) + yOffset(forEndAlignment: tie.endAlignment)
        
        var path = Path(commands: [
            .move(Point(midX, midY)),
            .line(Point(endX, endY))
        ])
        
        path.drawStyle = .stroke
        return [path]
    }
    
    private func xPosition(forNote note: Note, noteHead: NoteHeadDescription) -> Double {
        return note.xPosition
            + NoteHeadAligner.xOffset(forAlignment: noteHead.alignment)
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
        case .top:
            return 0.25
        case .bottom:
            return -0.25
        }
    }
    
    private func yOffset(forMiddleAlignment alignment: TieMiddleAlignment) -> Double {
        switch alignment {
        case .middleOfSpace:
            return 0
        case .topOfSpace:
            return 0.25
        case .bottomOfSpace:
            return -0.25
        }
    }
    
    private func xOffset(forOrientation orientation: TieOrientation) -> Double {
        switch orientation {
        case .verticallyAlignedWithNote:
            return 0
        case .adjacentToNote:
            return 1
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
