import Foundation

public extension Collection {
    
    /// Returns a new array sorted ascending by the `Comparable` result of transforming
    /// each element through the `transform` closure
    ///
    ///     let array = ["parrot", "dog", "worm"]
    ///     let sortedByLength = array.sortedAscendingBy { $0.count }
    ///     print("\(sortedByLength)") // ["dog", "worm", "parrot"]
    ///
    /// - Parameter transform: Closure to transform each `Element` to a `Comparable`
    /// type
    /// - Returns: Array of `Element`
    func sortedAscendingBy<T: Comparable>(_ transform: (Element) -> T) -> [Element] {
        return sorted { transform($0) < transform($1) }
    }
    
    /// Returns a new array sorted descending by the `Comparable` result of transforming
    /// each element through the `transform` closure
    ///
    ///     let array = ["parrot", "dog", "worm"]
    ///     let sortedByLength = array.sortedDescendingBy { $0.count }
    ///     print("\(sortedByLength)") // ["parrot", "worm", "dog"]
    ///
    /// - Parameter transform: Closure to transform each `Element` to a `Comparable`
    /// type
    /// - Returns: Array of `Element`
    func sortedDescendingBy<T: Comparable>(_ transform: (Element) -> T) -> [Element] {
        return sorted { transform($0) > transform($1) }
    }
}

extension Array {
    
    /// Sorts the `Element`s in ascending order
    ///
    /// - Parameter transform: Closure to transform each element to a `Comparable` type
    mutating func sortAscendingBy<T: Comparable>(_ transform: (Element) -> T) {
        sort { transform($0) < transform($1) }
    }
    
    /// Sorts the `Element`s in descending order
    ///
    /// - Parameter transform: Closure to transform each element to a `Comparable` type
    mutating func sortDescendingBy<T: Comparable>(_ transform: (Element) -> T) {
        sort { transform($0) > transform($1) }
    }
}
