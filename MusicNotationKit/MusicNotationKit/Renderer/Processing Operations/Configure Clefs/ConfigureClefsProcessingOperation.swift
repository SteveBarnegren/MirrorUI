import Foundation

class ConfigureClefsProcessingOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        
        // Set the clefs on the bars
        for stave in composition.staves {
            stave.bars.forEach { $0.clef = stave.clef }
        }
        
        composition.forEachBar(process)
    }
    
    private func process(bar: Bar) {
        
        let symbolType: ClefSymbol.SymbolType
        let staveOffset: Double
        
        switch bar.clef.clefType {
            case .gClef:
                symbolType = .gClef
                staveOffset = -1
            case .fClef:
                symbolType = .fClef
                staveOffset = 1
            case .percussion:
                symbolType = .percussion
                staveOffset = 0
        }
        
        bar.clefSymbol.symbolType = symbolType
        bar.clefSymbol.yPosition = staveOffset
    }
}
