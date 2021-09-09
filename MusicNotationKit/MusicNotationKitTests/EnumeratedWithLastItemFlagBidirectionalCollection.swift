import XCTest
@testable import MusicNotationKit

class EnumeratedWithLastItemFlagBidirectionalCollection: XCTestCase {
    
    func test_FlagIsCorrect() {
        
        let array = ["a", "b", "c"]
        
        var items = [String]()
        var flags = [Bool]()
        
        for (item, flag) in array.eachWithIsLast() {
            items.append(item)
            flags.append(flag)
        }
        
        XCTAssertEqual(items, ["a", "b", "c"])
        XCTAssertEqual(flags, [false, false, true])
    }

}
