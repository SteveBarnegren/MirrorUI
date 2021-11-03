import XCTest
@testable import MusicNotationKit

class Array_AppendTests: XCTestCase {

    func test_AppendVariadic() {
        var array = ["a", "b"]
        array.append("c", "d")
        XCTAssertEqual(array, ["a", "b", "c", "d"])
    }

    func test_AppendingVariadic() {
        let array = ["a", "b"].appending("c", "d")
        XCTAssertEqual(array, ["a", "b", "c", "d"])
    }
}
