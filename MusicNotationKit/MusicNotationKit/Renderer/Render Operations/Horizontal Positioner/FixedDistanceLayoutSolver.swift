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
        
        anchor.position = leadingEdgePos + anchor.width/2
        
        // Solve trailing layout items
        solveTrailingLayoutItems(forAnchor: anchor)
    }
    
    private func solveTrailingLayoutItems(forAnchor anchor: LayoutAnchor) {
        
        if let singleAnchor = anchor as? SingleItemLayoutAnchor {
            solveTrailingLayoutItems(forSingleItemAnchor: singleAnchor)
        } else if let combinedAnchor = anchor as? CombinedItemsLayoutAnchor {
            combinedAnchor.anchors.forEach {
                self.solveTrailingLayoutItems(forSingleItemAnchor: $0)
            }
        }
    }
    
    private func solveTrailingLayoutItems(forSingleItemAnchor anchor: SingleItemLayoutAnchor) {
        
        var offset = anchor.width/2
        
        for trailingItem in anchor.trailingLayoutItems {
            offset += trailingItem.distanceFromAnchor
            offset += trailingItem.width/2
            trailingItem.offset = offset
            offset += trailingItem.width/2
        }
    }
}
