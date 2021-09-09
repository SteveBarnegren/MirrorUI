import Foundation

class NoteClusterStemLengthCalculator<N> {
    
    // MARK: - Types
    
    struct Transformer<N> {
        let connectingHeadPosition: (N) -> Vector2D
        let extendingHeadPosition: (N) -> Vector2D
        let stemDirection: (N) -> StemDirection
        let setStemLength: (N, Double) -> Void
    }
    
    // MARK: - Properties
    
    private let tf: Transformer<N>
    private let preferredStemLength: Double

    // MARK: - Init
    
    init(transformer: Transformer<N>, preferredStemLength: Double) {
        self.tf = transformer
        self.preferredStemLength = preferredStemLength
    }
    
    // MARK: - Process
    
    func process(noteCluster: [N]) {
        
        if noteCluster.count <= 1 {
            noteCluster.forEach {
                let extensionLength = abs(tf.extendingHeadPosition($0).y - tf.connectingHeadPosition($0).y)
                tf.setStemLength($0, preferredStemLength + extensionLength)
            }
            return
        }
        
        // If the cluster creates a concave shape, then a horizontal beam should be used
        applyHorizontalBeaming(to: noteCluster)
    }
    
    private func applyHorizontalBeaming(to noteCluster: [N]) {
        
        let stemDirection = tf.stemDirection(noteCluster.first!)
        if stemDirection == .down {
            let minY = noteCluster.map { tf.extendingHeadPosition($0).y - preferredStemLength }.min()!
            for note in noteCluster {
                let length = tf.connectingHeadPosition(note).y  - minY
                tf.setStemLength(note, length)
            }
        } else {
            let maxY = noteCluster.map { tf.extendingHeadPosition($0).y + preferredStemLength }.max()!
            for note in noteCluster {
                let length = maxY - tf.connectingHeadPosition(note).y
                tf.setStemLength(note, length)
            }
        }
    }
    
    /*
    private func applySlantedBeaming(to noteCluster: [T]) {
        
        // First and last notes should be the preferred length
        let firstNote = noteCluster.first!
        let lastNote = noteCluster.last!
        [firstNote, lastNote].forEach { tf.setStemLength($0, preferredStemLength) }
        
        // Middle notes should be between first and last values
        let firstY = tf.position(firstNote).y + tf.stemEndOffset(firstNote)
        let lastY = tf.position(lastNote).y  + tf.stemEndOffset(lastNote)
        
        for note in noteCluster.dropFirst().dropLast() {
            let xPct = tf.position(note).x.pct(between: tf.position(firstNote).x, and: tf.position(lastNote).x)
            let stemEnd = firstY + (lastY-firstY)*xPct
            let length = (stemEnd - tf.position(note).y).inverted(if: { tf.stemDirection(note) == .down })
            tf.setStemLength(note, length)
        }
    }
    
    private func isConcave(cluster: [T]) -> Bool {
        
        if cluster.count <= 2 {
            return false
        }
        
        let firstNote = cluster.first!
        let lastNote = cluster.last!
        
        for note in cluster.dropFirst().dropLast() {
            let xPct = tf.position(note).x
                .pct(between: tf.position(firstNote).x, and: tf.position(lastNote).x)
            let yLerp = tf.position(firstNote).y
                .lerp(to: tf.position(lastNote).y, t: xPct)
            
            // Check if the position is above or below the lerped position.
            // Add half a pitch increment to avoid rounding errors.
            if (tf.stemDirection(note) == .up && tf.position(note).y > yLerp - 0.25)
                || (tf.stemDirection(note) == .down && tf.position(note).y < yLerp + 0.25) {
                return true
            }
        }
        
        return false
    }
 */

}

extension NoteClusterStemLengthCalculator.Transformer {
    
    static var notes: NoteClusterStemLengthCalculator.Transformer<Note> {
        return NoteClusterStemLengthCalculator.Transformer<Note>(connectingHeadPosition: { Vector2D($0.xPosition, $0.stemConnectingNoteHead.yPosition) },
                                                                 extendingHeadPosition: { Vector2D($0.xPosition, $0.stemExtendingNoteHead.yPosition) },
                                                                 stemDirection: { $0.stemDirection },
                                                                 setStemLength: { note, v in note.stemLength = v })
    }

    static var graceNotes: NoteClusterStemLengthCalculator.Transformer<GraceNote> {
        return NoteClusterStemLengthCalculator.Transformer<GraceNote>(connectingHeadPosition: { $0.position },
                                                                      extendingHeadPosition: { $0.position },
                                                                      stemDirection: { $0.stemDirection },
                                                                      setStemLength: { gn, v in gn.stemLength = v })
    }
}
