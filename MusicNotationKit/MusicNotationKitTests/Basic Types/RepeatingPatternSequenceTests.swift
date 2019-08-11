//
//  RepeatingPatternSequenceTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 28/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class RepeatingPatternSequenceTests: XCTestCase {

    func test_EmptyPattern() {
        
        var sequence = RepeatingPatternSequence<Int>(pattern: [])
        XCTAssertNil(sequence.next())
    }
    
    func test_OneItemPattern() {
        
        let sequence = RepeatingPatternSequence<Int>(pattern: [5])
        sequence.verify(startsWith: [5, 5, 5, 5, 5])
    }
    
    func test_TwoItemPattern() {
        
        let sequence = RepeatingPatternSequence<Int>(pattern: [5, 6])
        sequence.verify(startsWith: [5, 6, 5, 6, 5, 6])
    }
    
    func test_ThreeItemPattern() {
        
        let sequence = RepeatingPatternSequence<Int>(pattern: [5, 6, 7])
        sequence.verify(startsWith: [5, 6, 7, 5, 6, 7, 5, 6, 7])
    }
}
