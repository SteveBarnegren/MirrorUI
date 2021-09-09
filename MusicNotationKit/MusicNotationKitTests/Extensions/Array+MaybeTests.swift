import XCTest
@testable import MusicNotationKit

class Array_MaybeTests: XCTestCase {
    
    // MARK: - Append maybe
    
    func test_WhenGivenItem_AppendMaybeAppendsItem() {
        
        var array = ["a", "b", "c"]
        array.append(maybe: "d")
        XCTAssertEqual(array, ["a", "b", "c", "d"])
    }
    
    func test_WhenGivenNil_AppendMaybeDoesNothing() {
        
        var array = ["a", "b", "c"]
        array.append(maybe: nil)
        XCTAssertEqual(array, ["a", "b", "c"])
    }
    
    // MARK: - Appending maybe
    
    func test_WhenGivenItem_AppendingMaybeAppendsItem() {
        
        let array = ["a", "b", "c"]
        XCTAssertEqual(array.appending(maybe: "d"), ["a", "b", "c", "d"])
    }
    
    func test_WhenGivenNil_AppendingMaybeDoesNothing() {
        
        let array = ["a", "b", "c"]
        XCTAssertEqual(array.appending(maybe: nil), ["a", "b", "c"])
    }
}
