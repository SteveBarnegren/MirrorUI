import Foundation

private struct PitchAndPosition {
    let pitch: Pitch
    let stavePosition: Int
}

class TieVariations {
    let variations: [Variation<Tie>]
    let startNoteHeadIndex: Int
    let endNoteHeadIndex: Int
    
    init(variations: [Variation<Tie>], startHeadIndex: Int, endHeadIndex: Int) {
        self.variations = variations
        self.startNoteHeadIndex = startHeadIndex
        self.endNoteHeadIndex = endHeadIndex
    }
}

class TieCreator<N> {
    
    struct Transformer<N> {
        let pitches: (N) -> [Pitch]
        let stavePositions: (N) -> [Int]
        let stemDirection: (N) -> StemDirection
    }
    
    private let tf: Transformer<N>
    
    init(transformer: Transformer<N>) {
        self.tf = transformer
    }
    
    func createTies(between startNote: N, and endNote: N) -> [TieVariations] {
        
        func pitchesAndPositions(for note: N) -> [PitchAndPosition] {
            return zip(tf.pitches(note), tf.stavePositions(note))
                .map(PitchAndPosition.init)
        }
        
        let start = pitchesAndPositions(for: startNote)
        let end = pitchesAndPositions(for: endNote)
        
        var variationsArray = [TieVariations]()
        
        for (noteheadIndex, currentNoteHead) in start.enumerated() {
            
            let preferredDirection: VerticalDirection = (tf.stemDirection(startNote) == .down ? .up : .down)
            
            var ties = [Variation<Tie>]()
            
            // Big arc tie
            do {
                let tie = makeBigArcTie(stavePosition: currentNoteHead.stavePosition,
                                        direction: preferredDirection)
                ties.append(Variation(value: tie, suitability: .preferable))
            }
            
            // Adjacent arc tie
            do {
                let tie = makeAdjacentArcTie(stavePosition: currentNoteHead.stavePosition,
                                             direction: preferredDirection)
                ties.append(Variation(value: tie, suitability: .preferable))
            }
            
            // Flattened tie
            do {
                let tie = makeFlattenedTie(stavePosition: currentNoteHead.stavePosition,
                                           direction: preferredDirection)
                ties.append(Variation(value: tie, suitability: .allowed))
            }
            
            // Big arc tie (opposite direction)
            do {
                let tie = makeBigArcTie(stavePosition: currentNoteHead.stavePosition,
                                        direction: preferredDirection.opposite)
                ties.append(Variation(value: tie, suitability: .concession))
            }
            
            if let endHeadIndex = end.firstIndex(where: { $0.pitch == currentNoteHead.pitch }) {
                let variations = TieVariations(variations: ties,
                                               startHeadIndex: noteheadIndex,
                                               endHeadIndex: endHeadIndex)
                variationsArray.append(variations)
            }
            
            // Adjacent arc tie (opposite direction)
            do {
                let tie = makeAdjacentArcTie(stavePosition: currentNoteHead.stavePosition,
                                             direction: preferredDirection.opposite)
                ties.append(Variation(value: tie, suitability: .concession))
            }
        }
        
        return variationsArray
    }
    
    // Makes the ideal tie. Sits above or below the note, and arcs in to the next space.
    private func makeBigArcTie(stavePosition: Int, direction: VerticalDirection) -> Tie {
        
        let isOnSpace = stavePosition.isOdd
        let tieAboveNote = (direction == .up)
        let tieDirectionMultiplier = tieAboveNote ? 1 : -1
        
        // Start on the next available space
        var startSpace: StaveSpace
        let endAlignment: TieEndAlignment
        if isOnSpace {
            startSpace = StaveSpace(stavePosition: stavePosition,
                                    lineRounding: .spaceAbove).adding(spaces: tieDirectionMultiplier)
            endAlignment = .middleOfSpace
        } else {
            startSpace = StaveSpace(stavePosition: stavePosition,
                                    lineRounding: tieAboveNote ? .spaceAbove : .spaceBelow)
            endAlignment = tieAboveNote ? .sittingAboveNoteHead : .hangingBelowNoteHead
        }
        
        // Middle is one space above
        let middleSpace = startSpace.adding(spaces: tieDirectionMultiplier)
        
        let tie = Tie()
        tie.startPosition = TiePosition(space: startSpace)
        tie.middlePosition = TiePosition(space: middleSpace)
        tie.endAlignment = endAlignment
        tie.middleAlignment = .middleOfSpace
        tie.orientation = .verticallyAlignedWithNote
        
        return tie
    }
    
    // Makes an arcing tie that sits next to the note and arcs in to the space above /
    // below. As it starts on the same space as the note it takes up one less space
    // than the big arc style.
    private func makeAdjacentArcTie(stavePosition: Int, direction: VerticalDirection) -> Tie {
        
        let tieAboveNote = (direction == .up)
        let startSpace =  StaveSpace(stavePosition: stavePosition,
                                     lineRounding: tieAboveNote ? .spaceAbove : .spaceBelow)
        
        let endAlignment: TieEndAlignment = tieAboveNote ? .top : .bottom
        let middleSpace = startSpace.adding(spaces: tieAboveNote ? 1 : -1)
        
        let tie = Tie()
        tie.startPosition = TiePosition(space: startSpace)
        tie.middlePosition = TiePosition(space: middleSpace)
        tie.endAlignment = endAlignment
        tie.middleAlignment = .middleOfSpace
        tie.orientation = .adjacentToNote
        
        return tie
    }
    
    // Makes a flat adjacent tie that curves within a single stave space
    private func makeFlattenedTie(stavePosition: Int, direction: VerticalDirection) -> Tie {
        
        let tieAboveNote = (direction == .up)
        let space =  StaveSpace(stavePosition: stavePosition,
                                lineRounding: tieAboveNote ? .spaceAbove : .spaceBelow)
                
        let tie = Tie()
        tie.startPosition = TiePosition(space: space)
        tie.middlePosition = TiePosition(space: space)
        tie.endAlignment = (direction == .up) ? .bottom : .top
        tie.middleAlignment = (direction == .up) ? .topOfSpace : .bottomOfSpace
        tie.orientation = .adjacentToNote
        
        return tie
    }
}

extension TieCreator.Transformer {
    
    static var notes: TieCreator<Note>.Transformer<Note> {
        return TieCreator<Note>.Transformer<Note>.init(
            pitches: { $0.pitches },
            stavePositions: { n in n.noteHeads.map { $0.stavePosition.location } },
            stemDirection: { $0.stemDirection }
        )
    }
}
