//
//  LayoutTimingSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 22/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

private class SpaceableAnchor {
    var index: Int = 0
    var anchor: LayoutAnchor
    var distanceToNextAnchor: Double = 0
    var idealPct: Double = 0
    var currentPct: Double = 0
    
    init(anchor: LayoutAnchor) {
        self.anchor = anchor
    }
}

class LayoutTimingSolver {
    
    func distributeTime(toAnchors anchors: [LayoutAnchor], layoutWidth: Double) {
        
        // Create array of spaceable anchors
        var spaceableAnchors = [SpaceableAnchor]()
        for (index, anchor) in anchors.enumerated() where anchor.duration != nil {
            let spaceableAnchor = SpaceableAnchor(anchor: anchor)
            spaceableAnchor.index = index
            spaceableAnchors.append(spaceableAnchor)
        }
        
        // Work out the ideal percentages
        var totalDuration = Double(0)
        for spaceable in spaceableAnchors {
            totalDuration += spaceable.anchor.duration!.barPct
        }
        
        for spaceable in spaceableAnchors {
            spaceable.idealPct = spaceable.anchor.duration!.barPct / totalDuration
        }
        
        // Work out the current percentages
        for spaceable in spaceableAnchors {
            if let nextAnchor = anchors[maybe: spaceable.index+1] {
                spaceable.distanceToNextAnchor = nextAnchor.position - spaceable.anchor.position
            } else {
                spaceable.distanceToNextAnchor = layoutWidth - spaceable.anchor.position
            }
        }
        let totalAnchorDistances = spaceableAnchors.map { $0.distanceToNextAnchor }.sum()
        
        for spaceable in spaceableAnchors {
            spaceable.currentPct = spaceable.distanceToNextAnchor / totalAnchorDistances
        }
        
        // Sort By largest compared to ideal
        spaceableAnchors = spaceableAnchors.sortedAscendingBy { $0.idealPct - $0.currentPct }
        
        // Add the space to the anchors
        let availableSpace = layoutWidth - anchors.last!.trailingEdge
        
        
        
        
        
        
        
        
        // Just print out the values
        _print(spaceableAnchors: spaceableAnchors)
    }
    
    private func _print(spaceableAnchors: [SpaceableAnchor]) {
        print("----- Spaceable Anchors")
        for spaceable in spaceableAnchors {
            let current = String(format: "%.03f", spaceable.currentPct)
            let ideal = String(format: "%.03f", spaceable.idealPct)
            let diff = String(format: "%.03f", spaceable.idealPct - spaceable.currentPct)
            print("[\(spaceable.index)] (\(current) -> \(ideal)) (\(diff))")
        }
        print("All currents: \(spaceableAnchors.map { $0.currentPct }.sum())")
        print("All ideals: \(spaceableAnchors.map { $0.idealPct }.sum())")
        print("------")
    }

}
