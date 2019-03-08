//
//  NoteTimeCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteTimeCalculator {
    
    func process(noteSequence: NoteSequence) {
        
        var currentTime = Time.zero
        
        for note in noteSequence.notes {
            note.time = currentTime
            currentTime += note.duration
        }
    }
}
