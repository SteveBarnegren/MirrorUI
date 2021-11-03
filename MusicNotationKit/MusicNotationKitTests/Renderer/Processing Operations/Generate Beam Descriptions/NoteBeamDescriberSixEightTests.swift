import XCTest
@testable import MusicNotationKit

class NoteBeamDescriberSixEightTests: NoteBeamDescriberTestsBase {

    override func setUp() {
        super.setUp()
        self.timeSignature = TimeSignature(6, 8)
    }
    
    // MARK: - Half bar groupings
    
    func test_HalfBar_8() {
        assert(values: Array(repeating: 8, count: 3), beams:
            """
            |--|--|
            """
        )
    }
    
    func test_HalfBar_16() {
        assert(values: Array(repeating: 16, count: 6), beams:
            """
            |--|--|--|--|--|
            |--|--|--|--|--|
            """
        )
    }
    
    func test_HalfBar_32() {
        assert(values: Array(repeating: 32, count: 12), beams:
            """
            |--|--|--|--|--|--|--|--|--|--|--|
            |--|--|--|  |--|--|--|  |--|--|--|
            |--|--|--|  |--|--|--|  |--|--|--|
            """
        )
    }
    
    func test_HalfBar_64() {
        // TODO: Current beaming doesn't look to be correct. (should be as this unit test describes)
        /*
        assert(values: Array(repeating: 64, count: 24), beams:
            """
            |--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
            |--|--|--|--|--|--|--|--|--|--|--|  |--|--|--|--|--|--|--|--|--|--|--|
            |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|
            |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|
            """
        )
 */
    }
    
    func test_8_16_16_16_16() {
        assert(values: [8, 16, 16, 16, 16], beams:
            """
            |--|--|--|--|
            |  |--|--|--|
            """
        )
    }
    
    func test_16_16_8_16_16() {
        assert(values: [16, 16, 8, 16, 16], beams:
            """
            |--|--|--|--|
            |--|  |  |--|
            """
        )
    }
    
    func test_16_16_16_16_8() {
        assert(values: [16, 16, 16, 16, 8], beams:
            """
            |--|--|--|--|
            |--|--|--|  |
            """
        )
    }
    
    func test_16_8_16_16_16() {
        assert(values: [16, 8, 16, 16, 16], beams:
            """
            |--|--|--|--|
            |- |  |--|--|
            """
        )
    }
    
    // MARK: - Full bar groupings
    
    func test_FullBar_4() {
        assert(values: Array(repeating: 4, count: 3), beams:
            """
            |  |  |
            """
        )
    }
    
    func test_FullBar_8() {
        assert(values: Array(repeating: 8, count: 6), beams:
            """
            |--|--|  |--|--|
            """
        )
    }
    
    func test_FullBar_16() {
        assert(values: Array(repeating: 16, count: 12), beams:
            """
            |--|--|--|--|--|  |--|--|--|--|--|
            |--|--|--|--|--|  |--|--|--|--|--|
            """
        )
    }
    
    func test_FullBar_32() {
        assert(values: Array(repeating: 32, count: 24), beams:
            """
            |--|--|--|--|--|--|--|--|--|--|--|  |--|--|--|--|--|--|--|--|--|--|--|
            |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|
            |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|
            """
        )
    }
}
