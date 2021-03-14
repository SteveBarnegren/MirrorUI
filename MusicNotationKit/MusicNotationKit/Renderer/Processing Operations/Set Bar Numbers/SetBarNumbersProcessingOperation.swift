//
//  SetBarNumbersProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class SetBarNumbersProcessingOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        
        for stave in composition.staves {
            for (index, bar) in stave.bars.enumerated() {
                bar.barNumber = index
            }
        }
    }
}
