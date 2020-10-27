//
//  ConflictIdentifiers+TiesAndAccents.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 27/10/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension ConflictIdentifiers {
    
    static var tiesAndArticulationMarks: ConflictIdentifier<Tie, ArticulationMark> {
        return ConflictIdentifier<Tie, ArticulationMark>(areCompatible: isTieAndArticulationCompatible)
    }
    
    static func isTieAndArticulationCompatible(tie: Tie, articulationMark: ArticulationMark) -> Bool {
        
        let articulationNote = articulationMark.note!
        let startNote = tie.fromNote!
        let endNote = tie.toNote!

        if (tie.endAlignment == .sittingAboveNoteHead || tie.endAlignment == .hangingBelowNoteHead || tie.endAlignment == .middleOfSpace)
            && (articulationNote === startNote || articulationNote === endNote) {
            return false
        }
        
        return true
    }
}
