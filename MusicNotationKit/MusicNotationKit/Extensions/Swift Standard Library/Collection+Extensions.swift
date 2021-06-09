//
//  Collection+Extensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public extension Collection {
    
    func toArray() -> [Element] {
        return Array(self)
    }
}

extension Collection {

    var countInbetween: Int {
        if isEmpty {
            return 0
        } else {
            return count - 1
        }
    }
}
