//
//  StavePositionTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 24/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class StavePositionTests: XCTestCase {

    func test_PositionFromOffset() {
        XCTAssertEqual(StavePosition(location: -5).yPosition, -2.5)
        XCTAssertEqual(StavePosition(location: -4).yPosition, -2.0)
        XCTAssertEqual(StavePosition(location: -3).yPosition, -1.5)
        XCTAssertEqual(StavePosition(location: -2).yPosition, -1.0)
        XCTAssertEqual(StavePosition(location: -1).yPosition, -0.5)
        XCTAssertEqual(StavePosition(location: 0).yPosition, 0)
        XCTAssertEqual(StavePosition(location: 1).yPosition, 0.5)
        XCTAssertEqual(StavePosition(location: 2).yPosition, 1.0)
        XCTAssertEqual(StavePosition(location: 3).yPosition, 1.5)
        XCTAssertEqual(StavePosition(location: 4).yPosition, 2.0)
        XCTAssertEqual(StavePosition(location: 5).yPosition, 2.5)
    }
    
    func test_Comaparable() {
        XCTAssertLessThan(StavePosition(location: 1), StavePosition(location: 2))
        XCTAssertEqual(StavePosition(location: 5), StavePosition(location: 5))
        XCTAssertGreaterThan(StavePosition(location: 2), StavePosition(location: 1))
    }
    
    func test_addition() {
        let a = StavePosition(location: 3)
        let b = StavePosition(location: 2)
        XCTAssertEqual(a + b, StavePosition(location: 5))
    }
    
    func test_additionInPlace() {
        var a = StavePosition(location: 3)
        let b = StavePosition(location: 2)
        a += b 
        XCTAssertEqual(a, StavePosition(location: 5))
    }
    
    func test_subtraction() {
        let a = StavePosition(location: 5)
        let b = StavePosition(location: 2)
        XCTAssertEqual(a - b, StavePosition(location: 3))
    }
    
    func test_subtractionInPlace() {
        var a = StavePosition(location: 5)
        let b = StavePosition(location: 2)
        a -= b
        XCTAssertEqual(a, StavePosition(location: 3))
    }
}
