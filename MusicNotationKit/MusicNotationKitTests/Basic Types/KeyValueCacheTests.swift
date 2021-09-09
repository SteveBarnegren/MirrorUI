import Foundation
import XCTest
@testable import MusicNotationKit

class KeyValueCacheTests: XCTestCase {

    private let cache = KeyValueCache<String, String>()
    
    func test_ReturnsNilForUnknownKey() {
        XCTAssertNil(cache.value(forKey: "a"))
    }
    
    func test_ReturnsValueForCachedKey() {
        
        cache.set(value: "apple", forKey: "a")
        cache.set(value: "banana", forKey: "b")
        cache.set(value: "carrot", forKey: "c")
        
        XCTAssertEqual(cache.value(forKey: "a"), "apple")
        XCTAssertEqual(cache.value(forKey: "b"), "banana")
        XCTAssertEqual(cache.value(forKey: "c"), "carrot")
    }
    
    func test_ValuesCanBeUpdated() {
        
        cache.set(value: "apple", forKey: "a")
        cache.set(value: "banana", forKey: "b")
        cache.set(value: "carrot", forKey: "c")
        
        cache.set(value: "ant", forKey: "a")
        cache.set(value: "bird", forKey: "b")
        cache.set(value: "cat", forKey: "c")

        XCTAssertEqual(cache.value(forKey: "a"), "ant")
        XCTAssertEqual(cache.value(forKey: "b"), "bird")
        XCTAssertEqual(cache.value(forKey: "c"), "cat")
    }
}
