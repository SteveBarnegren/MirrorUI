//
//  Sequence+UnnestTuplesTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 29/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class Sequence_UnnestTuplesTests: XCTestCase {
    
    func test_UnnestTuples() {
        
        let array: [((String, String), String)] = [
            (("a", "b"), "c"),
            (("d", "e"), "f"),
            (("g", "h"), "i")
            ]
        
        let result = Array(array.unnestTuples())
        
        XCTAssertEqual(result.count, 3)
        XCTAssertEqualTuple3(result[maybe: 0], ("a", "b", "c"))
        XCTAssertEqualTuple3(result[maybe: 1], ("d", "e", "f"))
        XCTAssertEqualTuple3(result[maybe: 2], ("g", "h", "i"))
    }
}
