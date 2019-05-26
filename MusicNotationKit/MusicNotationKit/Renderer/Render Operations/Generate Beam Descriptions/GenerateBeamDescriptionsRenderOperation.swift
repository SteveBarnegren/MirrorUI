//
//  GenerateBeamDescriptionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateBeamDescriptionsRenderOperation: RenderOperation {
    
    private let noteBeamDescriber = NoteBeamDescriber<Note>(beaming: .notes)
    
    func process(composition: Composition, layoutWidth: Double) {
        composition.enumerateNoteSequences { noteBeamDescriber.applyBeams(to: $0.notes) }
    }
}
