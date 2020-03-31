//
//  Pitch.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

public struct Pitch {
    let note: Pitch.Note
    let accidental: Pitch.Accidental?
    
    init(_ note: Pitch.Note, _ accidental: Pitch.Accidental? = nil) {
        self.note = note
        self.accidental = accidental
    }
    
    var stavePosition: Int {
        return note.stavePosition
    }
    
    var staveOffset: Double {
        return note.staveOffset
    }
    
    // 2
    public static let a2 = Pitch(.a2)
    public static let aSharp2 = Pitch(.a2, .sharp)
    public static let bFlat2 = Pitch(.b2, .flat)
    public static let b2 = Pitch(.b2)
    public static let c2 = Pitch(.c2)
    public static let cSharp2 = Pitch(.c2, .sharp)
    public static let dFlat2 = Pitch(.d2, .flat)
    public static let d2 = Pitch(.d2)
    public static let dSharp2 = Pitch(.d2, .sharp)
    public static let eFlat2 = Pitch(.e2, .flat)
    public static let e2 = Pitch(.e2)
    public static let f2 = Pitch(.f2)
    public static let fSharp2 = Pitch(.f2, .sharp)
    public static let gFlat2 = Pitch(.g2, .flat)
    public static let g2 = Pitch(.g2)
    public static let gSharp2 = Pitch(.g2, .sharp)
    
    // 3
    public static let a3 = Pitch(.a3)
    public static let aSharp3 = Pitch(.a3, .sharp)
    public static let bFlat3 = Pitch(.b3, .flat)
    public static let b3 = Pitch(.b3)
    public static let c3 = Pitch(.c3)
    public static let cSharp3 = Pitch(.c3, .sharp)
    public static let dFlat3 = Pitch(.d3, .flat)
    public static let d3 = Pitch(.d3)
    public static let dSharp3 = Pitch(.d3, .sharp)
    public static let eFlat3 = Pitch(.e3, .flat)
    public static let e3 = Pitch(.e3)
    public static let f3 = Pitch(.f3)
    public static let fSharp3 = Pitch(.f3, .sharp)
    public static let gFlat3 = Pitch(.g3, .flat)
    public static let g3 = Pitch(.g3)
    public static let gSharp3 = Pitch(.g3, .sharp)
    
    // 4
    public static let a4 = Pitch(.a4)
    public static let aSharp4 = Pitch(.a4, .sharp)
    public static let bFlat4 = Pitch(.b4, .flat)
    public static let b4 = Pitch(.b4)
    public static let c4 = Pitch(.c4)
    public static let cSharp4 = Pitch(.c4, .sharp)
    public static let dFlat4 = Pitch(.d4, .flat)
    public static let d4 = Pitch(.d4)
    public static let dSharp4 = Pitch(.d4, .sharp)
    public static let eFlat4 = Pitch(.e4, .flat)
    public static let e4 = Pitch(.e4)
    public static let f4 = Pitch(.f4)
    public static let fSharp4 = Pitch(.f4, .sharp)
    public static let gFlat4 = Pitch(.g4, .flat)
    public static let g4 = Pitch(.g4)
    public static let gSharp4 = Pitch(.g4, .sharp)
    
    // 5
    public static let a5 = Pitch(.a5)
    public static let aSharp5 = Pitch(.a5, .sharp)
    public static let bFlat5 = Pitch(.b5, .flat)
    public static let b5 = Pitch(.b5)
    public static let c5 = Pitch(.c5)
    public static let cSharp5 = Pitch(.c5, .sharp)
    public static let dFlat5 = Pitch(.d5, .flat)
    public static let d5 = Pitch(.d5)
    public static let dSharp5 = Pitch(.d5, .sharp)
    public static let eFlat5 = Pitch(.e5, .flat)
    public static let e5 = Pitch(.e5)
    public static let f5 = Pitch(.f5)
    public static let fSharp5 = Pitch(.f5, .sharp)
    public static let gFlat5 = Pitch(.g5, .flat)
    public static let g5 = Pitch(.g5)
    public static let gSharp5 = Pitch(.g5, .sharp)
}

extension Pitch {
    enum Accidental {
        case sharp
        case flat
        case natural
    }
}

// Middle C is c4
extension Pitch {
    enum Note: Int {
        
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
}

extension Pitch: Comparable {
    public static func < (lhs: Pitch, rhs: Pitch) -> Bool {
        // Return is ascending
        
        func accidentalValue(forPitch pitch: Pitch) -> Int {
            if let accidental = pitch.accidental {
                switch accidental {
                case .sharp: return 1
                case .flat: return -1
                case .natural: return 0
                }
            } else {
                return 0
            }
        }
        
        if lhs.note.rawValue < rhs.note.rawValue {
            return true
        } else if lhs.note.rawValue > rhs.note.rawValue {
            return false
        } else {
            return accidentalValue(forPitch: lhs) < accidentalValue(forPitch: rhs)
        }
    }
}
