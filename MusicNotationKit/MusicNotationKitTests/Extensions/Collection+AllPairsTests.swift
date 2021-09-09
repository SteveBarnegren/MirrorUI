import XCTest
@testable import MusicNotationKit

class Collection_AllPairsTests: XCTestCase {
    
    func test_Empty() {
        
        let array = [String]()
        
        var loopCalled = false
        for (_, _) in array.allPairs() {
            loopCalled = true
        }
        
        XCTAssertFalse(loopCalled)
    }
    
    func test_OneValue() {
        
        let array = ["a"]
        
        var loopCalled = false
        for (_, _) in array.allPairs() {
            loopCalled = true
        }
        
        XCTAssertFalse(loopCalled)
    }
    
    func test_TwoValues() {
        
        let array = ["a", "b"]

        let results = array.allPairs().map { [$0.0, $0.1] }
        
        XCTAssertEqual(results, [
            ["a", "b"]
        ])
    }
    
    func test_ManyValues() {
        
        let array = ["a", "b", "c", "d", "e"]
        
        var results = [[String]]()
        
        for (left, right) in array.allPairs() {
            results.append([left, right])
        }
        
        XCTAssertEqual(results, [
            ["a", "b"],
            ["a", "c"],
            ["a", "d"],
            ["a", "e"],
            ["b", "c"],
            ["b", "d"],
            ["b", "e"],
            ["c", "d"],
            ["c", "e"],
            ["d", "e"]
        ])
    }
}
