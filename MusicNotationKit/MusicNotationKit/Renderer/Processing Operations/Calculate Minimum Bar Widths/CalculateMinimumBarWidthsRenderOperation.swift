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

        // Get the minimum width
        fixedDistanceLayoutSolver.solve(anchors: layoutAnchors)
        bar.minimumWidth = getWidth(forBar: bar)
        assert(bar.minimumWidth > 0, "Bar should have non-zero minimum width")
        
        // Get the preferred width
        expandAnchorsToPreferredSize(anchors: layoutAnchors)
        bar.preferredWidth = getWidth(forBar: bar)
        assert(bar.preferredWidth > 0, "Bar should have non-zero preferred width")
        assert(bar.preferredWidth >= bar.minimumWidth, "Bar preferred width should not be less than minimum width")
    }
    
    private func expandAnchorsToPreferredSize(anchors: [LayoutAnchor]) {
        
        var deltas = [Double]()
        
        // Work out the deltas
        for (anchor, next) in anchors.eachWithNext() {
            if let next = next, let duration = anchor.duration {
                let current = next.position - anchor.position
                let preferred = NaturalSpacing().staveSpacing(forDuration: duration)
                let diff = (preferred - current).constrained(min: 0)
                deltas.append(diff)
            } else {
                deltas.append(0)
            }
        }
        
        // Apply the deltas to expand the anchors
        var offset = 0.0
        for (anchor, delta) in zip(anchors, deltas) {
            offset += delta
            anchor.position += offset
        }
    }
    
    private func getWidth(forBar bar: Bar) -> Double {
        
        // The minimum width should be the start of the following
        // barline, or the end of the last anchor of this bar
        if let lastBarlineAnchor = bar.trailingBarlineAnchor {
            return lastBarlineAnchor.position - lastBarlineAnchor.width
        } else {
            return bar.layoutAnchors.map { $0.trailingEdge }.max() ?? 0
        }
    }
    
}
