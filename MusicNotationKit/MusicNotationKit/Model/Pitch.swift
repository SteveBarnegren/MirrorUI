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
    
    // 2
    case a2
    case b2
    case c2
    case d2
    case e2
    case f2
    case g2
    
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
    
    // 5
    case a5
    case b5
    case c5
    case d5
    case e5
    case f5
    case g5
    
    var stavePosition: Int {
        switch self {
        case .a2: return -15
        case .b2: return -14
        case .c2: return -13
        case .d2: return -12
        case .e2: return -11
        case .f2: return -10
        case .g2: return -9
        case .a3: return -8
        case .b3: return -7
        case .c3: return -6
        case .d3: return -5
        case .e3: return -4
        case .f3: return -3
        case .g3: return -2
        case .a4: return -1 // ↑ Below the middle of the stave
        case .b4: return 0  // - Middle of the stave
        case .c4: return 1  // ↓ Above the middle of the stave
        case .d4: return 2
        case .e4: return 3
        case .f4: return 4
        case .g4: return 5
        case .a5: return 6
        case .b5: return 7
        case .c5: return 8
        case .d5: return 9
        case .e5: return 10
        case .f5: return 11
        case .g5: return 12
        }
    }
    
    var staveOffset: Double {
        switch self {
        case .a2: return -7.5
        case .b2: return -7
        case .c2: return -6.5
        case .d2: return -6
        case .e2: return -5.5
        case .f2: return -5
        case .g2: return -4.5
        case .a3: return -4
        case .b3: return -3.5
        case .c3: return -3
        case .d3: return -2.5
        case .e3: return -2
        case .f3: return -1.5
        case .g3: return -1
        case .a4: return -0.5 // ↑ Below the middle of the stave
        case .b4: return 0    // - Middle of the stave
        case .c4: return 0.5  // ↓ Above the middle of the stave
        case .d4: return 1
        case .e4: return 1.5
        case .f4: return 2
        case .g4: return 2.5
        case .a5: return 3
        case .b5: return 3.5
        case .c5: return 4
        case .d5: return 4.5
        case .e5: return 5
        case .f5: return 5.5
        case .g5: return 6
        }
    }
}

extension Pitch: Comparable {
    public static func < (lhs: Pitch, rhs: Pitch) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
