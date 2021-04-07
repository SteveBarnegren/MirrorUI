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
        composition.barSlices.forEach(process)
//        for stave in composition.staves {
//            stave.bars.forEach(self.process)
//        }
    }
    
    private func process(bar: BarSlice) {
        
        let widths = getWidths(bar: bar, asFirstBar: false)
        bar.size.minimumWidth = widths.min
        bar.size.preferredWidth = widths.preferred
        
        let firstBarWidths = getWidths(bar: bar, asFirstBar: true)
        bar.size.minimumWidthAsFirstBar = firstBarWidths.min
        bar.size.preferredWidthAsFirstBar = firstBarWidths.preferred
    }
    
    private func getWidths(bar: BarSlice, asFirstBar: Bool) -> (min: Double, preferred: Double) {
        
        bar.resetLayoutAnchors()
        
        var layoutAnchors = bar.layoutAnchors.appending(maybe: bar.trailingBarlineAnchor)
        
        // Disable and remove anchors that are not enabled
        if !asFirstBar {
            var firstBarAnchors = [LayoutAnchor]()
            for anchor in layoutAnchors {
                if anchor.content.visibleInFirstBarOfLineOnly {
                    anchor.enabled = false
                } else {
                    firstBarAnchors.append(anchor)
                }
                layoutAnchors = firstBarAnchors
            }
        }

        // Get the minimum width
        fixedDistanceLayoutSolver.solve(anchors: layoutAnchors)
        let minWidth = getWidth(forBar: bar)
        assert(minWidth > 0, "Bar should have non-zero minimum width")
        
        // Get the preferred width
        expandAnchorsToPreferredSize(anchors: layoutAnchors)
        let preferredWidth = getWidth(forBar: bar)
        assert(preferredWidth > 0, "Bar should have non-zero preferred width")
        assert(preferredWidth >= minWidth, "Bar preferred width should not be less than minimum width")
        
        return (minWidth, preferredWidth)
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
    
    private func getWidth(forBar bar: BarSlice) -> Double {
        
        // The minimum width should be the start of the following
        // barline, or the end of the last anchor of this bar
        if let lastBarlineAnchor = bar.trailingBarlineAnchor {
            return lastBarlineAnchor.position - lastBarlineAnchor.leadingWidth
        } else {
            return bar.layoutAnchors.map { $0.trailingEdge }.max() ?? 0
        }
    }
    
}
