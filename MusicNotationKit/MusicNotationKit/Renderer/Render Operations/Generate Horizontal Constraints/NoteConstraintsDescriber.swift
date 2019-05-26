//
//  HorizontalConstraintsCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteConstraintsDescriber {
    
    private let noteHeadWidth = Double(1.3)
    
    func process(note: Note) {
        
        // Leading
        note.leadingConstraint = HorizontalConstraint(values: [ConstraintValue(length: leadingDistance(forNote: note), priority: .required)])
        
        // Trailing
        note.trailingConstraint = HorizontalConstraint(values: [ConstraintValue(length: trailingDistance(forNote: note), priority: .required)])
    }
    
    private func leadingDistance(forNote note: Note) -> Double {
        return noteHeadWidth/2
    }
    
    private func trailingDistance(forNote note: Note) -> Double {
        
        // Isolated quaver
        if note.symbolDescription.numberOfTails == 1 && note.beams.allSatisfy({ $0 == .cutOffRight }) {
            return noteHeadWidth/2 + 0.8
        }
        
        // Isolated Semiquaver or faster
        if note.symbolDescription.numberOfTails >= 2 && note.beams.allSatisfy({ $0 == .cutOffRight }) {
            return noteHeadWidth/2 + 0.9
        }
        
        // Standard, just note head width
        return noteHeadWidth/2
    }
}
