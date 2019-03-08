//
//  GenerateNoteConstraintsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateNoteConstraintsRenderOperation: RenderOperation {
    
    private let noteConstraintsDescriber = NoteConstraintsDescriber()
    
    func process(composition: Composition) {
        for bar in composition.bars {
            process(bar: bar)
        }
    }
    
    private func process(bar: Bar) {
        for noteSequence in bar.sequences {
            process(noteSequence: noteSequence)
        }
    }
    
    private func process(noteSequence: NoteSequence) {
        for note in noteSequence.notes {
            noteConstraintsDescriber.process(note: note)
        }
    }
    
}
