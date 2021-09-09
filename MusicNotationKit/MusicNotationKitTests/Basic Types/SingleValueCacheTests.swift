import XCTest
@testable import MusicNotationKit

class SingleValueCacheTests: XCTestCase {

    func testCaching() {
        
        var numberOfCalculations = 0
        
        let cache = SingleValueCache<Int> { () -> Int in
            numberOfCalculations += 1
            return 5
        }
        
        // Unused
        XCTAssertEqual(numberOfCalculations, 0)
        
        // Caclulate initial value
        XCTAssertEqual(cache.value, 5)
        XCTAssertEqual(numberOfCalculations, 1)
        
        // Access cached value
        XCTAssertEqual(cache.value, 5)
        XCTAssertEqual(numberOfCalculations, 1)
    }
    
    func testInvalidation() {
        
        var valueToReturn = 5
        
        let cache = SingleValueCache<Int> { () -> Int in
            return valueToReturn
        }
        
        // Initial value
        XCTAssertEqual(cache.value, 5)
        XCTAssertEqual(cache.value, 5)
        XCTAssertEqual(cache.value, 5)
        
        // Value changes, cache not invalidated, origninal value returned
        valueToReturn = 6
        XCTAssertEqual(cache.value, 5)

        // Invalidate cache, new value returned
        cache.invalidate()
        XCTAssertEqual(cache.value, 6)
    }
}
