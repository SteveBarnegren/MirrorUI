//
//  NaturalSpacingTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 01/10/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NaturalSpacingTests: XCTestCase {
        
    func test_Spacing() {
        
        assert(time: Time(semiquavers: 1), spacing: 2)
        assert(time: Time(semiquavers: 2), spacing: 2.5)
        assert(time: Time(semiquavers: 3), spacing: 3)
        assert(time: Time(semiquavers: 4), spacing: 3.5)
        assert(time: Time(semiquavers: 6), spacing: 4)
        assert(time: Time(semiquavers: 8), spacing: 5)
        assert(time: Time(semiquavers: 12), spacing: 6)
        assert(time: Time(semiquavers: 16), spacing: 7)
    }
    
    // MARK: - Assertions
    
    func assert(time: Time, spacing: Double, file: StaticString = #file, line: UInt = #line) {
        let sut = NaturalSpacing()
        XCTAssertEqual(sut.staveSpacing(forDuration: time), spacing, accuracy: 0.2, file: file, line: line)
    }

}
