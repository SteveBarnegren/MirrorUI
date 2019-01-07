//
//  EnumeratedWithLastItemFlagBidirectionalCollection.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class EnumeratedWithLastItemFlagBidirectionalCollection: XCTestCase {
    
    func test_FlagIsCorrect() {
        
        let array = ["a", "b", "c"]
        
        var items = [String]()
        var flags = [Bool]()
        
        for (item, flag) in array.enumeratedWithLastItemFlag() {
            items.append(item)
            flags.append(flag)
        }
        
        XCTAssertEqual(items, ["a", "b", "c"])
        XCTAssertEqual(flags, [false, false, true])
    }

}
