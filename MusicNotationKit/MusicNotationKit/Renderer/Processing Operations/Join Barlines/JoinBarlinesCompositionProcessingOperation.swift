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
        
        var previousTrailingBarline: Barline?
        
        for bar in composition.bars {
            if let barline = previousTrailingBarline, bar.trailingBarline == nil {
                bar.trailingBarline = barline
            }
            previousTrailingBarline = bar.leadingBarline
        }
    }
}
