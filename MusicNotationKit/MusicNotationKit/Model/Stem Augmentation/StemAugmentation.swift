import Foundation

public enum StemAugmentation {
    case tremolo1
    case tremolo2
    case tremolo3
    case tremolo4
    case tremolo5

    var glyphType: GlyphType {
        switch self {
            case .tremolo1: return .tremolo1
            case .tremolo2: return .tremolo2
            case .tremolo3: return .tremolo3
            case .tremolo4: return .tremolo4
            case .tremolo5: return .tremolo5
        }
    }
}
