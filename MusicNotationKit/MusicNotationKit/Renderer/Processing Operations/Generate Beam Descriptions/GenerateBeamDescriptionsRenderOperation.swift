import Foundation

class GenerateBeamDescriptionsProcessingOperation: CompositionProcessingOperation {
    
    private let noteBeamDescriber = NoteBeamDescriber<Note>(beaming: .notes)
    
    func process(composition: Composition) {
        composition.staves.forEach(process)
    }
    
    func process(stave: Stave) {
        
        var timeSignature = TimeSignature.fourFour
        
        for bar in stave.bars {
            timeSignature = bar.timeSignature ?? timeSignature
            for noteSequence in bar.sequences {
                noteBeamDescriber.applyBeams(to: noteSequence.notes, timeSignature: timeSignature)
            }
        }
    }
}
