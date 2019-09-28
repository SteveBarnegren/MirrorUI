//
//  Assertions.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 28/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation
import XCTest

func XCTAssertEqualTuple2<A: Equatable, B: Equatable>
    (_ lhs: (A, B), _ rhs: (A, B), file: StaticString = #file, line: UInt = #line) {
    
    XCTAssertEqual(lhs.0, rhs.0, file: file, line: line)
    XCTAssertEqual(lhs.1, rhs.1, file: file, line: line)
}
