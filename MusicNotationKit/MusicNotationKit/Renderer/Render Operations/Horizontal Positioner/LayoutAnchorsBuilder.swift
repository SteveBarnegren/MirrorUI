//
//  LayoutAnchorsBuilder.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class LayoutAnchorsBuilder {
    
    func makeAnchors(from composition: Composition) -> [LayoutAnchor] {
    
        var anchors = [LayoutAnchor]()
        
        var previousNote: Note?
        var previousAnchor: LayoutAnchor?
        
        for note in composition.bars.map({ $0.sequences }).joined().map({ $0.notes }).joined() {
            
            let anchor = LayoutAnchor(item: note)
            anchor.width = 1.4
            
            // Assign fixed constraint from the previous anchor
            if let prevAnchor = previousAnchor {
                let constraint = LayoutConstraint()
                constraint.from = prevAnchor
                constraint.to = anchor
                constraint.value = .greaterThan(2)
                prevAnchor.add(trailingConstraint: constraint)
                anchor.add(leadingConstraint: constraint)
            }
            
            // Assign time constraint for the previous anchor
            if let prevNote = previousNote, let prevAnchor = previousAnchor, let time = prevNote.layoutDuration {
                let constraint = LayoutConstraint()
                constraint.from = prevAnchor
                constraint.to = anchor
                constraint.value = .time(time.barPct)
                prevAnchor.add(trailingConstraint: constraint)
                anchor.add(leadingConstraint: constraint)
            }
            
            previousNote = note
            previousAnchor = anchor
            anchors.append(anchor)
        }
        
        return anchors
    }
}
