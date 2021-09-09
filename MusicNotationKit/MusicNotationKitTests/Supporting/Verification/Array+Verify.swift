import Foundation
import XCTest
@testable import MusicNotationKit

extension Array where Element: AnyObject {
    
    func verify(containsInstances instances: [Element], file: StaticString = #file, line: UInt = #line) {
        
        if self.count != instances.count {
            XCTFail("Expected \(instances.count) items, have \(self.count)", file: file, line: line)
            return
        }
        
        for (index, (obj1, obj2)) in zip(self, instances).enumerated() where obj1 !== obj2 {
            XCTFail("Different instances at index \(index)", file: file, line: line)
        }
    }
}

extension Array where Element: Equatable {
    func verify(equals other: [Element], message: String? = nil, file: StaticString = #file, line: UInt = #line) {
        if let m = message {
            XCTAssert(self == other, m, file: file, line: line)
        } else {
            XCTAssertEqual(self, other, file: file, line: line)
        }
    }
}

extension Sequence where Element: Equatable {
    func verify(startsWith prefix: [Element], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(Array(self.prefix(prefix.count)), prefix, file: file, line: line)
    }
}
