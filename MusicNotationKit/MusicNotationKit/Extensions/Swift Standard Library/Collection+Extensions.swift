import Foundation

public extension Collection {
    
    func toArray() -> [Element] {
        return Array(self)
    }
}

extension Collection {

    var countInbetween: Int {
        if isEmpty {
            return 0
        } else {
            return count - 1
        }
    }
}
