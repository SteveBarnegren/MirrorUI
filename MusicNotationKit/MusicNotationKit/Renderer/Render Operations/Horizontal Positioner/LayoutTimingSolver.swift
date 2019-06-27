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
    var barPct: Double = 0
    var distanceToNextAnchor: Double = 0
    var idealPct: Double = 0
    var currentPct: Double = 0
    var pctExpanded: Double = 0
    
    var proposedAdditionalSpace: Double = 0
    
    init(anchor: LayoutAnchor) {
        self.anchor = anchor
    }
}

class LayoutTimingSolver {
    
    func distributeTime(toAnchors anchors: [LayoutAnchor], layoutWidth: Double) {
        
        let allAnchors = makeSpaceableAnchors(fromAnchors: anchors)
        var stationaryAnchors = allAnchors
        var expandingAnchors = [SpaceableAnchor]()

        var availableSpace = layoutWidth - anchors.last!.trailingEdge
    
        // ****** Expand anchors until space empty ******
        while availableSpace > 0 && stationaryAnchors.isEmpty == false {
            
            // Update anchor information
            updateCurrentPercentages(forAnchors: allAnchors, layoutWidth: layoutWidth)
            print("-- Expanding --")
            _print(spaceableAnchors: expandingAnchors)
            print("-- Stationary --")
            _print(spaceableAnchors: stationaryAnchors)
            print("---------------")
            
            // Find initial anchors to expand
            if expandingAnchors.isEmpty {
                updateCurrentPercentages(forAnchors: allAnchors, layoutWidth: layoutWidth)
                expandingAnchors = stationaryAnchors.extractLeastExpandedAnchors()
                if expandingAnchors.isEmpty { break }
            }

            // Find the target pct to match
            let targetAnchors = stationaryAnchors.extractLeastExpandedAnchors()
            if targetAnchors.isEmpty {
                break
            }
            let targetPct = targetAnchors.first!.pctExpanded
            _print(spaceableAnchors: targetAnchors)
            
            // Figure out required expansion per anchor
            for anchor in expandingAnchors {
                let proposedNewValue = anchor.distanceToNextAnchor / anchor.pctExpanded * targetPct
                anchor.proposedAdditionalSpace = proposedNewValue - anchor.distanceToNextAnchor
            }
            
            // Figure out the scale the space should be applied (<1 if not enough available)
            let requiredSpace = expandingAnchors.sum(\.proposedAdditionalSpace)
            var scale = Double(1)
            if availableSpace < requiredSpace {
                scale = availableSpace / requiredSpace
            }
            
            // Apply the additional space, moving all anchors to the right
            for spaceable in expandingAnchors {
                offset(anchors: anchors[(spaceable.index+1)...].toAnySequence(),
                       by: spaceable.proposedAdditionalSpace * scale)
                
            }
            availableSpace -= requiredSpace * scale
            
            // Target anchors are now expanding
            expandingAnchors.append(contentsOf: targetAnchors)
        }
        
        // If there's still remaining space, keep expanding proportionatly to time
        if availableSpace > 0 {
            let totalDuration = allAnchors.sum(\.barPct)
            let multiplier = availableSpace / totalDuration
            for spaceable in allAnchors {
                offset(anchors: anchors[(spaceable.index+1)...].toAnySequence(),
                       by: spaceable.barPct * multiplier)
            }
        }
    
    }
    
    private func offset(anchors: AnySequence<LayoutAnchor>, by offset: Double) {
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
            spaceableAnchor.barPct = anchor.duration!.barPct
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
                spaceable.distanceToNextAnchor = 0//layoutWidth - spaceable.anchor.position
            }
        }
        let totalAnchorDistances = spaceableAnchors.map { $0.distanceToNextAnchor }.sum()
        
        for spaceable in spaceableAnchors {
            spaceable.currentPct = spaceable.distanceToNextAnchor / totalAnchorDistances
            spaceable.pctExpanded = spaceable.currentPct / spaceable.idealPct
        }
    }
    
    private func _print(spaceableAnchors: [SpaceableAnchor]) {
        for spaceable in spaceableAnchors {
            _print(spaceableAnchor: spaceable)
        }
    }
    
    private func _print(spaceableAnchor spaceable: SpaceableAnchor) {
        let current = String(format: "%.03f", spaceable.currentPct)
        let ideal = String(format: "%.03f", spaceable.idealPct)
        let diff = String(format: "%.03f", spaceable.idealPct - spaceable.currentPct)
        let pctExpanded = String(format: "%.03f", spaceable.pctExpanded)
        print("[\(spaceable.index)] (\(current) -> \(ideal)) (\(diff)) (abs: \(spaceable.distanceToNextAnchor)) (%ex: \(pctExpanded))")
    }

}

extension Array where Element: SpaceableAnchor {
    
    mutating func extractLeastExpandedAnchors() -> [SpaceableAnchor] {
        
        var value: Double?
        var anchors = [SpaceableAnchor]()
        var indexesToRemove = [Int]()
        
        for (index, anchor) in self.enumerated() {
            guard let v = value else {
                value = anchor.pctExpanded
                anchors.append(anchor)
                indexesToRemove.append(index)
                continue
            }
            
            if anchor.pctExpanded < v {
                value = anchor.pctExpanded
                anchors = [anchor]
                indexesToRemove = [index]
            } else if anchor.pctExpanded == v {
                anchors.append(anchor)
                indexesToRemove.append(index)
            }
        }
        indexesToRemove.reversed().forEach { self.remove(at: $0) }
        return anchors
    }
}
