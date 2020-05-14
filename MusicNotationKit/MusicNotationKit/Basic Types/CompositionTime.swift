//
//  CompositionTime.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 14/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

struct CompositionTime: Equatable {
    var bar: Int
    var time: Time
    
    static let zero = CompositionTime(bar: 0, time: .zero)
}

extension CompositionTime: Comparable {
    static func < (lhs: CompositionTime, rhs: CompositionTime) -> Bool {
        if lhs.bar == rhs.bar {
            return lhs.time < rhs.time
        } else {
            return lhs.bar < rhs.bar
        }
    }
}
