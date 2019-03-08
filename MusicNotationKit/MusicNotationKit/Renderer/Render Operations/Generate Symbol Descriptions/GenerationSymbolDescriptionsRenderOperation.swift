//
//  GenerationSymbolDescriptionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateSymbolDescriptionsRenderOperation: RenderOperation {
    
    private let noteSymbolDescriber = NoteSymbolDescriber()
    
    func process(composition: Composition, layoutWidth: Double) {
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
            note.symbolDescription = noteSymbolDescriber.symbolDescription(forNote: note)
        }
    }
}
