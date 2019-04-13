//
//  HorizontalConstraintsCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteConstraintsDescriber {
    
    private let noteHeadWidth = Double(1.4)
    
    func process(note: Note) {
        
        // Leading
        let leadingConstraint = HorizontalConstraint(values: [ConstraintValue(length: leadingDistance(forNote: note), priority: .required)])
        note.leadingConstraints = [leadingConstraint]
        
        // Trailing
        let trailingConstraint = HorizontalConstraint(values: [ConstraintValue(length: trailingDistance(forNote: note), priority: .required)])
        note.trailingConstraints = [trailingConstraint]
    }
    
    private func leadingDistance(forNote note: Note) -> Double {
        return noteHeadWidth/2
    }
    
    private func trailingDistance(forNote note: Note) -> Double {
        
        if note.symbolDescription.numberOfBeams == 0 {
            return noteHeadWidth/2
        }
        
        // Quaver
        if note.symbolDescription.numberOfBeams == 1 {
            return noteHeadWidth/2 + 0.8
        }
        
        // Other, not really supported yet
        return noteHeadWidth/2
    }
    
}
