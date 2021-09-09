import Foundation
import XCTest

// MARK: - Tuple 2

func XCTAssertEqualTuple2<A: Equatable, B: Equatable> (_ lhs: (A, B), _ rhs: (A, B), file: StaticString = #file, line: UInt = #line) {
    
    XCTAssertEqual(lhs.0, rhs.0, file: file, line: line)
    XCTAssertEqual(lhs.1, rhs.1, file: file, line: line)
}

func XCTAssertEqualTuple2<A: Equatable, B: Equatable> (_ lhs: (A, B)?, _ rhs: (A, B), file: StaticString = #file, line: UInt = #line) {
    if let lhs = lhs {
        XCTAssertEqualTuple2(lhs, rhs, file: file, line: line)
    } else {
        XCTFail("nil is not equal to \(rhs)", file: file, line: line)
    }
}

// MARK: - Tuple 3

func XCTAssertEqualTuple3<A: Equatable, B: Equatable, C: Equatable> (_ lhs: (A, B, C), _ rhs: (A, B, C), file: StaticString = #file, line: UInt = #line) {
    
    XCTAssertEqual(lhs.0, rhs.0, file: file, line: line)
    XCTAssertEqual(lhs.1, rhs.1, file: file, line: line)
    XCTAssertEqual(lhs.2, rhs.2, file: file, line: line)
}

func XCTAssertEqualTuple3<A: Equatable, B: Equatable, C: Equatable> (_ lhs: (A, B, C)?, _ rhs: (A, B, C), file: StaticString = #file, line: UInt = #line) {
    if let lhs = lhs {
        XCTAssertEqualTuple3(lhs, rhs, file: file, line: line)
    } else {
        XCTFail("nil is not equal to \(rhs)", file: file, line: line)
    }
}
