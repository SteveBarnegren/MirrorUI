//
//  JoinBarlinesCompositionProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 26/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class JoinBarlinesCompositionProcessingOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        
        for stave in composition.staves {
            for (bar, previous) in stave.bars.eachWithPrevious() where previous?.trailingBarline == nil {
                previous?.trailingBarline = bar.leadingBarline
            }
        }
    }
}
