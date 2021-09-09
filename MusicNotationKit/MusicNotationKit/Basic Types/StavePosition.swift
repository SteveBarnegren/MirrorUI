import Foundation

struct StavePosition {
    
    static let zero = StavePosition(location: 0)
    
    let location: Int
    
    var yPosition: Double {
        Double(location)/2
    }
}

extension StavePosition: Comparable {
    
    static func < (lhs: StavePosition, rhs: StavePosition) -> Bool {
        return lhs.location < rhs.location
    }
}

func + (lhs: StavePosition, rhs: StavePosition) -> StavePosition {
    
    let newLocation = lhs.location + rhs.location
    return StavePosition(location: newLocation)
}

func += (lhs: inout StavePosition, rhs: StavePosition) {
    lhs = lhs + rhs
}

func - (lhs: StavePosition, rhs: StavePosition) -> StavePosition {
    
    let newLocation = lhs.location - rhs.location
    return StavePosition(location: newLocation)
}

func -= (lhs: inout StavePosition, rhs: StavePosition) {
    lhs = lhs - rhs
}
