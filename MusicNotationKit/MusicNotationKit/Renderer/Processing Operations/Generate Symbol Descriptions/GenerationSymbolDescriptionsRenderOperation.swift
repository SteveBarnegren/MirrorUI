//
//  GenerationSymbolDescriptionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateSymbolDescriptionsProcessingOperation: CompositionProcessingOperation {
    
    private let glyphs: GlyphStore
    private let noteSymbolDescriber = NoteSymbolDescriber()
    private let noteHeadDescriber = NoteHeadDescriber()
    private let restSymbolDescriber = RestSymbolDescriber()
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func process(composition: Composition) {
        
        composition.forEachBar(process)
    }
    
    private func process(bar: Bar) {
        
        bar.forEachNote {
            
            // Make basic symbol description
            let description = noteSymbolDescriber.symbolDescription(forNote: $0)
            $0.hasStem = description.hasStem
            $0.numberOfTails = description.numberOfTails
            
            // Make note head descriptions
            $0.noteHeads = noteHeadDescriber.noteHeadDescriptions(forNote: $0, clef: bar.clef)
        }
        
        bar.forEachRest { $0.symbolDescription = restSymbolDescriber.symbolDescription(forRest: $0) }
    }
}
