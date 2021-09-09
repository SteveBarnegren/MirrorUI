import XCTest
@testable import MusicNotationKit

class NaturalSpacingTests: XCTestCase {
    
    let naturalSpacing = NaturalSpacing()
        
    func test_SpacingWithFullStrength() {
        
        naturalSpacing.strength = 1
        
        assert(time: Time(semiquavers: 1), spacing: 2)
        assert(time: Time(semiquavers: 2), spacing: 2.5)
        assert(time: Time(semiquavers: 3), spacing: 3)
        assert(time: Time(semiquavers: 4), spacing: 3.5)
        assert(time: Time(semiquavers: 6), spacing: 4)
        assert(time: Time(semiquavers: 8), spacing: 5)
        assert(time: Time(semiquavers: 12), spacing: 6)
        assert(time: Time(semiquavers: 16), spacing: 7)
    }
    
    func test_SpacingWithNoStrength() {
        
        naturalSpacing.strength = 0
        
        assert(time: Time(semiquavers: 1), spacing: 1)
        assert(time: Time(semiquavers: 2), spacing: 2)
        assert(time: Time(semiquavers: 3), spacing: 3)
        assert(time: Time(semiquavers: 4), spacing: 4)
        assert(time: Time(semiquavers: 6), spacing: 6)
        assert(time: Time(semiquavers: 8), spacing: 8)
        assert(time: Time(semiquavers: 12), spacing: 12)
        assert(time: Time(semiquavers: 16), spacing: 16)
    }
    
    // MARK: - Assertions
    
    func assert(time: Time, spacing: Double, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(naturalSpacing.staveSpacing(forDuration: time), spacing, accuracy: 0.2, file: file, line: line)
    }

}
