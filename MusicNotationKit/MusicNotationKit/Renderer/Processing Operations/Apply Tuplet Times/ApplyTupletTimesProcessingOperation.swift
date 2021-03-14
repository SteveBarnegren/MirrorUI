//
//  ApplyTupletTimesProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 30/10/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class ApplyTupletTimesProcessingOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        composition.forEachNoteSequence(process)
    }
    
    private func process(noteSequence: NoteSequence) {
        
        var currentTupletTime: TupletTime?
        
        for item in noteSequence.items {
            switch item {
            case .note(let p as Playable), .rest(let p as Playable):
                if let tuplet = currentTupletTime {
                    p.value.tuplet = tuplet
                }
            case .startTuplet(let t):
                currentTupletTime = t
            case .endTuplet:
                currentTupletTime = nil
            }
        }
    }
}
