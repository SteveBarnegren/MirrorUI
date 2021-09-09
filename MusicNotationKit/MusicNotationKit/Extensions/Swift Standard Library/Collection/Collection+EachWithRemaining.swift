import Foundation

extension Collection {
    func eachWithRemaining() -> EachWithRemainingSequence<Self> {
        return EachWithRemainingSequence(collection: self)
    }
}

struct EachWithRemainingSequence<WrappedCollection: Collection>: Sequence, IteratorProtocol {
    
    typealias Element = (WrappedCollection.Element, WrappedCollection.SubSequence)
    
    private let wrappedCollection: WrappedCollection
    private var currentIndex: WrappedCollection.Index
    
    init(collection: WrappedCollection) {
        self.wrappedCollection = collection
        currentIndex = wrappedCollection.startIndex
    }
    
    mutating func next() -> Element? {
        
        if currentIndex >= wrappedCollection.endIndex {
            return nil
        }
        
        let value = wrappedCollection[currentIndex]
        
        let nextIndex = wrappedCollection.index(after: currentIndex)
        let remianing = wrappedCollection.suffix(from: nextIndex)
        
        currentIndex = nextIndex
        return (value, remianing)
    }
}
