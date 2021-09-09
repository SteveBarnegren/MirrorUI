import Foundation

struct CompositionTime {
    var bar: Int
    var time: Time
    var absoluteTime: Time
    
    static let zero = CompositionTime(bar: 0, time: .zero, absoluteTime: .zero)
}

extension CompositionTime: Equatable {
    static func == (lhs: CompositionTime, rhs: CompositionTime) -> Bool {
        return lhs.bar == rhs.bar && lhs.time == rhs.time
    }
}

extension CompositionTime: Comparable {
    static func < (lhs: CompositionTime, rhs: CompositionTime) -> Bool {
        if lhs.bar == rhs.bar {
            return lhs.time < rhs.time
        } else {
            return lhs.bar < rhs.bar
        }
    }
}
