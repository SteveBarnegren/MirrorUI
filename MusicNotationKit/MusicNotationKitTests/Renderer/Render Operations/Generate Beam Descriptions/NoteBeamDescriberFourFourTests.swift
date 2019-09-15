//
//  NoteBeamDescriberFourFourTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 11/08/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NoteBeamDescriberFourFourTests: NoteBeamDescriberTestsBase {
    
    override func setUp() {
        super.setUp()
        self.timeSignature = TimeSignature(4, 4)
    }
    
    // MARK: - Crotchet Length Groupings
    
    func test_4() {
        assert(values: [4], beams:
            """
            |
            """
        )
    }
    
    func test_8_8() {
        assert(values: [8, 8], beams:
            """
            |--|
            """
        )
    }
    
  func test_8_16_16() {
        assert(values: [8, 16, 16], beams:
            """
            |--|--|
            |  |--|
            """
        )
    }
    
    func test_16_8_16() {
        assert(values: [16, 8, 16], beams:
            """
            |--|--|
            |- | -|
            """
        )
    }
    
    func test_16_16_8() {
        assert(values: [16, 16, 8], beams:
            """
            |--|--|
            |--|  |
            """
        )
    }
    
    func test_16_16_16_16() {
        assert(values: [16, 16, 16, 16], beams:
            """
            |--|--|--|
            |--|--|--|
            """
        )
    }
    
    func test_32_32_32_32_32_32_32_32() {
        assert(values: Array(repeating: 32, count: 8), beams:
            """
            |--|--|--|--|--|--|--|
            |--|--|--|--|--|--|--|
            |--|--|--|  |--|--|--|
            """
        )
    }
    
    // MARK: - Half bar groupings
    
    func test_HalfBar_4() {
        assert(values: [4, 4], beams:
            """
            |  |
            """
        )
    }
    
    func test_HalfBar_8() {
        assert(values: [8, 8, 8, 8], beams:
            """
            |--|--|--|
            """
        )
    }
    
    func test_HalfBar_16() {
        assert(values: [16, 16, 16, 16, 16, 16, 16, 16], beams:
            """
            |--|--|--|  |--|--|--|
            |--|--|--|  |--|--|--|
            """
        )
    }
    
    func test_HalfBar_32() {
        assert(values: Array(repeating: 32, count: 16), beams:
            """
            |--|--|--|--|--|--|--|  |--|--|--|--|--|--|--|
            |--|--|--|--|--|--|--|  |--|--|--|--|--|--|--|
            |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|
            """
        )
    }
    
    // MARK: - Full Bars
    
    func test_FullBar_4() {
        assert(values: [4, 4, 4, 4], beams:
            """
            |  |  |  |
            """
        )
    }
    
    func test_FullBar_8() {
        assert(values: [8, 8, 8, 8, 8, 8, 8, 8], beams:
            """
            |--|--|--|  |--|--|--|
            """
        )
    }
    
    func test_FullBar_16() {
        assert(values: Array(repeating: 16, count: 16), beams:
            """
            |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|
            |--|--|--|  |--|--|--|  |--|--|--|  |--|--|--|
            """
        )
    }
}
