//
//  Tie.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

enum TieOrientation {
    case aboveNoteHead
    case belowNoteHead
    case rightOfNoteHead
}

struct TiePosition {
    
    enum Sign {
        case positive
        case negative
        
        var sign: Int { self == .positive ? 1 : -1 }
    }
    
    enum SpaceQuartile {
        case zero
        case quarter
        case half
        case threeQuarters
        
        var value: Double {
            switch self {
            case .zero: return 0
            case .quarter: return 0.25
            case .half: return 0.5
            case .threeQuarters: return 0.75
            }
        }
    }

    var sign = Sign.positive
    var lineNumber: Int = 0
    var spaceQuartile: SpaceQuartile = .zero
}

class Tie {
    let orientation: TieOrientation
    var startPosition = TiePosition()
    var middlePosition = TiePosition()
    weak var toNote: Note?
    weak var toNoteHead: NoteHeadDescription?
    
    init(orientation: TieOrientation) {
        self.orientation = orientation
    }
}
