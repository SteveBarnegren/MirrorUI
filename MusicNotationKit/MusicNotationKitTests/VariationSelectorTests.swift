//
//  VariationSelectorTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 10/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class VariationSelectorTests: XCTestCase {

    func test_VariationSuitabilityComparable() {
        XCTAssert(VariationSuitability.preferable > VariationSuitability.allowed)
        XCTAssert(VariationSuitability.allowed > VariationSuitability.concession)
    }
    
}
