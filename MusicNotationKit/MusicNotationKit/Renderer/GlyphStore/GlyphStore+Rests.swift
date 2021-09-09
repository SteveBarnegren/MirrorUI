import Foundation

extension GlyphStore {
    
    func glyph(forRestStyle style: RestSymbolDescription.Style) -> Glyph? {
        
        let glyphType: GlyphType
        
        switch style {
        case .none:
            return nil
        case .whole:
            glyphType = .restWhole
        case .half:
            glyphType = .restHalf
        case .crotchet:
            glyphType = .restQuarter
        case .tailed(let tailedStyle):
            switch tailedStyle.numberOfTails {
            case 1: glyphType = .rest8th
            case 2: glyphType = .rest16th
            case 3: glyphType = .rest32nd
            case 4: glyphType = .rest64th
            case 5: glyphType = .rest128th
            case 6: glyphType = .rest256th
            case 7: glyphType = .rest512th
            case 8: glyphType = .rest1024th
            default:
                print("No available glyph for rest with \(tailedStyle.numberOfTails) tails. Using 1024th note rest glyph")
                glyphType = .rest1024th
            }
        }
        
        return self.glyph(forType: glyphType)
    }
}
