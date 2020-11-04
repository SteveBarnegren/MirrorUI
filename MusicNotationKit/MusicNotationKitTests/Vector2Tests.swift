//
//  Vector2Tests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 20/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class Vector2Tests: XCTestCase {

    func test_Vector2XYInitialisation() {
        
        let vector = Vector2(5, 6)
        XCTAssertEqual(vector.x, 5)
        XCTAssertEqual(vector.y, 6)
        XCTAssertEqual(vector.width, 5)
        XCTAssertEqual(vector.height, 6)
    }
    
    // MARK: - Adding/Subtracting X/Y
    
    func test_AddingXAndY() {
        let point = Vector2(5, 5).adding(x: 1, y: 3)
        XCTAssertEqual(point.x, 6)
        XCTAssertEqual(point.y, 8)
    }
    
    func test_AddingX() {
        let point = Vector2(5, 5).adding(x: 1)
        XCTAssertEqual(point.x, 6)
        XCTAssertEqual(point.y, 5)
    }
    
    func test_AddingY() {
        let point = Vector2(5, 5).adding(y: 1)
        XCTAssertEqual(point.x, 5)
        XCTAssertEqual(point.y, 6)
    }
    
    func test_SubtractingXAndY() {
        let point = Vector2(5, 5).subtracting(x: 1, y: 3)
        XCTAssertEqual(point.x, 4)
        XCTAssertEqual(point.y, 2)
    }
    
    func test_SubtractingX() {
        let point = Vector2(5, 5).subtracting(x: 1)
        XCTAssertEqual(point.x, 4)
        XCTAssertEqual(point.y, 5)
    }
    
    func test_SubtractingY() {
        let point = Vector2(5, 5).subtracting(y: 1)
        XCTAssertEqual(point.x, 5)
        XCTAssertEqual(point.y, 4)
    }

}
