import XCTest
@testable import MusicNotationKit

class IncrementingSequenceTests: XCTestCase {

    func test_CustomIncrementer() {
        
        let s = IncrementingSequence<Int>(initialValue: 0, incrementer: { $0 + 2 })
        s.verify(startsWith: [0, 2, 4, 6, 8, 10])
    }
    
    func test_AddingPattern() {
        
        let s = IncrementingSequence(initialValue: 0, addingPattern: [1, 2])
        s.verify(startsWith: [0, 1, 3, 4, 6, 7, 9, 10, 12])
    }
    
    func test_RepeatingAdditive() {
        
        let s = IncrementingSequence(repeatingAdditive: [10, 5, 2])
        s.verify(startsWith: [10, 15, 17, 27, 32, 34, 44, 49, 51])
    }

}
