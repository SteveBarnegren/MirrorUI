//
//  CreateBarSlicesRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 14/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class CreateBarSlicesRenderOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        
        let staves = composition.staves
        var barSlices = [BarSlice]()
        
        var barNum = 0
        
        func getNextBars() -> [Bar]? {
            let bars = staves.compactMap { $0.bars[maybe: barNum] }
            barNum += 1
            return bars.isEmpty ? nil : bars
        }
        
        while let bars = getNextBars() {
            let barSlice = BarSlice(bars: bars)
            barSlices.append(barSlice)
        }
        
        composition.barSlices = barSlices
    }
}