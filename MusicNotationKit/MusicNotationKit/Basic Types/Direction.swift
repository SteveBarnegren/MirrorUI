import Foundation

enum VerticalDirection {
    case up
    case down
    
    var opposite: VerticalDirection {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        }
    }
}
