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
        
        // 3 or more note heads
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
        
        // Get the chunks
        var clusterIndicies = [Int]()
        var lastClusterStavePositon: Int?
        
        func processCluster() {
            if clusterIndicies.count == 1 {
                tf.setNoteHeadAlignmentForIndex(note, clusterIndicies[0], .center)
            } else {
                processAdjacentNoteCluser(note: note, noteHeadIndicies: clusterIndicies)
            }
            clusterIndicies.removeAll()
            lastClusterStavePositon = nil
        }
        
        for index in 0..<sortMapper.count {
            let originalIndex = sortMapper.originalIndex(fromSorted: index)
            let stavePosition = stavePositions[originalIndex]
            if let last = lastClusterStavePositon {
                if stavePosition - last > 1 {
                    processCluster()
                }
            }
            clusterIndicies.append(originalIndex)
            lastClusterStavePositon = stavePosition
        }
        
        processCluster()
    }
    
    // noteHeadIndicies to be passed in ascending order
    private func processAdjacentNoteCluser(note: N, noteHeadIndicies: [Int]) {
        
        let evenAlignment: NoteHeadAlignment
        let oddAlignment: NoteHeadAlignment
        
        // If there is an odd number of notes, the lowest is on the correct side, then alternate
        if noteHeadIndicies.count.isOdd {
            evenAlignment = NoteHeadAlignment.center
            oddAlignment = tf.stemDirection(note) == .up ? .rightOfStem : .leftOfStem
        }
            // If there is an even number of notes, the lowest note is always on the left
        else {
            evenAlignment = tf.stemDirection(note) == .up ? .center : .leftOfStem
            oddAlignment = tf.stemDirection(note) == .up ? .rightOfStem : .center
        }
        
        // Apply alignments
        for (clusterIndex, originalIndex) in noteHeadIndicies.enumerated() {
            tf.setNoteHeadAlignmentForIndex(note, originalIndex, clusterIndex.isOdd ? oddAlignment : evenAlignment)
        }
    }
}

extension NoteHeadAlignmentDecider.Transformer {
    
    static var notes: NoteHeadAlignmentDecider.Transformer<Note> {
        return .init(noteHeadStavePositions: { (note) -> [Int] in
            return note.noteHeads.map { $0.stavePosition.location }
        }, stemDirection: { (note) -> StemDirection in
            note.stemDirection
        }, setNoteHeadAlignmentForIndex: { (note, index, alignment) in
            note.noteHeads[index].alignment = alignment
        })
    }
}
