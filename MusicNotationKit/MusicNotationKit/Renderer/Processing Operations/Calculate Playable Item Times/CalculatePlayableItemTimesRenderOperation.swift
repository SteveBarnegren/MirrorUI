//
//  CalculateNoteTimesRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculatePlayableItemTimesRenderOperation: CompositionProcessingOperation {
    
    private let playableItemTimeCalculator = PlayableItemTimeCalculator()
    
    func process(composition: Composition) {
        for bar in composition.bars {
            process(bar: bar)
        }
    }
    
    private func process(bar: Bar) {
        for noteSequence in bar.sequences {
            playableItemTimeCalculator.process(noteSequence: noteSequence)
        }
    }
}
