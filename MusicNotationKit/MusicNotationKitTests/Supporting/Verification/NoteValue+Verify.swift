import Foundation
@testable import MusicNotationKit
import XCTest

extension NoteValue {
    
    func verify(duration: Time, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self.duration, duration, file: file, line: line)
    }
}
