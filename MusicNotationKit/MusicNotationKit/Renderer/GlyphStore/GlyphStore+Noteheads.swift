import Foundation

extension GlyphStore {
    
    func glyph(forNoteHeadStyle style: NoteHead.Style) -> Glyph? {
        switch style {
        case .none:
            return nil
        case .semibreve:
            return self.glyph(forType: .noteheadWhole)
        case .open:
            return self.glyph(forType: .noteheadHalf)
        case .filled:
            return self.glyph(forType: .noteheadBlack)
        case .cross:
            return self.glyph(forType: .noteheadXBlack)
        }
    }
}
