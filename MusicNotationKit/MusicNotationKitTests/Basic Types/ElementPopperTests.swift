import XCTest
@testable import MusicNotationKit

class ElementPopperTests: XCTestCase {
    
    // MARK: - PopNext
    
    func test_EmptyArray() {
        
        let array = [Int]()
        var popper = ElementPopper(array: array)
        XCTAssertNil(popper.popNext())
    }
    
    func test_SingleItemArray() {
        
        let array = [5]
        var popper = ElementPopper(array: array)
        XCTAssertEqual(popper.popNext(), 5)
        XCTAssertNil(popper.popNext())
    }
    
    func test_MultipleItemArray() {
        
        let array = [5, 6, 7, 8]
        var popper = ElementPopper(array: array)
        XCTAssertEqual(popper.popNext(), 5)
        XCTAssertEqual(popper.popNext(), 6)
        XCTAssertEqual(popper.popNext(), 7)
        XCTAssertEqual(popper.popNext(), 8)
        XCTAssertNil(popper.popNext())
    }
    
    // MARK: - Next
    
    func test_Next() {
        
        let array = [5, 6, 7, 8]
        var popper = ElementPopper(array: array)
        XCTAssertEqual(popper.next(), 5)
        XCTAssertEqual(popper.popNext(), 5)
        XCTAssertEqual(popper.next(), 6)
        XCTAssertEqual(popper.popNext(), 6)
        XCTAssertEqual(popper.next(), 7)
        XCTAssertEqual(popper.popNext(), 7)
        XCTAssertEqual(popper.next(), 8)
        XCTAssertEqual(popper.popNext(), 8)
        XCTAssertNil(popper.next())
    }
}
