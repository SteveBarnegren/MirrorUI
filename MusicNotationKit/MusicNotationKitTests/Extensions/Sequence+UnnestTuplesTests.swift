import XCTest
@testable import MusicNotationKit

class Sequence_UnnestTuplesTests: XCTestCase {
    
    func test_UnnestTuples() {
        
        let array: [((String, String), String)] = [
            (("a", "b"), "c"),
            (("d", "e"), "f"),
            (("g", "h"), "i")
            ]
        
        let result = Array(array.unnestTuples())
        
        XCTAssertEqual(result.count, 3)
        XCTAssertEqualTuple3(result[maybe: 0], ("a", "b", "c"))
        XCTAssertEqualTuple3(result[maybe: 1], ("d", "e", "f"))
        XCTAssertEqualTuple3(result[maybe: 2], ("g", "h", "i"))
    }
}
