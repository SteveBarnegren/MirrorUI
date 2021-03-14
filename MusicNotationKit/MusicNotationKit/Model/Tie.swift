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
    // In the middle of a space
    case middleOfSpace
    // Sitting above a note head that is on a line (in the space that the top half of the note is in)
    case sittingAboveNoteHead
    // Hanging below a note head that in on a line (in the space that the bottom half of the note is in)
    case hangingBelowNoteHead
    // The bottom of a space
    case bottom
    // The top of a space
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
    weak var fromNoteHead: NoteHead?
    weak var toNote: Note?
    weak var toNoteHead: NoteHead?
    
    // Additonal information used to prune variations
    var startNoteCompositionTime = CompositionTime.zero
    var endNoteCompositionTime = CompositionTime.zero
}
