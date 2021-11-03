import Foundation

private let requiredTieSpace = 2.5

class LayoutAnchorsBuilder {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func makeAnchors(from composition: Composition) {
        
        for (barSlice, previousBarSlice, isLast) in composition.barSlices.eachWithPrevious().eachWithIsLast().unnestTuples() {
            
            var barAnchors = [LayoutAnchor]()
            
            // Barline
            let barlineAnchor = makeAnchorFromPrevious(forItems: barSlice.leadingBarlines) 
            barAnchors.append(barlineAnchor)
            previousBarSlice?.trailingBarlineAnchor = barlineAnchor
            
            // Clef
            let clefAnchor = makeAnchorFromPrevious(forItems: barSlice.clefSymbols, content: .leadingClef) 
            barAnchors.append(clefAnchor)

            // TimeSignature
            let timeSignatureSymbols = barSlice.timeSignatureSymbols
            if !timeSignatureSymbols.isEmpty {
                let timeSignatureAnchor = makeAnchorFromPrevious(forItems: timeSignatureSymbols, content: .timeSignature)
                barAnchors.append(timeSignatureAnchor)
            }
            
            // Notes
            let anchorsForSequences = barSlice.sequences
                .map { makeAnchors(forNoteSequence: $0)}
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
                barAnchors.append(makeAnchorFromPrevious(forItems: trailingBarlines))
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
                let constraint = LayoutConstraint(from: previousBarline, 
                                                  to: anchor, 
                                                  value: .greaterThan(requiredTieSpace / 2))
                constraint.activate()
            }
            
            // Create constraints for any ties that end on this note
            let pending = pendingTies.extract { $0.tie.toNote === note }
            for pendingTie in pending {
                let constraint = LayoutConstraint(from: pendingTie.anchor,
                                                  to: anchor,
                                                  value: .greaterThan(requiredTieSpace))
                constraint.activate()
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
                            content: LayoutAnchorContent = .unknown) -> LayoutAnchor {
        
        let singleItemAnchors = items.map { (item: HorizontalLayoutItem) -> SingleItemLayoutAnchor in
            return SingleItemLayoutAnchor(item: item, 
                                          leadingWidth: item.leadingWidth(glyphs: glyphs), 
                                          trailingWidth: item.trailingWidth(glyphs: glyphs))
        }
        
        let anchor = CombinedItemsLayoutAnchor(anchors: singleItemAnchors)
        anchor.content = content
        
        if let previousAnchor = previousAnchor {
            let constraint = LayoutConstraint(from: previousAnchor, 
                                              to: anchor,
                                              value: .greaterThan(0.5))
            constraint.activate()
        }
        
        return anchor
    }
    
    private func makeAnchorFromPrevious(forItems items: [HorizontalLayoutItem], 
                                        content: LayoutAnchorContent = .unknown) -> LayoutAnchor {
        
        let singleItemAnchors = items.map { (item: HorizontalLayoutItem) -> SingleItemLayoutAnchor in
            return SingleItemLayoutAnchor(item: item, 
                                          leadingWidth: item.leadingWidth(glyphs: glyphs), 
                                          trailingWidth: item.trailingWidth(glyphs: glyphs))
        }
        
        let anchor = CombinedItemsLayoutAnchor(anchors: singleItemAnchors)
        anchor.content = content
        
        let constraint = LayoutConstraint(fromPreviousTo: anchor, 
                                          value: .greaterThan(0.5)) 
        constraint.activate()
        
        return anchor
    }
    
    // Make from multiple previous anchor (clef and barline)
    private func makeAnchor(forPlayable playable: Playable, fromPrevious previousAnchors: [LayoutAnchor]) -> SingleItemLayoutAnchor {
        
        let anchor = SingleItemLayoutAnchor(item: playable, 
                                            leadingWidth: playable.leadingWidth(glyphs: glyphs), 
                                            trailingWidth: playable.trailingWidth(glyphs: glyphs), 
                                            barTime: playable.barTime)
        
        // Create leading anchors
        for item in playable.leadingChildItems {
            let adjacentAnchor = AdjacentLayoutAnchor(item: item)
            adjacentAnchor.width = item.leadingWidth(glyphs: glyphs) + item.trailingWidth(glyphs: glyphs)
            adjacentAnchor.distanceFromAnchor = item.hoizontalLayoutDistanceFromParentItem
            anchor.add(leadingAnchor: adjacentAnchor)
        }
        
        // Create Adjacent items for dots
        for dot in playable.trailingChildItems.compactMap({ $0 as? DotSymbol }) {
            let adjacentAnchor = AdjacentLayoutAnchor(item: dot)
            adjacentAnchor.width = dot.leadingWidth(glyphs: glyphs) + dot.trailingWidth(glyphs: glyphs)
            adjacentAnchor.distanceFromAnchor = dot.hoizontalLayoutDistanceFromParentItem
            anchor.add(trailingAnchor: adjacentAnchor)
        }
        
        // Assign fixed constraint from the previous anchor
        for prevAnchor in previousAnchors {
            let constraint = LayoutConstraint(from: prevAnchor,
                                              to: anchor,
                                              value: .greaterThan(0.5))
            constraint.activate()
        }
        
        return anchor
    }
    
    private func makeAnchors(forNoteSequence sequence: NoteSequence) -> [SingleItemLayoutAnchor] {
        
        var anchors = [SingleItemLayoutAnchor]()
        var prevAnchors = [LayoutAnchor]()
        
        for (playable, isFirst) in sequence.playables.eachWithIsFirst() {
            let anchor = makeAnchor(forPlayable: playable, fromPrevious: prevAnchors)
            prevAnchors = [anchor]
            
            if isFirst {
                let constraint = LayoutConstraint(fromPreviousTo: anchor, value: .greaterThan(0.5))
                constraint.activate()
            }
            
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
