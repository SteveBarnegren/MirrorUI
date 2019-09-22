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
        composition.bars.forEach(self.process)
    }
    
    private func process(bar: Bar) {
        
        fixedDistanceLayoutSolver.solve(anchors: bar.layoutAnchors)
        bar.minimumWidth = bar.layoutAnchors.last?.trailingEdge ?? 0
        assert(bar.minimumWidth > 0, "Bar should have non-zero minimum width")
    }
    
}
