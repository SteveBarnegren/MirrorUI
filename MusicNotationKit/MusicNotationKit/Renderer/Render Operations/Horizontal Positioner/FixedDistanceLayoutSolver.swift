//
//  FixedDistanceLayoutSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 27/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class FixedDistanceLayoutSolver {
    
    func solve(anchors: [LayoutAnchor]) {
        
        var previousAnchor: LayoutAnchor?
        for (anchor, isFirst) in anchors.eachWithIsFirst() {
            if !anchor.enabled { continue }
            defer { previousAnchor = anchor }
            
            solveAdjacentLayoutAnchorOffsets(forAnchor: anchor)
            if isFirst {
                anchor.position = -anchor.leadingEdgeOffset
            } else {
                solveLeadingConstraints(forAnchor: anchor, previousAnchor: previousAnchor)
            }
        }
        
        // There may be notes from different sequences that don't have constraints between
        // them. In this case we need to nudge the later note ahead of the first so that
        // they don't appear to be at the same point. The timing layout solver will
        // increase these distances.
        // (Disabled this code for now as it was causing an issue with multiple voices)
        // (Renabled - Turns out this code is required for the tuplets example)
        var nudgeAmount = 0.0
        for (anchor, previousAnchor) in anchors.eachWithPrevious() {
            guard let prev = previousAnchor else { continue }
            if anchor.position <= prev.position {
                nudgeAmount += (prev.position - anchor.position) + 0.1
            }
            
            anchor.position += nudgeAmount
        }
    }
    
    private func solveLeadingConstraints(forAnchor anchor: LayoutAnchor, previousAnchor: LayoutAnchor?) {
        
        var leadingEdgePos = Double(0)
        
        for constraint in anchor.leadingConstraints where constraint.isEnabled {
            
            var trailingEdge = Double(0)
            
            switch constraint.from {
            case .anchor(let a):
                if let anchor = a.value {
                    trailingEdge = anchor.trailingEdge
                }
            case .previousAnchor:
                if let prev = previousAnchor {
                    trailingEdge = prev.trailingEdge
                }
            }
            
            var constraintDistance: Double
            switch constraint.value {
            case .fixed(let v):
                constraintDistance = v
            case .greaterThan(let v):
                constraintDistance = v
            }
            leadingEdgePos = max(leadingEdgePos, trailingEdge + constraintDistance)
        }
        
        anchor.position = leadingEdgePos - anchor.leadingEdgeOffset
    }
    
    private func solveAdjacentLayoutAnchorOffsets(forAnchor anchor: LayoutAnchor) {
        
        if let singleAnchor = anchor as? SingleItemLayoutAnchor {
            solveLeadingLayoutAnchorOffsets(forSingleItemAnchor: singleAnchor)
            solveTrailingLayoutAnchorOffsets(forSingleItemAnchor: singleAnchor)
        } else if let combinedAnchor = anchor as? CombinedItemsLayoutAnchor {
            combinedAnchor.anchors.forEach {
                self.solveLeadingLayoutAnchorOffsets(forSingleItemAnchor: $0)
                self.solveTrailingLayoutAnchorOffsets(forSingleItemAnchor: $0)
            }
        }
    }
    
    private func solveLeadingLayoutAnchorOffsets(forSingleItemAnchor anchor: SingleItemLayoutAnchor) {
        
        var offset = -anchor.leadingWidth
        
        for leadingAnchor in anchor.leadingChildAnchors {
            offset -= leadingAnchor.distanceFromAnchor
            offset -= leadingAnchor.width/2
            leadingAnchor.offset = offset
            offset -= leadingAnchor.width/2
        }
    }
    
    private func solveTrailingLayoutAnchorOffsets(forSingleItemAnchor anchor: SingleItemLayoutAnchor) {
        
        var offset = anchor.trailingWidth
        
        for trailingAnchor in anchor.trailingChildAnchors {
            offset += trailingAnchor.distanceFromAnchor
            offset += trailingAnchor.width/2
            trailingAnchor.offset = offset
            offset += trailingAnchor.width/2
        }
    }
}
