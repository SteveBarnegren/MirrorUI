//
//  NoteBeamDescriberSixEightTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 13/08/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NoteBeamDescriberSixEightTests: NoteBeamDescriberTestsBase {

    override func setUp() {
        super.setUp()
        self.timeSignature = TimeSignature(6, 8)
    }
    
    // MARK: - Half bar groupings
    
    func test_HalfBar_8() {
        assert(values: [8, 8, 8], beams:
            """
            |--|--|
            """
        )
    }
    
    func test_HalfBar_16() {
        assert(values: [16, 16, 16, 16, 16, 16], beams:
            """
            |--|--|--|--|--|
            |--|--|--|--|--|
            """
        )
    }
    
    // MARK: - Full bar groupings
    
    func test_FullBar_4() {
        assert(values: [4, 4, 4], beams:
            """
            |  |  |
            """
        )
    }
    
    func test_FullBar_8() {
        assert(values: [8, 8, 8, 8, 8, 8], beams:
            """
            |--|--|  |--|--|
            """
        )
    }

}
