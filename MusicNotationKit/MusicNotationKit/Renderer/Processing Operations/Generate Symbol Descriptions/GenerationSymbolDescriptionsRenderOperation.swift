//
//  GenerationSymbolDescriptionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateSymbolDescriptionsProcessingOperation: CompositionProcessingOperation {
    
    private let noteSymbolDescriber = NoteSymbolDescriber()
    private let restSymbolDescriber = RestSymbolDescriber()
    
    func process(composition: Composition) {
        
        composition.enumerateNotes { $0.symbolDescription = noteSymbolDescriber.symbolDescription(forNote: $0) }
        composition.enumerateRests { $0.symbolDescription = restSymbolDescriber.symbolDescription(forRest: $0) }
        
    }
}
