//
//  NoteHeadAlignmentDecider.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteHeadAlignmentDecider<N> {
    
    struct Transformer<N> {
        let noteHeadStavePositions: (N) -> [Int]
        let stemDirection: (N) -> StemDirection
        let setNoteHeadAlignmentForIndex: (N, Int, NoteHeadAlignment) -> Void
    }
    
    private let tf: Transformer<N>
    
    init(transformer: Transformer<N>) {
        self.tf = transformer
    }
    
    func process(note: N) {
        let stavePositions = tf.noteHeadStavePositions(note)
        
        // 0 note heads
        if stavePositions.isEmpty {
            return
        }
        
        // 1 Note head
        if stavePositions.count == 1 {
            tf.setNoteHeadAlignmentForIndex(note, 0, .center)
            return
        }
                
        // 2 Note heads
        if stavePositions.count == 2 {
            processTwoHeadedNote(note: note, stavePositions: stavePositions)
            return
        }
        
        processThreeOrMoreHeadedNote(note: note, stavePositions: stavePositions)
    }
    
    private func processTwoHeadedNote(note: N, stavePositions: [Int]) {
        
        let stemDirection = tf.stemDirection(note)
        
        let highPositionIndex = stavePositions[1] > stavePositions[0] ? 1 : 0
        let lowPossitionIndex = highPositionIndex == 1 ? 0 : 1
        
        // If they're not 1 stave position apart then they won't overlap, so can stay in the center
        if stavePositions[highPositionIndex] - stavePositions[lowPossitionIndex] != 1 {
            tf.setNoteHeadAlignmentForIndex(note, highPositionIndex, .center)
            tf.setNoteHeadAlignmentForIndex(note, lowPossitionIndex, .center)
            return
        }
           
        // The higher always goes on the right
        if stemDirection == .down {
            tf.setNoteHeadAlignmentForIndex(note, highPositionIndex, .center)
            tf.setNoteHeadAlignmentForIndex(note, lowPossitionIndex, .leftOfStem)
        } else {
            tf.setNoteHeadAlignmentForIndex(note, lowPossitionIndex, .center)
            tf.setNoteHeadAlignmentForIndex(note, highPositionIndex, .rightOfStem)
        }
    }
    
    private func processThreeOrMoreHeadedNote(note: N, stavePositions: [Int]) {
        
        // Sort the stave positions ascending
        let sortMapper = SortMapper(items: stavePositions, sortingFunction: <)
        
        let evenAlignment: NoteHeadAlignment
        let oddAlignment: NoteHeadAlignment
        
        // If there is an odd number of notes, the lowest is on the correct side, then alternate
        if sortMapper.count.isOdd {
            evenAlignment = NoteHeadAlignment.center
            oddAlignment = tf.stemDirection(note) == .up ? .rightOfStem : .leftOfStem
        }
        // If there is an even number of notes, the lowest note is always on the left
        else {
            evenAlignment = tf.stemDirection(note) == .up ? .center : .leftOfStem
            oddAlignment = tf.stemDirection(note) == .up ? .rightOfStem : .center
        }

        // Apply alignments
        for i in (0..<sortMapper.count) {
            let originalIndex = sortMapper.originalIndex(fromSorted: i)
            tf.setNoteHeadAlignmentForIndex(note, originalIndex, i.isOdd ? oddAlignment : evenAlignment)
        }
    }
}

extension NoteHeadAlignmentDecider.Transformer {
    
    static var notes: NoteHeadAlignmentDecider.Transformer<Note> {
        return .init(noteHeadStavePositions: { (note) -> [Int] in
            return note.noteHeadDescriptions.map { $0.stavePosition }
        }, stemDirection: { (note) -> StemDirection in
            note.symbolDescription.stemDirection
        }, setNoteHeadAlignmentForIndex: { (note, index, alignment) in
            note.noteHeadDescriptions[index].alignment = alignment
        })
    }
}
