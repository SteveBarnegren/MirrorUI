//
//  Sequence+ContainsTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 05/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class Sequence_ContainsTests: XCTestCase {

    func test_SequenceContainsAnyOf() {
        
        XCTAssertFalse([String]().contains(anyOf: ["a", "b", "c"]))
        XCTAssertFalse(["a", "b", "c", "d", "e"].contains(anyOf: ["f", "g", "h"]))
        XCTAssertFalse(["a", "b", "c", "d", "e"].contains(anyOf: []))
        
        XCTAssertTrue(["a", "b", "c", "d", "e"].contains(anyOf: ["b", "c", "e"]))
        XCTAssertTrue(["a", "b", "c", "d", "e"].contains(anyOf: ["a"]))
    }
}
