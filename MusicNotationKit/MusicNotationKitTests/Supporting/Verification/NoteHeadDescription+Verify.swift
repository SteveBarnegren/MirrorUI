import Foundation
import XCTest
@testable import MusicNotationKit

extension NoteHead {
    
    @discardableResult func verify(style: NoteHead.Style, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(self.style, style, file: file, line: line)
        return self
    }
}
