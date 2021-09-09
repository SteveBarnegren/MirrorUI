import Foundation

class CalculateNoteHeadAlignmentProcessingOperation: CompositionProcessingOperation {
    
    private let alignmentDecider = NoteHeadAlignmentDecider(transformer: .notes)
    
    func process(composition: Composition) {
        composition.forEachNote(alignmentDecider.process)
    }
}
