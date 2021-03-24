//
//  StavePosition.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 24/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

struct StavePosition {
    
    static let zero = StavePosition(location: 0)
    
    let location: Int
    
    var yPosition: Double {
        Double(location)/2
    }
}

extension StavePosition: Comparable {
    
    static func < (lhs: StavePosition, rhs: StavePosition) -> Bool {
        return lhs.location < rhs.location
    }
}
