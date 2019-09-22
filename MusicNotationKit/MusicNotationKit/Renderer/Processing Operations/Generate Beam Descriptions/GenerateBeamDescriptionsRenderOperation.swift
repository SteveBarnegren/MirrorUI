//
//  GenerateBeamDescriptionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateBeamDescriptionsProcessingOperation: CompositionProcessingOperation {
    
    private let noteBeamDescriber = NoteBeamDescriber<Note>(beaming: .notes)
    
    func process(composition: Composition) {
        
        var timeSignature = TimeSignature.fourFour
        
        for bar in composition.bars {
            timeSignature = bar.timeSignature ?? timeSignature
            for noteSequence in bar.sequences {
                noteBeamDescriber.applyBeams(to: noteSequence.notes, timeSignature: timeSignature)
            }
        }
    }
}
