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
        
        for bar in composition.bars {
            // Barline
            let barlineAnchor = makeAnchor(forBarline: bar.leadingBarline, fromPrevious: anchors.last)
            anchors.append(barlineAnchor)
            
            // Notes
            let anchorsForSequences = bar.sequences
                .map { makeAnchors(forNoteSequence: $0, fromPrevious: barlineAnchor)}
                .joined()
                .toArray()
            
            let combinedAnchors = sortAndCombine(anchors: anchorsForSequences)
            applyDurations(toAnchors: combinedAnchors, barDuration: bar.duration)
            
            anchors.append(contentsOf: combinedAnchors)
        }
        
        return anchors
    }
    
    private func makeAnchor(forBarline barline: Barline, fromPrevious previousAnchor: LayoutAnchor?) -> LayoutAnchor {
        
        let anchor = SingleItemLayoutAnchor(item: barline)
        anchor.width = 0.2
        
        if let previousAnchor = previousAnchor {
            let constraint = LayoutConstraint()
            constraint.from = previousAnchor
            constraint.to = anchor
            constraint.value = .greaterThan(0.5)
            previousAnchor.add(trailingConstraint: constraint)
            anchor.add(leadingConstraint: constraint)
        }
        
        return anchor
    }
    
    private func makeAnchors(forNoteSequence sequence: NoteSequence, fromPrevious startingAnchor: LayoutAnchor?) -> [SingleItemLayoutAnchor] {
        
        var anchors = [SingleItemLayoutAnchor]()
        var previousAnchor: LayoutAnchor? = startingAnchor
        
        for note in sequence.notes {
            
            let anchor = SingleItemLayoutAnchor(item: note)
            anchor.width = 1.4
            anchor.time = note.time
            
            // Create Adjacent items for dots
            for dot in note.trailingLayoutItems.compactMap({ $0 as? DotSymbol }) {
                let adjacentItem = AdjacentLayoutItem(item: dot)
                adjacentItem.width = 0.35
                adjacentItem.distanceFromAnchor = 0.1
                anchor.add(trailingItem: adjacentItem)
            }
            
            // Assign fixed constraint from the previous anchor
            if let prevAnchor = previousAnchor {
                let constraint = LayoutConstraint()
                constraint.from = prevAnchor
                constraint.to = anchor
                constraint.value = .greaterThan(0.5)
                prevAnchor.add(trailingConstraint: constraint)
                anchor.add(leadingConstraint: constraint)
            }
            
            previousAnchor = anchor
            anchors.append(anchor)
        }
        
        return anchors
    }
    
    func sortAndCombine(anchors: [SingleItemLayoutAnchor]) -> [LayoutAnchor] {
        
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
    
    func applyDurations(toAnchors anchors: [LayoutAnchor], barDuration: Time) {
     
        var previous: LayoutAnchor?
        for (anchor, isLast) in anchors.enumeratedWithLastItemFlag() {
            
            if let previous = previous {
                previous.duration = anchor.time - previous.time
            }
            
            if isLast {
//                anchor.duration = barDuration - anchor.time
            }
            previous = anchor
        }
    }
}
