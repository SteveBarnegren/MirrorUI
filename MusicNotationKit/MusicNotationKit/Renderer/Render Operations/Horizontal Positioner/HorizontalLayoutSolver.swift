//
//  HorizontalLayoutSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalLayoutSolver {
    
    func solve(anchors: [LayoutAnchor], layoutWidth: Double) {
        
        func applyAnchorPositions() {
            anchors.forEach { $0.apply() }
        }
        
        solveUsingFixedDistances(anchors: anchors)
        applyAnchorPositions()
        
//        solveMinimumDistances(anchors: anchors)
//
//        // If there's not enough space for the layout, solve with scaled minimum widths
//        let minimumOptimalWidth = self.minimumOptimalWidth(forAnchors: anchors)
//        if /*minimumOptimalWidth >= layoutWidth*/ true {
//            solveUsingScaledFixedDistances(anchors: anchors, layoutWidth: layoutWidth, optimalWidth: minimumOptimalWidth)
//            applyAnchorPositions()
//            return
//        }
        
        print("Using timed layout")
        
//        // Resolve the trailing distances with minimum values
//        for anchor in anchors {
//            anchor.resolvedTrailingDistance = anchor.minimumTrailingDistance
//        }
//
//        // Work out how much timed distance we have to work with
//        var totalFixedDistance = Double(0)
//        for anchor in anchors {
//            totalFixedDistance += anchor.width
//            totalFixedDistance += anchor.minimumTrailingDistance
//        }
//        var timedDistance = layoutWidth - totalFixedDistance
//
//        // Apply note timing distance (naive for the moment, just divides proportionately)
//        var totalTime = anchors.compactMap { $0.trailingTimeValue }.sum()
//        for anchor in anchors {
//            if let time = anchor.trailingTimeValue {
//                anchor.resolvedTrailingDistance += timedDistance / totalTime * time
//            }
//        }
//
//        // Resolve anchor positions
//        var xPos = Double(0)
//        for anchor in anchors {
//            xPos += anchor.width/2
//            anchor.resolvedPosition = xPos
//            xPos += anchor.width/2
//            xPos += anchor.resolvedTrailingDistance
//        }
//
//        // Apply anchor positions to items
//        applyAnchorPositions()
    }
    
    private func solveUsingFixedDistances(anchors: [LayoutAnchor]) {
        
        for anchor in anchors {
            solveAnchor(anchor: anchor)
        }
    }
    
    private func solveAnchor(anchor: LayoutAnchor) {
        
        if let singleItemAnchor = anchor as? SingleItemLayoutAnchor {
            solve(singleItemAnchor: singleItemAnchor)
        }
    }
    
    private func solve(singleItemAnchor anchor: SingleItemLayoutAnchor) {
        
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
    
    func solveTrailingLayoutItems(forAnchor anchor: SingleItemLayoutAnchor) {
        
        var xPos = anchor.position + anchor.width/2
        
        for trailingItem in anchor.trailingLayoutItems {
            xPos += trailingItem.distanceFromAnchor
            xPos += trailingItem.width/2
            trailingItem.position = xPos
            xPos += trailingItem.width/2
        }
    }
    
    
    /*
    private func solveUsingScaledFixedDistances(anchors: [LayoutAnchor], layoutWidth: Double, optimalWidth: Double) {
        
        let requiredWidth = anchors.map { $0.width }.sum()
        
        // If the required width doesn't fit, just use that
        guard layoutWidth > requiredWidth else {
            print("Using required width layout")
            var xPos = Double(0)
            for anchor in anchors {
                xPos += anchor.width/2
                anchor.resolvedPosition = xPos
                xPos += anchor.width/2
            }
            return
        }
        
        print("Using scaled minimum distance layout")
        
        // Scale the minimum fixed distances
        let whitespace = layoutWidth - requiredWidth
        let scale = whitespace / (optimalWidth-requiredWidth)
        
        var xPos = Double(0)
        for anchor in anchors {
            xPos += anchor.width/2
            anchor.resolvedPosition = xPos
            xPos += anchor.width/2
            xPos += anchor.minimumTrailingDistance * scale
        }
    }
 */
    
    func _print(anchors: [SingleItemLayoutAnchor]) {
        
        print("**************")
        for anchor in anchors {
            print("\(anchor.position)")
            for trailingItem in anchor.trailingLayoutItems {
                print("  - \(trailingItem.position)")
            }
        }
    }
}
