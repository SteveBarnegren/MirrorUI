//
//  HorizontalLayoutSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalLayoutSolver {
    
    let layoutTimingSolver = LayoutTimingSolver()
    
    func solve(anchors: [LayoutAnchor], layoutWidth: Double) {
        
        func applyAnchorPositions() {
            anchors.forEach { $0.apply() }
        }
        
        solveUsingFixedDistances(anchors: anchors)
        layoutTimingSolver.distributeTime(toAnchors: anchors, layoutWidth: layoutWidth)
        applyAnchorPositions()
    }
    
    // MARK: - Fixed distance solving
    
    private func solveUsingFixedDistances(anchors: [LayoutAnchor]) {
        
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
    
    func _print(anchors: [LayoutAnchor]) {
        
        print("**************")
        for anchor in anchors {
            print("\(anchor.position)")
        }
    }
}
