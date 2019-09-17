//
//  Array+EachWithTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest

class Array_EachWithTests: XCTestCase {
    
    // MARK: - Each with previous
    
    func test_EachWithPrevious_EmptyArray() {
        
        let array = Array<String>()
        
        let results = array.eachWithPrevious()
        XCTAssertEqual(results.count, 0)
    }
    
    func test_EachWithPrevious_SingleItem() {
        
        let array = ["a"]
        
        let results = array.eachWithPrevious()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqualTuple2(results[0], ("a", nil))
    }
    
    func test_EachWithPrevious_TwoItems() {
        
        let array = ["a", "b"]
        
        let results = array.eachWithPrevious()
        XCTAssertEqual(results.count, 2)
        XCTAssertEqualTuple2(results[0], ("a", nil))
        XCTAssertEqualTuple2(results[1], ("b", "a"))
    }
    
    func test_EachWithPrevious_ThreeItems() {
        
        let array = ["a", "b", "c"]
        
        let results = array.eachWithPrevious()
        XCTAssertEqual(results.count, 3)
        XCTAssertEqualTuple2(results[0], ("a", nil))
        XCTAssertEqualTuple2(results[1], ("b", "a"))
        XCTAssertEqualTuple2(results[2], ("c", "b"))
    }
}

