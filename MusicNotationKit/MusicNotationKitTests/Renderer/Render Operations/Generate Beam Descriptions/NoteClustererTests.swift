import XCTest
@testable import MusicNotationKit

private class TestNote {
    let value: NoteValue
    let time: Time
    
    init(value: NoteValue, time: Time) {
        self.value = value
        self.time = time
    }
}

class NoteClustererTests: XCTestCase {
    
    // MARK: - 4/4
    
    func test_4_4_BarOfCrotchets() {
        
        let values: [NoteValue] = [4, 4, 4, 4]
        let clusters = self.clusters(from: values, timeSignature: .fourFour)
        clusters.verify([[4], [4], [4], [4]])
    }
    
//    func test_4_4_BarOfQuavers() {
//        
//        let values: [NoteValue] = [8, 8, 8, 8,
//                                   8, 8, 8, 8]
//        let clusters = self.clusters(from: values, timeSignature: .fourFour)
//        clusters.verify([[8, 8, 8, 8], [8, 8, 8, 8]])
//    }
    
    // MARK: - Helpers
    
    private func clusters(from values: [NoteValue], timeSignature: TimeSignature) -> [[TestNote]] {
        
        // Create test notes from the values
        var currentTime = Time.zero
        var testNotes = [TestNote]()
        
        for value in values {
            let note = TestNote(value: value, time: currentTime)
            testNotes.append(note)
            currentTime += value.duration
        }
        
        // Use NoteClusterer to create clusters
        let transformer = NoteClusterer<TestNote>.Transformer<TestNote>(time: { $0.time })
        let noteClusterer = NoteClusterer<TestNote>(transformer: transformer)
        return noteClusterer.clusters(from: testNotes, timeSignature: timeSignature)
    }
}

// MARK: - Verification

private extension Array where Element == [TestNote] {
    
    func verify(_ values: [[NoteValue]], file: StaticString = #file, line: UInt = #line) {
        let asValues = self.map { inner in inner.map { $0.value } }
        XCTAssert(asValues == values, "\(asValues.testFailureDescription) != \(values.testFailureDescription)", file: file, line: line)
    }
}

// MARK: - Descriptions

protocol TestFailureDescribable {
    var testFailureDescription: String { get }
}

extension Array: TestFailureDescribable where Element: TestFailureDescribable {
    
    var testFailureDescription: String {
        return "[" + map { $0.testFailureDescription }.joined(separator: ", ") + "]"
    }
}

extension NoteValue: TestFailureDescribable {
    
    var testFailureDescription: String {
        
        let divisionDesc = "\(self.division)"
        
        let dotsDesc: String
        switch dots {
        case .none:
            dotsDesc = ""
        case .dotted:
            dotsDesc = "."
        case .doubleDotted:
            dotsDesc = ".."
        }
        
        return divisionDesc + dotsDesc
    }
    
}
