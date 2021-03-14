//
//  NoteHeadDescription+Verify.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 21/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import XCTest
@testable import MusicNotationKit

extension NoteHead {
    
    @discardableResult func verify(style: NoteHead.Style, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(self.style, style, file: file, line: line)
        return self
    }
}
