//
//  Vector2Tests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 20/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class Vector2Tests: XCTestCase {

    func test_Vector2XYInitialisation() {
        
        let vector = Vector2(5, 6)
        XCTAssertEqual(vector.x, 5)
        XCTAssertEqual(vector.y, 6)
        XCTAssertEqual(vector.width, 5)
        XCTAssertEqual(vector.height, 6)
    }

}
