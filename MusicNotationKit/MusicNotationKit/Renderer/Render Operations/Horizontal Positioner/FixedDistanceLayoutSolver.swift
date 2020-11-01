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
        
        var isFirst = true
        for anchor in anchors {
            solveAdjacentLayoutAnchorOffsets(forAnchor: anchor)
            if isFirst == false {
                solveLeadingConstraints(forAnchor: anchor)
            } else {
                anchor.position = -anchor.leadingEdgeOffset
            }
            isFirst = false
        }
        
        // Double stemmed writting may contain notes from different voices that don't have
        // constraints between them. In this case we need to nudge the later note ahead of
        // the first so that they don't appear to be at the same point. The timing layout
        // solver will increase these distances.
        var nudgeAmount = 0.0
        for (anchor, previousAnchor) in anchors.eachWithPrevious() {
            guard let prev = previousAnchor else { continue }
            if anchor.position <= prev.position {
                nudgeAmount += (prev.position - anchor.position) + 0.1
            }
            
            anchor.position += nudgeAmount
        }
    }
    
    private func solveLeadingConstraints(forAnchor anchor: LayoutAnchor) {
        
        var leadingEdgePos = Double(0)
        
        for constraint in anchor.leadingConstraints {
            guard let fromAnchor = constraint.from else {
                continue
                //fatalError("All constraints should have a from value")
            }
            
            var constraintDistance: Double
            switch constraint.value {
            case .fixed(let v):
                constraintDistance = v
            case .greaterThan(let v):
                constraintDistance = v
            }
            leadingEdgePos = max(leadingEdgePos, fromAnchor.trailingEdge + constraintDistance)
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
        
        for leadingAnchor in anchor.leadingLayoutAnchors {
            offset -= leadingAnchor.distanceFromAnchor
            offset -= leadingAnchor.width/2
            leadingAnchor.offset = offset
            offset -= leadingAnchor.width/2
        }
    }
    
    private func solveTrailingLayoutAnchorOffsets(forSingleItemAnchor anchor: SingleItemLayoutAnchor) {
        
        var offset = anchor.trailingWidth
        
        for trailingAnchor in anchor.trailingLayoutAnchors {
            offset += trailingAnchor.distanceFromAnchor
            offset += trailingAnchor.width/2
            trailingAnchor.offset = offset
            offset += trailingAnchor.width/2
        }
    }
}
