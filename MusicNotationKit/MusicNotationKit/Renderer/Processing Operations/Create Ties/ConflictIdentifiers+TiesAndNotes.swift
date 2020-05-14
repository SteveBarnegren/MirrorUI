//
//  ConflictIdentifiers+TiesAndNotes.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 14/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension ConflictIdentifiers {
    
    static var tiesAndNotes: ConflictIdentifier<Tie, Note> {
        return ConflictIdentifier<Tie, Note>(areCompatible: isTieAndNoteCompatible)
    }
    
    static func isTieAndNoteCompatible(tie: Tie, note: Note) -> Bool {
        
        print("------ Ties and notes ------")
        
        // If the note time is less that the tie time, do not conflict
        if note.time < tie.startNoteTime {
            print("✅ < start")
            return true
        }
        
        // If the note time is greater than the tie end time, do not conflict
        if note.time > tie.endNoteTime {
            print("✅ > end")
            return true
        }
        
        // If the note is at the tie start time, check for overlapping note heads
        if note.time == tie.startNoteTime && doesTieVerticallyAlignWithNote(tie: tie) {
            for noteHead in note.noteHeadDescriptions where tie.fromNoteHead !== noteHead {
                let yRange = self.yRange(forNoteHead: noteHead)
                let tieY = startY(forTie: tie)
                if yRange.contains(tieY) {
                    print("❌ Start overlaps note")
                    return false
                }
            }
        }
        
        // If the note is at the tie end time, check for overlapping note heads
        if note.time == tie.endNoteTime && doesTieVerticallyAlignWithNote(tie: tie) {
            for noteHead in note.noteHeadDescriptions where tie.toNoteHead !== noteHead {
                let yRange = self.yRange(forNoteHead: noteHead)
                let tieY = startY(forTie: tie)
                if yRange.contains(tieY) {
                    print("❌ End overlaps note")
                    return false
                }
            }
        }
        
        print("✅ passed")
        
        return true
    }
    
    static func doesTieVerticallyAlignWithNote(tie: Tie) -> Bool {
        
        switch tie.orientation {
        case .verticallyAlignedWithNote:
            return true
        case .adjacentToNote:
            return false
        }
    }
    
    static func startY(forTie tie: Tie) -> Double {
        let y = StavePositionUtils.staveYOffset(forStavePostion: tie.startPosition.space.stavePosition)
        
        let yOffset: Double
        switch tie.endAlignment {
        case .middleOfSpace:
            yOffset = 0
        case .sittingAboveNoteHead:
            yOffset = 0.25
        case .hangingBelowNoteHead:
            yOffset = -0.25
        case .bottom:
            yOffset = -0.25
        case .top:
            yOffset = 0.25
        }
        
        return y + yOffset
    }
    
    static func yRange(forNoteHead noteHead: NoteHeadDescription) -> ClosedRange<Double> {
        
        let staveOffset = StavePositionUtils.staveYOffset(forStavePostion: noteHead.stavePosition)
        let noteHeadHeight = 1.0
        return (staveOffset - noteHeadHeight/2)...(staveOffset + noteHeadHeight/2)
    }
    
    static func isTieAndNoteHeadCompatible(tie: Tie, noteHead: NoteHeadDescription) -> Bool {
      fatalError()
        
        
    }
}
