import Foundation

extension Collection {
    func allPairs() -> AllPairsSequence<Self> {
        return AllPairsSequence(collection: self)
    }
}

struct AllPairsSequence<WrappedCollection: Collection>: Sequence, IteratorProtocol {
    
    typealias Element = (WrappedCollection.Element, WrappedCollection.Element)
    
    private let wrappedCollection: WrappedCollection
    private var currentIndex: WrappedCollection.Index
    private var currentPairIndex: WrappedCollection.Index
    private var reachedEnd = false
    
    init(collection: WrappedCollection) {
        self.wrappedCollection = collection
        currentIndex = wrappedCollection.startIndex
        currentPairIndex = wrappedCollection.index(after: wrappedCollection.startIndex)
    }
    
    mutating func next() -> Element? {
        
        if reachedEnd {
            return nil
        }
        
        // Wrap around
        if currentPairIndex >= wrappedCollection.endIndex {
            currentIndex = wrappedCollection.index(after: currentIndex)
            currentPairIndex = wrappedCollection.index(after: currentIndex)
            
            // Return nil if we reached the end
            if currentPairIndex >= wrappedCollection.endIndex {
                reachedEnd = true
                return nil
            }
        }
        
        // Get the values
        let currentValue = wrappedCollection[currentIndex]
        let pairValue = wrappedCollection[currentPairIndex]
        
        // Move the pair value along
        currentPairIndex = wrappedCollection.index(after: currentPairIndex)
        
        return (currentValue, pairValue)
    }
}
