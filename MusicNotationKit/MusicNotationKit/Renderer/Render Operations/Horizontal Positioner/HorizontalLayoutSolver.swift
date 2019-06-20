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
            anchors.forEach { $0.item.xPosition = $0.resolvedPosition }
        }
        
        solveMinimumDistances(anchors: anchors)
        
        // If there's not enough space for the layout, solve with scaled minimum widths
        let minimumOptimalWidth = self.minimumOptimalWidth(forAnchors: anchors)
        if minimumOptimalWidth >= layoutWidth {
            solveUsingScaledFixedDistances(anchors: anchors, layoutWidth: layoutWidth, optimalWidth: minimumOptimalWidth)
            applyAnchorPositions()
            return
        }
        
        print("Using timed layout")
        
        // Resolve anchor postions with minimum distances
        var xPos = Double(0)
        for anchor in anchors {
            xPos += anchor.width/2
            anchor.resolvedPosition = xPos
            xPos += anchor.width/2
            xPos += anchor.minimumTrailingDistance
        }
        
        // Apply anchor positions to items
        applyAnchorPositions()
        
        // DEBUG - print anchor positions
//        print("Anchor positions")
//        for anchor in anchors {
//            print("\(anchor.item.xPosition)")
//        }
    }
    
    private func solveMinimumDistances(anchors: [LayoutAnchor]) {
        
        for anchor in anchors {
            var minimumDistance = Double(0)
            for constraint in anchor.trailingConstraints {
                minimumDistance = max(minimumDistance, constraint.minimumValue)
            }
            anchor.minimumTrailingDistance = minimumDistance
        }
    }
    
    
    
    private func minimumOptimalWidth(forAnchors anchors: [LayoutAnchor]) -> Double {
        return anchors.map { $0.minimumTrailingDistance + $0.width }.sum()
    }
    
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
}
