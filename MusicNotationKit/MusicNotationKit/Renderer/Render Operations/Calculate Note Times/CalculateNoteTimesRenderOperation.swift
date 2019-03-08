//
//  CalculateNoteTimesRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateNoteTimesRenderOperation: RenderOperation {
    
    private let noteTimeCalculator = NoteTimeCalculator()
    
    func process(composition: Composition, layoutWidth: Double) {
        for bar in composition.bars {
            process(bar: bar)
        }
    }
    
    private func process(bar: Bar) {
        for noteSequence in bar.sequences {
            noteTimeCalculator.process(noteSequence: noteSequence)
        }
    }
    
}
