import Foundation

struct IncrementingSequence<T>: Sequence, IteratorProtocol {
    
    private var currentValue: T
    private let incrementer: (T) -> T
    private var hasReturnedInitialValue = false
    
    init(initialValue: T, incrementer: @escaping (T) -> T) {
        self.currentValue = initialValue
        self.incrementer = incrementer
    }
    
    mutating func next() -> T? {
        
        if hasReturnedInitialValue == false {
            hasReturnedInitialValue = true
            return currentValue
        } else {
            currentValue = incrementer(currentValue)
            return currentValue
        }
    }
}

extension IncrementingSequence where T: AdditiveArithmetic {
    
    init(initialValue: T, addingPattern items: [T]) {
        
        var pattern = RepeatingPatternSequence(pattern: items)
        self = IncrementingSequence(initialValue: initialValue, incrementer: {
            return $0 + pattern.next()!
        })
    }
    
    init(repeatingAdditive items: [T]) {
        
        let rotatedPattern = items.dropFirst().toArray().appending(items.first!)
        self = IncrementingSequence(initialValue: items.first!, addingPattern: rotatedPattern)
    }
}
