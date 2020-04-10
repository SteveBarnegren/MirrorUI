//
//  CalculateNoteHeadAlignmentProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateNoteHeadAlignmentProcessingOperation: CompositionProcessingOperation {
    
    private let alignmentDecider = NoteHeadAlignmentDecider(transformer: .notes)
    
    func process(composition: Composition) {
        composition.enumerateNotes(alignmentDecider.process)
    }
}
