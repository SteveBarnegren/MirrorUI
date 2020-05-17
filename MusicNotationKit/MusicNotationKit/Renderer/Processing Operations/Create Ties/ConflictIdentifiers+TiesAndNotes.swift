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
                
        // If the note time is less that the tie time, do not conflict
        if note.compositionTime < tie.startNoteTime {
            return true
        }
        
        // If the note time is greater than the tie end time, do not conflict
        if note.compositionTime > tie.endNoteTime {
            return true
        }
        
        // If the note is at the tie start time, check for overlapping note heads
        if note.compositionTime == tie.startNoteTime && doesTieVerticallyAlignWithNote(tie: tie) {
            for noteHead in note.noteHeadDescriptions where tie.fromNoteHead !== noteHead {
                let yRange = self.yRange(forNoteHead: noteHead)
                let tieY = startY(forTie: tie)
                if yRange.contains(tieY) {
                    return false
                }
            }
            return true
        }
        
        // If the note is at the tie end time, check for overlapping note heads
        if note.compositionTime == tie.endNoteTime && doesTieVerticallyAlignWithNote(tie: tie) {
            for noteHead in note.noteHeadDescriptions where tie.toNoteHead !== noteHead {
                let yRange = self.yRange(forNoteHead: noteHead)
                let tieY = startY(forTie: tie)
                if yRange.contains(tieY) {
                    return false
                }
            }
            return true
        }
        
        // The note is in the middle of the tie, check that the tie doesn't overlap it
        let middleYRange = yRange(forTieMiddle: tie)
        let middleTimeRange = timeRange(forTieMiddle: tie)
        if middleTimeRange.contains(note.compositionTime.absoluteTime) {
            for noteHead in note.noteHeadDescriptions {
                let yRange = self.yRange(forNoteHead: noteHead)
                if yRange.overlaps(middleYRange) {
                    return false
                }
            }
        }
                
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
    
    static func yRange(forTieMiddle tie: Tie) -> ClosedRange<Double> {
        
        let y = StavePositionUtils.staveYOffset(forStavePostion: tie.middlePosition.space.stavePosition)
        
        let yOffset: Double
        switch tie.middleAlignment {
        case .middleOfSpace:
            yOffset = 0
        case .topOfSpace:
            yOffset = 0.25
        case .bottomOfSpace:
            yOffset = -0.25
        }
        
        let midY = y + yOffset
        let tieWidth = 0.2
        return (midY - tieWidth)...(midY + tieWidth)
    }
    
    static func timeRange(forTieMiddle tie: Tie) -> ClosedRange<Time> {
        
        let middleTime = tie.startNoteTime.absoluteTime + ((tie.endNoteTime.absoluteTime - tie.startNoteTime.absoluteTime)/2)
        let quarter = (middleTime - tie.startNoteTime.absoluteTime)/2
        let start = tie.startNoteTime.absoluteTime + quarter
        let end = tie.endNoteTime.absoluteTime - quarter
        return start...end
    }
}