//
//  Direction.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

enum VerticalDirection {
    case up
    case down
    
    var opposite: VerticalDirection {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        }
    }
}
