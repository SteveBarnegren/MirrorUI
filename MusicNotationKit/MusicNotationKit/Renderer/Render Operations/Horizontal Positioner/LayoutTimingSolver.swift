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
    var nextAnchor: LayoutAnchor?
    var distanceToNextAnchor: Double = 0
    var idealPct: Double = 0
    var currentPct: Double = 0
    var deltaToIdealPct: Double = 0
    
    var proposedAdditionalSpace: Double = 0
    
    init(anchor: LayoutAnchor) {
        self.anchor = anchor
    }
}

class LayoutTimingSolver {
    
    func distributeTime(toAnchors anchors: [LayoutAnchor], layoutWidth: Double) {
        
        var allAnchors = makeSpaceableAnchors(fromAnchors: anchors)
        var stationaryAnchors = allAnchors
        var expandingAnchors = [SpaceableAnchor]()

        let availableSpace = layoutWidth - anchors.last!.trailingEdge
        
        while availableSpace > 0 {
            updateCurrentPercentages(forAnchors: allAnchors, layoutWidth: layoutWidth)
            print("****** LOOP START ******")
            print("------")
            _print(spaceableAnchors: expandingAnchors)
            print("------")
            _print(spaceableAnchors: stationaryAnchors)
            print("------")

            // Find anchors to expand
            var anchorsToExpand = [SpaceableAnchor]()
            guard let anchorRequiringExpansion = stationaryAnchors.extract(maximumBy: { $0.deltaToIdealPct }) else {
                fatalError("no anchors to expand")
            }
            anchorsToExpand.append(anchorRequiringExpansion)
            let additionalAnchors = stationaryAnchors.extract { $0.deltaToIdealPct == anchorRequiringExpansion.deltaToIdealPct }
            anchorsToExpand.append(contentsOf: additionalAnchors)
            print("**** Select anchors")
            _print(spaceableAnchors: anchorsToExpand)
            expandingAnchors.append(contentsOf: anchorsToExpand)

            // Find the target delta to match
            print("**** Find target delta")
            let currentDelta = anchorRequiringExpansion.deltaToIdealPct
            //let targetDelta = stationaryAnchors.map { $0.deltaToIdealPct }.max()!
            if stationaryAnchors.count <= 1 {
                return
            }
            
            let targetAnchor = stationaryAnchors.max(by: { $0.deltaToIdealPct < $1.deltaToIdealPct })!
            let targetDelta = targetAnchor.deltaToIdealPct
            _print(spaceableAnchor: targetAnchor)
            print("Current delta: \(currentDelta)")
            print("Target delta: \(targetDelta)")
            
            
            // Get the total required expansion
            print("**** Space out anchors")
            let totalSpaceableDistance = allAnchors.map { $0.distanceToNextAnchor }.sum()
            print("Total spaceable distance: \(totalSpaceableDistance)")
            
            for anchor in expandingAnchors {
                let pctToExpandTo = anchor.idealPct - targetDelta
                let proposedNewValue = anchor.distanceToNextAnchor / anchor.currentPct * pctToExpandTo
                anchor.proposedAdditionalSpace = proposedNewValue - anchor.distanceToNextAnchor
                _print(spaceableAnchor: anchor)
                print("  - Proposed additional space: \(anchor.proposedAdditionalSpace)")
            }
            
            // Apply the additional space (scaled if not enough available)
            let requiredSpace = expandingAnchors.map { $0.proposedAdditionalSpace }.sum()
            
            if requiredSpace <= availableSpace {
                for spaceable in expandingAnchors {
                    if spaceable.index < allAnchors.count {
                        offset(anchors: anchors[(spaceable.index+1)...].toArray(),
                               by: spaceable.proposedAdditionalSpace)
                    }
                }
            } else {
                break;
                //fatalError("Run out of available space to expand")
            }
        }
    }
    
    private func offset(anchors: [LayoutAnchor], by offset: Double) {
        print("***** Offset anchors")
        //_print(spaceableAnchors: anchors)
        for anchor in anchors {
            anchor.position += offset
        }
    }
    
    private func makeSpaceableAnchors(fromAnchors anchors: [LayoutAnchor]) -> [SpaceableAnchor] {
        
        // Create array of spaceable anchors
        var spaceableAnchors = [SpaceableAnchor]()
        for (index, anchor) in anchors.enumerated() where anchor.duration != nil {
            let spaceableAnchor = SpaceableAnchor(anchor: anchor)
            spaceableAnchor.nextAnchor = anchors[maybe: index+1]
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
        
        return spaceableAnchors
    }
    
    private func updateCurrentPercentages(forAnchors spaceableAnchors: [SpaceableAnchor], layoutWidth: Double) {
        
        // Work out the current percentages
        for spaceable in spaceableAnchors {
            if let nextAnchor = spaceable.nextAnchor {
                spaceable.distanceToNextAnchor = nextAnchor.position - spaceable.anchor.position
            } else {
                spaceable.distanceToNextAnchor = layoutWidth - spaceable.anchor.position
            }
        }
        let totalAnchorDistances = spaceableAnchors.map { $0.distanceToNextAnchor }.sum()
        
        for spaceable in spaceableAnchors {
            spaceable.currentPct = spaceable.distanceToNextAnchor / totalAnchorDistances
            spaceable.deltaToIdealPct = spaceable.idealPct - spaceable.currentPct
        }
    }
    
    private func _print(spaceableAnchors: [SpaceableAnchor]) {
        for spaceable in spaceableAnchors {
            _print(spaceableAnchor: spaceable)
        }
        //print("All currents: \(spaceableAnchors.map { $0.currentPct }.sum())")
        //print("All ideals: \(spaceableAnchors.map { $0.idealPct }.sum())")
    }
    
    private func _print(spaceableAnchor spaceable: SpaceableAnchor) {
        let current = String(format: "%.03f", spaceable.currentPct)
        let ideal = String(format: "%.03f", spaceable.idealPct)
        let diff = String(format: "%.03f", spaceable.idealPct - spaceable.currentPct)
        print("[\(spaceable.index)] (\(current) -> \(ideal)) (\(diff))")
    }

}
