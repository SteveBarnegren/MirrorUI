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
        
        let layoutAnchors = bar.layoutAnchors.appending(maybe: bar.lastBarlineAnchor)
        fixedDistanceLayoutSolver.solve(anchors: layoutAnchors)
        
        // The minimum width should be the start of the following
        // barline, or the end of the last anchor of this bar
        if let lastBarlineAnchor = bar.lastBarlineAnchor {
            bar.minimumWidth = lastBarlineAnchor.position - lastBarlineAnchor.width
            print("Calculate minimum width based on last barline anchor!!!")
        } else {
            bar.minimumWidth = bar.layoutAnchors.map { $0.trailingEdge }.max() ?? 0
        }
        
        assert(bar.minimumWidth > 0, "Bar should have non-zero minimum width")
    }
    
}
