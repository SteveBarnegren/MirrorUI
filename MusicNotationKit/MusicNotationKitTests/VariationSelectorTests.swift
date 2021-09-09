import XCTest
@testable import MusicNotationKit

class VariationSelectorTests: XCTestCase {

    func test_VariationSuitabilityComparable() {
        XCTAssert(VariationSuitability.preferable > VariationSuitability.allowed)
        XCTAssert(VariationSuitability.allowed > VariationSuitability.concession)
    }
    
}
