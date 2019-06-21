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
        
        var xPos = anchor.position + anchor.width/2
        
        for trailingItem in anchor.trailingLayoutItems {
            xPos += trailingItem.distanceFromAnchor
            xPos += trailingItem.width/2
            trailingItem.position = xPos
            xPos += trailingItem.width/2
        }
    }
    
    // MARK: - Time solving
    
//    private func distributeTime(toAnchors anchors: [LayoutAnchor], layoutWidth: Double) {
//
//        // Last anchor may not be accounted for!
//
//        class SpaceableAnchor {
//            var index: Int = 0
//            var anchor: LayoutAnchor
//            var distanceToNextAnchor: Double = 0
//            var idealPct: Double = 0
//            var currentPct: Double = 0
//
//            init(anchor: LayoutAnchor) {
//                self.anchor = anchor
//            }
//        }
//
//        func _print(spaceableAnchors: [SpaceableAnchor]) {
//            print("----- Spaceable Anchors")
//            for spaceable in spaceableAnchors {
//                let current = String(format: "%.03f", spaceable.currentPct)
//                let ideal = String(format: "%.03f", spaceable.idealPct)
//                let diff = String(format: "%.03f", spaceable.idealPct - spaceable.currentPct)
//                print("[\(spaceable.index)] (\(current) -> \(ideal)) (\(diff))")
//            }
//            print("All currents: \(spaceableAnchors.map { $0.currentPct }.sum())")
//            print("All ideals: \(spaceableAnchors.map { $0.idealPct }.sum())")
//            print("------")
//        }
//
//
//
//
//        // Create array of spaceable anchors
//        var spaceableAnchors = [SpaceableAnchor]()
//        for (index, anchor) in anchors.enumerated() where anchor.duration != nil {
//            let spaceableAnchor = SpaceableAnchor(anchor: anchor)
//            spaceableAnchor.index = index
//            spaceableAnchors.append(spaceableAnchor)
//        }
//
//        // Work out the ideal percentages
//        var totalDuration = Double(0)
//        for spaceable in spaceableAnchors {
//            totalDuration += spaceable.anchor.duration!.barPct
//        }
//
//        for spaceable in spaceableAnchors {
//            spaceable.idealPct = spaceable.anchor.duration!.barPct / totalDuration
//        }
//
//        // Work out the current percentages
//        for spaceable in spaceableAnchors {
//            if let nextAnchor = anchors[maybe: spaceable.index+1] {
//                spaceable.distanceToNextAnchor = nextAnchor.position - spaceable.anchor.position
//            } else {
//                spaceable.distanceToNextAnchor = layoutWidth - spaceable.anchor.position
//            }
//        }
//        let totalAnchorDistances = spaceableAnchors.map { $0.distanceToNextAnchor }.sum()
//
//        for spaceable in spaceableAnchors {
//            spaceable.currentPct = spaceable.distanceToNextAnchor / totalAnchorDistances
//        }
//
//        // Sort By largest compared to ideal
//        spaceableAnchors = spaceableAnchors.sortedAscendingBy { $0.idealPct - $0.currentPct }
//
//        // Add the space to the anchors
//        let availableSpace = layoutWidth - anchors.last!.trailingEdge
//
//
//
//        // Just print out the values
//        _print(spaceableAnchors: spaceableAnchors)
//    }
    
    
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
    
    func _print(anchors: [LayoutAnchor]) {
        
        print("**************")
        for anchor in anchors {
            print("\(anchor.position)")
        }
    }
}
