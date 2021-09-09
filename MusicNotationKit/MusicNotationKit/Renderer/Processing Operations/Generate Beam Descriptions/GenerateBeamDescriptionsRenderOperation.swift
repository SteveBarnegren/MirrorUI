import Foundation

class GenerateBeamDescriptionsProcessingOperation: CompositionProcessingOperation {
    
    private let noteBeamDescriber = NoteBeamDescriber<Note>(beaming: .notes)
    
    func process(composition: Composition) {
        composition.staves.forEach(process)
    }
    
    func process(stave: Stave) {
        
        for bar in stave.bars {
            let timeSignature = bar.timeSignature
            for noteSequence in bar.sequences {
                noteBeamDescriber.applyBeams(to: noteSequence.notes, timeSignature: timeSignature)
            }
        }
    }
}
