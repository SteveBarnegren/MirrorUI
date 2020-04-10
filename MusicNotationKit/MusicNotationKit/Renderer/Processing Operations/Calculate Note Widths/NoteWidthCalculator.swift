//
//  NoteWidthCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

// Can eventually calulate this from the path
private let noteHeadWidth = 1.2

// Should be sinlge source of truth for this
private let stemThickness = 0.1

class NoteWidthCalculator {
    
    func width(forNote note: Note) -> (leading: Double, trailing: Double) {
        
        // Centered on the note head
        var leading = noteHeadWidth/2
        var trailing = noteHeadWidth/2
        
        // Add the stem if required
//        if note.symbolDescription.hasStem {
//            leading += stemThickness/2
//            trailing += stemThickness/2
//        }
        
        // Add additional width if there are note heads on the opposite side of the stem. A note can only contain either left of stem OR right of stem heads, so we can break after finding either one.
        alignmentLoop: for alignment in note.noteHeadDescriptions.map({ $0.alignment }) {
            switch alignment {
            case .center:
                continue
            case .leftOfStem:
                leading += noteHeadWidth
                break alignmentLoop
            case .rightOfStem:
                trailing += noteHeadWidth
                break alignmentLoop
            }
        }
        
        return (leading, trailing)
    }
}
