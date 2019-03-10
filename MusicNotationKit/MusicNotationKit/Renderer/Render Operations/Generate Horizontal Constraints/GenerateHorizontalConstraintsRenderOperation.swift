//
//  GenerateNoteConstraintsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateHorizontalConstraintsRenderOperation: RenderOperation {
    
    private let noteConstraintsDescriber = NoteConstraintsDescriber()
    private let restConstraintsDescriber = RestConstraintsDescriber()
    
    func process(composition: Composition, layoutWidth: Double) {
        composition.enumerateNotes(noteConstraintsDescriber.process)
        composition.enumerateRests(restConstraintsDescriber.process)
    }
}
