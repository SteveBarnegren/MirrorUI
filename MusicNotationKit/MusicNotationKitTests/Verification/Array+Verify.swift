//
//  Array+Verify.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 13/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation
import XCTest
@testable import MusicNotationKit

extension Array where Element: AnyObject {
    
    func verify(containsInstances instances: [Element], file: StaticString = #file, line: UInt = #line) {
        
        if self.count != instances.count {
            XCTFail("Expected \(instances.count) items, have \(self.count)", file: file, line: line)
            return
        }
        
        for (index, (obj1, obj2)) in zip(self, instances).enumerated() {
            if obj1 !== obj2 {
                XCTFail("Different instances at index \(index)", file: file, line: line)
            }
        }
    }
}
