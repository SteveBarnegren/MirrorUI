//
//  GenerateBeamDescriptionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateBeamDescriptionsRenderOperation: RenderOperation {
    
    private let noteBeamDescriber = NoteBeamDescriber()
    
    func process(composition: Composition) {
        composition.enumerateNoteSequences { noteBeamDescriber.applyBeams(toNoteSequence: $0) }
    }
}
