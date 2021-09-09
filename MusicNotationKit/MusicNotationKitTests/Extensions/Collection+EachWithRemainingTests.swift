import XCTest
@testable import MusicNotationKit

class Collection_EachWithRemainingTests: XCTestCase {

    func test_EachWithRemaining() {
        
        let input = ["a", "b", "c", "d"]
        
        var output = [(String, [String])]()
        
        for (value, reminaing) in input.eachWithRemaining() {
            output.append((value, reminaing.toArray()))
        }
        
        XCTAssertEqual(output[maybe: 0]?.0, "a")
        XCTAssertEqual(output[maybe: 0]?.1, ["b", "c", "d"])
        
        XCTAssertEqual(output[maybe: 1]?.0, "b")
        XCTAssertEqual(output[maybe: 1]?.1, ["c", "d"])
        
        XCTAssertEqual(output[maybe: 2]?.0, "c")
        XCTAssertEqual(output[maybe: 2]?.1, ["d"])
        
        XCTAssertEqual(output[maybe: 3]?.0, "d")
        XCTAssertEqual(output[maybe: 3]?.1, [])
        
        XCTAssertNil(output[maybe: 4])
    }
    
    func test_SingleItem() {
        
        let input = ["a"]
        
        var output = [(String, [String])]()
        
        for (value, reminaing) in input.eachWithRemaining() {
            output.append((value, reminaing.toArray()))
        }
        
        XCTAssertEqual(output.count, 1)
        XCTAssertEqual(output[maybe: 0]?.0, "a")
        XCTAssertEqual(output[maybe: 0]?.1, [])
    }
    
    func test_EmptyCollection() {
        
        let input = [String]()
        
        var loopCalled = false
        for _ in input.eachWithRemaining() {
            loopCalled = true
        }
        
        XCTAssertFalse(loopCalled)
    }

}
