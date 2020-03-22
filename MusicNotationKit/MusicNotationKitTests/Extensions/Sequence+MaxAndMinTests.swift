//
//  Sequence+MaxAndMinTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 22/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class Sequence_MaxAndMinTests: XCTestCase {
    
    // MARK: - Max by key
    
    func test_MaxByKey() {
        let array = ["cat", "dog", "chicken", "horse"]
        let result = array.max(byKey: \.count)
        XCTAssertEqual(result, "chicken")
    }
    
    func test_MaxByKey_DuplicateMaximumValues_ReturnsFirstMatch() {
        let array = ["cat", "dog", "bird", "duck"]
        let result = array.max(byKey: \.count)
        XCTAssertEqual(result, "bird")
    }
    
    func test_MaxByKey_NoValues() {
        let array = [String]()
        let result = array.max(byKey: \.count)
        XCTAssertNil(result)
    }
    
    // MARK: - Min by key
    
    func test_MinByKey() {
        let array = ["chicken", "dog", "horse"]
        let result = array.min(byKey: \.count)
        XCTAssertEqual(result, "dog")
    }
    
    func test_MinByKey_DuplicateMinimumValues_ReturnsFirstMatch() {
        let array = ["cat", "bird", "dog", "duck"]
        let result = array.min(byKey: \.count)
        XCTAssertEqual(result, "cat")
    }
    
    func test_MinByKey_NoValues() {
        let array = [String]()
        let result = array.min(byKey: \.count)
        XCTAssertNil(result)
    }
}
