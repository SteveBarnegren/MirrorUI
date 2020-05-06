//
//  TieCreator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

private struct PitchAndPosition {
    let pitch: Pitch
    let stavePosition: Int
}

class TieVariationSet {
    let ties: [Tie]
    let startNoteHeadIndex: Int
    let endNoteHeadIndex: Int
    
    init(ties: [Tie], startHeadIndex: Int, endHeadIndex: Int) {
        self.ties = ties
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
    
    func createTies(between startNote: N, and endNote: N) -> [TieVariationSet] {
        
        func pitchesAndPositions(for note: N) -> [PitchAndPosition] {
            return zip(tf.pitches(note), tf.stavePositions(note))
                .map(PitchAndPosition.init)
        }
        
        let start = pitchesAndPositions(for: startNote)
        let end = pitchesAndPositions(for: endNote)
        
        var variationSets = [TieVariationSet]()
        
        for (noteheadIndex, currentNoteHead) in start.enumerated() {
            
            let preferredDirection: VerticalDirection = (tf.stemDirection(startNote) == .down ? .up : .down)
            
            var ties = [Tie]()
            
            // Make the preferred vertical tie (above or below the note)
            let preferredVerticalTie = makeTie(stavePosition: currentNoteHead.stavePosition,
                                               direction: preferredDirection)
            ties.append(preferredVerticalTie)
            
            // Make the fallback vertical ties (above or below on the opposite side)
            let fallbackVerticalTie = makeTie(stavePosition: currentNoteHead.stavePosition,
                                              direction: preferredDirection.opposite)
            ties.append(fallbackVerticalTie)
            
            if let endHeadIndex = end.firstIndex(where: { $0.pitch == currentNoteHead.pitch }) {
                let variationSet = TieVariationSet(ties: ties,
                                                   startHeadIndex: noteheadIndex,
                                                   endHeadIndex: endHeadIndex)
                variationSets.append(variationSet)
            }
        }
        
        return variationSets
    }
    
    private func makeTie(stavePosition: Int, direction: VerticalDirection) -> Tie {
        
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
        
        return tie
    }
}

extension TieCreator.Transformer {
    
    static var notes: TieCreator<Note>.Transformer<Note> {
        return TieCreator<Note>.Transformer<Note>.init(pitches: { $0.pitches },
                                                       stavePositions: { n in n.noteHeadDescriptions.map { $0.stavePosition } },
                                                       stemDirection: { $0.symbolDescription.stemDirection })
    }
}
