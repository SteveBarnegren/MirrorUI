//
//  LayoutAnchorsBuilder.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

private let requiredTieSpace = 2.5

class LayoutAnchorsBuilder {
    
    func makeAnchors(from composition: Composition) {
        
        // Add a trailing bar line
        // TODO: this should definitely not be done here!
        for stave in composition.staves {
            stave.bars.last?.trailingBarline = Barline()
        }
        
        for (barSlice, previousBarSlice, isLast) in composition.barSlices.eachWithPrevious().eachWithIsLast().unnestTuples() {
            
            var barAnchors = [LayoutAnchor]()
            
            // Barline
            let previousBarLastAnchor = previousBarSlice?.trailingBarlineAnchor ?? previousBarSlice?.layoutAnchors.last
            let barlineAnchor = makeAnchor(forItems: barSlice.leadingBarlines, fromPrevious: previousBarLastAnchor)
            previousBarSlice?.trailingBarlineAnchor = barlineAnchor
            barAnchors.append(barlineAnchor)
            
            // Clef
            let clefAnchor = makeAnchor(forItems: barSlice.clefSymbols, fromPrevious: barlineAnchor, type: .leadingClef)
            barAnchors.append(clefAnchor)
            
            // Notes
            let anchorsForSequences = barSlice.sequences
                .map { makeAnchors(forNoteSequence: $0, fromPrevious: [barlineAnchor, clefAnchor])}
                .joined()
                .toArray()
            
            // Add tie constraints
            let leadingTies = previousBarSlice?.trailingTies ?? []
            addTieWidthConstraints(toAnchors: anchorsForSequences,
                                   previousBarline: barlineAnchor,
                                   leadingTies: leadingTies)
            
            // Combine
            let combinedAnchors = sortAndCombine(anchors: anchorsForSequences)
            applyDurations(toAnchors: combinedAnchors, barDuration: barSlice.duration)
            
            barAnchors += combinedAnchors
            
            let trailingBarlines = composition.barSlices.last!.trailingBarlines
            if isLast, !trailingBarlines.isEmpty {
                barAnchors.append(makeAnchor(forItems: trailingBarlines, fromPrevious: barAnchors.last))
            }
            
            barSlice.layoutAnchors = barAnchors
        }
        
    }
    
    // MARK: - Add Ties
    
    private func addTieWidthConstraints(toAnchors anchors: [SingleItemLayoutAnchor],
                                        previousBarline: LayoutAnchor,
                                        leadingTies: [Tie]) {
        
        struct PendingTie {
            let note: Note
            let anchor: SingleItemLayoutAnchor
            let tie: Tie
        }
        
        var pendingTies = [PendingTie]()
        
        for anchor in anchors {
            guard let note = anchor.item as? Note else { continue }
            
            // Create constraints for leading ties
            if leadingTies.contains(where: { $0.toNote === note }) {
                let constraint = LayoutConstraint()
                constraint.value = .greaterThan(requiredTieSpace / 2)
                constraint.insert(from: previousBarline, to: anchor)
            }
            
            // Create constraints for any ties that end on this note
            let pending = pendingTies.extract { $0.tie.toNote === note }
            for pendingTie in pending {
                let startAnchor = pendingTie.anchor
                let endAnchor = anchor
                let constraint = LayoutConstraint()
                constraint.value = .greaterThan(requiredTieSpace)
                constraint.insert(from: startAnchor, to: endAnchor)
            }
            
            // Create pending ties for any ties that are start on this note
            for noteHead in note.noteHeads {
                if let tie = noteHead.tie?.chosenVariation {
                    let pendingTie = PendingTie(note: note, anchor: anchor, tie: tie)
                    pendingTies.append(pendingTie)
                }
            }
        }
    }
    
    // MARK: - Make Anchors
    
    private func makeAnchor(forItems items: [HorizontalLayoutItem], 
                            fromPrevious previousAnchor: LayoutAnchor?, 
                            type: LayoutAnchorContent = .unknown) -> LayoutAnchor {
        
        let singleItemAnchors = items.map { (item: HorizontalLayoutItem) -> SingleItemLayoutAnchor in
            return SingleItemLayoutAnchor(item: item, 
                                          leadingWidth: item.leadingWidth, 
                                          trailingWidth: item.trailingWidth)
        }
        
        let anchor = CombinedItemsLayoutAnchor(anchors: singleItemAnchors)
        anchor.layoutAnchorType = type
        
        if let previousAnchor = previousAnchor {
            let constraint = LayoutConstraint()
            constraint.value = .greaterThan(0.5)
            constraint.insert(from: previousAnchor, to: anchor)
        }
        
        return anchor
    }
    
    // Make from multiple previous anchor (clef and barline)
    private func makeAnchor(forPlayable playable: Playable, fromPrevious previousAnchors: [LayoutAnchor]) -> SingleItemLayoutAnchor {
        
        let anchor = SingleItemLayoutAnchor(item: playable, 
                                            leadingWidth: playable.leadingWidth, 
                                            trailingWidth: playable.trailingWidth, 
                                            barTime: playable.barTime)
        
        // Create leading anchors
        for item in playable.leadingChildItems {
            let adjacentAnchor = AdjacentLayoutAnchor(item: item)
            adjacentAnchor.width = item.leadingWidth + item.trailingWidth
            adjacentAnchor.distanceFromAnchor = item.hoizontalLayoutDistanceFromParentItem
            anchor.add(leadingAnchor: adjacentAnchor)
        }
        
        // Create Adjacent items for dots
        for dot in playable.trailingChildItems.compactMap({ $0 as? DotSymbol }) {
            let adjacentAnchor = AdjacentLayoutAnchor(item: dot)
            adjacentAnchor.width = dot.leadingWidth + dot.trailingWidth
            adjacentAnchor.distanceFromAnchor = dot.hoizontalLayoutDistanceFromParentItem
            anchor.add(trailingAnchor: adjacentAnchor)
        }
        
        // Assign fixed constraint from the previous anchor
        for prevAnchor in previousAnchors {
            let constraint = LayoutConstraint()
            constraint.value = .greaterThan(0.5)
            constraint.insert(from: prevAnchor, to: anchor)
        }
        
        return anchor
    }
    
    // Make from multiple previous anchor (clef and barline)
    private func makeAnchors(forNoteSequence sequence: NoteSequence, fromPrevious previousAnchors: [LayoutAnchor]) -> [SingleItemLayoutAnchor] {
        
        var anchors = [SingleItemLayoutAnchor]()
        var prevAnchors = previousAnchors
        
        for playable in sequence.playables {
            let anchor = makeAnchor(forPlayable: playable, fromPrevious: prevAnchors)
            prevAnchors = [anchor]
            anchors.append(anchor)
        }
        
        return anchors
    }

    // MARK: - Sort / Combine
    
    func sortAndCombine(anchors: [SingleItemLayoutAnchor]) -> [LayoutAnchor] {
        
        let chunkedAnchors = anchors
            .sortedAscendingBy { $0.barTime }
            .chunked(atChangeTo: { $0.barTime })
        
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
                previous.duration = anchor.barTime - previous.barTime
            }
            
            if isLast {
                anchor.duration = barDuration - anchor.barTime
            }
            
            previous = anchor
        }
    }
}
