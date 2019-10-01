//
//  Array+ExtractTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 22/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class Array_ExtractTests: XCTestCase {

    func test_ExtractMinimum() {
        
        var array = [5, 6, 10, 2, 9, 3]
        let value = array.extract(minimumBy: { $0 })
        
        XCTAssertEqual(value, 2)
        XCTAssertEqual(array, [5, 6, 10, 9, 3])
    }
    
    func test_ExtractMaximum() {
        
        var array = [5, 6, 10, 2, 9, 3]
        let value = array.extract(maximumBy: { $0 })
        
        XCTAssertEqual(value, 10)
        XCTAssertEqual(array, [5, 6, 2, 9, 3])
    }
}
