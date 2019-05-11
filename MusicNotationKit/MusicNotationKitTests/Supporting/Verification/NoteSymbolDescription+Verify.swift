//
//  NoteSymbolDescription+Verify.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 11/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation
@testable import MusicNotationKit
import XCTest

extension NoteSymbolDescription {
    
    @discardableResult func verify(headStyle: HeadStyle, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(self.headStyle, headStyle, file: file, line: line)
        return self
    }
    
    @discardableResult func verify(hasStem: Bool, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(self.hasStem, hasStem, file: file, line: line)
        return self
    }
    
    @discardableResult func verify(numberOfBeams: Int, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(self.numberOfBeams, numberOfBeams, file: file, line: line)
        return self
    }
}