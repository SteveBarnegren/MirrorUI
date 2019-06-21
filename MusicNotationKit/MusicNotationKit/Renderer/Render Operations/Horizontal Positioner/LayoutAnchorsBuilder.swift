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
        
        let firstBar = composition.bars[0]
        
        let anchorsForSequences = firstBar.sequences.map(self.anchors(forNoteSequence:)).joined().toArray()
        let combinedAnchors = sortAndCombine(anchors: anchorsForSequences)
        
        return combinedAnchors
    }
    
    private func anchors(forNoteSequence sequence: NoteSequence) -> [LayoutAnchor] {
        
        var anchors = [SingleItemLayoutAnchor]()
        
        var previousNote: Note?
        var previousAnchor: SingleItemLayoutAnchor?
        
        for note in sequence.notes {
            
            let anchor = SingleItemLayoutAnchor(item: note)
            anchor.width = 1.4
            anchor.time = note.time
            
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
    
    func sortAndCombine(anchors: [LayoutAnchor]) -> [LayoutAnchor] {
        
        let chunkedAnchors = anchors
            .sortedAscendingBy { $0.time }
            .chunked(atChangeTo: { $0.time })
        
        var combinedAnchors = [LayoutAnchor]()
        
        for anchors in chunkedAnchors {
            
            if anchors.count == 1 {
                combinedAnchors.append(anchors[0])
            } else if anchors.count > 1 {
                let combined = CombinedItemsLayoutAnchor(anchors: anchors)
                combinedAnchors.append(combined)
            } else {
                fatalError("Should never happen")
            }
        }
        
        return combinedAnchors
    }
}
