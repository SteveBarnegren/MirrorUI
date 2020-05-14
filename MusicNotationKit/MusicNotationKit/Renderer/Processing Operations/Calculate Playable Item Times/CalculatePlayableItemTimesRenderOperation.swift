//
//  CalculateNoteTimesRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculatePlayableItemTimesProcessingOperation: CompositionProcessingOperation {
    
    private let playableItemTimeCalculator = PlayableItemTimeCalculator()
    
    func process(composition: Composition) {
        for (barIndex, bar) in composition.bars.enumerated() {
            for sequence in bar.sequences {
                
                var currentTime = Time.zero
                for playable in sequence.playables {
                    playable.time = currentTime
                    playable.compositionTime = CompositionTime(bar: barIndex, time: currentTime)
                    currentTime += playable.duration
                }
            }
        }
    }
}
