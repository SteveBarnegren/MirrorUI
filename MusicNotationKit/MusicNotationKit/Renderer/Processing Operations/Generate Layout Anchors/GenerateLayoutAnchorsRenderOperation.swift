import Foundation

class GenerateBarLayoutAnchorsProcessingOperation: CompositionProcessingOperation {
    
    private let layoutAnchorsBuilder: LayoutAnchorsBuilder
    
    init(glyphs: GlyphStore) {
        layoutAnchorsBuilder = LayoutAnchorsBuilder(glyphs: glyphs)
    }
    
    func process(composition: Composition) {
        layoutAnchorsBuilder.makeAnchors(from: composition)
    }
}
