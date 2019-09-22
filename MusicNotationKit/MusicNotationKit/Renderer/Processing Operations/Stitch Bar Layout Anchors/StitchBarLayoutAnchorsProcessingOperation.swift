//
//  StitchBarLayoutAnchorsProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 22/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class StitchBarLayoutAnchorsProcessingOperation: CompositionProcessingOperation {
    
    private let layoutAnchorsStitcher = BarLayoutAnchorsStitcher()
    
    func process(composition: Composition) {
        layoutAnchorsStitcher.stichAnchors(for: composition.bars)
    }
}
