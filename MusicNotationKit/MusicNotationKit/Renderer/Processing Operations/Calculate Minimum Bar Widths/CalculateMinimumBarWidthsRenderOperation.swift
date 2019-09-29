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
        
        bar.resetLayoutAnchors()
        
        let layoutAnchors = bar.layoutAnchors.appending(maybe: bar.trailingBarlineAnchor)
        fixedDistanceLayoutSolver.solve(anchors: layoutAnchors)
        
        // The minimum width should be the start of the following
        // barline, or the end of the last anchor of this bar
        if let lastBarlineAnchor = bar.trailingBarlineAnchor {
            bar.minimumWidth = lastBarlineAnchor.position - lastBarlineAnchor.width
        } else {
            bar.minimumWidth = bar.layoutAnchors.map { $0.trailingEdge }.max() ?? 0
        }
        
        assert(bar.minimumWidth > 0, "Bar should have non-zero minimum width")
    }
    
}
