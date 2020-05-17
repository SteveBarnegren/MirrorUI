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
        XCTAssertEqual(CompositionTime(bar: 3, time: Time(crotchets: 6), absoluteTime: .zero),
                       CompositionTime(bar: 3, time: Time(crotchets: 6), absoluteTime: .zero))
        
        // Same bar, different times
        XCTAssertNotEqual(CompositionTime(bar: 3, time: Time(crotchets: 2), absoluteTime: .zero),
                          CompositionTime(bar: 3, time: Time(crotchets: 4), absoluteTime: .zero))
        
        // Same time, different bars
        XCTAssertNotEqual(CompositionTime(bar: 3, time: Time(crotchets: 2), absoluteTime: .zero),
                          CompositionTime(bar: 5, time: Time(crotchets: 2), absoluteTime: .zero))
    }
    
    func test_Comparable() {
        
        let referenceTime = CompositionTime(bar: 3, time: Time(crotchets: 2), absoluteTime: .zero)
        // Less than
        XCTAssert(CompositionTime(bar: 2, time: Time(crotchets: 1), absoluteTime: .zero) < referenceTime)
        XCTAssert(CompositionTime(bar: 2, time: Time(crotchets: 2), absoluteTime: .zero) < referenceTime)
        XCTAssert(CompositionTime(bar: 2, time: Time(crotchets: 3), absoluteTime: .zero) < referenceTime)
        XCTAssert(CompositionTime(bar: 2, time: Time(crotchets: 4), absoluteTime: .zero) < referenceTime)
        XCTAssert(CompositionTime(bar: 3, time: Time(crotchets: 1), absoluteTime: .zero) < referenceTime)
        
        // Equal
        XCTAssertEqual(CompositionTime(bar: 3, time: Time(crotchets: 2), absoluteTime: .zero), referenceTime)
        
        // Greater than
        XCTAssert(CompositionTime(bar: 3, time: Time(crotchets: 3), absoluteTime: .zero) > referenceTime)
        XCTAssert(CompositionTime(bar: 3, time: Time(crotchets: 4), absoluteTime: .zero) > referenceTime)
        XCTAssert(CompositionTime(bar: 4, time: Time(crotchets: 1), absoluteTime: .zero) > referenceTime)
        XCTAssert(CompositionTime(bar: 4, time: Time(crotchets: 2), absoluteTime: .zero) > referenceTime)
        XCTAssert(CompositionTime(bar: 4, time: Time(crotchets: 3), absoluteTime: .zero) > referenceTime)
        XCTAssert(CompositionTime(bar: 4, time: Time(crotchets: 4), absoluteTime: .zero) > referenceTime)
    }
}
