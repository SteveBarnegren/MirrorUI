//
//  CompositionTimeTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 14/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class CompositionTimeTests: XCTestCase {
    
    func test_Equatable() {
        
        // Equal bar and time
        XCTAssertEqual(CompositionTime(bar: 3, time: Time(crotchets: 6)),
                       CompositionTime(bar: 3, time: Time(crotchets: 6)))
        
        // Same bar, different times
        XCTAssertNotEqual(CompositionTime(bar: 3, time: Time(crotchets: 2)),
                          CompositionTime(bar: 3, time: Time(crotchets: 4)))
        
        // Same time, different bars
        XCTAssertNotEqual(CompositionTime(bar: 3, time: Time(crotchets: 2)),
                          CompositionTime(bar: 5, time: Time(crotchets: 2)))
    }
    
    func test_Comparable() {
        
        let referenceTime = CompositionTime(bar: 3, time: Time(crotchets: 2))
        // Less than
        XCTAssert(CompositionTime(bar: 2, time: Time(crotchets: 1)) < referenceTime)
        XCTAssert(CompositionTime(bar: 2, time: Time(crotchets: 2)) < referenceTime)
        XCTAssert(CompositionTime(bar: 2, time: Time(crotchets: 3)) < referenceTime)
        XCTAssert(CompositionTime(bar: 2, time: Time(crotchets: 4)) < referenceTime)
        XCTAssert(CompositionTime(bar: 3, time: Time(crotchets: 1)) < referenceTime)
        
        // Equal
        XCTAssertEqual(CompositionTime(bar: 3, time: Time(crotchets: 2)), referenceTime)
        
        // Greater than
        XCTAssert(CompositionTime(bar: 3, time: Time(crotchets: 3)) > referenceTime)
        XCTAssert(CompositionTime(bar: 3, time: Time(crotchets: 4)) > referenceTime)
        XCTAssert(CompositionTime(bar: 4, time: Time(crotchets: 1)) > referenceTime)
        XCTAssert(CompositionTime(bar: 4, time: Time(crotchets: 2)) > referenceTime)
        XCTAssert(CompositionTime(bar: 4, time: Time(crotchets: 3)) > referenceTime)
        XCTAssert(CompositionTime(bar: 4, time: Time(crotchets: 4)) > referenceTime)
    }
}
