//
//  HorizontalConstraintsCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteConstraintsDescriber {
    
    func process(note: Note) {
        
        // Leading - 0.5 for the note head
        var leadingWidth = Double(0)
        leadingWidth += 0.7
    
        // Trailing - 0.5 for the note head
        var trailingWidth = Double(0)
        trailingWidth += 0.7
    
        note.leadingWidth = leadingWidth
        note.trailingWidth = trailingWidth
        
        let leadingConstraint = HorizontalConstraint(values: [ConstraintValue(length: 0.7, priority: .required)])
        note.leadingConstraints = [leadingConstraint]
        
        let trailingConstraint = HorizontalConstraint(values: [ConstraintValue(length: 0.7, priority: .required)])
        note.trailingConstraints = [trailingConstraint]
        
    }
}
