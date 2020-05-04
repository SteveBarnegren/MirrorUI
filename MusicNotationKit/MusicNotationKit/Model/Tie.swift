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
    let space: Int
}

class Tie {
    var startPosition = TiePosition(space: 0)
    var middlePosition = TiePosition(space: 0)
    weak var toNote: Note?
    weak var toNoteHead: NoteHeadDescription?
}
