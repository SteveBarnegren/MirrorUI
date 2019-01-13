//
//  FloatingPoint+ExtensionsTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 13/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class FloatingPoint_ExtensionsTests: XCTestCase {

    func test_PctBetween() {
        XCTAssertEqual((55 as Double).pct(between: 50, and: 60), 0.5, accuracy: 0.01)
        XCTAssertEqual((57.5 as Double).pct(between: 50, and: 60), 0.75, accuracy: 0.01)
        XCTAssertEqual((52.5 as Double).pct(between: 50, and: 60), 0.25, accuracy: 0.01)
    }
    
    func test_InterpolateTo() {
        XCTAssertEqual((10 as Double).interpolate(to: 20, t: 0.5), 15, accuracy: 0.01)
        XCTAssertEqual((10 as Double).interpolate(to: 20, t: 0.25), 12.5, accuracy: 0.01)
    }
}
