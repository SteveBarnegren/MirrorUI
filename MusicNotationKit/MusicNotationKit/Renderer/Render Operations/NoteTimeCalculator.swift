//
//  NoteTimeCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteTimeCalculator {
    
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
        
        var currentTime = Time.zero
        
        for note in noteSequence.notes {
            note.time = currentTime
            currentTime += note.duration
        }
    }
}
