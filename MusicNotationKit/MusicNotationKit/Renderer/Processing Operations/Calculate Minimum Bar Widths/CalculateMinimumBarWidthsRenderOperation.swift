//
//  CalculateMinimumBarWidthsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateMinimumBarWidthsProcessingOperation: CompositionProcessingOperation {
    
    private let fixedDistanceLayoutSolver = FixedDistanceLayoutSolver()

    func process(composition: Composition) {
        for bar in composition.bars {
            composition.bars.map { $0.layoutAnchors }.joined().forEach { $0.reset() }
            process(bar: bar)
        }
        
        
        //composition.bars.forEach(self.process)
    }
    
    private func process(bar: Bar) {
        
        bar.layoutAnchors.forEach { $0.reset() }
        
        fixedDistanceLayoutSolver.solve(anchors: bar.layoutAnchors)
        bar.minimumWidth = bar.layoutAnchors.map { $0.trailingEdge }.max() ?? 0
        assert(bar.minimumWidth > 0, "Bar should have non-zero minimum width")
    }
    
}
