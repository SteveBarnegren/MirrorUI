//
//  NoteValue+Verify.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 12/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation
@testable import MusicNotationKit
import XCTest

extension NoteValue {
    
    func verify(duration: Time, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self.duration, duration, file: file, line: line)
    }
}
