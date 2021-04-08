//
//  GenerateBarLayoutAnchorsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateBarLayoutAnchorsProcessingOperation: CompositionProcessingOperation {
    
    private let layoutAnchorsBuilder: LayoutAnchorsBuilder
    
    init(glyphs: GlyphStore) {
        layoutAnchorsBuilder = LayoutAnchorsBuilder(glyphs: glyphs)
    }
    
    func process(composition: Composition) {
        layoutAnchorsBuilder.makeAnchors(from: composition)
    }
}
