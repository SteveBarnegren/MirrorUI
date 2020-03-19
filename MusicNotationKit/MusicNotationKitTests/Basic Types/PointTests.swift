//
//  PointTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 19/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class PointTests: XCTestCase {
    
    // MARK: - Adding/Subtracting X/Y
    
    func test_AddingXAndY() {
        let point = Point(5, 5).adding(x: 1, y: 3)
        XCTAssertEqual(point.x, 6)
        XCTAssertEqual(point.y, 8)
    }
    
    func test_AddingX() {
        let point = Point(5, 5).adding(x: 1)
        XCTAssertEqual(point.x, 6)
        XCTAssertEqual(point.y, 5)
    }
    
    func test_AddingY() {
        let point = Point(5, 5).adding(y: 1)
        XCTAssertEqual(point.x, 5)
        XCTAssertEqual(point.y, 6)
    }
    
    func test_SubtractingXAndY() {
        let point = Point(5, 5).subtracting(x: 1, y: 3)
        XCTAssertEqual(point.x, 4)
        XCTAssertEqual(point.y, 2)
    }
    
    func test_SubtractingX() {
        let point = Point(5, 5).subtracting(x: 1)
        XCTAssertEqual(point.x, 4)
        XCTAssertEqual(point.y, 5)
    }
    
    func test_SubtractingY() {
        let point = Point(5, 5).subtracting(y: 1)
        XCTAssertEqual(point.x, 5)
        XCTAssertEqual(point.y, 4)
    }
}
