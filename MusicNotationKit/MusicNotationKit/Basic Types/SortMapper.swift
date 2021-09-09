import Foundation

/// Allows working with sorted array without sorting the underlying data. Applies
/// the sorting function and maintains a mapping of the original indicies to the
/// sorted indicies.
struct SortMapper<T> {
    
    private let sortedIndicies: [Int]
    
    var count: Int {
        return sortedIndicies.count
    }
    
    init(items: [T], sortingFunction areIncreasingOrder: (T, T) -> Bool) {
        
        sortedIndicies = items.enumerated().sorted(by: { lhs, rhs -> Bool in
            areIncreasingOrder(lhs.element, rhs.element)
        }).map { $0.offset }
    }
    
    func originalIndex(fromSorted sortedIndex: Int) -> Int {
        return sortedIndicies[sortedIndex]
    }
}
