import Foundation

class CalculatePlayableItemWidthsProcessingOperation: CompositionProcessingOperation {
    
    private let glyphs: GlyphStore
    private let noteWidthCalculator: NoteWidthCalculator
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
        noteWidthCalculator = NoteWidthCalculator(glyphs: glyphs)
    }
    
    func process(composition: Composition) {
        
        // Calculate note widths
        composition.forEachNote {
            let result = self.noteWidthCalculator.width(forNote: $0)
            $0.horizontalLayoutWidth = .offset(leading: result.leading, trailing: result.trailing)
        }
    }
}
