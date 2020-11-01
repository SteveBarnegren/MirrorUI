//
//  NoteTimeCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class PlayableItemTimeCalculator {
    
    func process(noteSequence: NoteSequence) {
        
        var currentTime = Time.zero
        
        for playable in noteSequence.playables {
            playable.barTime = currentTime
            currentTime += playable.duration
        }
    }
}
