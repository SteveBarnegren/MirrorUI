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
        
        for anchor in anchors {
            solveAnchor(anchor: anchor)
        }
    }
    
    private func solveAnchor(anchor: LayoutAnchor) {

        solveAdjacentLayoutAnchorOffsets(forAnchor: anchor)
        
        var leadingEdgePos = Double(0)
        
        for constraint in anchor.leadingConstraints {
            guard let fromAnchor = constraint.from else {
                fatalError("All constraints should have a from value")
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
        
        var offset = -anchor.width/2
        
        for leadingAnchor in anchor.leadingLayoutAnchors {
            offset -= leadingAnchor.distanceFromAnchor
            offset -= leadingAnchor.width/2
            leadingAnchor.offset = offset
            offset -= leadingAnchor.width/2
        }
    }
    
    private func solveTrailingLayoutAnchorOffsets(forSingleItemAnchor anchor: SingleItemLayoutAnchor) {
        
        var offset = anchor.width/2
        
        for trailingAnchor in anchor.trailingLayoutAnchors {
            offset += trailingAnchor.distanceFromAnchor
            offset += trailingAnchor.width/2
            trailingAnchor.offset = offset
            offset += trailingAnchor.width/2
        }
    }
}
