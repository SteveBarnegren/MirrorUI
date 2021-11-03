import Foundation

extension Array {

    mutating func append(_ elements: Element...) {
        self.append(contentsOf: elements)
    }

    func appending(_ elements: Element...) -> Self {
        var copy = self
        copy.append(contentsOf: elements)
        return copy
    }
}
