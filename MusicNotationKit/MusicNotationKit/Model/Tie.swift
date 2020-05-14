//
//  Tie.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

enum TieOrientation {
    case verticallyAlignedWithNote
    case adjacentToNote
}

enum TieEndAlignment {
    case middleOfSpace
    case sittingAboveNoteHead
    case hangingBelowNoteHead
    case bottom
    case top
}

enum TieMiddleAlignment {
    case middleOfSpace
    case topOfSpace
    case bottomOfSpace
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
    var middleAlignment = TieMiddleAlignment.middleOfSpace
    var orientation = TieOrientation.verticallyAlignedWithNote
    weak var fromNote: Note?
    weak var fromNoteHead: NoteHeadDescription?
    weak var toNote: Note?
    weak var toNoteHead: NoteHeadDescription?
    
    // Additonal information used to prune variations
    var startNoteTime = Time.zero
    var endNoteTime = Time.zero
}
