//
//  LayoutAnchorsBuilder.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class LayoutAnchorsBuilder {
    
    func makeAnchors(from composition: Composition) {
        
        // Add a trailing bar line
        // TODO: this should definitely not be done here!
        composition.bars.last?.trailingBarline = Barline()
                
        for (bar, previousBar, isLast) in composition.bars.eachWithPrevious().eachWithIsLast().unnestTuples() {
            
            var barAnchors = [LayoutAnchor]()
            
            // Barline
            let previousBarLastAnchor = previousBar?.trailingBarlineAnchor ?? previousBar?.layoutAnchors.last
            let barlineAnchor = makeAnchor(forBarline: bar.leadingBarline, fromPrevious: previousBarLastAnchor)
            previousBar?.trailingBarlineAnchor = barlineAnchor
            barAnchors.append(barlineAnchor)
            
            // Notes
            let anchorsForSequences = bar.sequences
                .map { makeAnchors(forNoteSequence: $0, fromPrevious: barlineAnchor)}
                .joined()
                .toArray()
            
            // Add tie constraints
            addTieWidthConstraints(toAnchors: anchorsForSequences)
            
            // Combine
            let combinedAnchors = sortAndCombine(anchors: anchorsForSequences)
            applyDurations(toAnchors: combinedAnchors, barDuration: bar.duration)
            
            barAnchors += combinedAnchors
            
            if isLast, let trailingBarline = composition.bars.last?.trailingBarline {
                barAnchors.append(makeAnchor(forBarline: trailingBarline, fromPrevious: barAnchors.last))
            }
            
            bar.layoutAnchors = barAnchors
        }
    }
    
    // MARK: - Add Ties
    
    private func addTieWidthConstraints(toAnchors anchors: [SingleItemLayoutAnchor]) {
        
        struct PendingTie {
            let note: Note
            let anchor: SingleItemLayoutAnchor
            let tie: Tie
        }
        
        var pendingTies = [PendingTie]()
        
        for anchor in anchors {
            guard let note = anchor.item as? Note else { continue }
            
            // Create constraints for any ties that end on this note
            let pending = pendingTies.extract { $0.tie.toNote === note }
            for pendingTie in pending {
                let startAnchor = pendingTie.anchor
                let endAnchor = anchor
                let constraint = LayoutConstraint()
                constraint.from = startAnchor
                constraint.to = endAnchor
                constraint.value = .greaterThan(2.5)
                startAnchor.add(trailingConstraint: constraint)
                endAnchor.add(leadingConstraint: constraint)
            }
            
            // Create pending ties for any ties that are start on this note
            for noteHead in note.noteHeadDescriptions {
                if let tie = noteHead.tie?.chosenVariation {
                    let pendingTie = PendingTie(note: note, anchor: anchor, tie: tie)
                    pendingTies.append(pendingTie)
                }
            }
        }
    }
    
    // MARK: - Make Anchors
    
    private func makeAnchor(forBarline barline: Barline, fromPrevious previousAnchor: LayoutAnchor?) -> LayoutAnchor {
        
        let anchor = SingleItemLayoutAnchor(item: barline)
        anchor.leadingWidth = barline.leadingWidth
        anchor.trailingWidth = barline.trailingWidth
        
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
        
        for playable in sequence.playables {
            let anchor = makeAnchor(forPlayable: playable, fromPrevious: previousAnchor)
            previousAnchor = anchor
            anchors.append(anchor)
        }
        
        return anchors
    }
    
    private func makeAnchor(forPlayable playable: Playable, fromPrevious previousAnchor: LayoutAnchor?) -> SingleItemLayoutAnchor {
        
        let anchor = SingleItemLayoutAnchor(item: playable)
        anchor.leadingWidth = playable.leadingWidth
        anchor.trailingWidth = playable.trailingWidth
        anchor.time = playable.time
        
        // Create leading anchors
        for item in playable.leadingLayoutItems {
            let adjacentAnchor = AdjacentLayoutAnchor(item: item)
            adjacentAnchor.width = item.leadingWidth + item.trailingWidth
            adjacentAnchor.distanceFromAnchor = item.hoizontalLayoutDistanceFromParentItem
            anchor.add(leadingAnchor: adjacentAnchor)
        }
        
        // Create Adjacent items for dots
        for dot in playable.trailingLayoutItems.compactMap({ $0 as? DotSymbol }) {
            let adjacentAnchor = AdjacentLayoutAnchor(item: dot)
            adjacentAnchor.width = dot.leadingWidth + dot.trailingWidth
            adjacentAnchor.distanceFromAnchor = dot.hoizontalLayoutDistanceFromParentItem
            anchor.add(trailingAnchor: adjacentAnchor)
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
        
        return anchor
    }
    
    // MARK: - Sort / Combine
    
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
        for (anchor, isLast) in anchors.eachWithIsLast() {
            
            if let previous = previous {
                previous.duration = anchor.time - previous.time
            }
            
            if isLast {
                anchor.duration = barDuration - anchor.time
            }
            
            previous = anchor
        }
    }
}
