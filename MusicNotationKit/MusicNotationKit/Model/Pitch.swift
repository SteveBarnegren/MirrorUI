//
//  Pitch.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

// Middle C is c4
public enum Pitch: Int {
    
    // 3
    case a3
    case b3
    case c3
    case d3
    case e3
    case f3
    case g3
    
    // 4
    case a4
    case b4
    case c4 // middle c
    case d4
    case e4
    case f4
    case g4
    
    var staveOffset: Int {
        switch self {
        case .a3: return -8
        case .b3: return -7
        case .c3: return -6
        case .d3: return -5
        case .e3: return -4
        case .f3: return -3
        case .g3: return -2
        case .a4: return -1 // ↑ Below the middle of the stave
        case .b4: return 0 // Middle of the stave
        case .c4: return 1 // ↓ Above the middle of the stave
        case .d4: return 2
        case .e4: return 3
        case .f4: return 4
        case .g4: return 5
        }
    }
}
