import Foundation

class JoinBarlinesCompositionProcessingOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        
        for stave in composition.staves {
            for (bar, previous) in stave.bars.eachWithPrevious() where previous?.trailingBarline == nil {
                previous?.trailingBarline = bar.leadingBarline
            }
        }
    }
}
