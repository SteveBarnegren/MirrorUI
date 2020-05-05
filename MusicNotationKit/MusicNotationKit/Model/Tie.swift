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

enum TieEndAlignment {
    case middleOfSpace
    case sittingAboveNoteHead
    case hangingBelowNoteHead
}

struct TiePosition {
    
    let space: StaveSpace
    
    init() {
        self.space = StaveSpace(0, .positive)
    }
    
    init(space: StaveSpace) {
        self.space = space
    }
}

class Tie {
    var startPosition = TiePosition()
    var middlePosition = TiePosition()
    var endAlignment = TieEndAlignment.middleOfSpace
    weak var toNote: Note?
    weak var toNoteHead: NoteHeadDescription?
}
