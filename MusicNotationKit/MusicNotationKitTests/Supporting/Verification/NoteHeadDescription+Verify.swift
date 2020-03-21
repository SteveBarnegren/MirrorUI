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

extension NoteHeadDescription {
    
    @discardableResult func verify(style: NoteHeadDescription.Style, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(self.style, style, file: file, line: line)
        return self
    }
}
