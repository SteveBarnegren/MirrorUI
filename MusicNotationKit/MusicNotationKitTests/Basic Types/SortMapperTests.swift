import XCTest
@testable import MusicNotationKit

class SortMapperTests: XCTestCase {

    func testSortMapper() {
        
        let strings = ["d", "b", "a", "c"]
        
        let mapper = SortMapper<String>(items: strings, sortingFunction: <)
        XCTAssertEqual(mapper.originalIndex(fromSorted: 0), 2)
        XCTAssertEqual(mapper.originalIndex(fromSorted: 1), 1)
        XCTAssertEqual(mapper.originalIndex(fromSorted: 2), 3)
        XCTAssertEqual(mapper.originalIndex(fromSorted: 3), 0)
        
        XCTAssertEqual(mapper.count, 4)
    }

}
