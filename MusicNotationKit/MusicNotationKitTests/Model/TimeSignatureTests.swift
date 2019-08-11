//
//  TimeSignatureTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 27/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class TimeSignatureTests: XCTestCase {

    // MARK: - 1/16
    
    func test_1_16() {
        assert(
            timeSignature: TimeSignature(1, 16),
            breaks: []
        )
    }
    
    // MARK: - 2/16 or 1/8
    
    func test_2_16() {
        assert(
            timeSignature: TimeSignature(2, 16),
            breaks: []
        )
    }
    
    func test_1_8() {
        assert(
            timeSignature: TimeSignature(1, 8),
            breaks: []
        )
    }
    
    // MARK: - 3/16
    
    func test_3_16() {
        assert(
            timeSignature: TimeSignature(3, 16),
            breaks: []
        )
    }
    
    // MARK: - 4/16 or 2/8
    
    func test_4_16() {
        assert(
            timeSignature: TimeSignature(4, 16),
            breaks: [Time(semiquavers: 2)]
        )
    }
    
    func test_2_8() {
        assert(
            timeSignature: TimeSignature(2, 8),
            breaks: []
        )
    }
    
    func test_1_4() {
        assert(
            timeSignature: TimeSignature(1, 4),
            breaks: []
        )
    }

    // MARK: - 5/16
    
    func test_5_16() {
        assert(
            timeSignature: TimeSignature(5, 16),
            breaks: [Time(semiquavers: 3)]
        )
    }
    
    // MARK: - 6/16 or 3/8
    
    func test_6_16() {
        assert(
            timeSignature: TimeSignature(6, 16),
            breaks: [Time(semiquavers: 3)]
        )
    }
    
    func test_3_8() {
        assert(
            timeSignature: TimeSignature(3, 8),
            breaks: []
        )
    }
    
    // MARK: - 8/16 or 4/8 or 2/4 or 1/2
    
    func test_8_16() {
        assert(
            timeSignature: TimeSignature(8, 16),
            breaks: [Time(semiquavers: 4)]
        )
    }
    
    func test_4_8() {
        assert(
            timeSignature: TimeSignature(4, 8),
            breaks: [Time(quavers: 2)]
        )
    }
    
    func test_2_4() {
        assert(
            timeSignature: TimeSignature(2, 4),
            breaks: []
        )
    }
    
    func test_1_2() {
        assert(
            timeSignature: TimeSignature(1, 2),
            breaks: []
        )
    }
    
    // MARK: - 9/16
    
    func test_9_16() {
        assert(
            timeSignature: TimeSignature(9, 16),
            breaks: [Time(semiquavers: 3), Time(semiquavers: 6)]
        )
    }
    
    // MARK: - 10/16 or 5/8
    
    func test_5_8() {
        assert(
            timeSignature: TimeSignature(5, 8),
            breaks: [Time(quavers: 3)]
        )
    }
    
    // MARK: - 12/16 or 6/8 or 3/4
    
    func test_12_16() {
        assert(
            timeSignature: TimeSignature(12, 16),
            breaks: [Time(semiquavers: 3), Time(semiquavers: 6), Time(semiquavers: 9)]
        )
    }
    
    func test_6_8() {
        assert(
            timeSignature: TimeSignature(6, 8),
            breaks: [Time(quavers: 3)]
        )
    }
    
    func test_3_4() {
        assert(
            timeSignature: TimeSignature(3, 4),
            breaks: []
        )
    }
    
    // MARK: - 14/16 or 7/8
    
    func test_7_8() {
        assert(
            timeSignature: TimeSignature(7, 8),
            breaks: [Time(quavers: 4)]
        )
    }
    
    // MARK: - 16/16 or 8/8 or 4/4 or 2/2
    
    func test_8_8() {
        assert(
            timeSignature: TimeSignature(8, 8),
            breaks: [Time(quavers: 3), Time(quavers: 6)]
        )
    }
    
    func test_4_4() {
        assert(
            timeSignature: TimeSignature(4, 4),
            breaks: [Time(crotchets: 2)]
        )
    }
    
    func test_2_2() {
        assert(
            timeSignature: TimeSignature(2, 2),
            breaks: [Time(crotchets: 2)]
        )
    }
    
    // MARK: - 18/16 or 9/8
    
    func test_9_8() {
        assert(
            timeSignature: TimeSignature(9, 8),
            breaks: [Time(quavers: 3), Time(quavers: 6)]
        )
    }
    
    // MARK: - 20/16 or 10/8 or 5/4
    
    func test_10_8() {
        assert(
            timeSignature: TimeSignature(10, 8),
            breaks: [Time(quavers: 4), Time(quavers: 7)]
        )
    }
    
    func test_5_4() {
        assert(
            timeSignature: TimeSignature(5, 4),
            breaks: [Time(crotchets: 3)]
        )
    }
    
    // MARK: - 12/8 or 6/4 or 3/2
    
    func test_12_8() {
        assert(
            timeSignature: TimeSignature(12, 8),
            breaks: [Time(quavers: 3), Time(quavers: 6), Time(quavers: 9)]
        )
    }
    
    func test_6_4() {
        assert(
            timeSignature: TimeSignature(6, 4),
            breaks: [Time(crotchets: 3)]
        )
    }
    
    func test_3_2() {
        assert(
            timeSignature: TimeSignature(3, 2),
            breaks: [Time(crotchets: 2), Time(crotchets: 4)]
        )
    }
    
    // MARK: - 7/4
    
    func test_7_4() {
        assert(
            timeSignature: TimeSignature(7, 4),
            breaks: [Time(crotchets: 4)]
        )
    }
    
    // MARK: - 15/8
    
    func test_15_8() {
        assert(
            timeSignature: TimeSignature(15, 8),
            breaks: [Time(quavers: 3), Time(quavers: 6), Time(quavers: 9), Time(quavers: 12)]
        )
    }
    
    // MARK: - 18/8 or 9/4

    func test_18_8() {
        assert(
            timeSignature: TimeSignature(18, 8),
            breaks: [Time(quavers: 3), Time(quavers: 6), Time(quavers: 9), Time(quavers: 12), Time(quavers: 15)]
        )
    }
    
    func test_9_4() {
        assert(
            timeSignature: TimeSignature(9, 4),
            breaks: [Time(crotchets: 3), Time(crotchets: 6)]
        )
    }


}

// MARK: - Helpers

extension TimeSignatureTests {
    
    func assert(timeSignature: TimeSignature, breaks: [Time], file: StaticString = #file, line: UInt = #line) {
        
        let actualBreaks = timeSignature
            .beamBreaks()
            .prefix(while: { $0 < timeSignature.barDuration })
            .toArray()
            
        actualBreaks.verify(equals: breaks,
                            message: "\(actualBreaks.testFailureDescription) != \(breaks.testFailureDescription)",
                            file: file,
                            line: line)
    }
}

extension Time: TestFailureDescribable {
    
    var testFailureDescription: String {
        return "\(self.value)/\(self.division)"
    }
}
