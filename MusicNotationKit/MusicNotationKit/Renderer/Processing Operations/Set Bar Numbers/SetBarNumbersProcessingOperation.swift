import Foundation

class SetBarNumbersProcessingOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        
        for stave in composition.staves {
            for (index, bar) in stave.bars.enumerated() {
                bar.barNumber = index
            }
        }
    }
}
