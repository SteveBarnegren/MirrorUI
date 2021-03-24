//
//  StaveSpaceTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 04/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class StaveSpaceTests: XCTestCase {

    func test_AddSpaces() {
        
        func assert(_ v1: UInt, _ s1: StaveSpace.Sign,
                    add v2: Int,
                    equals v3: UInt, _ s3: StaveSpace.Sign,
                    file: StaticString = #file, line: UInt = #line) {
            XCTAssertEqual(StaveSpace(v1, s1).adding(spaces: v2), StaveSpace(v3, s3), file: file, line: line)
        }
        
        // Positive add positive addition
        assert(2, .positive, add: 2, equals: 4, .positive)
        assert(0, .positive, add: 3, equals: 3, .positive)
        
        // Negative add Negative addition
        assert(2, .negative, add: -2, equals: 4, .negative)
        assert(0, .negative, add: -3, equals: 3, .negative)
        
        // Positive add negative
        assert(3, .positive, add: -1, equals: 2, .positive)
        assert(3, .positive, add: -2, equals: 1, .positive)
        assert(3, .positive, add: -3, equals: 0, .positive)
        assert(3, .positive, add: -4, equals: 0, .negative)
        assert(3, .positive, add: -5, equals: 1, .negative)
        assert(3, .positive, add: -6, equals: 2, .negative)
        assert(3, .positive, add: -7, equals: 3, .negative)
        
        // Nagative add Positive
        assert(3, .negative, add: 0, equals: 3, .negative)
        assert(3, .negative, add: 1, equals: 2, .negative)
        assert(3, .negative, add: 2, equals: 1, .negative)
        assert(3, .negative, add: 3, equals: 0, .negative)
        assert(3, .negative, add: 4, equals: 0, .positive)
        assert(3, .negative, add: 5, equals: 1, .positive)
        assert(3, .negative, add: 6, equals: 2, .positive)
        assert(3, .negative, add: 7, equals: 3, .positive)
        
        // Add from negative zero
        assert(0, .negative, add: 0, equals: 0, .negative)
        assert(0, .negative, add: 1, equals: 0, .positive)
        assert(0, .negative, add: 2, equals: 1, .positive)
        assert(0, .negative, add: 3, equals: 2, .positive)
    }
    
    func test_SubtractSpaces() {
        
        func assert(_ v1: UInt, _ s1: StaveSpace.Sign,
                    subtract v2: Int,
                    equals v3: UInt, _ s3: StaveSpace.Sign,
                    file: StaticString = #file, line: UInt = #line) {
            XCTAssertEqual(StaveSpace(v1, s1).subtracting(spaces: v2), StaveSpace(v3, s3), file: file, line: line)
        }
        
        // Subtract from positive
        assert(3, .positive, subtract: 0, equals: 3, .positive)
        assert(3, .positive, subtract: 1, equals: 2, .positive)
        assert(3, .positive, subtract: 2, equals: 1, .positive)
        assert(3, .positive, subtract: 3, equals: 0, .positive)
        assert(3, .positive, subtract: 4, equals: 0, .negative)
        assert(3, .positive, subtract: 5, equals: 1, .negative)
        assert(3, .positive, subtract: 6, equals: 2, .negative)
        assert(3, .positive, subtract: 7, equals: 3, .negative)
        
        // Subtract negatives from neagitive
        assert(3, .negative, subtract: -1, equals: 2, .negative)
        assert(3, .negative, subtract: -2, equals: 1, .negative)
        assert(3, .negative, subtract: -3, equals: 0, .negative)
        assert(3, .negative, subtract: -4, equals: 0, .positive)
        assert(3, .negative, subtract: -5, equals: 1, .positive)
        assert(3, .negative, subtract: -6, equals: 2, .positive)
        assert(3, .negative, subtract: -7, equals: 3, .positive)
    }
    
    // MARK: - Stave Position conversion
    
    func test_FromStavePosition_RoundingUp() {
        
        // Stave position 6 -> -6 (round up)
        XCTAssertEqual(StaveSpace(stavePosition: 6, lineRounding: .spaceAbove),
                       StaveSpace(3, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 5, lineRounding: .spaceAbove),
                       StaveSpace(2, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 4, lineRounding: .spaceAbove),
                       StaveSpace(2, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 3, lineRounding: .spaceAbove),
                       StaveSpace(1, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 2, lineRounding: .spaceAbove),
                       StaveSpace(1, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 1, lineRounding: .spaceAbove),
                       StaveSpace(0, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 0, lineRounding: .spaceAbove),
                       StaveSpace(0, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: -1, lineRounding: .spaceAbove),
                       StaveSpace(0, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -2, lineRounding: .spaceAbove),
                       StaveSpace(0, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -3, lineRounding: .spaceAbove),
                       StaveSpace(1, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -4, lineRounding: .spaceAbove),
                       StaveSpace(1, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -5, lineRounding: .spaceAbove),
                       StaveSpace(2, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -6, lineRounding: .spaceAbove),
                       StaveSpace(2, .negative))
    }
    
    func test_FromStavePosition_RoundingDown() {
        
        // Stave position 6 -> -6 (round up)
        XCTAssertEqual(StaveSpace(stavePosition: 6, lineRounding: .spaceBelow),
                       StaveSpace(2, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 5, lineRounding: .spaceBelow),
                       StaveSpace(2, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 4, lineRounding: .spaceBelow),
                       StaveSpace(1, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 3, lineRounding: .spaceBelow),
                       StaveSpace(1, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 2, lineRounding: .spaceBelow),
                       StaveSpace(0, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 1, lineRounding: .spaceBelow),
                       StaveSpace(0, .positive))
        XCTAssertEqual(StaveSpace(stavePosition: 0, lineRounding: .spaceBelow),
                       StaveSpace(0, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -1, lineRounding: .spaceBelow),
                       StaveSpace(0, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -2, lineRounding: .spaceBelow),
                       StaveSpace(1, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -3, lineRounding: .spaceBelow),
                       StaveSpace(1, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -4, lineRounding: .spaceBelow),
                       StaveSpace(2, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -5, lineRounding: .spaceBelow),
                       StaveSpace(2, .negative))
        XCTAssertEqual(StaveSpace(stavePosition: -6, lineRounding: .spaceBelow),
                       StaveSpace(3, .negative))
    }
    
    func test_ConvertToStavePosition() {
        
        XCTAssertEqual(StaveSpace(4, .positive).stavePosition.location, 9)
        XCTAssertEqual(StaveSpace(3, .positive).stavePosition.location, 7)
        XCTAssertEqual(StaveSpace(2, .positive).stavePosition.location, 5)
        XCTAssertEqual(StaveSpace(1, .positive).stavePosition.location, 3)
        XCTAssertEqual(StaveSpace(0, .positive).stavePosition.location, 1)
        XCTAssertEqual(StaveSpace(0, .negative).stavePosition.location, -1)
        XCTAssertEqual(StaveSpace(1, .negative).stavePosition.location, -3)
        XCTAssertEqual(StaveSpace(2, .negative).stavePosition.location, -5)
        XCTAssertEqual(StaveSpace(3, .negative).stavePosition.location, -7)
        XCTAssertEqual(StaveSpace(4, .negative).stavePosition.location, -9)
    }
}
