import Foundation

class CreateBarlinesProcessingOperation: CompositionProcessingOperation {

    private let barlineCreator = BarlineCreator()

    func process(composition: Composition) {
        composition.staves.forEach(process)
    }

    private func process(stave: Stave) {
        stave.bars.eachWithPrevious().forEach { bar, previousBar in
            let barline = barlineCreator.createBarline(leadingOptions: previousBar?.barlineOptions,
                                                       trailingOptions: bar.barlineOptions)
            previousBar?.trailingBarline = barline
            bar.leadingBarline = barline
        }

        // Process the last barline
        if let lastBar = stave.bars.last {
            lastBar.trailingBarline = barlineCreator.createBarline(leadingOptions: lastBar.barlineOptions,
                                                                   trailingOptions: nil)
        }
    }
}
